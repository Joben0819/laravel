# Use the official PHP image as a base
FROM php:8.0-fpm

# Install necessary dependencies (like Composer)
RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev zip git unzip && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set the working directory in the container
WORKDIR /var/www

# Copy the Laravel app into the container
COPY . /var/www

# Install Laravel dependencies
RUN composer install

# Set the correct permissions
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
