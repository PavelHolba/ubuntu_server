#!/bin/bash

set -e

clear

echo
echo "## "
echo "## job: [apache install] // state: [starting]"
echo "## "
echo

# Update package list and install Apache and OpenSSL
sudo apt update
sudo apt install -y apache2 openssl

# Enable necessary Apache modules
sudo a2enmod ssl
sudo a2enmod headers

# Create directory for SSL certificates
sudo mkdir -p /etc/ssl/mycerts

# Generate private key
sudo openssl genpkey -algorithm RSA -out /etc/ssl/mycerts/server.key

# Set company details
country="CZ"
state="CZ"
locality="Ostrava"
organization="mujserver"
organizational_unit="IT"
common_name="localhost"
email_address="admin@mujserver.com"

# Generate CSR (Certificate Signing Request) with company details
sudo openssl req -new -key /etc/ssl/mycerts/server.key -out /etc/ssl/mycerts/server.csr \
    -subj "/C=${country}/ST=${state}/L=${locality}/O=${organization}/OU=${organizational_unit}/CN=${common_name}/emailAddress=${email_address}"

# Generate self-signed certificate
sudo openssl x509 -req -days 365 -in /etc/ssl/mycerts/server.csr -signkey /etc/ssl/mycerts/server.key -out /etc/ssl/mycerts/server.crt

# Configure Apache to use the self-signed certificate
sudo bash -c 'cat > /etc/apache2/sites-available/default-ssl.conf <<EOF
<IfModule mod_ssl.c>
    <VirtualHost _default_:443>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html

        SSLEngine on
        SSLCertificateFile /etc/ssl/mycerts/server.crt
        SSLCertificateKeyFile /etc/ssl/mycerts/server.key

        <FilesMatch "\.(cgi|shtml|phtml|php)$">
            SSLOptions +StdEnvVars
        </FilesMatch>
        <Directory /usr/lib/cgi-bin>
            SSLOptions +StdEnvVars
        </Directory>

        BrowserMatch "MSIE [2-6]" \\
            nokeepalive ssl-unclean-shutdown \\
            downgrade-1.0 force-response-1.0
        BrowserMatch "MSIE [17-9]" ssl-unclean-shutdown
    </VirtualHost>
</IfModule>
EOF'

# Enable the default SSL site
sudo a2ensite default-ssl.conf

# Modify Apache ports configuration to listen on port 443, leaving comment from original file in just in case
echo '# If you just change the port or add more ports here, you will likely also
# have to change the VirtualHost statement in
# /etc/apache2/sites-enabled/000-default.conf

Listen 0.0.0.0:443' | sudo tee /etc/apache2/ports.conf > /dev/null

# Restart Apache to apply changes
sudo systemctl restart apache2

echo
echo "## "
echo "## job: [apache install] // state: [completed]"
echo "## "
echo
