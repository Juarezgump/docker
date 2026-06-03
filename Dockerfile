FROM php:8.2-apache

# Instalación de dependencias del sistema
RUN apt-get update && apt-get install -y zip unzip git && \
    docker-php-ext-install pdo pdo_mysql

# Instalación de Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configuración de Apache (Manteniendo tu archivo)
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

WORKDIR /var/www/html

# Instalación de dependencias (PHPStan se instala como dev)
COPY composer.json ./
RUN composer install --optimize-autoloader

# Copiar el resto del código
COPY . .

# Habilitar rewrite de Apache por si lo necesitas en tu 000-default.conf
RUN a2enmod rewrite
