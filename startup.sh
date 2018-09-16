#!/usr/bin/env bash
acme="/root/.acme.sh/acme.sh"

if [[ "$DOMAIN" == "" ]] ;then
    echo "please set env: DOMAIN"
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

mkdir -p /ssl/${DOMAIN}/
touch /var/log/acme.sh.log
if [[ "${DP_Id}" != "" ]];then
$acme   --issue   --dns dns_dp -d ${DOMAIN}
elif [[ "${DP_Id}" != "" ]];then
$acme   --issue   --dns dns_ali -d ${DOMAIN}
else
$acme   --issue   --dns ${DNS_API} -d ${DOMAIN}
fi
$acme  --installcert  -d ${DOMAIN}    \
        --key-file   /ssl/${DOMAIN}/privkey.pem \
        --fullchain-file /ssl/${DOMAIN}/fullchain.pem \
        --reloadcmd  "python /app/update_cdn_sslcert.py" --debug --log  "/var/log/acme.sh.log"


tail -f /var/log/acme.sh.log
