#!/bin/bash

HOSTNAME=$1
if [ -z "$HOSTNAME" ]; then
	echo "Usage: docker exec lidio601/nginx-vhost-proxy /rm-vhost.sh <domain.example.com>"
	exit 1
fi

echo "Removing virtual-host configuration for host $HOSTNAME"

if [ -f "/etc/nginx/conf.d/$HOSTNAME.conf" ]; then
	rm -fv "/etc/nginx/conf.d/$HOSTNAME.conf"
fi

/etc/init.d/nginx reload