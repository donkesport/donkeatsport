FROM php:8.5-fpm-alpine AS base

# Dépendances RUNTIME uniquement (pas les -dev)
RUN apk add --no-cache \
    libpng \
    libzip \
    zip \
    unzip

# Build des extensions PHP : on installe les -dev dans un groupe virtuel
# qu'on supprime juste après — les .so compilés restent dans l'image
RUN apk add --no-cache --virtual .build-deps \
        libpng-dev \
        libzip-dev \
    && docker-php-ext-install pdo_mysql bcmath gd zip \
    && apk del .build-deps

# Préparation de Composer et Laravel (toujours en tant que root)
ENV COMPOSER_HOME=/usr/local/share/composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# On prépare le dossier Composer ET le dossier web
RUN mkdir -p $COMPOSER_HOME /var/www && \
    chown -R www-data:www-data $COMPOSER_HOME /var/www

# On définit le PATH globalement
ENV PATH="${COMPOSER_HOME}/vendor/bin:${PATH}"
WORKDIR /var/www/donkeatsport

# --- DEVELOPPEMENT ---
FROM base AS development
RUN apk add --no-cache nodejs npm git curl
USER www-data
RUN composer global require laravel/installer

# --- PRODUCTION ---
FROM base AS production

# En production, on a besoin de Node temporairement pour compiler les assets
# car certains plugins (comme wayfinder) appellent 'php artisan'
RUN apk add --no-cache nodejs npm

# On copie tout le code source Laravel
COPY ./src/donkeatsport .

# Installation des dépendances PHP
RUN composer install --no-dev --optimize-autoloader

# Installation des dépendances JS et Build du Frontend
# Maintenant 'php artisan' est disponible car on est sur l'image base (PHP)
RUN npm install 
RUN npm install --save-dev laravel-echo pusher-js && npm run build

# Nettoyage : On supprime Node et les modules pour alléger l'image finale
RUN npm prune --production && \
    rm -rf node_modules && \
    apk del nodejs npm

# Correction des permissions pour Laravel
RUN chown -R www-data:www-data /var/www/donkeatsport/storage /var/www/donkeatsport/bootstrap/cache

USER www-data