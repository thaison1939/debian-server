#!/bin/bash

set -e

DB_NAME="mydatabase"
DB_USER="myuser"
DB_PASS="mypassword" 
DOMAIN=""  #optional

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

echo "Updating system..."
apt update -y && apt upgrade -y

echo "Installing Apache, PostgreSQL, and UFW..."
apt install -y apache2 postgresql ufw

systemctl enable apache2
systemctl start apache2

echo "Configuring firewall..."
ufw allow 80/tcp  # HTTP
ufw allow 443/tcp # HTTPS
ufw allow 22/tcp  # SSH 
ufw enable

echo "Configuring PostgreSQL..."
sudo -u postgres psql <<EOF
CREATE DATABASE $DB_NAME;
CREATE USER $DB_USER WITH ENCRYPTED PASSWORD '$DB_PASS';
GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;
EOF

echo "Setting up Apache Virtual Host..."
cat > /etc/apache2/sites-available/000-default.conf <<EOF
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html

    <Directory /var/www/html>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

echo "Restarting Apache..."
systemctl restart apache2

public_IP_address=$(hostname -I | awk '{print $1}')

echo "Server setup complete! Visit your IP in a browser to test."
echo "http://$public_IP_address"
