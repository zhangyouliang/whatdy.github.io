---
layout: post
title: nginx 重写规则
excerpt: nginx 重写规则的一些规律,以及常用方法
tags:
  - nginx
---

apache ,nginx 配置转换工具 [http://www.atool.org/htaccess2nginx.php](http://www.atool.org/htaccess2nginx.php)

nginx rewrite 指令执行顺序

### # rewrite
- 执行server块的rewrite指令(这里的块指的是server关键字后{}包围的区域)
- 执行 location 匹配
- 执行选定的location中的rewrite指令

如果其中某步`URI`被重写,则重新循环执行`1~3`,直到找到真正的文件.如果循环超过`10`次,则出现`500 Internal Server Error 错误`


flag 标志位:

```
rewrite regex URL [flag];
```

`rewrite` 是关键字，`regex` 是正则表达式，`URL`是要替代的内容，`[flag]`是标记位的意思，它有以下几种值：

- `last`: 相当于Apache的`[L]`标记，表示`完成rewrite`
- `break`: 停止执行当前虚拟主机的后续rewrite指令集
- `redirect`: 返回`302临时重定向`，地址栏会显示跳转后的地址
- `permanent`: 返回`301永久重定向`，地址栏会显示跳转后的地址


### # location的用法

`location ~* /js/.*/\.js`
以 `=` 开头，表示精确匹配；如只匹配根目录结尾的请求，后面不能带任何字符串。
以`^~` 开头，表示uri以某个常规字符串开头，不是正则匹配
以`~` 开头，表示区分大小写的正则匹配;
以`~*` 开头，表示不区分大小写的正则匹配
以`/` 开头，通用匹配, 如果没有其它匹配,任何请求都会匹配到

```
location / { 
    # Redirect everything that isn't a real file to index.php
    try_files $uri $uri/ /index.php$is_args$args;  <==>  try_files $uri $uri/ /index.php?$query_string;
}
# 或者 
rewrite ^/(.*)$ /index.php/$1 last;
```

优先级:  (location = 精准匹配) > (location 完整路径) > (location ^~ 路径) > (location ~,~* 正则顺序) > (location 部分起始路径) > (/)


例子:

```
# 这里是直接转发给后端应用服务器了，也可以是一个静态首页
# 第一个必选规则
location = / {
    proxy_pass  http://tomcat:8080/index
}
# 第二个必选规则是处理静态文件请求，这是nginx作为http服务器的强项
# 有两种配置模式，目录匹配或后缀匹配,任选其一或搭配使用
location ^~ /static/ {
    root /webroot/static/;
}
location ~* \.(gif|jpg|jpeg|png|css|js|ico)$ {
    root /webroot/res/;
}
# 第三个规则就是通用规则，用来转发动态请求到后端应用服务器
location / {
    proxy_pass  http://tomcat:8080/
}
```


#### # if 判断指令


当表达式只是一个变量时，如果值为空或任何以0开头的字符串都会当做false
直接比较变量和内容时，使用=或!=
`~`  正则表达式匹配
`~*` 不区分大小写的匹配
`!~`  区分大小写的不匹配
`-f`和`!-f`  用来判断是否存在文件
`-d`和`!-d`  用来判断是否存在目录
`-e`和`!-e`  用来判断是否存在文件或目录
`-x`和`!-x`  用来判断文件是否可执行


```
if ($http_user_agent ~ MSIE) {
    rewrite ^(.*)$ /msie/$1 break;
} //如果UA包含"MSIE"，rewrite请求到/msid/目录下

if ($http_cookie ~* "id=([^;]+)(?:;|$)") {
    set $id $1;
 } //如果cookie匹配正则，设置变量$id等于正则引用部分

if ($request_method = POST) {
    return 405;
} //如果提交方法为POST，则返回状态405（Method not allowed）。return不能返回301,302

if ($slow) {
    limit_rate 10k;
} //限速，$slow可以通过 set 指令设置

if (!-f $request_filename){
    break;
    proxy_pass  http://127.0.0.1; 
} //如果请求的文件名不存在，则反向代理到localhost 。这里的break也是停止rewrite检查

if ($args ~ post=140){
    rewrite ^ http://mysite.com/ permanent;
} //如果query string中包含"post=140"，永久重定向到mysite.com
```


if指令中，可以使用全局变量，这些变量有：
`$args`： #这个变量等于请求行中的参数，同$query_string
`$content_length`： 请求头中的Content-length字段。
`$content_type`： 请求头中的Content-Type字段。
`$document_root`： 当前请求在root指令中指定的值。
`$host`： 请求主机头字段，否则为服务器名称。
`$http_user_agent`： 客户端agent信息
`$http_cookie`： 客户端cookie信息
`$limit_rate`： 这个变量可以限制连接速率。
`$request_method`： 客户端请求的动作，通常为GET或POST。
`$remote_addr`： 客户端的IP地址。
`$remote_port`： 客户端的端口。
`$remote_user`： 已经经过Auth Basic Module验证的用户名。
`$request_filename`： 当前请求的文件路径，由root或alias指令与URI请求生成。
`$scheme`： HTTP协议（如http，https）。
`$server_protocol`： 请求使用的协议，通常是HTTP/1.0或HTTP/1.1。
`$server_addr`： 服务器地址，在完成一次系统调用后可以确定这个值。
`$server_name`： 服务器名称。
`$server_port`： 请求到达服务器的端口号。
`$request_uri`： 包含请求参数的原始URI，不包含主机名，如：”/foo/bar.php?arg=baz”。
`$uri`： 不带请求参数的当前URI，$uri不包含主机名，如”/foo/bar.html”。
`$document_uri`： 与$uri相同。
`$query_string`： 请求参数,不写GET会接收不到参数(get 参数丢失往往都是因为他)。
`$is_args` 如果`$args`设置，值为"?"，否则为""。
`$uri` 请求中的当前URI(不带请求参数，参数位于$args)
`$args` 这个变量等于GET请求中的参数。例如，foo=123&bar=blahblah;这个变量只可以被修改


### 例子

> 代理 a.com ,目标域名 b.com

nginx.conf
    
    upstream mysvr {
        server b.com weight=5;
      }

a.com.conf
    
    server {
        listen 80;
        server_name hiweixiu.wxjdkyx.com;
        access_log /data/wwwlogs/access_nginx.log combined;
        index index.html index.htm index.php;
        location / {
         proxy_pass  http://mysvr;
         # 目标网站可能根据 Host 属性进行跳转,所以这里有时候需要设置为目标应
         # proxy_set_header Host "b.com";
         proxy_set_header Host $host;
         proxy_set_header X-Real-Ip $remote_addr;
         proxy_set_header X-Forwarded-For $remote_addr;
        }    
      }