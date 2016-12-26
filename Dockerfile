# Ubuntu Trusty
# LEMP Environment (Nginx, Mysql, Php)
# Nginx with rtmp and auth module (for HLS purposes)

FROM ubuntu:14.04
MAINTAINER Amine D. <amine.dai@free.fr>

# Install required libs:
RUN apt-get update
RUN apt-get -y install build-essential libpcre3 libpcre3-dev libssl-dev git wget

# Compile Nginx 1.11.5 with RTMP and Auth Modules (+ SSL and Debug)
RUN echo ". /scripts/install_nginx.sh" >> /etc/bash.bashrc
RUN bash ./scripts/install_nginx.sh

# Change Nginx configuration
# ...
