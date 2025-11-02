# Use official PHP 8.4 image with Apache
FROM php:8.4-apache

# Install required PHP extensions
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev libonig-dev libxml2-dev zip unzip git \
    && docker-php-ext-install pdo_mysql mysqli mbstring exif pcntl bcmath gd

# Copy your PHP project files into the container
COPY . /var/www/html/

# Set proper ownership and permissions
RUN chown -R www-data:www-data /var/www/html

# Enable Apache mod_rewrite (useful for frameworks or clean URLs)
RUN a2enmod rewrite

# Optionally, you can copy a custom Apache config if you want to override defaults
# COPY default /etc/apache2/sites-available/000-default.conf

# Expose port 80
EXPOSE 80

# Start Apache in the foreground (default behavior of this image)
CMD ["apache2-foreground"]
