#!/bin/bash

cd `dirname $0`

docker build --rm=true -t lidio601/nginx-vhost-proxy:latest .