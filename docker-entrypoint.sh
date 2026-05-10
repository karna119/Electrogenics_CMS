#!/bin/bash
set -e

# Railway injects PORT at runtime — configure Apache to listen on it
PORT=${PORT:-80}

# Update Apache ports.conf to use the Railway-assigned port
echo "Listen ${PORT}" > /etc/apache2/ports.conf

# Update the default vhost to use the correct port
sed -i "s/<VirtualHost \*:80>/<VirtualHost *:${PORT}>/" /etc/apache2/sites-available/000-default.conf

# Explicitly disable mpm_event and enable mpm_prefork to avoid MPM conflicts
a2dismod mpm_event || true
a2enmod mpm_prefork || true

# Start Apache in foreground
exec apache2-foreground
