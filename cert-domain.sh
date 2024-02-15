#!/bin/sh

if [ $# -eq 0 ]; then
    echo "No domain provided"
    exit 1
fi

certbot delete -n --cert-name $1

certbot certonly --manual \
    --preferred-challenges=dns \
    --manual-auth-hook /srv/share/bin/cloudns/certbot-auth.sh \
    --manual-cleanup-hook /srv/share/bin/cloudns/certbot-cleanup.sh \
    -d $1 -d *.$1
