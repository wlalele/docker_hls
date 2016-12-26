#!/bin/bash

# Check if th nginx.conf file exists
if [ ! -f "scripts/nginx.conf" ]; then
    echo "ERROR ! Nginx configuration file not found !"
    exit 1
fi

# Dependencies
apt-get update
apt-get -y install build-essential libpcre3 libpcre3-dev libssl-dev git wget gcc

# Compile Nginx with RTMP and Auth Modules (+ SSL and Debug)
NGINX="nginx-1.11.5"
wget https://nginx.org/download/$NGINX.tar.gz
git clone https://github.com/arut/nginx-rtmp-module.git
tar -zxvf $NGINX.tar.gz
cd $NGINX
./configure --with-debug --with-http_ssl_module --with-http_auth_request_module --add-module=../nginx-rtmp-module
make
make install
cd ..
rm -rf $NGINX*
rm -rf nginx-rtmp-module

# Compile ffmpeg and ffprobe
git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg
cd ffmpeg
./configure --disable-yasm
make
make install
cd ..
rm -rf ffmpeg

# Load Nginx config
mv /usr/local/nginx/conf/nginx.conf /usr/local/nginx/conf/nginx.conf.original
cp /scripts/nginx.conf /usr/local/nginx/conf

# Start Nginx
/usr/local/nginx/sbin/nginx
