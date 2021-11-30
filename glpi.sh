#!/bin/bash
# glpi.sh

echo "Script d'installation automatique de GLPI"
echo "Lancez avec l'utilisateur root"

apt update && apt full-upgrade -y

apt install perl -y
apt install php-ldap php-imap php-apcu php-xmlrpc php-cas php-mysqli php-mbstring php-curl php-gd php-simplexml php-xml php-intl php-zip php-bz2 -y

systemctl reload apache2

cd /tmp/
wget github.com/glpi-project/glpi/releases/download/9.5.6/glpi-9.5.6.tgz

tar xzf glpi-9.5.6.tgz -C /var/www/html

chown -R www-data:www-data /var/www/html/glpi
chmod -R 775 /var/www/html/glpi

echo "Création des bases de données"
apt install mariadb-server -y


echo "CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'password';"
echo "grant all privileges on glpi.* to newuser@localhost;"
echo "flush privileges;"
echo "exit;"
mysql -u root


echo "Vous pouvez vous rendre sur http://votre_ip/glpi"