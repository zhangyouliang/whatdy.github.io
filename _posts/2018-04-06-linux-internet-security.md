---
layout: post
title: 网络安全相关命令
excerpt: 记录 Linux & mac 常用的网络安全命令
tags:
  - linux 
  - 网络安全 
---

### # mac 
```shell
## 获取全部 网络服务
networksetup -listallnetworkservices
## 获取 wifi 的信息
networksetup -getinfo Wi-Fi
```

### # ICMP 

ICMP (Internet Control Message Protocol)

### # 路由表

```shell
## ===> mac 
## 列出 route table
$ netstat -nr
## 只显示 IPV4 路由
netstat -nr -f inet
## 只显示 IPV6 路由
netstat -nr -f inet6
## route 操作 route table

## ===> linux
## 列出 route,以及操作 route table
$ route
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
default         172.16.79.253   0.0.0.0         UG    0      0        0 eth0

```

向路由表添加一个路由信息 一般来说，都是为了能访问别的子网才设置路由的


操作 route table
```shell
route add -net 224.0.0.0 netmask 240.0.0.0 reject
route del -net 224.0.0.0 netmask 240.0.0.0 reject
```


参考: 

[http://luodw.cc/2015/12/30/network-command/](http://luodw.cc/2015/12/30/network-command/)

[http://network.51cto.com/art/201503/469761.htm](http://network.51cto.com/art/201503/469761.htm)

分类:
（1）链路层协议发现的路由（即是直连路由）
（2）静态路由
（3）动态路由协议发现的路由。


### # route 命令

- ARP 地址解析协议

[https://baike.baidu.com/item/%E8%B7%AF%E7%94%B1%E8%A1%A8](https://baike.baidu.com/item/%E8%B7%AF%E7%94%B1%E8%A1%A8)

### # nslookup 和 dig

```shell
$ nslookup www.baidu.com

Server:		192.168.0.1
Address:	192.168.0.1#53

Non-authoritative answer:
www.baidu.com	canonical name = www.a.shifen.com.
Name:	www.a.shifen.com
Address: 115.239.211.112
Name:	www.a.shifen.com
Address: 115.239.210.27

$ dig trace www.baidu.com
;; ANSWER SECTION:
www.baidu.com.		300	IN	CNAME	www.a.shifen.com.
www.a.shifen.com.	300	IN	A	115.239.210.27
www.a.shifen.com.	300	IN	A	115.239.211.112

$ host baidu.com        
baidu.com has address 123.125.114.144
baidu.com has address 220.181.57.216
baidu.com has address 111.13.101.208
baidu.com mail is handled by 15 mx.n.shifen.com.
baidu.com mail is handled by 10 mx.maillb.baidu.com.
baidu.com mail is handled by 20 mx1.baidu.com.
baidu.com mail is handled by 20 jpmx.baidu.com.
baidu.com mail is handled by 20 mx50.baidu.com.

## host -a baidu.com
## -a 参数,输出 和 dig baidu.com 一样详细

## host -t ns baidu.com
## -t 查询执行类型的记录

## soa 权威域名服务器的选项
## host -C baidu.com
```

参考: [http://luodw.cc/2015/12/27/dns03/](http://luodw.cc/2015/12/27/dns03/)


### # arp 

原理: [http://blog.csdn.net/Linux_ever/article/details/50516502](http://blog.csdn.net/Linux_ever/article/details/50516502)

```shell
# 查看 ip 和 mac 映射
arp -a
# 清除 eth0 网卡的arp信息
arp -d -i eth0 -a
# 利用 tcpdump 观察 arp 信息 
# 观察 dst,src 为 172.16.78.9 的 数据流
tcpdump -i eth0 -ent '(dst 172.16.78.9 or  src 172.16.78.9)'


```


### # Linux 下查看局域网内所有主机IP和MAC

> [http://blog.csdn.net/keepsmi1e/article/details/9370049](http://blog.csdn.net/keepsmi1e/article/details/9370049)


用 nmap 对局域网扫描一遍,然后查看 arp 缓存表就可以知道局域网内 ip 对应的 mac 了.
nmap比较强大也可以直接扫描mac地址和端口。执行扫描之后就可以 cat/proc/net/arp查看arp缓存表了。

```shell
# 进行 ping 扫描,打印出对扫描做出相应的主机
nmap -sP 192.168.0.1/24
# 仅列出指定网络上的每台主机,不发送任何报文到目标主机
nmap -sL 192.168.0.1/24
# 探测目标主机开放的端口，可以指定一个以逗号分隔的端口列表(如-PS22，23，25，80)
nmap -PS 118.31.78.77
# 使用UDPping探测主机
nmap -PU 192.168.0.1/24

# 使用频率最高的扫描选项（SYN扫描,又称为半开放扫描），它不打开一个完全的TCP连接，执行得很快：　
nmap -sS 192.168.1.0/24

# 在文件ipandmaclist.txt文件中就可以查看ip对应的mac地址了。
nmap -sP -PI -PT -oN ipandmaclist.txt 192.168.0.1/24

```

### # traceroute
```shell
traceroute www.baidu.com
```

### # mac 相关命令

> [https://www.jianshu.com/p/f4edc2632710](https://www.jianshu.com/p/f4edc2632710)

```shell
使用 dig 来诊断域名信息
dig www.oschina.net A dig www.oschina.net MX
查看谁正在登录到你的 Mac 机器
w
显示系统路由表
netstat -r
显示活动网络连接
netstat -an
显示网络统计
netstat -s
```

### # tcpdump 抓包命令

> [http://luodw.cc/2015/12/30/network-command/](http://luodw.cc/2015/12/30/network-command/)

强大的抓包命令.当udp程序收到icmp不可达数据包时，用户程序是不会知道的，所以用tcpdump看到，因为tcpdump可以解析所有到大网络层的数据包，包括icmp，arp等等。当然还有udp,tcp。

```shell
## 默认监听所有网络接口的流量
$ tcpdump
## 监听指定网络接口
$ tcpdump -i eth0
## 监听tcp
$ tcpdump tcp
$ tcpdump udp
## 监听指定主机,可以是主机名或者ip
tcpdump host Charles
tcpdump host 192.168.1.151
## 监听端口
tcpdump port 8080
## 截获主机hostname发送的所有数据
tcpdump -i eth0 src host hostname
## 监视所有送到主机hostname的数据包
tcpdump -i eth0 dst host hostname
## 监视指定主机和端口的数据包
如果想要获取主机 118.31.78.77 接收或发出的telnet包，使用如下命令
sudo tcpdump tcp port 4000 and host 118.31.78.77
对本机的udp 123 端口进行监视 123 为ntp的服务端口
tcpdump udp port 123

```


### # netstat 命令

```shell
# 默认情况下，netstat输出的是所有已连接的tcp,udp和unix域套接字
netstat | more
# 列出所有的端口（包括监听和未监听的） 
netstat -a
# 只列出所有的tcp连接 
netstat -at
# 只列出所有的udp连接 
netstat -au
# 列出所有处于监听的连接，包括tcp,udp和unix域套接字 
netstat -l
# 只列出tcp监听端口 
netstat -lt
# 只列出udp监听端口 
netstat -lu
# n 拒绝显示别名,全部用数字代替(便于查看端口占用)
netstat -tunlp 
# 只列出unix域套接字监听端口 
netstat -lx
# 查看路由表信息 netstat -r

Routing tables

Internet:
Destination        Gateway            Flags        Refs      Use   Netif Expire
default            192.168.0.1        UGSc           11        0     en0

# 一般有两条路由信息，一个是默认路由，即目的地地址不在本网络时，通过网络接口eth0，传到网关192.168.1.1这个也就是第一跳路由器的地址；如果目的地地址是在同一个局域网中，即与子网掩码255.255.255.0与之后=192.168.1.0，则没有网关，通过eth0广播询问即可。

# 查询网络接口列表 
netstat -i

# 找出程序运行的端口 

netstat -ap | grep ssh
```


### # ifconfig

```shell
## 启动 eth0 网卡
ifconfig eth0 up
## 查看 eth0 网卡
ifocnfig eth0

```

### # ivp6

> [http://test-ipv6.com/](http://test-ipv6.com/)

```shell
## 修改dns
nameserver 8.8.8.8
nameserver 114.114.114.114
 
#  应当得到一个 AAAA 记录而不出现错误 
dig aaaa aaaa.v6ns.test-ipv6.com
```

### # ufw 

Ubuntu 16.04 防火墙

千万别手贱开启,否则 ssh 都连接不进去...vpn 遇到过..


### # ndp 

NDP用来发现直接相连的邻居信息

```
ndp -an
```


