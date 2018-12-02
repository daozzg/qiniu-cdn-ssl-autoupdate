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
if [[ "${DP_Id}" != "" ]];then
$acme   --issue   --dns dns_dp  -d ${SSLDOMAIN} -d *.${SSLDOMAIN}
elif [[ "${Ali_Key}" != "" ]];then
$acme   --issue   --dns dns_ali  -d ${SSLDOMAIN} -d *.${SSLDOMAIN}
else
$acme   --issue   --dns ${DNS_API}  -d ${SSLDOMAIN} -d *.${SSLDOMAIN}
fi
$acme  --installcert  -d ${SSLDOMAIN}    \
        --key-file   /ssl/${SSLDOMAIN}/privkey.pem \
        --fullchain-file /ssl/${SSLDOMAIN}/fullchain.pem \
        --reloadcmd  "python /app/update_cdn_sslcert.py" --debug --log  "/var/log/acme.sh.log"


tail -f /var/log/acme.sh.log