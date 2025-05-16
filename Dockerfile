FROM almalinux:9

RUN dnf install -y epel-release && \
    dnf install -y httpd php php-mbstring php-pdo php-mysqlnd php-cli php-gd git && \
    dnf clean all && \
    rm -rf /var/cache/dnf

RUN git clone https://github.com/ORT-FI-7417-SolucionesCloud/e-commerce-obligatorio-2025.git /var/www/html

RUN chown -R apache:apache /var/www/html

RUN echo '<VirtualHost *:80>\n\
    ServerName localhost\n\
    DocumentRoot "/var/www/html"\n\
    <Directory "/var/www/html">\n\
        Options Indexes FollowSymLinks\n\
        AllowOverride All\n\
        Require all granted\n\
    </Directory>\n\
</VirtualHost>' > /etc/httpd/conf.d/ecommerce.conf

RUN echo 'RewriteEngine On\n\
\n\
RewriteCond %{REQUEST_FILENAME} !-f\n\
RewriteCond %{REQUEST_FILENAME} !-d\n\
\n\
RewriteRule ^(.+)$ index.php?uri=$1 [QSA,L]' > /var/www/html/.htaccess

EXPOSE 80
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]