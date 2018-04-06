#!/usr/bin/env bash

USER=root
IP=$1

if [ ! -n "$1" ] ;then
   echo "Usage: $0 {ip}"
   exit 1
fi

jekyll build
tar -zcvf deploy.tar.gz _site
scp ./deploy.tar.gz $USER@$IP:/data/nginx/deploy.tar.gz

#ssh $USER@$IP > /dev/null 2>&1 << eeooff
ssh $USER@$IP << eeooff
cd /data/nginx
rm -rf /data/nginx/blog
tar -zxvf deploy.tar.gz
mv _site blog
rm -rf deploy.tar.gz
exit
eeooff

echo done!

rm -rf deploy.tar.gz
