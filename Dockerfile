# ───── Stage 1: Build (Composer, dependencies, etc.) ─────
FROM php:8.4-fpm AS build

# Install dependencies
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev && \
    docker-php-ext-install pdo_mysql zip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy app source
WORKDIR /var/www/html
COPY . .

# If you have composer.json, install dependencies
# COPY composer.json composer.lock ./
# RUN composer install --no-dev --optimize-autoloader

# ───── Stage 2: Production (Nginx + PHP-FPM runtime) ─────
FROM nginx:latest AS prod

# Install PHP (only runtime)
RUN apt-get update && apt-get install -y \
    php8.4-fpm php8.4-mysql php8.4-cli php8.4-curl php8.4-gd php8.4-xml php8.4-mbstring php8.4-zip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy project from build stage
COPY --from=build /var/www/html /var/www/html

# Copy your Nginx config
COPY default /etc/nginx/conf.d/default.conf

# Set permissions
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

# Start both PHP-FPM and Nginx
CMD service php8.4-fpm start && nginx -g "daemon off;"
