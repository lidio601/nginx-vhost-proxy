#!/bin/bash

HOSTNAME=$1
if [ -z "$HOSTNAME" ]; then
	echo "Usage: docker exec nginx-vhost-proxy /rm-vhost.sh <domain.example.com>"
	exit 1
fi

function sep {
	echo -e "\n\n####################"
}

function ifexit {
	[ "$?" -eq "0" ] || exit 1
}

echo "Removing virtual-host configuration for host $HOSTNAME"

if [ -f "/etc/nginx/conf.d/$HOSTNAME.conf" ]; then
	rm -fv "/etc/nginx/conf.d/$HOSTNAME.conf"
fi

/etc/init.d/nginx reload