# Ubuntu Trusty
# LEMP Environment (Nginx, Mysql, Php)
# Nginx with rtmp and auth module (for HLS purposes)

FROM ubuntu:14.04
MAINTAINER Amine D. <amine.dai@free.fr>

# Install required libs:	
RUN apt-get update \
	&& touch /etc/apt/sources.list.d/ondrej-php5.list \
	&& echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu trusty main" >>  /etc/apt/sources.list.d/ondrej-php5.list \
	&& echo "deb-src http://ppa.launchpad.net/ondrej/php/ubuntu trusty main" >> /etc/apt/sources.list.d/ondrej-php5.list \ 
	&& apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C

RUN apt-get update && apt-get install -y \ 
	build-essential \
	libpcre3 \
	libpcre3-dev \
	libssl-dev \
	git \
	wget \
	gcc \
	curl \
	ufw \
	php5.6 \
	php5.6-fpm \
	php5.6-mbstring \
	php5.6-mcrypt \
	php5.6-mysql \
	php5.6-xml \
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

#Install IPTV-Panel project
RUN git clone git@bitbucket.org:wlalele/iptv-panel.git \
	&& cd iptv-panel/ \
	&& curl -s http://getcomposer.org/installer | php \
	&& php composer.phar install --quiet

CMD /usr/local/nginx/sbin/nginx