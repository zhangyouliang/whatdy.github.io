---
layout: post
title: spring-boot 热部署
excerpt: 解决频繁的重启spring boot 服务器问题
ags:
  - java
  - spring-boot
---


SpringBoot 热部署

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-devtools</artifactId>
    <optional>true</optional>
</dependency>
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
            <configuration>
                <fork>true</fork>
            </configuration>
        </plugin>
    </plugins>
</build>
```

然后设置idea

1. Build Execution > Compiler > Build Project automatically 打上勾

2. Register 设置 :  Ctrl + Option + Command 点击 Register ,找到 `compiler.automake.allow.when.app.running`

3. 重启 IDEA

