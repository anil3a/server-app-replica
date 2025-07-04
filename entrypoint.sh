#!/bin/bash
set -e

# Example input: "site1:site1.local:8001 site2:site2.local:8002"
SITES=${SITES:-"site1:site1.local:8001"}

for site in $SITES; do
  IFS=":" read -r FOLDER DOMAIN PORT <<< "$site"

  echo "Configuring $FOLDER on $DOMAIN:$PORT"

  # Add Listen port
  echo "Listen $PORT" >> /etc/apache2/ports.conf

  # Export vars for envsubst
  export FOLDER
  export DOMAIN
  export PORT

  # Generate vhost file
  envsubst < /templates/vhost-site.conf.template > "/etc/apache2/sites-available/$DOMAIN.conf"

  DOC_ROOT="/var/www/html/$FOLDER"
  if [ ! -d "$DOC_ROOT" ]; then
    echo "Creating missing document root: $DOC_ROOT"
    mkdir -p "$DOC_ROOT"
    echo "<?php echo 'Welcome to $DOMAIN'; ?>" > "$DOC_ROOT/index.php"
  fi

  # Enable site
  a2ensite "$DOMAIN.conf"
done

# Disable default
a2dissite 000-default.conf

# Start services
service cron start
exec apachectl -D FOREGROUND
