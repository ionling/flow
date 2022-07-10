+++
title = "微服务定时任务调研"
date = 2022-07-10T11:25:36+08:00
draft = false
+++

定时任务是业务开发中必不可少的一个系统组件, 与消息队列, 缓存, 数据库一样. 微服务架构目前
(2022) 已经是高并发, 大规模的后端最佳实践, 本文将对比业界主流的定时任务框架, 并根据自己
的需求给出心目中微服务定时任务框架的最好选择.

## 框架基本要求

我理想中的微服务定时任务框架需要满足以下几个要求:

- 任务日志
  - 每次任务运行的开始时间, 结束时间, 任务结果... 需要被记录
- 任务可配置, 热更新
  - 任务可以通过配置文件直接定义, 并且可以热更, 无需重启服务
- 支持一次性任务
- 任务可调试
- 管理后台
- 支持服务发现

## 开源方案

### Celery

Celery 本身是一个异步任务队列框架, 不过通过 beat 组件也支持定时任务.

架构如下图所示, 原图[^1]:

![celery-arch1.jpg](https://s2.loli.net/2022/01/30/AW2YfNM1GnevTot.jpg)

- Celery 本身作为一个任务队列, 可以分成两部分: Worker 和 Broker
- 程序将任务发给 Broker, Broker 再将任务分发给 Worker 执行
- 如果要执行定时任务, 则需要启动一个 Celery beat 服务
- 这个服务充当调度器, 触发任务, 任务会发给 Broker, 最后由 Worker 执行

### Airflow

一个基于 DAG (有向无环图) 的工作流引擎:

1. 使用消息队列让系统更易**扩展**
2. 采用 Python 编写, 可以使用 Python 来**动态**定义管线
3. 通过自定义 Operators 和扩展库使得引擎有良好的**可扩展性**
4. 提供 Web UI 操作更加直观
5. 内置了丰富的 Operators...

### K8s CronJob

CronJob controller 的实现也是用的 [robfig/cron], 具体代码[^15]就不分析了. K8s CronJob 是
以 Pod 为单位进行调度的, 意思是每个任务都需要打包成一个镜像, 当然也可以每次都指定同一个
容器, 但是传给容器的参数不一样.

> Job 会创建一个或者多个 Pods，并将继续重试 Pods 的执行，直到指定数量的 Pods 成功终止。
> 随着 Pods 成功结束，Job 跟踪记录成功完成的 Pods 个数。 当数量达到指定的成功个数阈值时，
> 任务（即 Job）结束。 删除 Job 的操作会清除所创建的全部 Pods。 挂起 Job 的操作会删除
> Job 的所有活跃 Pod，直到 Job 被再次恢复执行。[^17]

Cons:

1. 任务需要幂等
2. 最高精度的调度为分钟
3. 启动任务是拉取镜像创建 Pod 需要时间, 可能造成任务延迟执行 (不清楚会不会提前进行)

> CronJob 根据其计划编排，在每次该执行任务的时候大约会创建一个 Job。 我们之所以说 "大约"，
> 是因为在某些情况下，可能会创建两个 Job，或者不会创建任何 Job。 我们试图使这些情况尽量
> 少发生，但不能完全杜绝。因此，Job 应该是 幂等的。
>
> CronJob 控制器每 10 秒钟执行一次检查。[^16]

还有一些其他问题:

1. 一定量级下 CronJob schedule delay (文章是在 v1.17 下, 最新的版本性能应该优化过了)
   1. [聊一聊 Kubernetes cronJob controller 的那些事儿 - 掘金](https://juejin.cn/post/6844904020973191182)
2. Lyft 的一些经验之谈
   1. [Kubernetes CronJobs at Scale Part 1 by Kevin Yang | Lyft Engineering](https://eng.lyft.com/improving-kubernetes-cronjobs-at-scale-part-1-cf1479df98d4)
   2. [Kubernetes CronJobs at Scale Part 2 by Kevin Yang | Lyft Engineering](https://eng.lyft.com/how-we-learned-to-improve-kubernetes-cronjobs-at-scale-part-2-of-2-dad0c973ffca)
   3. 对应的翻译
      1. [我们如何学会大规模改善Kubernetes CronJobs（第1部分，共2部分）](https://mp.weixin.qq.com/s?src=11&timestamp=1657377576&ver=3910&signature=bCpp3MNAlV*HJZGR*0A7J1OtYU9siqlSLrm9zh2cOY8ZVOEVuKZSUFQHNyWh9qeu-JSCGLNiD1LggWQF2oFP6CB*8qeCTJozyaDQjnMmhRt37Bi6XJjmofKUFgkPapHa&new=1)
      2. [我们如何学会大规模改善Kubernetes CronJobs（第2部分，共2部分）](https://zhuanlan.zhihu.com/p/305040921)
3. K8s v1.19 中对定时器的优化以及他们进行的定制化操作
   - [Kubernetes中CronJob的改进以及我们的定制化需求 - 我的小米粥分你一半](https://corvo.myseu.cn/2022/02/27/2022-02-27-Kubernetes%E4%B8%ADCronJob%E7%9A%84%E6%94%B9%E8%BF%9B%E4%BB%A5%E5%8F%8A%E6%88%91%E4%BB%AC%E7%9A%84%E5%AE%9A%E5%88%B6%E5%8C%96%E9%9C%80%E6%B1%82/)

### go-cron-job-microservice

https://github.com/jz222/go-cron-job-microservice

看了一下源码, 底层使用 [robfig/cron] 做调度器[^2], 任务通过 HTTP 方式触发, 任务配置信息保存
到 MongoDB 里面.

### Summary

1. Celery
   1. 缺点: 如果当前任务队列阻塞, 则定时任务会延时执行
   2. 与 Python 技术栈绑定
2. Airflow
   1. 如果定时任务很多, 依赖很复杂的话, 就需要这么一个系统
   2. 普通公司来说不需要这么复杂的东西
3. K8s CronJob
   1. 只支持分钟级别的调度
   2. 与 K8s 绑定, 需要熟悉 K8s
4. go-cron-job-microservice
   1. 与 MongoDB 绑定
   2. 只是一个简单的 Demo

### Others

这里还有一些其他一些比较成熟的定时任务框架, 就不深入研究了:

- [分布式任务调度平台XXL-JOB](https://www.xuxueli.com/xxl-job/)
- [ElasticJob](https://shardingsphere.apache.org/elasticjob/current/cn/overview/)
  - Job 类型
    - Simple Job
    - Dataflow Job
    - Script Job
    - HTTP Job
- [SIA-TASK - GitHub](https://github.com/siaorg/sia-task)
  - README 里面的截图很漂亮
  - [宜信开源|分布式任务调度平台 SIA-TASK 的架构设计与运行流程 - SegmentFault](https://segmentfault.com/a/1190000019382088)
- [GitHub - shunfei/cronsun: A Distributed, Fault-Tolerant Cron-Style Job System.](https://github.com/shunfei/cronsun)

## 定时任务的组织

微服务里的定时任务该怎么编写, 如何组织:

- 方案一: 每个服务一个定时任务服务
  - Cons
    - 定时任务服务太多, 创建服务很麻烦
    - 每个服务都要一直运行, 占用服务器资源
- 方案二: 直接在服务里启动定时任务
  - Cons
    - 一般一个服务会有多个副本同时运行, 需要分布式锁来保证一个任务只会执行一次
- 方案三: 全局唯一调度器服务 + 接口调用触发
  - HTTP/gRPC 触发
  - Cons
    - 对于任务执行时间比较长的, 肯定是异步执行
      - 这样就无法记录任务结果
      - 并且在任务执行过程中, 运行该服务容器不能退出 (容易受到业务接口的影响)
      - 后面集成链路追踪应该可以解决这个问题

目前就使用方案三, 所有的任务都通过配置文件来定义, 业务代码该在哪在哪, 不要耦合[^13].

## 参考

1. [分布式任务调度SchedulerX](https://cn.aliyun.com/aliware/schedulerx)
2. [探寻繁杂定时任务的解决方案：分布式任务调度系统 - 掘金](https://juejin.cn/post/6844904142473789448)
3. [容器化平台定时任务设计调研笔记 - 晒太阳的猫](https://zhengyinyong.com/post/cronjob-in-container-platform/)
4. [Celery: an overview of the architecture and how it works](https://www.vinta.com.br/blog/2017/celery-overview-archtecture-and-how-it-works/)

[robfig/cron]: https://github.com/robfig/cron

[^1]: [amazonaws/producer\_\_consumer.jpg](https://vinta-cms.s3.amazonaws.com/media/filer_public/e4/73/e473005f-2190-40bd-86a5-cb0b9f60a810/producer__consumer.jpg)
[^2]: [github/go.mod#L15](https://github.com/jz222/go-cron-job-microservice/blob/4c335b237c5cf5633367ddb73de496f40db4873c/go.mod#L15)
[^13]: [请教大佬们，微服务中定时任务的代码应该如何设计 - V2EX](https://v2ex.com/t/802400)
[^15]: [sourcegraph/cronjob_controllerv2.go?L27](https://sourcegraph.com/github.com/kubernetes/kubernetes@v1.23.3/-/blob/pkg/controller/cronjob/cronjob_controllerv2.go?L27)
[^16]: [CronJob | Kubernetes](https://kubernetes.io/zh/docs/concepts/workloads/controllers/cron-jobs/)
[^17]: [Jobs | Kubernetes](https://kubernetes.io/zh/docs/concepts/workloads/controllers/job/)
