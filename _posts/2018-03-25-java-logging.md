---
layout: post
title: JAVA 日志
excerpt: 记录 Java 日志级别
tags:
  - java
---

**static Level WARN**
WARN level表明会出现潜在错误的情形。

**static Level ERROR**
ERROR level指出虽然发生错误事件，但仍然不影响系统的继续运行。

**static Level FATAL**
FATAL level指出每个严重的错误事件将会导致应用程序的退出。
另外，还有两个可用的特别的日志记录级别: 

(以下描述来自[log4j API](http://jakarta.apache.org/log4j/docs/api/index.html) ):

**static Level ALL**
ALL Level是最低等级的，用于打开所有日志记录。

**static Level OFF**
OFF Level是最高等级的，用于关闭所有日志记录。
日志记录器（Logger）的行为是分等级的。如下表所示：
分为`OFF、FATAL、ERROR、WARN、INFO、DEBUG、ALL`或者您定义的级别。
Log4j建议只使用四个级别，优先级从高到低分别是 `ERROR、WARN、INFO、DEBUG`。
通过在这里定义的级别，您可以控制到应用程序中相应级别的日志信息的开关。比如在这里定义了INFO级别，则应用程序中所有DEBUG级别的日志信息将不被打印出来，也是说大于等于的级别的日志才输出。
日志记录的级别有继承性，子类会记录父类的所有的日志级别。
