FROM php:8-fpm-alpine

# packages to keep
RUN apk add --no-cache yaml

# packages for build only
RUN apk add --no-cache --virtual build-deps git yaml-dev $PHPIZE_DEPS

# production conf
RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# add YAML support
RUN pecl channel-update pecl.php.net
RUN pecl install yaml && docker-php-ext-enable yaml

# cleanup build dependencies
RUN apk del --purge build-deps
RUN rm -rf /tmp/pear

# copy app and conf
ADD ./src /var/www/html
ADD ./conf/app-php.ini /usr/local/etc/php/conf.d/app-php.ini
ADD ./conf/app-fpm.conf /usr/local/etc/php-fpm.d/zz-app-fpm.conf

RUN chown -R www-data:www-data /var/www

USER www-data
