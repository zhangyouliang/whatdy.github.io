---
layout: post
title: nginx 配置 ssl问题 
excerpt: nginx 搭建ssl 过程以及遇到的相关问题
tags:
 - Linux
 - Nginx 
---

### # PHP-FPM + nginx  $_SERVER['HTTPS'] 参数不存在

最近在一个项目,以前是http协议的,现在要改成https,其中有段代码是通过判断`$_SERVER['HTTPS']` 来判断是否是 https的,结果遇到了即使是http,也不能正确判断的问题

```
# YII 当中无法获取 $_SERVER['HTTPS'] 问题
 
# nginx php模块当中添加下面语句
fastcgi_param  HTTPS on;

```
