#!/bin/bash

cd `dirname $0`

docker build --rm=true -t lidio601/nginx-vhost-proxy:latest .

docker run -it --rm=true \
    -p 80:80 -p 443:443 \
    -v "/etc/letsencrypt:/etc/letsencrypt" \
    -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
    lidio601/nginx-vhost-proxy:latest /bin/bash