#!/bin/bash
set -u

API="./unifi-api.sh"

$API /stat/sysinfo sysinfo.json
version=$(cat sysinfo.json | jq -r '.data[].version')
echo Version $version

$API /stat/health stat_health.json
wlan_subsystem=$(cat stat_health.json | jq -r '.data[]|select (.subsystem=="wlan")|.status')
lan_subsystem=$(cat stat_health.json | jq -r '.data[]|select (.subsystem=="lan")|.status')
wan_subsystem=$(cat stat_health.json | jq -r '.data[]|select (.subsystem=="wan")|.status')
echo "Subsystem WLAN: $wlan_subsystem"
echo "Subsystem LAN: $lan_subsystem"
echo "Subsystem WAN: $wan_subsystem"


$API /stat/device-basic stat_device-basic.json

readarray -t lines < <( cat stat_device-basic.json |jq -r '.data[]|(.name+"%%%"+.type+"%%%"+.model+"%%%"+.mac)'  )

anzahl=${#lines[@]}
for i in $(seq 0 $(((anzahl-1))) )
do
 line=${lines[$i]}
 #echo ${line}| cat -A
 u_name=$(echo $line|awk -F"%%%" '{print $1}')
 u_type=$(echo $line|awk -F"%%%" '{print $2}')
 u_model=$(echo $line|awk -F"%%%" '{print $3}')
 u_mac=$(echo $line|awk -F"%%%" '{print $4}')
 # for debug:
 #  echo -e "name $u_name\ntype $u_type\nmodel $u_model\nmac $u_mac\n---\n"
 printf "%17.17s  %10.10s  %10.10s  %14.14s\n" "$u_name" "$u_type" "$u_model"  "$u_mac"
done

