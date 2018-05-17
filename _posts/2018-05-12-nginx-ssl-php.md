---
layout: post
title: nginx 配置 ssl问题 
excerpt: nginx 搭建ssl 过程以及遇到的相关问题
tags:
 - Linux
 - Nginx 
---

### # PHP-FPM + nginx  $_SERVER['HTTPS'] 参数不存在

```
# YII 当中无法获取 $_SERVER['HTTPS'] 问题
 
# nginx php模块当中添加下面语句
fastcgi_param  HTTPS on;

```
