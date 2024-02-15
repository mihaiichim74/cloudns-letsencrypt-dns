#!/bin/bash

auth=$(cat /root/.cloudns-auth)
user=$(echo $auth | cut -d '|' -f 1)
pass=$(echo $auth | cut -d '|' -f 2)

url="https://api.cloudns.net/dns/list-zones.json?auth-id=${user}&auth-password=${pass}&page=1&rows-per-page=100"
zones=$(curl $url | jq -r '.[] | .name' 2>/dev/null)

for zone in $zones
do
  domainname=$( echo $zone | rev | cut -d'.' -f 1,2 | rev)
  certdir=/etc/letsencrypt/live/$zone
  if [ -d $certdir ] ; then
    echo -n "."
  else
    certbot certonly --manual \
      --preferred-challenges=dns \
      --manual-auth-hook /usr/local/bin/certbot-auth.sh \
      --manual-cleanup-hook /usr/local/bin/certbot-cleanup.sh \
      -d $zone -d *.$zone
  fi
done
