# Ubuntu Trusty
# LEMP Environment (Nginx, Mysql, Php)
# Nginx with rtmp and auth module (for HLS purposes)

FROM ubuntu:14.04
MAINTAINER Amine D. <amine.dai@free.fr>

# Install required libs:
RUN apt-get update
RUN apt-get -y install build-essential libpcre3 libpcre3-dev libssl-dev git wget

# Set ENV variables:
ENV nginx nginx-1.11.5

# Compile Nginx 1.11.5 with RTMP and Auth Modules (+ SSL and Debug)
RUN wget https://nginx.org/download/${nginx}.tar.gz
RUN git clone https://github.com/arut/nginx-rtmp-module.git
RUN tar -zxvf ${nginx}.tar.gz
WORKDIR ${nginx}
RUN ./configure --with-debug --with-http_ssl_module --with-http_auth_request_module --add-module=../nginx-rtmp-module
RUN make
RUN make install

# Change Nginx configuration
# ...


