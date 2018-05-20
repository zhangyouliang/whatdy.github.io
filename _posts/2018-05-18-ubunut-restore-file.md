---
layout: post
title: Ubuntu 删除文件恢复 
excerpt: 今天在查看笔记的时候,不小心把辛辛苦苦苦整理的 vim 快捷键的笔记删除了,我的天....,赶紧去网上翻,恢复办法,这不下面就是恢复过程
tags:
 - Linux
 - Ubuntu 
---

Ubuntu 16.04 Ext4  rm -rf 文件恢复
=====

今天在查看笔记的时候,不小心把辛辛苦苦苦整理的 vim 快捷键的笔记删除了,我的天....,赶紧去网上找恢复办法,这不下面就是恢复过程

	Disk /dev/vda: 40 GiB, 42949672960 bytes, 83886080 sectors
	Units: sectors of 1 * 512 = 512 bytes
	Sector size (logical/physical): 512 bytes / 512 bytes
	I/O size (minimum/optimal): 512 bytes / 512 bytes
	Disklabel type: dos
	Disk identifier: 0xd6804155

	Device     Boot Start      End  Sectors Size Id Type
	/dev/vda1  *     2048 83884031 83881984  40G 83 Linux
	# 删除文件
	rm -rf /home/zyl/note/vim.md 
	# 安装
	apt install extundelete
	# 恢复
	extundelete /dev/vda1 --restore-file /home/zyl/note/vim.md
	# 查看恢复的文件
	cat /root/RECOVERED_FILES/home/zyl/note/vim.md

其他恢复方式
	恢复分区所有的文件
	# extundelete /dev/sda1 –-restore-all

	恢复单个文件
	# extundelete /dev/sda3 --restore-file /root/aaa.file

	恢复单个目录
	# extundelete /dev/sdb1 --restore-directory /root/aaa

	恢复的文件在当前位置的RECOVERED_FILES目录下。












