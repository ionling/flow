+++
title = "GMP"
lastmod = 2021-10-19T21:44:56+08:00
draft = false
+++

-   [Go 语言调度器与 Goroutine 实现原理 | Go 语言设计与实现](https://draveness.me/golang/docs/part3-runtime/ch06-concurrency/golang-goroutine/)
-   [也谈goroutine调度器 | Tony Bai](https://tonybai.com/2017/06/23/an-intro-about-goroutine-scheduler/)
-   煎鱼的这两篇文章到时很容易理解, 比那些动不动就来啥状态转换和源码分析的好多了
    -   [Go 群友提问：Goroutine 数量控制在多少合适，会影响 GC 和调度？](https://mp.weixin.qq.com/s?%5F%5Fbiz=MzUxMDI4MDc1NA%3D%3D&mid=2247487250&idx=1&sn=3004324a9d2ba99233c4af48843dba64)
    -   [再见 Go 面试官：GMP 模型，为什么要有 P？](https://mp.weixin.qq.com/s/an7dml9NLOhqOZjEGLdEEw)

最开始的 Go 1.0 是 GM 模型, 没有 P, G 表示的就是 goroutine, M (machine) 表示系统线程, G
运行时会绑定一个 M, 调度器会维护一个全局的 goroutine 队列, 当一个 G 执行完了的时候, 会从
全局队列中取 G 继续执行, 如果 G 被阻塞了(比如一些系统, 网络调用), 这时 M 就会被重新放内
核队列中，等待新的一轮唤醒.

但是这样做实际上会有一些问题(下面的描述不够清晰, 可以参考这个[^fn:1]的多线程调度器小节):

-   存在单一的全局锁:
    -   所有与 goroutine 相关的操作(创建、完成、重排等), 都需要锁的保护, 锁竞争严重
-   Goroutine 交接:
    -   M 之间会经常交接可运行的 goroutine, 每个 M 必须能够执行任何可运行的 G，特别是刚刚创
        建 G 的 M, 这会导致延迟增加和额外的开销.
-   每个 M 都需要内存缓存(M.mcache):
    -   导致资源消耗过大(每个 mcache 可以使用到 2M 的内存缓存和其他缓存)
-   频繁的线程阻塞:
    -   存在 syscalls 的情况下, 线程经常被阻塞, 这增加了很多额外的性能开销.

为了解决上述问题, Go 1.1 引入了 P (processor), 并且实现了 Work Stealing 算法来解决一些新
产生的问题.

带来的变化:

-   每个 P 有自己的本地队列, 大幅度地减轻了对全局队列的依赖, 所带来的效果就是锁竞争的减少.
    而 GM 模型主要的性能开销就是锁竞争.
-   通过 Work Stealing 算法, 如果 P 的本地队列为空, 则会从全局队列和其他 P 的本地队列窃取
    G 来运行, 减少空闲, 提高资源利用率.

[^fn:1]: [Go 语言调度器与 Goroutine 实现原理 | Go 语言设计与实现](https://draveness.me/golang/docs/part3-runtime/ch06-concurrency/golang-goroutine/)
