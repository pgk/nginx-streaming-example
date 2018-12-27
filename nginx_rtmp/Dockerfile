FROM debian:stretch-slim

LABEL maintainer="Panos Kountanis <p@kountanis.com>"

ENV NGINX_VERSION 1.14.2

RUN set -x \
	&& apt-get update \
	&& apt-get install --no-install-recommends --no-install-suggests -y \
		 build-essential libpcre3 libpcre3-dev libssl-dev wget unzip ffmpeg zlib1g zlib1g-dev ca-certificates \
	&& mkdir -p /tmp/src \
	&& cd /tmp/src && wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
	&& cd /tmp/src && wget https://github.com/arut/nginx-rtmp-module/archive/master.zip \
	&& cd /tmp/src && tar -zxvf nginx-${NGINX_VERSION}.tar.gz \
	&& cd /tmp/src && unzip master.zip \
	&& cd /tmp/src && cd nginx-${NGINX_VERSION} \
	&& ./configure --with-http_ssl_module --add-module=../nginx-rtmp-module-master \
	&& make \
	&& make install

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /usr/local/nginx/logs/access.log \
	&& ln -sf /dev/stderr /usr/local/nginx/logs/error.log

EXPOSE 80
EXPOSE 443
# for streams
EXPOSE 9099

STOPSIGNAL SIGTERM

CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
