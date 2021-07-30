+++
title = "简单命令行增强"
date = 2021-07-30T15:17:00+08:00
lastmod = 2021-07-30T15:17:13+08:00
draft = false
+++

这里介绍三个我日常经常用到的工具, 对于需要频繁命令行操作的工作, 能带来一定效率的提升.(之
前公司内部的分享, 现在整理一下, 重新发布)


## fish {#fish}

Shell 有好几种，目前最常用是 Bash 和 Zsh。[^fn:1] fish 是“friendly
interactive shell”的缩写，是一个“交互式的、对用户友好的 命令行 shell”。[^fn:2]


### Features {#features}

Fish 有如下特性:


#### Auto suggestions {#auto-suggestions}

Fish 会自动根据历史和补全进行智能提示:

{{< figure src="https://i.loli.net/2021/07/30/7my4YnB5IRqVeEd.gif" >}}


#### Tab completions {#tab-completions}

使用 Tab 键进行补全:

{{< figure src="https://i.loli.net/2021/07/30/PL1izuR6H7hZYsp.jpg" >}}

Fish 还能根据 Man Page 自动生成补全:

{{< figure src="https://i.loli.net/2021/07/30/QLpsFMeZoXKzvwO.jpg" >}}


#### Syntax highlighting {#syntax-highlighting}

Fish 对于不正确的命令会显示红色, 正确的命令会显示蓝色:

不存在的路径:

{{< figure src="https://i.loli.net/2021/07/30/bL85nX9CFVc1e3i.jpg" >}}

不存在的命令:

{{< figure src="https://i.loli.net/2021/07/30/UJPXWFobO5Qjdl2.jpg" >}}

存在的命令:

{{< figure src="https://i.loli.net/2021/07/30/lPaFXMVe1CEy3TG.jpg" >}}


### 注意事项 {#注意事项}

在使用中需要注意的是 fish 被有意设计成不完全与 POSIX 兼容. fish 的作者们认为 POSIX 中存在
一些缺陷和矛盾, 并通过 fish 简化的或不同的语法解决这些问题. 因此, 即使简单的 POSIX 兼容
的脚本也可能需要较多的修改, 甚至完全重写, 才能在 fish 中运行.[^fn:2] 在遇到不兼容的情
况下, 我们可以切换到 Bash 下进行操作.


### 安装 {#安装}

我们的测试服务器的系统基本都是 CentOS 7. 虽然 EPEL 里有 fish 包, 但是不推荐
这种方式, 一是 fish 版本比较老, 二是安装速度慢(不知道启用了 fastestmirror 插
件为啥还是这么慢). 建议直接下载 RPM 包扔到服务器上安装.

RPM 包可以进这个网站下载: [Install package shells:fish:release:3 / fish](https://software.opensuse.org/download.html?project=shells:fish:release:3&package=fish).

```bash
scp fish-3.0.2-1.13.x86_64.rpm root@10.252.3.108:/tmp/fish-3.0.2-1.13.x86_64.rpm
rpm -i /tmp/fish-3.0.2-1.13.x86_64.rpm
rm /tmp/fish-3.0.2-1.13.x86_64.rpm
```


## fzf {#fzf}

[GitHub - junegunn/fzf: A command-line fuzzy finder](https://github.com/junegunn/fzf)


### 简介 {#简介}

fzf is a general-purpose command-line fuzzy finder.[^fn:3]

{{< figure src="https://raw.githubusercontent.com/junegunn/i/master/fzf-preview.png" >}}

It's an interactive Unix filter for command-line that can be used with any
list; files, command history, processes, hostnames, bookmarks, git commits,
etc.

我一般用来快速执行历史命令(CTRL-R):

{{< figure src="https://i.loli.net/2021/07/30/BcwFuitnC1V2KYJ.png" >}}

使用 CTRL-T 可以快速获取当前目录及子目录的文件路径:

{{< figure src="https://i.loli.net/2021/07/30/Aor3SbBe4TpzLc1.png" >}}

fzf 结合其他命令可以组合出很多种用法, 大家可以网上搜一下, 或者直接看 fzf GitHub Wiki.


### 安装 {#安装}

```bash
# Install
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Or update
cd ~/.fzf && git pull && ./install
```


## z.lua {#z-dot-lua}

[GitHub - skywind3000/z.lua: A new cd command that helps you navigate faster b...](https://github.com/skywind3000/z.lua)

z.lua 是一个快速跳转目录的工具, 它是 [z](https://github.com/rupa/z) 一个改进版, 与之类似的还有 [autojump](https://github.com/wting/autojump).


### Features {#features}

快速跳转到目录:

{{< figure src="https://i.loli.net/2021/07/30/bXVu3FyAKQ6BhfM.jpg" >}}

列出访问过的目录:

{{< figure src="https://i.loli.net/2021/07/30/4nv9MNidQ6zYbhU.jpg" >}}

自动补全:

{{< figure src="https://i.loli.net/2021/07/30/EkdxHYJSR5FTOXI.jpg" >}}


### 安装 {#安装}

安装的话比较简单, 从 GitHub 上下载下来 z.lua 就可以, 然后在 shell 的初始化脚本
里加入初始化代码就 ok 了.

Bash:

```bash
# NOTE: Replace `/path/to/z.lua` to real path
eval "$(lua /path/to/z.lua --init bash enhanced once)"
```

Fish:

Create `~/.config/fish/conf.d/z.fish` with following code.

```shell
source (lua /path/to/z.lua --init fish enhanced once | psub)
```

[^fn:1]: [Fish shell 入门教程 - 阮一峰的网络日志](http://www.ruanyifeng.com/blog/2017/05/fish%5Fshell.html)
[^fn:2]: [fish (简体中文) - ArchWiki](https://wiki.archlinux.org/index.php/Fish%5F(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))
[^fn:3]: [GitHub - junegunn/fzf: A command-line fuzzy finder](https://github.com/junegunn/fzf)
