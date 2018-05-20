---
layout: post
title: PHP 相关笔记 
excerpt: 记录平时使用 PHP 遇到的一些问题
tags:
  - php
---

**#$_SERVER 参数**

```PHP
# 最后一层代理的 IP 地址
[REMOTE_ADDR] => 10.42.149.196
# 访问者真实 IP
[HTTP_X_FORWARDED_FOR] => 101.81.14.6
# 服务器地址
[SERVER_ADDR] => 10.42.93.182
```
**#mac安装PHP拓展问题**

2018-03-30 舍弃了 php拓展库,所以这里我们用port代替,由于 `homebrew` 在国内太慢,这里也就不折腾他了,以`redis` 为例:

    # port
    # 安装 php redis 拓展
    sudo port install php71-redis
    # 配置文件位置
    cat /opt/local/etc/php71
    # 拓展位置
    /opt/local/lib/php71/extensions
    # 将下载好的拓展放入到  php -i | grep extension_dir 显示的目录下面,最后修改配置文件   



**#php路径相关问题**

    # mac brew 默认核心仓库位置
    open /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core/Formula
    # 查看 php 配置文件位置
    php -i | grep Configuration
    # php 拓展位置
    php -i | grep extension_dir

**#php拓展版本查看**
    
    php --ri 拓展名
    或者
    php -i | less
    /拓展名
    或者
    php -r "echo swoole_version()"


