---
layout: post
title: 阿里云支持 ipv6
excerpt: 通过 tunnelbroker 使阿里云服务器支持 ipv6
tags:
  - linux 
---
### # 基础

- Ubuntu 16.04
- tunnelbroker ipv6 隧道地址

### # 步骤

启用 IPv6 的主要有四步：

- 注册并创建 IPv6 通道
- 配置 ECS 使其支持 IPv6
- 配置 Nginx 使其监听 IPv6 端口
- 配置 DNS 使其支持 IPv6 解析


#### 第一步：注册并创建 IPv6 通道

- 注册 [https://www.tunnelbroker.net/](https://www.tunnelbroker.net/) （需要邮箱验证）
- 点击 [Create Regular Tunnel](https://www.tunnelbroker.net/new_tunnel.php)
- 在IPv4 Endpoint (Your side)处填上 ECS 的 IPv4 地址
- 在Available Tunnel Servers中选择Hong Kong, HK（如果你面向海外用户，可以选择更接近目标用户的地区）
点击Create Tunnel后，通道就创建完成了

#### 第二步：配置 ECS 使其支持 IPv6


编辑/etc/sysctl.conf，将以下三项的配置改成0

```shell
net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.default.disable_ipv6 = 0
net.ipv6.conf.lo.disable_ipv6 = 0
```


在/etc/network/interfaces底部加上以下内容（注：下面大写的处，需要替换成你在 HE 得到的Server IPv6 Address，但不包括最后的::1/64，如：2001:470:100:100）

```shell
auto he-ipv6
iface he-ipv6 inet6 v4tunnel
address <IPV6>::2
netmask 64
remote <HE 的 Server IPv4 Address>
local <阿里云的 IPv4 地址(Notice: 是 DHCP服务获取的IPv4地址,而不是提供给 tunnelbroker 的那个地址 )>
endpoint any
ttl 255
gateway <IPv6>::1
up ip -6 route add 2000::/3 via ::<HE 的 Server IPv4 Address> dev he-ipv6
up ip -6 addr add <IPv6>::1:1/128 dev he-ipv6
up ip -6 addr add <IPv6>::2:1/128 dev he-ipv6
down ip -6 route flush dev he-ipv6
```

重启服务器

```shell
## 检测
$ ifup he-ipv6

## 重启 网卡
$ ifdown he-ipv6 && ifup he-ipv6
```

### # 参考
[https://jiandanxinli.github.io/2016-08-06.html](https://jiandanxinli.github.io/2016-08-06.html)