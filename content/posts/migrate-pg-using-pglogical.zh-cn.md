+++
title = "使用 pglogical 迁移 PostgreSQL"
date = 2024-01-15T17:23:36+08:00
draft = false
+++

## 背景

为了减少数据库查询的延迟, 我们决定将我们的数据库迁移到离后端程序更近的一个区域.

## TLDR

为了减少应用停机时间, 最后采用的是基于 [pglogical] 插件的逻辑复制方案.

### 更改 PG 配置

我们需要更改 PostgreSQL 的配置以支持逻辑复制, 并且这些配置需要重启数据库生效.
(研究过不重启的方法, 没有找到)

如果要同步多个数据库, 需要正确配置的 `max_worker_processes` 参数, 参考:
[worker registration failed](#error-worker-registration-failed)

```toml
# 参考 https://github.com/2ndQuadrant/pglogical#quick-setup

wal_level = 'logical'
max_worker_processes = 16   # one per database needed on provider node
                            # one per node needed on subscriber node
max_replication_slots = 16  # one per node needed on provider node
max_wal_senders = 16        # one per node needed on provider node
shared_preload_libraries = 'pglogical'

track_commit_timestamp = on # needed for last/first update wins conflict resolution
                            # property available in PostgreSQL 9.5+
```

可以使用 `SHOW` 指令来检查配置参数:

```sql
SHOW wal_level;
SHOW shared_preload_libraries;
```

### DDL

在开始逻辑复制之前, 我们需要保证源数据库与目标数据库的结构一致.
我们是采用的 [goose] 来管理我们所有的 DDL, 这一步一条命令就解决了.
[pglogical] 自带了同步结构的功能,
具体来说就是将 `pglogical.create_subscription()` 函数中的
`synchronize_structure` 参数设置成 `true`.

### 创建订阅

这里我们以 `order` 数据库为例.

在源端:

```sql
-- 给逻辑复制专门创建一个用户
CREATE ROLE logicalrep WITH LOGIN;
ALTER USER logicalrep WITH PASSWORD 'your_pass';

-- 给予 logicalrep 用户必要的权限
GRANT USAGE ON schema public TO logicalrep;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO logicalrep;
GRANT USAGE ON schema pglogical TO logicalrep;
GRANT SELECT ON ALL TABLES IN SCHEMA pglogical TO logicalrep;


-- 创建 pglogical 扩展
CREATE EXTENSION pglogical;


-- dsn 可以留空 (暂时没发现有啥影响)
SELECT pglogical.create_node(
    node_name := 'provider1',
    dsn := ''
);

-- 将 public schema 中的所有表加入复制集
SELECT pglogical.replication_set_add_all_tables('default', ARRAY['public']);
```

在目标端:

```sql
CREATE EXTENSION pglogical;
SELECT pglogical.create_node(
    node_name := 'sub',
    dsn := 'dbname=order'
);

-- 创建订阅
SELECT pglogical.create_subscription(
    subscription_name := 'sub_order',
    provider_dsn := 'host=your_host port=5432 dbname=order user=logicalrep password=your_pass'
);

-- 检查订阅状态
--
-- 预期状态是 `replicating`.
-- 如果不是, 就要检查目标端或者源端的数据库日志来确定问题.
select * from pglogical.show_subscription_status();
```

### 同步 Sequence

当订阅创建成功时, 数据已经同步过来了, 这里还差容易被人忽略的一步,
我们还需要同步 Sequence, 否则新创建的记录会报重复键错误.

这里我们编写了一个脚本来进行同步:
https://gist.github.com/ionling/10f50bf3d77040fa8bb4f6695c23befe#file-main-go-L270

考虑到订阅延迟, 新的 last value 是原来的 1.1 倍.
主要的 SQL 如下:

```sql
-- 获取 last values
SELECT * FROM pg_sequences;

-- 修改目标端的 last value
ALTER SEQUENCE public.videos_id_seq RESTART new_value;

-- 检查 last value
-- 参考 https://gist.github.com/lbbedendo/449ff46d3baa7838b99ec513c2de92a7
SELECT last_value FROM public.videos_id_seq;

-- 注意修改了 last value 之后, 这个 SQL 查出来的 last value 会是 NULL
SELECT * FROM pg_sequences;
```

### 检查数据

我们写了一个脚本来检查两端的数据是否一次,
这个脚本会同时检查表的行数与表随机一部分的数据的相等性:
<https://gist.github.com/ionling/10f50bf3d77040fa8bb4f6695c23befe>

### 删除订阅

等应用在新数据库上稳定运行一段时间后, 我们就可以删除订阅了.

```sql
SELECT * FROM pglogical.drop_subscription('sub_order');
```

## 解决方案

这里我们将探讨几种迁移方案的优缺点.

### 备份恢复

这个方案应该是最简单的了, 停机, 备份数据库, 在新实例上恢复, 然后启动应用.
缺点就是停机时间比较长, 不可控, 停机期间需要完成新数据库的恢复以及数据校验,
如果提前演练一下应该可以缩短停机时间.

### 逻辑复制

PostgreSQL 原生提供了逻辑复制功能, 可以持续的将数据从一个数据库同步至另外一个数据库.
通过这种方式, 我们可以在应用重启之前就将两端的数据同步到一致的状态, 并且在极短的时间内重启应用.
优点不言而喻.

### 多主集群

最方便应用迁移的方式就是搭建一个多主集群, 这样新旧数据库可以一起工作,
对于应用来说就没有停机时间这一说法了.

通过 [spock] 插件可以实现多主集群,
但是这个插件的性能与可能的潜在问题需要评估一下.
具体的可以参考文章:
[How to achieve multi-master replication in PostgreSQL with Spock](https://www.pgedge.com/blog/achieve-multiactive-data-replication-in-postgresql-with-spock)

### 总结

综合考虑复杂性与功能性, 我们最后选择了逻辑复制方案.
AWS 有一篇博客专门讲 [pglogical] 的迁移, 挺不错的:

1. <https://aws.amazon.com/cn/blogs/database/part-1-upgrade-your-amazon-rds-for-postgresql-database-comparing-upgrade-approaches/>
2. <https://aws.amazon.com/cn/blogs/database/part-2-upgrade-your-amazon-rds-for-postgresql-database-using-the-pglogical-extension/>

## 笔记

### Could not open relation with OID

在测试创建订阅的时候, 我删除了 [pglogical] 扩展, 但是看到 pglogical schema 没有删除,
于是手动删除了它, 结果就是重新创建 [pglogical] 扩展的时候遇到错误:

```text
Could not open relation with OID
```

断开重新连接数据库就能解决这个问题, 参考:
<https://github.com/2ndQuadrant/pglogical/issues/347>

### PostgreSQL 权限

PostgreSQL 的一些权限可能与我们想象的不一样, 比如:

```sql
GRANT ALL ON DATABASE mydb TO admin;
```

这个只是授予数据库本身的权限给用户, 并没有授予数据库里面的对象权限给用户, 比如表, 序列之类的.
admin 用户可以删除数据库, 但是并不能在这个数据库里面创建表.[^1]

### ERROR: worker registration failed

创建订阅的时候, 遇到如下问题:

```log
ERROR: worker registration failed, you might want to increase max_worker_processes setting
```

根据 [pglogical] 的 README:

> one process per node is needed on the subscriber node.

按道理实际使用的线程数量应该不会超过我们配置的 `max_worker_processes`.
于是我们继续确认一下, 发现了两个冲突的资料:

来自 [EnterpriseDB](https://www.enterprisedb.com/docs/pgd/3.7/pglogical/configuration/),
的资料提到:

> One per database + two per subscription on the subscriber (downstream).

另外在 [GitHub Issue #7](https://github.com/2ndQuadrant/pglogical/issues/7),
中提到:

> One worker needed for the main maintenance process,
> one per subscription, one per replicated database,
> and during startup, it can need one per any connectable database on top of that.

举例来说, 两个数据库, 每个数据库都创建了一个订阅:

- 根据 README, 我们需要 `2*1 = 2` 个线程
- 根据 EnterpriseDB, 我们需要 `2*1 + 2*2 = 6` 个线程
- 根据 Issue, 我们需要 `2*2 = 4` 个线程

哪个是正确的? 这里我们没有进行测试, 反正肯定不是 README.

### 其他工具

- <https://github.com/shayonj/pg_easy_replicate>
- <https://bucardo.org/>

## 参考文章

- [PostgreSQL bi-directional replication using pglogical | AWS Database Blog](https://aws.amazon.com/cn/blogs/database/postgresql-bi-directional-replication-using-pglogical/)
- [pglogical - Database Migration Guide](https://docs.aws.amazon.com/dms/latest/sbs/chap-manageddatabases.postgresql-rds-postgresql-full-load-pglogical.html)
- [Zero downtime Postgres migration, done right](https://engineering.theblueground.com/zero-downtime-postgres-migration-done-right/)
- [Container Security: Tips for Securing PostgreSQL Instances in Docker | by Pan...](https://pankajconnect.medium.com/container-security-tips-for-securing-postgresql-instances-in-docker-9de5d2a932fb)
- [如何使用逻辑流复制发布和订阅功能\_云数据库 RDS(RDS)-阿里云帮助中心](https://help.aliyun.com/zh/rds/apsaradb-rds-for-postgresql/use-the-pglogical-extension-for-logical-streaming-replication)

[^1]: <https://stackoverflow.com/a/74111630/7134763>

[goose]: https://github.com/pressly/goose
[pglogical]: https://github.com/2ndQuadrant/pglogical
[spock]: https://github.com/pgEdge/spock
