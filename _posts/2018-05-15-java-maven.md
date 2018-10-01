---
layout: post
title: maven 基本用法 - 书签
excerpt: 记录 Maven的基本用法
tags:
 - Java
 - Maven 
---

> [maven 包搜索](http://mvnrepository.com/)

### *nix 创建java项目

````
# mvn archetype:generate -DgroupId={project-packaging} -DartifactId={project-name} -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
mvn archetype:generate -DgroupId=com.whatdy -DartifactId=hello -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
````

目录结构

````
hello
   |-src
   |---main
   |-----java
   |-------com
   |---------whatdy   
   |-----------App.java
   |---test|-----java
   |-------com
   |---------whatdy
   |-----------AppTest.java
   |-pom.xml
````

mvn package 打包文件

这里的命令还可以这样执行: `mvn clean package` ,表示先执行`clean`在执行`package`打包操作

基本步骤:

````
mvn clean compile ===> mvn clean  , mvn compile 

mvn package 

java -jar target/hello-1.0-SNAPSHOT.jar

````

## *nix 创建 java Web 项目

````
# mvn archetype:generate -DgroupId={project-packaging} -DartifactId={project-name} -DarchetypeArtifactId=maven-archetype-webapp -DinteractiveMode=false
mvn archetype:generate -DgroupId=com.whatdy -DartifactId=helloWebApp -DarchetypeArtifactId=maven-archetype-webapp -DinteractiveMode=false

# mvn archetype:generate -DgroupId={project-packaging} -DartifactId={project-name}-DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
mvn archetype:generate -DgroupId=com.whatdy -DartifactId=hello -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
````

目录结构

````
.
├── pom.xml
└── src
    └── main
        ├── resources
        └── webapp
            ├── WEB-INF
            │   └── web.xml
            └── index.jsp
````
注意，为方便起见，声明 `maven-eclipse-plugin`，并配置wtpversion 来避免输入参数 `-Dwtpversion=2.0`。现在，每次使用 `mvn eclipse:eclipse`，Maven将这个项目导入转换为 `Eclipse Web` 项目。

````
#之前 
mvn eclipse:eclipse --> Eclipse Java project (JAR)
mvn eclipse:eclipse -Dwtpversion=2.0 --> Eclipse Java web project (WAR)

#之后
mvn eclipse:eclipse --> Eclipse Java web project (WAR)
````



#### eclipse and idea

生成,清除 eclipse 项目结构
```
mvn eclipse:eclipse
mvn eclipse:clean
```
生成,清除 idea 项目结构
```
mvn idea:idea
mvn idea:clean
```

#### mvn 常用

````
# 清理 (删除target 目录下面编译内容)
mvn clean

# 编译项目
mvn compile

# 编译测试程序
mvn test-compile

# 打包发布
mvn package

# 打包时候跳过测试
mvn package -Dmaven.test.skip=true

## 安装当前工程的输出文件到本地仓库
mvn install

mvn test  //测试全部
mvn -Dtest=TestApp01 test  //仅测试TestApp01

--------------------

# 生成站点目录
mvn site 

# 生成站点目录并发布
mvn site-deploy


# 查看实际pom信息
mvn help:effective-pom

# 查看帮助信息
mvn help:help 或 mvn help:help -Ddetail=true

# 查看插件的帮助信息
mvn <plug-in>:help，比如：mvn dependency:help 或 mvn ant:help 

````

## 安装第三方包

如果网上没有的包,需要我们自己打包,自己引用,则需要以下操作

已oracle驱动程序为例，比如驱动路径为c:/driver/ojdbc14.jar，是10.2.0.3.0版本

在该网址能够查到：http://www.mvnrepository.com/artifact/com.oracle/ojdbc14 artifactId和groupId。


```
mvn install:install-file -DgroupId=com.oracle -DartifactId=ojdbc14 -Dversion=10.2.0.3.0 -Dpackaging=jar -Dfile=c:/driver/ojdbc14.jar
```
这样就可以在pom中依赖引用了：
 
````
<dependency>
    <groupId>com.oracle</groupId>
    <artifactId>ojdbc14</artifactId>
    <version>10.2.0.3.0</version>
</dependency>
````

## maven 指定jar的入口类

```
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-shade-plugin</artifactId>
            <version>1.2.1</version>
            <executions>
                <execution>
                    <phase>package</phase>
                    <goals>
                        <goal>shade</goal>
                    </goals>
                    <configuration>
                        <transformers>
                            <transformer
                                    implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                                <mainClass>com.whatdy.Main</mainClass>
                            </transformer>
                        </transformers>
                    </configuration>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```


## 参考

https://www.cnblogs.com/adolfmc/archive/2012/07/31/2616908.html










