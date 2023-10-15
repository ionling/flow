+++
title = "如何在 Kubernetes 上快速调试 Distroless 容器"
date = 2023-09-26T09:49:00+08:00
lastmod = 2023-10-15T18:16:01+08:00
draft = false
+++

See [微信文章](https://mp.weixin.qq.com/s?__biz=MzI3MTI2NzkxMA%3D%3D&mid=2247527762&idx=1&sn=2cfd745be7b5a31e2e5c3d22652384d0)

> 1.  使用 distroless debug 镜像
> 2.  debug 容器与共享进程命名空间
> 3.  `kubectl debug`
>
> 目前上面所有的都不适合在生产环境使用，无法在不修改 Pod 定义的情况下进行调试。
>
> 期望 Kubernetes 1.23 版本之后 debug 功能添加 SYS_PTRACE 的支持。到时候，再尝试一下。
