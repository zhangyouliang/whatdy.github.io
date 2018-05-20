---
layout: post
title: LINUX 实用命令
excerpt: Linux 常用命令笔记,不定期更新
tags:
  - linux
---
### # sed 

比如，我想替换文件中的 properties 为 property ,可以使用
```bash
sed  's/properties/property/g'  build.xml
```
这种方式，其实并没有修改build.xml文件的内容。如果想保存修改，通常的做法就需要重定向到另外的一个文件

```bash
sed  's/properties/property/g'  build.xml > build.xml.tmp
# 如果想直接修改源文件，而没有这样的过程，可以用下面的命令
sed  -i 's/properties/property/g'  build.xml
```
### # 列出当前目录全部的目录

```bash
# 三种方式
find . -type d -maxdepth 1
ls -F | grep '/$'
ls -l | grep '^d'
```

### # 列出当前目录下的所有文件（包括隐藏文件）的绝对路径， 对目录不做递归

    ls | sed "s:^:`pwd`/:"
    find $PWD -maxdepth 1 | xargs ls -ld
    nl 显示文件的行数
    head 显示前几行
    sort 按照顺序排序
    watch 每隔一秒高亮显示网络链接数的变化情况
    watch -n 1 -d netstat -ant
    每隔一秒高亮显示http链接数的变化情况
    watch -n 1 -d 'pstree|grep http'
    
### cat
查看文件并且显示行数 cat -n /etc/inetd.conf

### # tee

把数据重定向到给定**文件**和**屏幕上**

```
# 将 ls 的 stdin 重定向到文件,并且输出到屏幕上面
ls | tee out.txt
```

### # wget

[参考](http://man.linuxde.net/wget)

```
-a<日志文件>：在指定的日志文件中记录资料的执行过程；
-c：继续执行上次终端的任务；
-O filename 将文件保存为 filename
-i<文件>：从指定文件获取要下载的URL地址；
--limit-rate=300k 限速下载
-c 断点续传
--user-agent 伪装代理名称下载
```

### # find 

[参考](http://www.cnblogs.com/peida/archive/2013/02/26/2932972.html)
```
atime n  查找系统中最后N分钟访问的文件
amin n  查找系统中最后n*24小时访问的文件
# 查找今天的(24小时内)
find . -atime -1
# 查找今天之前的(24小时内)
find . -atime +1
# 搜索当前目录的以 .log 结尾,一天内,权限问 600 ,大小大于 1 b 的普通文件,并且按照普通方式输出
find . -type f -name '*.log' -atime -1 -perm 600 -size +1c -print
```
### # xargs

xargs 命令是一个其他命令参数传递一个过滤器,擅长将stdin转化成命令参数,xargs 能够处理管道或者 stdin 并将其转化成特定命令的命令参数.

xargs 的默认命令是echo ,空格是默认定界符.
这也就意味着通过管道传递给xargs包含**换行**和**空白**,不过通过xargs的处理,换行和空白将被空格取代

cat abc | xargs echo <=====> cat abc | xargs


测试文件:
```
➜  ~ cat abc | xargs      
a b c d e f g h i j k l m n o p q r s t u v w x y z
➜  ~ cat abc | xargs -n3
a b c
d e f
g h i
j k l
m n o
p q r
s t u
v w x
y z
➜  ~ echo "nameXnameXnameXname" | xargs -dX
name name name name
```

读取 stdin,将格式化后的参数传递给命令

```
➜  ~ cat sk.sh                 
#!/bin/sh

echo $*
```
测试
```
➜  ~ cat arg                         
aaa
bbb
ccc
➜  ~ cat arg | xargs -I {} ./sk.sh {}
aaa
bbb
ccc
```

xargs 的一个`选项 -I` , 使用 -I 指定一个**替换字符串{}**,这个字符串在xargs拓展时会被替换掉,每一个参数命令都会被执行一次：

```
➜  ~ cat abc | xargs -I {} ./sk.sh "==>" {} "<=="
==> a b c d e f g <==
==> h i j k l m n <==
==> o p q <==
==> r s t <==
==> u v w x y z <==
```

xargs 结合 find 使用

用rm 删除太多的文件时候，可能得到一个错误信息：/bin/rm Argument list too long. 用xargs去避免这个问题


xargs -0 将\0作为定界符
统计一个源代码目录中所有php 文件的行数

```
## 正常输出
➜  Controllers git:(master) find . -type f -name '*.php' -print
./Controller.php
./FetchController.php
./LoginController.php
./SockController.php
./TestController.php
## 将 \n 替换为 NULL

➜  Controllers git:(master) find . -type f -name '*.php' -print0

./Controller.php./FetchController.php./LoginController.php./SockController.php./TestController.php

## 将 find 中的数据的 \n 替换为 NULL,同时 xargs 将 NULL 作为定界符
➜  Controllers git:(master) find . -type f -name '*.php' -print0 | xargs -0 wc -l
      71 ./Controller.php
      95 ./FetchController.php
      54 ./LoginController.php
     112 ./SockController.php
      30 ./TestController.php
     362 total
```

查找所有 jpg 文件,并且压缩他们

```
find . -type f -name '*.jpg' -print | xargs tar -czvf images.tar.gz
```

下载
```
cat url-list.txt | xargs wget -c
```