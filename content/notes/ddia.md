+++
title = "DDIA"
date = 2021-12-15T00:00:00+08:00
lastmod = 2021-12-24T10:51:48+08:00
draft = false
+++

## Designing Data Intensive Applications {#designing-data-intensive-applications}

-   [GitHub - Vonng/ddia: 《Designing Data-Intensive Application》DDIA中文翻译](https://github.com/Vonng/ddia)


## Notes {#notes}


### Part 1 {#part-1}


#### Chap 1 {#chap-1}

数据系统的概念:

数据存储可以用作消息队列(Redis), 消息队列也有持久化的保证(Kafka).

推特首页的实现方式:

1.  采用每次去数据库里面查询, 但是性能不好
2.  每个用户有个 list, 每次发推后, 给对应关注的用户 list 添加数据

> 保证网站响应迅速对于保持客户的满意度非常重要，亚马逊观察到：响应时间增加 100 毫秒，销售
> 量就减少 1％；而另一些报告说：慢 1 秒钟会让客户满意度指标减少 16% 推特。


#### Chap 2 {#chap-2}

> 存储 ID 还是文本字符串，这是个 副本（duplication） 问题。
>
> 新的非关系型“NoSQL”数据存储在两个主要方向上存在分歧：
>
> 1.  文档数据库的应用场景是：数据通常是自我包含的，而且文档之间的关系非常稀少。
> 2.  图形数据库用于相反的场景：任意事物都可能与任何事物相关联。

图数据模型, 这一块没啥基础, 就草草的看过了

声明式查询 vs 命令式


#### Chap 3 {#chap-3}

对以下概念讲得真棒:

-   LSM Tree, B Tree
-   聚集索引, 非聚集索引, 覆盖索引
-   OLTP, OLAP
-   数据仓库
-   列式存储

> 作为一名应用程序开发人员，如果你掌握了有关存储引擎内部的知识，那么你就能更好地了解哪种工
> 具最适合你的特定应用程序。如果你需要调整数据库的调整参数，这种理解可以让你设想一个更高或
> 更低的值可能会产生什么效果。
>
> 尽管本章不能让你成为一个特定存储引擎的调参专家，但它至少大概率使你有了足够的概念与词汇储
> 备去读懂你所选择的数据库的文档。


#### Chap 4 编码与演化 {#chap-4-编码与演化}

这一章主要讲了数据的编码格式, 语言内置的编码 (Python 的 pickle, Golang 的 gob 之类的),
更通用的格式 (JSON, XML...), 还有二进制编码 (MessagePack, Thrift, Protocol Buffers...),
以及如何实现向前向后兼容 (这部分仔细讲解了 Thrift, Protocol Buffers 和 Avro 的编码格式).

还有数据流的几种类型 (数据库, RPC, 消息传递), 看完这里你就会明白为什么上有人用消息队列实
现 RPC[^fn:1], 还有 Event Sourcing 的概念, 本质都是数据. 说数据的怎么又说到 RPC 去了, 只
能说 RPC 是也是数据交流的方式, 再延伸一下, 程序等于数据加算法, 这里的数据涵盖到编程的方
方面面也正常.

[^fn:1]: [使用 RabbitMQ 实现 RPC - 小芳芳的文章 - 知乎](https://zhuanlan.zhihu.com/p/48230422)
