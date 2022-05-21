+++
title = "Nim"
date = 2022-05-21T00:00:00+08:00
lastmod = 2022-05-21T23:19:22+08:00
draft = false
+++

## Links {#links}

-   [Nim Programming Language](https://nim-lang.org/)
-   [GitHub - nim-lang/Nim: Nim is a compiled, garbage-collected systems programmi...](https://github.com/nim-lang/Nim)
-   [Manning | Nim in Action](https://www.manning.com/books/nim-in-action)
-   [Nim's Memory Management](https://nim-lang.github.io/Nim/gc.html)
-   [Nim ❚ A Scripter's Notes](https://scripter.co/notes/nim)


## Intro {#intro}

-   [静态语言元编程哪家强: Nim · Ruby China](https://ruby-china.org/topics/23915)

[如何评价 Nim 语言？ - Sheldon 的回答 - 知乎](https://www.zhihu.com/question/28224083/answer/540930664):

> 早在十多年前，C++还在探索新标准的时候，德国的一个偏僻小镇上，一位程序员出于对自
> 己所用语言都不满意，以 LISP 元编程为核心，Python 语法为模板，写出了 Nimrod，这是
> Nim 的早期原型。几经辗转，现在的 Nim，提供开箱即用的宏套件，与 C89 无缝交互，编译
> 成 C++的更好性能，也覆盖了 Web 前端单页应用开发，这位程序员则成为了今天的 Nim 之
> 父 Andreas Rumpf - O'Reilly Media。


## Install {#install}

最好使用 choosenim 安装, 方便安装 nimlsp, 否则会报错:

```text
/tmp/nimble_4477/githubcom_PMunchnimlsp/src/nimlsppkg/suggestlib.nim(11, 8) template/generic instantiation of `mImport` from here
/tmp/nimble_4477/githubcom_PMunchnimlsp/src/nimlsppkg/suggestlib.nim(7, 14) Error: cannot open file: /usr/nimsuggest/nimsuggest.nim
    Prompt: Build failed for 'nimlsp@0.3.2', would you like to try installing 'nimlsp@#head' (latest unstable)? [y/N]
```

```sh
pacman -S nim
```


## Tutorials {#tutorials}

-   [Nim basics](https://narimiran.github.io/nim-basics/)
-   [Nim by Example - Main](https://nim-by-example.github.io/)
-   [Learn Nim in Y Minutes](https://learnxinyminutes.com/docs/nim/)
-   [Intro - Nim Days](https://xmonader.github.io/nimdays/book_intro.html)


## Toolchain {#toolchain}


### choosenim {#choosenim}

-   [dom96/choosenim](https://github.com/dom96/choosenim)


### nimble {#nimble}

-   [nim-lang/nimble: Package manager for the Nim programming language.](https://github.com/nim-lang/nimble)

<!--listend-->

```sh
sudo pacman -S nimble
```


### nimlsp {#nimlsp}

-   [PMunch/nimlsp: Language Server Protocol implementation for Nim](https://github.com/PMunch/nimlsp)

With Nim installed through choosenim

```sh
nimble install nimlsp
```


## Packages {#packages}

-   [Nim package directory](https://nimble.directory/)
-   [GitHub - andreaferretti/patty: A pattern matching library for Nim](https://github.com/andreaferretti/patty)
