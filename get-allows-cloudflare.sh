#!/bin/bash

RES=$(curl --request GET \
  --url https://api.cloudflare.com/client/v4/ips \
  --header 'Authorization: Bearer undefined' \
  --header 'Content-Type: application/json' )
STA=$(echo $RES | jq .success)
if [ $STA == true ]; then
    IPV4=$(echo $RES | jq -r .result.ipv4_cidrs.[])
    IPV6=$(echo $RES | jq -r .result.ipv6_cidrs.[])
    IP="$IPV4 $IPV6"

    echo "deny all;" > allow-address
    for ip in $IP
    do
    echo "$ip;" >> allow-address
    done
fi
