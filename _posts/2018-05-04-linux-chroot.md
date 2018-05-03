---
layout: post
title: Linux chroot 命令详解
excerpt: chroot 命令详解
tags:
  - linux 
---

> chroot，即 change root directory (更改 root 目录)。在 linux 系统中，系统默认的目录结构都是以 /，即以根 (root) 开始的。而在使用 chroot 之后，系统的目录结构将以指定的位置作为 / 位置。


基本语法
-----
**chroot NEWROOT [COMMAND [ARG]...]**

具体用法请参考本文的 demo。

为什么要使用 chroot 命令
-----
**增加了系统的安全性，限制了用户的权力：**

在经过 chroot 之后，在新根下将访问不到旧系统的根目录结构和文件，这样就增强了系统的安全性。一般会在用户登录前应用 chroot，把用户的访问能力控制在一定的范围之内。

**建立一个与原系统隔离的系统目录结构，方便用户的开发：**

使用 chroot 后，系统读取的是新根下的目录和文件，这是一个与原系统根下文件不相关的目录结构。在这个新的环境中，可以用来测试软件的静态编译以及一些与系统不相关的独立开发。

**切换系统的根目录位置，引导 Linux 系统启动以及急救系统等：**

chroot 的作用就是切换系统的根位置，而这个作用最为明显的是在系统初始引导磁盘的处理过程中使用，从初始 RAM 磁盘 (initrd) 切换系统的根位置并执行真正的 init，本文的最后一个 demo 会详细的介绍这种用法。

通过 chroot 运行 busybox 工具
----
busybox 包含了丰富的工具，我们可以把这些工具放置在一个目录下，然后通过 chroot 构造出一个 mini 系统。简单起见我们直接使用 docker 的 busybox 镜像打包的文件系统。先在当前目录下创建一个目录 rootfs：
```
$ mkdir rootfs
```
然后把 busybox 镜像中的文件释放到这个目录中：
```
$ (docker export $(docker create busybox) | tar -C rootfs -xvf -)
```
通过 ls 命令查看 rootfs 文件夹下的内容：

```
➜  ~ ls rootfs 
bin  dev  etc  home  proc  root  sys  tmp  usr  var

```
万事俱备，让我们开始吧！

**执行 chroot 后的 ls 命令**
```
➜  ~ sudo chroot rootfs /bin/ls
bin   dev   etc   home  proc  root  sys   tmp   usr   var
```


虽然输出结果与刚才执行的 ls rootfs 命令形同，但是这次运行的命令却是 rootfs/bin/ls。

**运行 chroot 后的 pwd 命令**
```
$ sudo chroot rootfs /bin/pwd
```

哈，pwd 命令真把 rootfs 目录当根目录了！

**不带命令执行 chroot**

```
➜  ~ sudo chroot rootfs        
chroot: failed to run command ‘/usr/bin/zsh’: No such file or directory
```

这次出错了，因为找不到 /bin/bash。我们知道 busybox 中是不包含 bash 的，但是 chroot 命令为什么会找 bash 命令呢？ 原来，如果不给 chroot 指定执行的命令，默认它会执行 '${SHELL} -i'，而我的系统中 ${SHELL} 为 /bin/bash。
既然 busybox 中没有 bash，我们只好指定 /bin/sh 来执行 shell 了。
```
➜  ~ sudo chroot rootfs /bin/sh 
/ # 

```

运行 sh 是没有问题的，并且我们打印出了当前进程的 PID。

检查程序是否运行在 chroot 环境下
虽然我们做了好几个实验，但是肯定会有朋友心存疑问，怎么能证明我们运行的命令就是在 chroot 目录后的路径中呢？
其实，我们可以通过 /proc 目录下的文件检查进程的中的根目录，比如我们可以通过下面的代码检查上面运行的 /bin/sh 命令的根目录(请在另外一个 shell 中执行)：
```
➜  pid=$(pidof -s sh)
➜  ~ sudo ls -ld /proc/$pid/root
lrwxrwxrwx 1 root root 0 May  4 00:58 /proc/18974/root -> /root/rootfs
```

输出中的内容明确的指出 PID 为 46644 的进程的根目录被映射到了 /tmp/rootfs 目录。

通过代码理解 chroot 命令
-----
下面我们尝试自己实现一个 chroot 程序，代码中涉及到两个函数，分别是 chroot() 函数和 chdir() 函数，其实真正的 chroot 命令也是通过调用它们实现的：

```
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
 
int main(int argc, char *argv[])
{
    if(argc<2){
        printf("Usage: chroot NEWROOT [COMMAND...] \n");
        return 1;
    }

    if(chroot(argv[1])) {
        perror("chroot");
        return 1;
    }
 
    if(chdir("/")) {
        perror("chdir");
        return 1;
    }
 
    if(argc == 2) {
        // hardcode /bin/sh for my busybox tools.
        argv[0] = (char *)"/bin/sh";
 
        argv[1] = (char *) "-i";
        argv[2] = NULL;
    } else {
        argv += 2;
    }
 
    execvp (argv[0], argv);
    printf("chroot: cannot run command `%s`\n", *argv);
 
    return 0;
}
```
复制代码
把上面的代码保存到文件 mychroot.c 文件中，并执行下面的命令进行编译：
```
$ gcc -Wall mychroot.c -o mychroot
```
mychroot 的用法和 chroot 基本相同：
```
$ sudo ./mychroot ./rootfs
```
特别之处是我们的 mychroot 在没有传递命令的情况下执行了 /bin/sh，原因当然是为了支持我们的 busybox 工具集，笔者在代码中 hardcode 了默认的 shell：

```
argv[0] = (char *)"/bin/sh";
```
从代码中我们也可以看到，实现 chroot 命令的核心逻辑其实并不复杂。


参考: [参考1](http://www.cnblogs.com/sparkdev/p/8556075.html)