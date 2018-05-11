---
layout: post
title: 使用阿里云ECS搭建Shadowscoks和VPN翻墙
excerpt: 利用阿里云搭建vpn
tags:
  - linux 
  - vpn 
---

> ShadowsocksX: [https://github.com/shadowsocks/ShadowsocksX-NG/releases](https://github.com/shadowsocks/ShadowsocksX-NG/releases)


## 1 为什么翻墙
作为一个技术人员, 最常用的就是Google、StackOverflow、Github这些网站, 工作期间几乎每分钟都在用。

另外,偶尔也上上Facebook、YouTube、草榴以及Porn, 娱乐一下自己。

如果不能翻墙, 几乎就是鱼离开了水, 人离开了空气, 感觉一刻都不能待下去。

## 2 常用的翻墙方法
常用的翻墙方法是:

1 购买一台大陆以外的服务器,搭建VPN或者ShadowScoks。

2 购买第三方的代理服务。 (我试用过后,觉得速度不可控,而且限制多。 况且我们公司人多, 算下来不如自己搭建划算)

3 使用自由门、GoAgent(速度比较慢、经常不能用、mac或者手机上用不了)

我用的电脑是Mac, 电脑支持VPN、ShadowSocks, 手机是iPhone, 没有越狱,不支持ShadowSocks(更正: 现在在App Store 下载 Wingy 软件,已经支持ShadowSocks)。

电脑版的ShadowSocks客户端支持自动代理模式,国内的不走代理,国外的走代理,而且能自定义。

而VPN只能完全代理。 所以我决定Shadowscoks和VPN都搭建。 电脑上主要用Shadowsocks,手机上用VPN(更正:手机上可以用 Wingy 了)。

那么,如何选择一家合适的代理服务器呢?

国外比较知名的云服务运营商有有Linode、DigitalOcean等, 费用基本10美元一个月。ping值在200左右。

国内阿里云也有香港和美国节点,香港节点价格117元/月, ping值在50左右。

之前2年用的是linode, 一直比较稳定,但是最近, 速度实在太慢了, 决定迁回阿里云香港试一下。 在这里做个记录。

(更正: 2017年之前阿里云香港的服务器是可以用的, 现在(2017年底)已经搭建的 Shadowsocks Server 貌似不受影响, 但新搭建的貌似已经不能访问了, 所以建议使用 阿里云新加坡 的机房搭建)

## 3 实施
### 3.1 购买服务器
在阿里云后台,购买 1核CPU 1GB内存 的服务器, 操作系统选择的是 CentOS 7.0 64位, 价格117元/月。

### 3.2 使用Shdowsocks翻墙
#### 1) 安装Shdowsocks服务端

登录阿里云服务器, 执行以下命令
```bash
# 安装pip
yum install python-pip

# 使用pip安装shadowsocks
pip install shadowsocks
```
### 2) 配置Shdowsocks服务,并启动

新建 /etc/shadowsocks.json 文件, 并写入以下内容
```json
{
	"server":"remote-shadowsocks-server-ip-addr",
	"server_port":443,
	"local_address":"127.0.0.1",
	"local_port":1080,
	"password":"your-passwd",
	"timeout":300,
	"method":"aes-256-cfb",
	"fast_open":false,
	"workers":5
}
```
注意修改 `server` 和 `password`, `workers` 表示启动的进程数量。

`server_port` 强烈建议使用443端口, 其它端口容易被查封。

然后使用以下命令启动: `ssserver -c /etc/shadowsocks.json -d start`

如果出现报错: `Cannot assign requested address`, 请将 `server` 换成 `0.0.0.0`, 然后重新启动上面的命令。

### 3) 使用本机Shdowsocks客户端, 连接服务端上网

如果用的是mac, 上网站 https://sourceforge.net/projects/shadowsocksgui/ 下载客户端。

安装完后进行如下配置:


![image](http://oj74t8laa.bkt.clouddn.com/markdown/vpn/shadowsocks.jpg)

如果是windows, 上面的网站也有客户端下载链接。

如果是android, 参考网站 https://github.com/shadowsocks/shadowsocks-android

如果是iPhone, 那你用不了shadowsocks, 只能用下面的VPN了。(更正,现在可以用 Wingy 了)

3.3 使用VPN翻墙
VPN 隧道协议PPTP、L2TP、IPSec和SSLVPN（SSTP，OpenVPN）中安全性逐级提高，相应的受到墙的干扰逐级减弱。 考虑到跨平台，PPTP穿透力及安全性，这里搭建支持 ikev1/ikev2 的 Ipsec VPN，适用于iOS、Android、Windows 7+ 、MacOS X,及Linux。 为了兼容Windows 7以下的系统，同时搭建L2TP/IPSec支持。

TODO: 待完善

## python + docker 方式搭建
Ubuntu:
```bash
curl -sSL http://acs-public-mirror.oss-cn-hangzhou.aliyuncs.com/docker-engine/internet | sh -
apt install docker.io
# 映射1984 到宿主机443 端口
docker run -d -p 443:1984 oddrationale/docker-shadowsocks -s 0.0.0.0 -p 1984 -k <密码> -m aes-256-cfb
```

我们就可以利用 Shadowsocks  iOS/OX/windows/android 等版本进行登录了
```
账号: xx.xx.xx.xx
端口: 443
加密方式: aes-256-cfb
密码: <密码>
```
