#!/bin/bash

[[ $DEBUG ]] && set -x 

if [ "${1:0:1}" = '-' ]; then
	set -- mongod "$@"
fi

# allow the container to be started with `--user`
if [ "$1" = 'mongod' -a "$(id -u)" = '0' ]; then
	chown -R mongodb /data/configdb /data/db
	exec gosu mongodb "$BASH_SOURCE" "$@"
fi

if [ "$1" = 'mongod' ]; then
	numa='numactl --interleave=all'
	if $numa true &> /dev/null; then
		set -- $numa "$@"
	fi
fi


[[ $DEBUG ]] && set -x 

sed -i -e "s/POD_IP/${POD_IP:-'0.0.0.0'}/g" \
       -e "s/HOSTNAME/${HOSTNAME}.${HOSTNAME%-*}.${TENANT_ID}.svc.cluster.local./g" /mongo.sql

sleep 10
CURRENT_POD_NUM=$(nslookup ${SERVICE_NAME} | grep Address | sed '1d' | awk '{print $2}' | wc -l)
[[ $DEBUG ]] && echo $(nslookup ${SERVICE_NAME})> ./logfile
if [[ $CURRENT_POD_NUM -gt 1 ]];then
    sed -i '$a\discovery.zen.ping.unicast.hosts' /mongo.sql
    ip=$(nslookup ${SERVICE_NAME} | grep Address | sed '1d' | awk '{print $2}')
    ips=$(echo $ip | tr ' ' ',')
    [[ $DEBUG ]] && echo ${ip} >> ./logfile
    sed -i "s/discovery.zen.ping.unicast.hosts*/discovery.zen.ping.unicast.hosts: [${ips}]/g" /mongo.sql
fi
    
[[ $PAUSE ]] && sleep $PAUSE
    
exec "$@"
