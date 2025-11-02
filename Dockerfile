# Use official Debian-based Nginx as base image
FROM nginx:latest

# Install PHP and required extensions
RUN apt-get update && apt-get install -y \
    php php-fpm php-mysql php-cli php-curl php-gd php-xml php-mbstring php-zip php-bcmath \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy project files into container
COPY . /var/www/html

# Copy custom Nginx configuration
COPY default /etc/nginx/conf.d/default.conf

# Ensure correct permissions
RUN mkdir -p /run/php && chown -R www-data:www-data /var/www/html

# Expose port 80 for web access
EXPOSE 80

# Start PHP-FPM service, then Nginx in foreground
CMD service php8.4-fpm start && nginx -g "daemon off;"
