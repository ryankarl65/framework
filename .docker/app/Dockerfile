# Docker image of Laravel Shopper (PHP)
FROM php:7.4-apache as production

# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Update and install some needed packages
RUN apt-get -y update \
    && apt-get install -y libicu-dev git unzip curl expect grep \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl

# Install PHP Core Extensions
RUN apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

# Copy php-extension-installer from  mlocati image  -- https://github.com/mlocati/docker-php-extension-installer
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions gd xdebug zip pdo_pgsql pgsql pdo_mysql mysqli 

# COPY composer from composer docker image (Official)
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Install Laravel Shopper
WORKDIR /var/www
RUN rm -rf *
RUN composer create-project laravel/laravel .
RUN composer require shopper/framework
RUN rm .env

# Check if the container is ready
#HEALTHCHECK CMD curl --fail http://localhost:8000 || exit 1

COPY entrypoint.sh /
COPY script/* .
ENTRYPOINT ["/entrypoint.sh"]
RUN composer dump-autoload
CMD ["php","artisan","serve"]

# Expose the port 8000 of the container
EXPOSE 8000

VOLUME [ "/var/www" ] 