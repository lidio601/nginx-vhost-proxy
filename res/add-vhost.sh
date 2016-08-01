#!/bin/bash

HOSTNAME=$1
if [ -z "$HOSTNAME" ]; then
	echo "Usage: docker exec nginx-vhost-proxy /add-vhost.sh <domain.example.com> [container-port-or-80]"
	exit 1
fi

PORT=$2
if [ -z "$PORT" ]; then
	PORT=80
fi

echo "Adding virtual-host configuration for host $HOSTNAME port $PORT"

echo "server { \
	listen 80; \
	listen [::]:80 ipv6only=on; \
	server_name $HOSTNAME; \
	location / { \
		proxy_pass http://$HOSTNAME:$PORT; \
	} \
} \
" >"/etc/nginx/conf.d/$HOSTNAME.conf"

/etc/init.d/nginx reload