#!/bin/bash

# Check if th nginx.conf file exists
if [ ! -f "scripts/nginx.conf" ]; then
    echo "ERROR ! Nginx configuration file not found !"
    exit 1
fi

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

# Load Nginx config
mv /usr/local/nginx/conf/nginx.conf /usr/local/nginx/conf/nginx.conf.original
cp /scripts/nginx.conf /usr/local/nginx/conf