---
layout: post
title: docker + golang 编写迷你镜像
categories:
  - docker
  - golang
---

#### docker 多阶段构建 

> [参考](https://bbs.testerhome.com/topics/15805)

    # 不需要Go语言编译环境
    FROM scratch
    
    # 将编译结果拷贝到容器中
    COPY server /server
    
    # 指定容器运行时入口程序 server
    ENTRYPOINT ["/server"]

> 提示：scratch 是内置关键词，并不是一个真实存在的镜像。 FROM scratch 会使用一个完全干净的文件系统，不包含任何文件。 因为Go语言编译后不需要运行时，也就不需要安装任何的运行库。FROM scratch可以使得最后生成的镜像最小化，其中只包含了 server 程序。


在 Docker 17.05版本以后，就有了新的解决方案，直接一个Dockerfile就可以解决：

    # 编译阶段
    FROM golang:1.10.3
    
    COPY server.go /build/
    
    WORKDIR /build
    
    RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GOARM=6 go build -ldflags '-w -s' -o server && chmod +x server
   
    
    # 运行阶段
     FROM scratch
    
    # 从编译阶段的中拷贝编译结果到当前镜像中
    COPY --from=0 /build/server /
    
    ENTRYPOINT ["/server"]
    

这个 Dockerfile 的玄妙之处就在于 COPY 指令的--from=0 参数，从前边的阶段中拷贝文件到当前阶段中，多个FROM语句时，0代表第一个阶段。除了使用数字，我们还可以给阶段命名，比如：

    # 编译阶段 命名为 builder
    FROM golang:1.10.3 as builder
    
    # ... 省略
    
    # 运行阶段
    FROM scratch
    
    # 从编译阶段的中拷贝编译结果到当前镜像中
    COPY --from=builder /build/server /
    
更为强大的是，`COPY --from` 不但可以从前置阶段中拷贝，还可以直接从一个已经存在的镜像中拷贝。比如，

    FROM ubuntu:16.04
    
    COPY --from=quay.io/coreos/etcd:v3.3.9 /usr/local/bin/etcd /usr/local/bin/
