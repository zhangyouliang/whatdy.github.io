---
layout: post
title: Linux curl && http
excerpt: Linux 常用命令 CURL 和 http 命令的使用情况
tags:
  - Linux
---

### # CURL 命令 

常用参数列表: 

```
-A/--user-agent <string>	设置用户代理发送给服务器
-b/--cookie <name=string/file>	cookie字符串或文件读取位置
--basic	使用HTTP基本验证
-c/--cookie-jar <file>	操作结束后把cookie写入到这个文件中
-d/--data <data>	HTTP POST方式传送数据
-D/--dump-header <file>	把header信息写入到该文件中
-e/--referer	来源网址
-G/--get	以get的方式来发送数据
-H/--header <line>	自定义头信息传递给服务器
-i/--include	输出时包括protocol头信息
-I/--head	只显示请求头信息
-s，可以去除统计信息

-o/--output	把输出写到该文件中
-u/--user <user[:password]>	设置服务器的用户和密码
-x/--proxy <host[:port]>	在给定的端口上使用HTTP代理
-X/--request <command>	指定什么命令
```

例子: 
```bash
#!/bin/bash
# post 带着请求头,post body并且显示protocol头信息
#  -H 'Content-Type:application/json' \
curl -s -i -X POST \
    -H  'Accept:application/json; text/plain, */*' \
    -H 'User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 11_2_6 like Mac OS X) AppleWebKit/604.5.6 (KHTML, like Gecko) Mobile/15D100' \
    -H "Cookie:app_name=ShenDeng" \
    -H "X-Requested-With: XMLHttpRequest" \
    -H "Origin: http://localhost"  \
    -H "Host: http://localhost"  \
    http://localhost:8000 -d "app_id=1325997595&idfa=53B9A1CA-72F1-46E2-89C2-969120929E95&ip=127.0.0.1&source=hcc"
```

参考:  [http://man.linuxde.net/curl](http://man.linuxde.net/curl)

#### # http 命令

> Http 命令默认显示头部信息,带有高亮,JSON数据自动格式化

截取常用部分

````
$ http example.org               # => GET
$ http example.org hello=world   # => POST

$ http :3000                    # => http://localhost:3000
$ http :/foo                    # => http://localhost/foo

':' HTTP headers:
      Referer:http://httpie.org  Cookie:foo=bar  User-Agent:bacon/1.0

'==' URL parameters to be appended to the request URI:
      search==httpie

'=' Data fields to be serialized into a JSON object (with --json, -j)
          or form data (with --form, -f):
      name=HTTPie  language=Python  description='CLI HTTP client'

````