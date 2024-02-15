#!/bin/bash

token=$(cat /root/.cloudns-token)
user=$(echo $token | cut -d '|' -f 1)
pass=$(echo $token | cut -d '|' -f 2)

domainname=$( echo $CERTBOT_DOMAIN )

url="https://api.cloudns.net/dns/records.json?auth-id=${user}&auth-password=${pass}&domain-name=${domainname}&type=TXT&host=_acme-challenge"
records=$(curl $url | jq -r '.[] | .id' 2>/dev/null)

for record_id in $records
do
    curl -X "POST" "https://api.cloudns.net/dns/delete-record.json" \
      -H 'Content-Type: application/json' \
      -d "{\"domain-name\": \"${domainname}\", \"auth-id\": \"${user}\", \"auth-password\": \"${pass}\", \"record-id\": \"${record_id}\"}"
done
