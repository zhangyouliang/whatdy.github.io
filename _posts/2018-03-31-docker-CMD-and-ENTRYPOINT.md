---
layout: post
title: docker CMD 和 ENTRYPOINT
excerpt: 探索 docker CMD 和 ENTRYPOINT 区别。
tags:
  - docker
---

### CMD

支持三种形式:

- CMD ["executable","param1","param2"] 使用 exec 执行，推荐方式；

```bash
FROM python:3.6.3
CMD ["python"]

# docker run --rm -it test  不要带执行命令
➜  test docker run --rm -it test                
Python 3.6.3 (default, Dec 12 2017, 16:40:53) 
[GCC 4.9.2] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> 
```

相当于`/bin/sh -c python`

- CMD command param1 param2 在 /bin/sh 中执行，提供给需要交互的应用；
- CMD ["param1","param2"] 提供给 ENTRYPOINT 的默认参数；

```bash
FROM python:3.6.3
CMD "python"
# CMD 部分展现
"Cmd": [
    "/bin/sh",
    "-c",
    "\"python\""
],
```
```bash
FROM python:3.6.3

CMD /usr/local/bin/python
# CMD 部分展现
"Cmd": [
    "/bin/sh",
    "-c",
    "/usr/local/bin/python"
],
```
```bash
FROM python:3.6.3
CMD ["python"]

# CMD 部分展现
"Cmd": [
    "python"
],
```

总结如下:

CMD shell 形式并且为参数的时候,会传递给 sh,形式为 `/bin/sh -c "xxx"`
CMD shell 形式并且是可执行参数的时候,会传递给 sh,形式为 `/bin/sh -c xxx`

CMD 以可执行命令的方式传入,则会替换 sh,将传入的命令作为基础命令 ,**但是会被 run 传入的参数覆盖**


例如上面的 `python`,如果运行 `docker run --rm -it test --help`,我们的本意是查看python的帮助信息,但是会报错,命令被覆盖为了`--help`,这个命令是不存在,所以我们可以这样运行`docker run --rm -it test python --help`

这里还需要注意,由于没有 `entrypoint`,也就是没有 `/bin/sh -c `的加持,如果传入字符串会报错,也就是`docker run --rm -it test "python --help"`,除非设置了一下操作
```bash
FROM python:3.6.3
Entrypoint ["/bin/sh","-c"]
# 1. docker run --rm -it test "python --help"
# 相当于: /bin/sh -c "python --help"

# 2. docker run --rm -it test python --help
# 相当于: /bin/sh -c python 
Python 2.7.12 (default, Dec  4 2017, 14:50:18) 
[GCC 5.4.0 20160609] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> 
```



指定启动容器时执行的命令，每个 Dockerfile 只能有一条 CMD 命令。如果指定了多条命令，只有最后一条会被执行。

***如果用户启动容器时候指定了运行的命令，则会覆盖掉 CMD 指定的命令。***

### ENTRYPOINT

两种格式：

- ENTRYPOINT ["executable", "param1", "param2"]

```bash
FROM python3.6.3
ENTRYPOINT ["/usr/local/bin/python"]

# docker inspect <name> 查看明细
"Entrypoint": [
    "/usr/local/bin/python"
],

```

- ENTRYPOINT command param1 param2（shell中执行）。

```bash
FROM python3.6.3
ENTRYPOINT "/usr/local/bin/python"

# docker inspect <name> 查看明细

"Entrypoint": [
    "/bin/sh",
    "-c",
    "\"/usr/local/bin/python\""
],

```

***配置容器启动后执行的命令，并且不可被 docker run 提供的参数覆盖。***

每个 Dockerfile 中只能有一个 ENTRYPOINT，当指定多个时，只有最后一个起效。


**从上面的说明，我们可以看到有两个共同点：**

- 都可以指定shell或exec函数调用的方式执行命令；
- 当存在多个CMD指令或ENTRYPOINT指令时，只有最后一个生效；

