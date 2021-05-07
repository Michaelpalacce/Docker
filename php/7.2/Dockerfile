FROM php:7.2-fpm-alpine

LABEL Maintainer="Stefan Genov"

#Helpers
RUN apk add bash git

ENV APP_PORT=9000
ENV PM_MAX_CHILDREN=20
ENV PM_START_SERVERS=10
ENV PM_MIN_SPARE_SERVERS=10
ENV PM_MAX_SPARE_SERVERS=15
ENV R_LIMIT_FILES=10000
ENV PHP_MEMORY_LIMIT=64m
ENV MAX_EXECUTION_TIME=120
ENV EXPOSE_PHP=Off
ENV DATE_TIMEZONE=UTC
ENV DISPLAY_ERRORS=0
ENV ERROR_LOG_LOCATION=/var/log/www-error.log
ENV ERROR_REPORTING=22527
ENV LOG_ERRORS=1
ENV LOG_ERRORS_MAX_LEN=2048
ENV MAX_INPUT_TIME=60
ENV OUTPUT_BUFFERING=4096
ENV REGISTER_ARGC_ARGV=0
ENV REQUEST_ORDER=GP
ENV SESSION_GC_DIVISOR=1000
ENV SHORT_OPEN_TAG=0

# Install Extra DEPS
ENV PHPIZE_DEPS autoconf file g++ gcc make pkgconf re2c libc-dev yaml-dev pcre-dev zlib-dev libmemcached-dev cyrus-sasl-dev libpng-dev
RUN set -xe \
	&& apk --no-cache update \
	&& apk add --no-cache $PHPIZE_DEPS \
	&& sed -i 's/^exec $PHP -C -n/exec $PHP -C/g' $(which pecl) \
	&& pecl install yaml-2.0.0 memcached \
	&& echo "extension=yaml.so" > /usr/local/etc/php/conf.d/01_yaml.ini \
	&& echo "extension=memcached.so" > /usr/local/etc/php/conf.d/20_memcached.ini \
#   PHP Extensions
	&& docker-php-ext-install bcmath \
	&& docker-php-ext-install mbstring \
	&& docker-php-ext-install zip \
	&& docker-php-ext-install opcache \
	&& docker-php-ext-enable yaml \
	&& docker-php-ext-enable memcached \
#	Install composer
	&& curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
#	Install Cassandra driver and dependencies
#	Install driver dependencies
	&& apk add --no-cache python3 py-pip cmake autoconf g++ gcc make libuv gmp libstdc++ mariadb-client \
	&& apk add --virtual cpp_driver_deps pcre-dev openssl-dev libuv-dev gmp-dev \
	&& ln -s /usr/bin/python3 /usr/bin/python \
#	Install cpp-driver
	&& git clone https://github.com/datastax/cpp-driver.git cpp-driver \
	&& cd cpp-driver \
	&& git checkout tags/2.15.3 \
	&& mkdir build \
	&& cd build \
	&& cmake -DCASS_BUILD_STATIC=ON -DCASS_BUILD_SHARED=ON .. \
	&& make -j4 \
	&& make install \
	&& cd /lib \
	&& git clone https://github.com/Michaelpalacce/php-driver.git php-driver \
#	PHP-DRIVER
	&& cd php-driver \
	&& pecl install ext/package.xml \
	&& ln -s /usr/local/lib64/libcassandra* /usr/local/lib/ \
	&& docker-php-ext-enable cassandra \
	&& cd /lib \
#	DELETE files and dependencies
	&& rm -rf cpp-driver \
	&& rm -rf php-driver \
	&& apk del cpp_driver_deps \
#	Add pdo and pdo_mysql
	&& docker-php-ext-install pdo pdo_mysql \
#	Install PHPUNIT
	&& wget -O phpunit https://phar.phpunit.de/phpunit-7.phar \
	&& chmod +x phpunit\
	&& mv phpunit /usr/bin/ \
#	Imap extension and deps
	&& apk add --no-cache imap-dev krb5-dev openssl-dev \
	&& docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
	&& docker-php-ext-install imap \
	&& docker-php-ext-enable imap \
#	INSTALL node and npm
	&& apk add --no-cache nodejs npm --repository="http://dl-cdn.alpinelinux.org/alpine/v3.11/main/" \
#	INSTALLING AND CONFIGURING GD
	&& apk add --no-cache freetype libjpeg-turbo libpng freetype-dev libjpeg-turbo-dev libpng-dev libxpm-dev libwebp-dev \
	&& docker-php-ext-configure gd --with-gd --with-webp-dir --with-jpeg-dir --with-png-dir --with-zlib-dir --with-xpm-dir --with-freetype-dir \
	&& docker-php-ext-install gd

# Set www.conf
COPY ./www.conf /usr/local/etc/php-fpm.d/www.conf
# Set custom php.ini
COPY ./docker-php-custom.ini /usr/local/etc/php/conf.d/docker-php-custom.ini