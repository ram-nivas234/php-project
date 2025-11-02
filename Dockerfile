# Use official PHP-FPM image as base
FROM php:8.4-fpm

# Install Nginx
RUN apt-get update && apt-get install -y nginx && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy project files
COPY . /var/www/html

# Copy your Nginx configuration (named 'default')
COPY default /etc/nginx/conf.d/default.conf

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Expose HTTP port
EXPOSE 80

# Start PHP-FPM and Nginx
CMD service php8.4-fpm start && nginx -g "daemon off;"
