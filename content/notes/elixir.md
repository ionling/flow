+++
title = "Elixir"
date = 2022-05-21T00:00:00+08:00
lastmod = 2022-05-21T23:10:44+08:00
draft = false
+++

## Links {#links}

-   [Elixir](https://elixir-lang.org/)
-   [Elixir School](https://elixirschool.com/zh-hans/)
-   [Elixir 程序设计 · 看云](https://www.kancloud.cn/wizardforcel/programming-elixir)
-   [神奇的仙丹，性感的 Elixir - 张逸说 - SegmentFault 思否](https://segmentfault.com/a/1190000009088163)
-   [A week with Elixir - Joe Armstrong - Erlang and other stuff](https://joearms.github.io/published/2013-05-31-a-week-with-elixir.html)
-   <https://klibert.pl/statics/python-and-elixir/>
-   [Elixir交互式Shell: 3. 创建本地和远程Shell - SegmentFault 思否](https://segmentfault.com/a/1190000004912067)
-   [Is Elixir a scripting language?](https://thoughtbot.com/blog/is-elixir-a-scripting-language)
-   [Cool CLIs in Elixir (Part 2) with IO.ANSI | Dennis Beatty](https://dennisbeatty.com/2019/03/12/cool-clis-in-elixir-part-2-with-io-ansi.html)


## Install {#install}

-   [Installing Elixir - Elixir](https://elixir-lang.org/install.html)


### macOS {#macos}

```shell
brew install elixir
```


## Language Reference {#language-reference}


### Operators {#operators}

-   in


### Range {#range}

-   [Range — Elixir v1.10.3](https://hexdocs.pm/elixir/Range.html)


### Types {#types}

-   Basics
    -   Integers
    -   Floats
    -   Booleans
    -   Atoms
    -   Strings
-   Collections
    -   Lists
    -   Tuples
    -   Keyword lists
    -   Maps


## Notes {#notes}

当匹配的左边包含变量的时候，匹配操作符同时会做赋值操作。


## elixir-ls {#elixir-ls}

-   [elixir-lsp/elixir-ls](https://github.com/elixir-lsp/elixir-ls)

<!--listend-->

```sh
mkdir -p ~/.local/elixir-ls
unar elixir-ls-1.12.1.zip -o ~/.local/elixir-ls -D

# Add following to .zshenv
[ -d ~/.local/elixir-ls ] && export PATH=~/.local/elixir-ls:$PATH
```


## OTP {#otp}

-   [Erlang/Elixir 中的 OTP 编程介绍 - 掘金](https://juejin.im/post/5b34494a51882574866d5d97)
-   [OTP in Elixir: Learn GenServer by Building Your Own URL Shortener - Ilija Eft...](https://ieftimov.com/post/otp-elixir-genserver-build-own-url-shortener/)


## IEx {#iex}

-   i
-   c
-   r


## Mix {#mix}

```sh
# Usage: mix [task]
mix help                        # Lists all available tasks
mix help TASK                   # Prints documentation for a given task
```


## Hex {#hex}

The package manager for the Erlang ecosystem


### Mirrors {#mirrors}

-   [Mirrors | Hex](https://hex.pm/docs/mirrors)

<!--listend-->

```sh
mix hex.config mirror_url https://hexpm.upyun.com
```


## Frameworks {#frameworks}


### Phoenix {#phoenix}

-   [Phoenix](https://www.phoenixframework.org/)
-   [A Gentle Introduction to GraphQL with Elixir and Phoenix](https://timber.io/blog/a-gentle-introduction-to-graphql-with-elixir-and-phoenix/)
-   [Creating GraphQL APIs Using Elixir Phoenix and Absinthe](https://medium.com/velotio-perspectives/creating-graphql-apis-using-elixir-phoenix-and-absinthe-486ff38f2549)


## Solutions {#solutions}


### Periodic task {#periodic-task}

-   <https://medium.com/@efexen/periodic-tasks-with-elixir-5d9050bcbdb3>
-   <https://medium.com/@efexen/periodic-tasks-with-elixir-part-2-8aaee425aed0>
-   [GitHub - quantum-elixir/quantum-core: Cron-like job scheduler for Elixir](https://github.com/quantum-elixir/quantum-core)
-   [GitHub - erlware/erlcron: Erlang cronish system](https://github.com/erlware/erlcron)