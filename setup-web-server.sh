#!/bin/bash

usage="
   set option -d [require] : your domain (e.g. dev.example.com)
"

OS=$(cat /etc/os-release | grep -E ^NAME= | awk -F= '{print$2}' | sed 's/"//g')
if [ "$OS" != "AlmaLinux" ]; then
   echo "This script can run at 'AlmaLinux'."
   echo "Your OS is $OS, then EXIT."
   exit 1
fi

if [ "$USER" != "root" ] || [ "$(getent group wheel | grep $USER)" == "" ]; then
   echo "This script can run at 'root' or sudo user."
   echo "You are $USER and don't have sudo authority, then EXIT."
   exit 1
fi

while [ "$1" != "" ]; do
  case $1 in
    -d)
      DOMAIN=$2;;
    -ipv6)
      IPV6_ADDRESS=$2;;
    -gw)
      IPV6_GATEWAY=$2;;
  esac
  shift
loop

if [ "$DOMAIN" == "" ]; then
  echo $usage
  exit 1
fi

echo "[script] ipv6 setting"
IP_CONFIG="/etc/sysconfig/network-scripts/ifcfg-eth0"
sed -i -e '//s/"yes"/"no"/' ifcfg-eth01

systemctl restart NetworkManager.service
nmcli con up eth0

echo "[script] install nginx"


echo "[script] install snap"


echo "[script] install certbot"


echo "set nginx conf"
echo "set your domain: $DOMAIN"


NGINX_CONF_FILE="/etc/nginx/nginx.conf"
if [ ! -f "${NGINX_CONF_FILE}.bak" ]; then
  cp -p $NGINX_CONF_FILE "${NGINX_CONF_FILE}.bak"
fi

rm -f $NGINX_CONF_FILE
sed 's/#DOMAIN#/'"$DOMAIN"'/g' nginx.conf > $NGINX_CONF_FILE

echo "done."
echo "you have to set DNS setting. A Record or AAAA Record."
