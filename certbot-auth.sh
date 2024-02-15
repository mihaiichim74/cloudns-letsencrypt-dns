#!/bin/bash

auth=$(cat /root/.cloudns-auth)
user=$(echo $auth | cut -d '|' -f 1)
pass=$(echo $auth | cut -d '|' -f 2)

domainname=$( echo $CERTBOT_DOMAIN )

curl -X "POST" "https://api.cloudns.net/dns/add-record.json" \
     -H 'Content-Type: application/json' \
     -d "{\"domain-name\": \"${domainname}\", \"auth-id\": \"${user}\", \"auth-password\": \"${pass}\", \"ttl\": 300, \"record-type\": \"TXT\", \"host\": \"_acme-challenge\", \"record\"
: \"${CERTBOT_VALIDATION}\" }"

sleep 60
