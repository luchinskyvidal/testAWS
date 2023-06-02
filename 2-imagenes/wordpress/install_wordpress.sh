#!/bin/bash

# Actualizar so
sudo apt-get update
sudo apt-get upgrade -y

# Instala Apache, MySQL y PHP
sudo apt-get install apache2 mysql-server php libapache2-mod-php php-mysql -y

# Descarga e instala WordPress
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
sudo mv wordpress /var/www/html/

# Configurar la base de datos de WordPress (con la postrgresql)
sudo mysql -e "CREATE DATABASE ${DB_NAME};"
sudo mysql -e "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';"
sudo mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Configurar el archivo de configuración de WordPress
sudo cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
sudo sed -i "s/database_name_here/${DB_NAME}/" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/username_here/${DB_USER}/" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/password_here/${DB_PASSWORD}/" /var/www/html/wordpress/wp-config.php

# Configurar permisos de directorios
sudo chown -R www-data:www-data /var/www/html/wordpress/
sudo chmod -R 755 /var/www/html/wordpress/

# Reiniciar servicios
sudo systemctl restart apache2
sudo systemctl restart mysql

# Eliminar archivos temporales
rm /tmp/latest.tar.gz

echo "WordPress installation completed."
