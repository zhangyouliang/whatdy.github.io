---
layout: post
title: docker+supervisor 实现后台运行程序
excerpt: docker + supervisor 轻松实现多进程后台运行程序。
tags:
  - docker
  - python
---

由于 docker 是进程式的,所以当我们的进程执行关闭,docker 容器也就自然停止,这里不是使用循环的方式,而是使用更加优雅的 supervisor 方式,而且还可以是多进程。

> 注意 supervisor 不支持任何的 python3

**基础镜像构建**

Dockerfile
```Dockerfile
FROM python:3.6.3

WORKDIR /app
COPY requirements.txt /app

# 由于本身代码是 py3的,所以这里另外安装一个 py2 
RUN pip install --trusted-host pypi.python.org -r requirements.txt \
    && pip install virtualenv \
    && virtualenv --system-site-packages -p python2.7 /opt/python2.7 \
    && /opt/python2.7/bin/pip install supervisor \
    && /opt/python2.7/bin/echo_supervisord_conf > /etc/supervisord.conf
```

requirements.txt
```
APScheduler==3.5.1
configparser==3.5.0
DBUtils==1.2
PyMySQL==0.8.0
requests==2.18.4
... 其他的包
```

镜像构建: `docker build -t test:latest .`

文件目录结构:
```
.
├── Dockerfile
├── app.py
├── docker
│   ├── config.sh
│   ├── start.sh
│   └── supervisor
│       └── cron.conf
```

这里其实我是为了启动 `app.py` 文件的

```bash
# start.sh
#!/bin/bash
#根据环境变量启动镜像
/docker/config.sh
#启动守护
/opt/python2.7/bin/supervisord -c /etc/supervisord.conf

# config.sh
#!/bin/bash
sed -i -e "s/nodaemon=false/nodaemon=true /g" /etc/supervisord.conf
sed -i -e "s/;\[include\]/\[include\]/g" /etc/supervisord.conf
echo 'files=/docker/supervisor/*.conf' >>  /etc/supervisord.conf

# cron.conf
[program:cron]
command=/usr/local/bin/python /app/app.py
autorestart=true
stdout_events_enabled=true
stderr_events_enabled=true

# Dockerfile

FROM test:latest
MAINTAINER YouliangZhang <1577121881@qq.com>

# ------------------------------------------------------------------------------
# Provision the server
# ------------------------------------------------------------------------------
RUN mkdir /docker
ADD docker /docker

ADD . /app
RUN chmod a+x /docker/*.sh

# Use Supervisor to run and manage all other services
CMD ["/docker/start.sh"]

```

镜像构建: `docker build -t xx:latest .`
镜像启动: `docker run -d xx:latest --name xx`