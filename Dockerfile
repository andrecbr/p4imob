FROM php:8.0.12

RUN apt-get update && apt-get install -y \
    git \
    curl \
	libonig-dev \
    zip \
	unzip

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo_mysql mbstring

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
	
COPY --chown=www-data:www-data composer.json composer.lock ./
RUN composer install --prefer-dist --no-autoloader

COPY --chown=www-data:www-data . .
RUN composer dump-autoload --optimize

COPY ./ /var/www

CMD [ "env" ]

WORKDIR /var/www

CMD php artisan serve --host=0.0.0.0 --port=8181

EXPOSE 8181