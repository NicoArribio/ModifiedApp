FROM almalinux:9

RUN dnf install -y epel-release && \
    dnf install -y httpd php php-mbstring php-pdo php-mysqlnd php-cli php-gd git && \
    dnf clean all && \
    rm -rf /var/cache/dnf

RUN git clone https://github.com/ORT-FI-7417-SolucionesCloud/e-commerce-obligatorio-2025.git /var/www/html

RUN chown -R apache:apache /var/www/html

RUN bash -c 'cat > /etc/httpd/conf.d/ecommerce.conf <<EOF
<VirtualHost *:80>
    ServerName 192.168.0.100
    DocumentRoot "/var/www/html"

    <Directory "/var/www/html">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF'

# Add .htaccess with routing rules
RUN cat <<'EOF' > /var/www/html/.htaccess
RewriteEngine On

RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d

RewriteRule ^(.+)$ index.php?uri=$1 [QSA,L]
EOF
EXPOSE 80
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]