+++
title = "Git"
date = 2021-11-19T00:00:00+08:00
lastmod = 2021-11-19T12:27:19+08:00
draft = false
+++

## Commands {#commands}


### worktree {#worktree}

-   [Git Worktrees: The Best Git Feature You’ve Never Heard Of](https://levelup.gitconnected.com/git-worktrees-the-best-git-feature-youve-never-heard-of-9cd21df67baf)
-   [Git worktree 作用及使用 | Verne in GitHub](https://einverne.github.io/post/2019/03/git-worktree.html)


## Config {#config}


### Lookup order {#lookup-order}

Git 使用一系列的配置文件来存储你定义的偏好，它首先会查找 `/etc/gitconfig` 文件，
该文件含有 对系统上所有用户及他们所拥有的仓库都生效的配置值（译注：
`gitconfig` 是全局配置文件）， 如果传递 `--system` 选项给 `git config` 命令，
Git 会读写这个文件。

接下来 Git 会查找每个用户的 `~/.gitconfig` 文件，你能传递 `--global` 选项让
Git 读写该文件。

最后 Git 会查找由用户定义的各个库中 Git 目录下的配置文件（ `.git/config` ），
该文件中的值只对属主库有效。 以上阐述的三层配置从一般到特殊层层推进，如果定义
的值有冲突，以后面层中定义的为准，例如：在 `.git/config` 和 `/etc/gitconfig`
的较量中， `.git/config` 取得了胜利。虽然你也可以直接手动编辑这些配置文件，但
是运行 `git config` 命令将会来得简单些[^fn:1]。


### autocrlf {#autocrlf}

以 `FlashExpressAssistant` 为例, 以前在 Windows 上开发, 换行符为 CRLF, 现在我
需要在 Linux 上对代码进行一些小修复, 我可以把 `core.autocrlf` 设置成 `input`,
具体的解释可以参见[^fn:1]里的 `core.autocrlf` 一节.

```bash
git config core.autocrlf input
```


## Services {#services}

-   Gitee
-   CODING


### GitLab {#gitlab}

-   [极狐GitLab官方网站\_DevOps 平台\_源代码管理\_持续集成工具](https://about.gitlab.cn/)


### GitHub {#github}


#### Profile README {#profile-readme}

-   [Shields.io: Quality metadata badges for open source projects](https://shields.io/)
-   [GitHub 自定义首页，结合 GitHub Action 更香 - 知乎](https://zhuanlan.zhihu.com/p/180550738)
-   <https://github-readme-stats.vercel.app/api?username=ionling>


## Tools {#tools}


### Gitmoji {#gitmoji}

-   [gitmoji | An emoji guide for your commit messages](https://gitmoji.dev/)
-   [GitHub - carloscuesta/gitmoji-cli: A gitmoji interactive command line tool fo...](https://github.com/carloscuesta/gitmoji-cli)


```sh
npm i -g gitmoji-cli
```


### Tree Viewer {#tree-viewer}

-   [GitHub - ineo6/git-master: Git Master Extension for git file tree, support Gi...](https://github.com/ineo6/git-master)
-   [GitHub - tavyandy97/span-tree: 🌳 Tree for GitLab](https://github.com/tavyandy97/span-tree)
-   [GitHub - ovity/octotree: GitHub on steroids](https://github.com/ovity/octotree)


## Issues {#issues}


### Diffs contain control sequences in magit {#diffs-contain-control-sequences-in-magit}

Because you set `color.ui` to `always`[^fn:2]^,^[^fn:3]. Just set it to `true`, and this is
the Git's default option.


## How to {#how-to}


### Change the author of one specific commit {#change-the-author-of-one-specific-commit}

Reference[^fn:4]:

1.  Rebase all commits: `git rebase -i --root`
2.  Change `pick` to `edit` for commits you need to edit
3.  `git commit --amend --reset-author --no-edit`
4.  `git rebase --continue`
5.  Repeat step 3 and step 4


```sh
git commit --amend --author="John Doe <john@doe.org>"
```

More methods see this[^fn:5].


### Extract subdir to new repo {#extract-subdir-to-new-repo}

```sh
mkdir new-repo
cd new-repo
git init --bare

cd ../big-repo
git subtree split --prefix subdir -b split
git push ../new-repo split:master
git branch -d split

# Push to remote
git remote add ...
```

原理:

使用 subtree split 命令将一定前缀的提交记录放到新分支上去, 然后将这个分支推送到一
个新初始化的 git 仓库里就行了(没想到还能 push 到本地仓库, 👍)

参考:

-   [从现有项目中拆分Git Subtree | Hisoka Blog](https://hisoka0917.github.io/git/2018/03/29/split-git-subtree/)
-   [Using Git subtrees to split a repository · Los Techies](https://lostechies.com/johnteague/2014/04/04/using-git-subtrees-to-split-a-repository/)


### Find when a file was deleted {#find-when-a-file-was-deleted}

Reference[^fn:6]

```bash
# see the changes of a file, works even
# if the file was deleted
git log -- [file_path]

# limit the output of Git log to the
# last commit, i.e. the commit which delete the file
# -1 to see only the last commit
# use 2 to see the last 2 commits etc
git log -1 -- [file_path]

# include stat parameter to see
# some statics, e.g., how many files were
# deleted
git log -1 --stat -- [file_path]
```


### Get current branch name {#get-current-branch-name}

```sh
git rev-parse --abbrev-ref HEAD
```


### Manage large files {#manage-large-files}

-   git-annex
-   git-lfs
    -   [Git LFS 服务器实现杂谈](https://forcemz.net/git/2017/04/16/Moses/)


### Recover a deleted branch {#recover-a-deleted-branch}

Just create a new branch by using a branch name, a commit-id, or a tag.

```bash
git branch <branchname> <start-point>
```


### Recover a deleted file {#recover-a-deleted-file}

Reference[^fn:7]

Method1:

1.  `git log --diff-filter=D --summary`: Get all the commits which have deleted
    files and the files deleted(use less \`/\` command to find target commit)
2.  `git checkout $commit~1 filename`: Restore the deleted file
    Example: `git checkout e4cf499627~1 problem/models.py`

    Method2: Use `git rev-list` to find target commit


### Recover a dropped stash {#recover-a-dropped-stash}

If you have only just popped it and the terminal is still open, you will still
have the hash value printed by git stash pop on screen.

Just run `git stash apply $stash_hash`.[^fn:8]


### Rename a branch {#rename-a-branch}

Rename current branch:

```bash
git branch -m new-name
```

Rename a target branch:

```bash
git branch -m old-name new-name
```


### Revert initial commit {#revert-initial-commit}

```bash
git update-ref -d HEAD
```

From: <https://stackoverflow.com/a/6637891>

> You just need to delete the branch you are on. You can't use `git branch -D`
> as this has a safety check against doing this. You can use `update-ref` to do
> this.


### Set editor {#set-editor}

```sh
git config --global core.editor "vim"
```


### Set proxy {#set-proxy}

-   [git 设置和取消代理 · GitHub](https://gist.github.com/laispace/666dd7b27e9116faece6)

With SSH:

```conf-space
Host gitlab.com
    User git
    ProxyCommand nc -x localhost:1080 %h %p
```

With HTTP(S):

```sh
git config --global https.proxy http://127.0.0.1:1080
git config --global https.proxy https://127.0.0.1:1080
```


### Specify ssh key for repo {#specify-ssh-key-for-repo}


#### Steps {#steps}

1.  修改 SSH 配置文件，加入如下内容
2.  然后就可以愉快的提交了


```text
Host gitlab.com
    User git
    IdentityFile ~/.ssh/gitkraken_rsa
    IdentitiesOnly yes
```


#### Attention {#attention}

在 WSL 下，记得修改权限，不然可能会出现如下错误：

-   `Permissions 0777 for '/home/Hope/.ssh/gitkraken_rsa' are too open`
-   `Bad owner or permissions on /home/Hope/.ssh/config`

Run `chmod 600 ~/.ssh/config` and `chmod 600 ~/.ssh/gitkraken_rsa`


#### Reference {#reference}

-   [git 指定 sshkey 访问远程仓库](https://segmentfault.com/a/1190000005349818)
-   [ssh returns "Bad owner or permissions on ~/.ssh/config"](https://serverfault.com/questions/253313/ssh-returns-bad-owner-or-permissions-on-ssh-config)


### Syncing a fork {#syncing-a-fork}

REF [保持 fork 之后的项目和上游同步 · staticblog/wiki Wiki · GitHub](https://github.com/staticblog/wiki/wiki/%E4%BF%9D%E6%8C%81fork%E4%B9%8B%E5%90%8E%E7%9A%84%E9%A1%B9%E7%9B%AE%E5%92%8C%E4%B8%8A%E6%B8%B8%E5%90%8C%E6%AD%A5)

```bash
git remote add upstream https://github.com/staticblog/staticblog.github.io.git
# Check result with `git remote -v`

git fetch upstream
git checkout master
git merge upstream/master

git push
```


## Misc {#misc}


### .gitkeep {#dot-gitkeep}

> git 无法追踪一个空的文件夹，当用户需要追踪(track)一个空的文件夹的时候，按照惯例，大家会
> 把一个称为 .gitkeep 的文件放在这些文件夹里。

[^fn:1]: [unix - bash HISTSIZE vs. HISTFILESIZE? - Stack Overflow](https://stackoverflow.com/a/19454838)
[^fn:2]: [Magit fails, status contains weird characters - Emacs Stack Exchange](https://emacs.stackexchange.com/questions/21983/magit-fails-status-contains-weird-characters)
[^fn:3]: [Magit User Manual: Diffs contain control sequences](https://magit.vc/manual/magit/Diffs-contain-control-sequences.html)
[^fn:4]: [How to change the commit author for one specific commit? - Stack Overflow](https://stackoverflow.com/questions/3042437/how-to-change-the-commit-author-for-one-specific-commit)
[^fn:5]: [How can I change the author (name / email) of a commit? | Learn Version Contr...](https://www.git-tower.com/learn/git/faq/change-author-name-email/)
[^fn:6]: [Git - Tutorial 29. See which commit deleted a file](http://www.vogella.com/tutorials/Git/article.html#retrievefiles%5Ffinddeletedfile)
[^fn:7]: [Find and restore a deleted file in a Git repository - Stack Overflow](https://stackoverflow.com/questions/953481/find-and-restore-a-deleted-file-in-a-git-repository)
[^fn:8]: [How to recover a dropped stash in Git? - Stack Overflow](https://stackoverflow.com/questions/89332/how-to-recover-a-dropped-stash-in-git)
