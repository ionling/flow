+++
title = "Erlang"
date = 2022-05-21T00:00:00+08:00
lastmod = 2022-05-21T23:13:40+08:00
draft = false
+++

## Links {#links}

-   [Erlang Programming Language](https://www.erlang.org/)
-   [The WhatsApp Architecture Facebook Bought For $19 Billion - High Scalability -](http://highscalability.com/blog/2014/2/26/the-whatsapp-architecture-facebook-bought-for-19-billion.html)


## Intro {#intro}


### 游戏开发 {#游戏开发}

[从事 erlang 开发的你们现在都怎么样了？ - manlin 的回答 - 知乎](https://www.zhihu.com/question/325308435/answer/1026747365):

> 目前我们公司几乎都是 erlang 作为主导，开发了不少游戏。从部署到运维后期，erlang 都表
> 现的非常优秀，从来没掉过链子。这一点也是绝大多数人使用它的原因之一。


### 任其崩溃 {#任其崩溃}

[应该如何理解 Erlang 的「任其崩溃」思想？ - 天才的回答 - 知乎](https://www.zhihu.com/question/21325941/answer/948855070):

> 所以“任其崩溃”，其实是有前提条件的。这个前提条件是：
>
> **隔离。无副作用。**


### 微服务 {#微服务}

[为啥 Erlang 没有像 Go、Scala 语言那样崛起？ - 布丁的回答 - 知乎](https://www.zhihu.com/question/38032439/answer/84176970):

> 你甚至可以认为整个 Google 集群管理系统 Borg 就是一个大号 Erlang 平台，一堆
> supervisor 在管着一堆 share nothing RPC 消息通信随时会挂的服务（流行用语叫 micro
> service），绝大部分服务无状态可以随时挂。

[微服务架构学习之我见 - 简书](https://www.jianshu.com/p/11f47b69b18c):

> Erlang 跟微服务实际上没有什么直接的关系。但是这门语言的设计哲学使得我们能发现它跟微服务
> 之间的一些内在关联。
>
> Erlang 具有以下特征：
>
> 1.  轻量级进程。单台 PC 机上可以创建数以万计的进程。
> 2.  消息驱动。进程之间通过消息进行交互。
> 3.  容错。进程之间的链接、监督使得系统更可靠。
> 4.  通过进程组管理进程。
>
> 这些特征使得 Erlang 开发出来的系统天然地就类似于一个小型的微服务系统，两者看上去颇有几分
> 神似


## QA {#qa}


### 什么是软实时调度 {#什么是软实时调度}

-   [Erlang的调度原理（译文） - siyao - 博客园](https://www.cnblogs.com/zhengsyao/p/how_erlang_does_scheduling_translation.html)

简单来说, 就是两次调度之间的时间比较短(1ms), 这样就保证所有的任务都有公平的时间份额, 代
价是上下文切换带来的性能损失, 所谓的鱼与熊掌不可兼得.