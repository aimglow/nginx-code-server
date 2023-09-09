#!/bin/bash

usage="
   set option -d [require] : your domain (e.g. dev.example.com)
"

while [ "$1" != "" ]; do
  case $1 in
    -d)
      DOMAIN=$2;;
  esac
  shift
loop

if [ "$DOMAIN" == "" ]; then
  echo $usage
  exit 1
fi

NGINX_CONF_FILE="/etc/nginx/nginx.conf"
if [ ! -f "${NGINX_CONF_FILE}.bak" ]; then
  cp -p $NGINX_CONF_FILE "${NGINX_CONF_FILE}.bak"
fi

rm -f $NGINX_CONF_FILE
sed 's/#DOMAIN#/'"$DOMAIN"'/g' nginx.conf > $NGINX_CONF_FILE
