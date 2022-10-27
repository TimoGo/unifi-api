#!/bin/bash
set -u

# purpose: 
# create new json with important data of all unifi devices,
# completed with DNS names.

API="./unifi-api.sh"

$API /stat/device device.json


# extract important fields and add dns (first) with content of .ip
cat device.json | jq '.data[]| {model,ip,mac,"dns":.ip}'  >device_extrakt.json
#exit 1


# fill arrays a_ip and a_dns with content
# use dig for each ip to look up each ip.
a_ip=( )
a_dns=( )
for ip in $( cat device_extrakt.json|jq -r '.ip'  )
 do 
  a_ip=("${a_ip[@]}" $ip)
  dns=$(dig +short -x $ip)
  test -z $dns && dns="undef."
  a_dns=("${a_dns[@]}" $dns)
done

# for debugging:
#  echo a_ip ${a_ip[*]}
#  echo a_dns ${a_dns[*]}

tmpfile=$(mktemp)

 
# replace ip with dns content in file device_extrakt.json
# jq and bash arrays: https://unix.stackexchange.com/questions/666033/how-to-search-and-replace-multiple-values-in-an-array-using-jq
for i in "${!a_ip[@]}"; do
    ip=${a_ip[i]}
    dns=${a_dns[i]}

    jq --arg ip "$ip" --arg dns "$dns" '( select(.dns == $ip) ).dns|= $dns ' device_extrakt.json >"$tmpfile"
    mv -- "$tmpfile" device_extrakt.json
done

