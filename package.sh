#!/bin/bash
set -e

INSTALL=/tmp/openresty/
cd ./ngx_openresty-1.7.0.1/

./configure \
--with-luajit \
--sbin-path=/usr/sbin/nginx \
--conf-path=/etc/nginx/nginx.conf \
--error-log-path=/var/log/nginx/error.log \
--http-client-body-temp-path=/var/lib/nginx/body \
--http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
--http-log-path=/var/log/nginx/access.log \
--http-proxy-temp-path=/var/lib/nginx/proxy \
--http-scgi-temp-path=/var/lib/nginx/scgi \
--http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
--lock-path=/var/lock/nginx.lock \
--pid-path=/var/run/nginx.pid \
--with-http_dav_module \
--with-http_flv_module \
--with-http_geoip_module \
--with-http_gzip_static_module \
--with-http_image_filter_module \
--with-http_realip_module \
--with-http_stub_status_module \
--with-http_ssl_module \
--with-http_sub_module \
--with-http_xslt_module \
--with-ipv6 \
--with-sha1=/usr/include/openssl \
--with-md5=/usr/include/openssl \
--with-mail \
--with-mail_ssl_module \
--with-http_stub_status_module \
--with-http_secure_link_module \
--with-http_sub_module 

make
make install DESTDIR=$INSTALL

mkdir -p $INSTALL/var/lib/nginx
mkdir -p /tmp/openresty/etc/nginx/sites-enabled
mkdir -p /tmp/openresty/etc/nginx/sites-available
cd ..

install -m 0555 -D nginx.init $INSTALL/etc/init.d/nginx
install -m 0555 -D nginx.logrotate $INSTALL/etc/logrotate.d/nginx

fpm -s dir -t deb -n nginx-resty -v 1.7.0.1 --iteration 1 -C "$INSTALL" \
--description "openresty 1.7.0.1" \
-d libxslt1.1 \
-d libgd-dev \
-d libgeoip1 \
-d libpcre3 \
--config-files /etc/nginx/fastcgi.conf.default \
--config-files /etc/nginx/win-utf \
--config-files /etc/nginx/fastcgi_params \
--config-files /etc/nginx/nginx.conf \
--config-files /etc/nginx/koi-win \
--config-files /etc/nginx/nginx.conf.default \
--config-files /etc/nginx/mime.types.default \
--config-files /etc/nginx/koi-utf \
--config-files /etc/nginx/uwsgi_params \
--config-files /etc/nginx/uwsgi_params.default \
--config-files /etc/nginx/sites-available \
--config-files /etc/nginx/sites-enabled \
--config-files /etc/nginx/fastcgi_params.default \
--config-files /etc/nginx/mime.types \
--config-files /etc/nginx/scgi_params.default \
--config-files /etc/nginx/scgi_params \
--config-files /etc/nginx/fastcgi.conf \
etc usr var
