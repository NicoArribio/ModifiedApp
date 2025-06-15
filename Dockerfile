FROM php:8.2-apache

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    libzip-dev \
    unzip \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install zip mysqli pdo pdo_mysql \
    && docker-php-ext-enable pdo_mysql

# Habilitar mod_rewrite
RUN a2enmod rewrite

# Configurar .htaccess
COPY .htaccess /var/www/html/

# Romper la caché de Docker en este punto para asegurar que las siguientes líneas se re-ejecuten
# Cada vez que edites el Dockerfile por encima de esta línea, se reconstruirá todo.
RUN echo "Cache bust for SetEnv: $(date)"

# Copiar todos los archivos de la aplicación al directorio web
COPY . /var/www/html/

# Cambiar permisos de la aplicación para Apache
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

# Exponer el puerto por el que Apache escuchará
EXPOSE 80

# Comando principal para iniciar Apache en primer plano
CMD ["apache2-foreground"]
