---
layout: post
title: Git 常用命令
excerpt: 收集了自己平常使用的一些git命令,方便后期快速查看
tags:
  - git
---

### # tag
````
git tag 显示已经有的标签
git tag -l 'v1.0.*' 匹配标签
git tag -a v1.0.0 -m 'connotated'  含附注的标签
git tag v1.0.0 创建轻量标签
git show v1.0.0 查看标签
git push origin v1.0.0 标签分享
git push origin --tags 分享全部标签
````
### # git ls-remote

查看远程仓库情况
````
git ls-remote --tags 查看远程tag情况
git ls-remote --get-url 查看远程 url 
````


### # cherry-pick 
    git cherry-pick  <commit id> 提交单个commit 到当前分支
    - dev           开发分支
    - master        主分支
    - master_feature 主分支功能开发
    
     
     由于开始一直在 dev 分支开发,所以需要将刚刚提交的两次commit 合并到 master 分支,但是这个时候又不希望之前的内容一块合并了.
     这个时候我们就可以使用 `cherry-pick` 命令,分别提交这两次 commit master 分支.
    
     git checkout master
     git checkout -b master_feature
     ## commit 补充到 master_feature分支
     git cherry-pick 32b9e1c
     git cherry-pick 3459e1c
    
     # 这个时候我们以后可以直接在 master_feature 分支开发,最后在合并
     # 或者使用下面的操作,不创建新分支,直接提交到主分支
    
     git checkout master
     git cherry-pick 32b9e1c
     git cherry-pick 3459e1c


### # git fetch , git rebase,git pull
````
git fetch 从远程拉去信息到本地仓库
git pull 从远程拉去信息到本地仓库和工作区域
git fetch origin master 拉去 origin 上面的 master 分支信息(--all 拉去全部远程仓库数据)
git rebase origin/master 合并 origin/master 到本地工作区
````
### # clean
````
git checkout . && git clean -xdf 删除当前全部没有提交的数据
````
### # checkout
````
git checkout -b feature-1 origin/master 根据远程分支的基础上分化出一个新的分支来
git checkout <file> 从暂存区恢复文件
````
### # push  **

````
git push [远程名] :[分支名] # git push origin :serverfix
````
删除远程分支名,但是保留本地 commit,**git push [远程名] [本地分支]:[远程分支] 语法，如果省略[本地分支]，那就等于是在说“在这里提取空白然后把它变成[远程分支]”。**



### # rm
````
git rm --cached <file> 解除对改文件的 tracked
git reset HEAD <file> 从暂存区删除该文件
````

### # stash

**注意只能暂存添加到 stage 当中的数据**
````
git stash 可用来暂存当前正在进行的工作
git stash pop 取出,并且删除最后一次 stash 的数据
git stash save "work in progress for foo feature" 添加注释
git stash list 查看 stash 列表
````
### # git 相关别名
````
alias.st=status
alias.co=checkout
alias.ci=commit
alias.br=branch
alias.lg=log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
alias.unstage=reset HEAD
alias.last=log -1
````

### # rebase , merge

```
 o---o---o---o---o  master
                    \
                     o---o---o---o---o  next
                                      \
                                       o---o---o  topic

# 将 topic 与 next 不同部分 衍合到 master 分支当中,注意不衍合 topic 和next 共有部分!!!  (这里功能是合并topic 特有的三个 commit )
# git rebase --onto master next topic
# git merge topic # on master branch

 o---o---o---o---o  master
                   |       \
                   |        o'--o'--o'  topic
                    \
                     o---o---o---o---o  next


# 测试完毕 next 分支,再把 next 分支衍合

git rebase master next 

# git merge next # on master branch


# 上面提到的,如果我们打算将 topic 分支与 master 合并,可以使用下面两个命令
# on master branch 
git merge topic 
git rebase topic 
```

### #  git rebase 多人开发
```
# dev
# git pull ==> git fech origin master && git merge origin/master
# git rebase origin master 我在本地的分支 dev_branch上， 对远程仓库（默认origin代表远程仓库）的 master 使用变基拣选操作
# git rebase master 对本地仓库的master使用变基拣选操作

git pull --rebase origin master


git co master && git merge dev && git push


#  momo
# git pull = git fetch + git merge
# git pull --rebase = git fetch + git rebase

git pull --rebase origin master

git checkout master && git merge momo && git push
```