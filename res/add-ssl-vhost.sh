#!/bin/bash

HOSTNAME=$1
if [ -z "$HOSTNAME" ]; then
	echo "Usage: docker exec nginx-vhost-proxy /add-ssl-vhost.sh <domain.example.com> [container-port-or-80]"
	exit 1
fi

PORT=$2
if [ -z "$PORT" ]; then
	PORT=80
fi

function sep {
	echo -e "\n\n####################"
}

function ifexit {
	[ "$?" -eq "0" ] || exit 1
}

echo "Creating fake virtual-host for certbot webroot checks"

WWWDIR=/tmp/www_${HOSTNAME}
mkdir -vp ${WWWDIR}
ifexit

echo "server { \
    server_name $HOSTNAME; \
    access_log  /var/log/nginx/$HOSTNAME.log  main; \
    root $WWWDIR; \
}" >"/etc/nginx/conf.d/$HOSTNAME.conf"
ifexit

nginx -t
ifexit

/etc/init.d/nginx reload
ifexit

echo "Certbot running in webroot mode for host $HOSTNAME"
certbot certonly --webroot --register-unsafely-without-email --agree-tos -w $WWWDIR -d $HOSTNAME -d $HOSTNAME
ifexit

echo "Adding SSL virtual-host configuration for host $HOSTNAME port $PORT"

echo "server { \
    server_name $HOSTNAME www.$HOSTNAME; \
    access_log  /var/log/nginx/$HOSTNAME.log main; \
    ssl_certificate /etc/letsencrypt/live/$HOSTNAME/fullchain.pem; \
    ssl_certificate_key /etc/letsencrypt/live/$HOSTNAME/privkey.pem; \
    include snippets/ssl-params.conf; \
    location / { \
        proxy_pass http://$HOSTNAME:$PORT; \
    } \
} \
" >"/etc/nginx/conf.d/$HOSTNAME.conf"

/etc/init.d/nginx restart
