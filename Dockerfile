# Stage 1: Build React frontend
FROM node:20-alpine AS build-stage
WORKDIR /app
COPY edusec-frontend/package*.json ./
RUN npm install
COPY edusec-frontend/ .
RUN npm run build

# Stage 2: PHP Apache Backend
FROM php:8.1-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    libicu-dev \
    libonig-dev \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions required by Yii2 and EduSec
RUN docker-php-ext-install \
    pdo_mysql \
    mysqli \
    gd \
    zip \
    intl \
    mbstring \
    opcache

# Enable Apache mod_rewrite for Yii2 URL routing
RUN a2enmod rewrite

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY . /var/www/html

# Copy build artifacts and entrypoint
COPY --from=build-stage /app/dist /var/www/html/app
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Update Apache configuration to allow .htaccess overrides
RUN echo '<Directory /var/www/html>\n\
    Options Indexes FollowSymLinks\n\
    AllowOverride All\n\
    Require all granted\n\
    </Directory>' > /etc/apache2/conf-available/edusec.conf \
    && a2enconf edusec

# Install Composer dependencies
RUN composer install --no-interaction --no-dev --optimize-autoloader || true

# Set proper permissions
RUN mkdir -p runtime assets \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 777 runtime assets \
    && chmod 644 /var/www/html/.htaccess || true

# Start via entrypoint
ENTRYPOINT ["docker-entrypoint.sh"]
