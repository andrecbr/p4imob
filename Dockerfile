###
# Não roda com o docker-compose.
# Necessita rodar separado com os comandos
#     > docker build -t my-first-image .
#     > docker run -p 8181:8181 my-first-image
###
#FROM php:7.4-fpm
#RUN apt-get update -y && apt-get install -y openssl libonig-dev zip unzip git
#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
#RUN docker-php-ext-install pdo mbstring
#WORKDIR /app
#COPY . /app
#RUN composer install
#CMD php artisan serve --host=0.0.0.0 --port=8181
#EXPOSE 8181

FROM php:7.4-fpm

RUN apt-get update && apt-get install -y \
    git \
    curl \
	libonig-dev \
    zip \
	unzip

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
	
COPY --chown=www-data:www-data composer.json composer.lock ./
RUN composer install --prefer-dist --no-autoloader

COPY --chown=www-data:www-data . .
RUN composer dump-autoload --optimize

# copia o projeto para o Docker
COPY ./ /var/www

# Set working directory
WORKDIR /var/www

CMD php artisan serve --host=0.0.0.0 --port=8181

EXPOSE 8181