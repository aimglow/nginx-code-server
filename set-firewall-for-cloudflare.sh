#!/bin/bash

RES=$(curl --request GET \
  --url https://api.cloudflare.com/client/v4/ips \
  --header 'Authorization: Bearer undefined' \
  --header 'Content-Type: application/json' )
STA=$(echo $RES | jq .success)
if [ $STA == true ]; then
    jq --version > /dev/null
    if [ $? -eq 0 ]; then

        # 既存のルール削除
        EXIST_RULE=$(firewall-cmd --list-all | grep -E 'prefix="cloudflare"' | sed 's/^.*rule/rule/')
        IFS=$'\n'
        for RULE in $EXIST_RULE
        do
            firewall-cmd --permanent --zone=public --remove-rich-rule='"'"$RULE"'"'
        done
        firewall-cmd --reload

        # 新しいIPv4ルール設定
        IPV4=$(echo $RES | jq -r .result.ipv4_cidrs.[])
        for ip in $IPV4
        do
            RULE="rule family=ipv4 source address=$ip port port=https protocol=tcp log prefix=cloudflare accept"
            firewall-cmd --permanent --zone=public --add-rich-rule='"'"$RULE"'"'
        done

        # 新しいIPv6ルール設定
        IPV6=$(echo $RES | jq -r .result.ipv6_cidrs.[])
        for ip in $IPV6
        do
            RULE="rule family=ipv6 source address=$ip port port=https protocol=tcp log prefix=cloudflare accept"
            firewall-cmd --permanent --zone=public --add-rich-rule='"'"$RULE"'"'
        done
        firewall-cmd --reload
    fi
fi
