# Ubuntu Trusty
# LEMP Environment (Nginx, Mysql, Php)
# Nginx with rtmp and auth module (for HLS purposes)

FROM ubuntu:14.04
MAINTAINER Amine D. <amine.dai@free.fr>

# Install required libs:
RUN apt-get update && apt-get install -y \ 
	build-essential \
	libpcre3 \
	libpcre3-dev \
	libssl-dev \
	git \
	wget \
	gcc \
	curl \
	&& rm -rf /var/lib/apt/lists/*
	
# Load Nginx config && start it

ADD scripts/install_nginx.sh /scripts/install_nginx.sh
ADD scripts/nginx.conf /scripts/nginx.conf
RUN bash /scripts/install_nginx.sh

# Compile ffmpeg and ffprobe
RUN git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg \
	&& cd /ffmpeg \
	&& ./configure --disable-yasm \
	&& make \
	&& make install \
	&& cd / \
	&& rm -rf ffmpeg

# Add RSA Key to clone IPTV Panel from bitbucket repository
RUN mkdir /root/.ssh/
ADD id_rsa_iptv_docker /root/.ssh/id_rsa_iptv_docker
RUN touch /root/.ssh/known_hosts \
	& ssh-keyscan bitbucket.org >> /root/.ssh/known_hosts
	
RUN git clone git@bitbucket.org:wlalele/iptv-panel.git \
	&& cd iptv-panel/ \
	&& curl -s http://getcomposer.org/installer | php \
	&& php composer.phar install

CMD /usr/local/nginx/sbin/nginx