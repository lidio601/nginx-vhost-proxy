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

function sep {
	echo -e "\n\n####################"
}

function ifexit {
	[ "$?" -eq "0" ] || exit 1
}

echo "Adding virtual-host configuration for host $HOSTNAME port $PORT"

echo "server { \
	server_name $HOSTNAME www.$HOSTNAME; \
    access_log  /var/log/nginx/$HOSTNAME.log main; \
	location / { \
		proxy_pass http://$HOSTNAME:$PORT; \
	} \
} \
" >"/etc/nginx/conf.d/$HOSTNAME.conf"

/etc/init.d/nginx reload