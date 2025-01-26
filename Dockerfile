FROM php:8.0-fpm

WORKDIR /var/www

COPY . .

RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev zip git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

COPY .env.example .env

RUN composer install

CMD ["php", "-S", "0.0.0.0:80", "-t", "public"]
