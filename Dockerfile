# Use the official PHP image
FROM php:8.0-fpm

# Set the working directory
WORKDIR /var/www

# Copy the application code to the container
COPY . .

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Laravel dependencies
RUN composer install --optimize-autoloader --no-dev

# Copy environment variables
COPY .env.example .env

# Generate application key
RUN php artisan key:generate

# Set permissions for Laravel storage and cache
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

# Expose port 80
EXPOSE 80

# Use PHP-FPM as the default command
CMD ["php-fpm"]
