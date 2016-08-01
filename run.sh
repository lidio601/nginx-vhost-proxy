#!/bin/bash

# Run your own website on a separate container
#> docker run -d -p 8080:80 --host domain.example.com my-website-image 

# Run the nginx virtual-host proxy service and link to the first container
docker run -d -p 80:80 --name nginx-vhost-proxy --link domain.example.com lidio601/nginx-vhost-proxy

# Alternatively you can create your own network in which you
# will run all your websites' container
#> docker network create mynet
#> docker run -d -p 80:80 --name nginx-vhost-proxy --net mynet lidio601/nginx-vhost-proxy

# Then add each website to the nginx configuration
docker exec nginx-vhost-proxy /add-vhost.sh domain.example.com

# Or remove it =)
#> docker exec nginx-vhost-proxy /rm-vhost.sh domain.example.com
