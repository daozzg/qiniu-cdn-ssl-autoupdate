#!/usr/bin/env bash
acme="/root/.acme.sh/acme.sh"

if [[ "$SSLDOMAIN" == "" ]] ;then
    echo "please set env: SSLDOMAIN"
    exit 1
fi
if [[ "$ACCESS_KEY" == "" ]] ;then
    echo "please set env: ACCESS_KEY"
    exit 1
fi
if [[ "$SECRET_KEY" == "" ]];then
    echo "please set env: SECRET_KEY"
    exit 1
fi
service cron start

mkdir -p /ssl/${SSLDOMAIN}/
touch /var/log/acme.sh.log
$acme   --issue  -d ${SSLDOMAIN} -d *.${SSLDOMAIN}  --dns dns_dp
$acme  --installcert  -d *.${SSLDOMAIN}    \
        --keypath   /ssl/${SSLDOMAIN}/privkey.pem \
        --fullchainpath /ssl/${SSLDOMAIN}/fullchain.pem \
        --reloadcmd  "python /app/update_cdn_sslcert.py" --debug --log  "/var/log/acme.sh.log"


tail -f /var/log/acme.sh.log
