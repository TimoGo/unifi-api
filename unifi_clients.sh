#!/bin/bash
set -u

# purpose: 
# use python tool jtbl (json tables) to output a sorted ascii-table client

# jtbl: https://github.com/kellyjonbrazil/jtbl

API="./unifi-api.sh"

$API /stat/sta sta.json

cat sta.json| jq '.data|=sort_by(.is_wired,.uptime)' |  jq '.data|.[]' | jq -c '{ is_wired,hostname, ip, uptime,mac, oui, first_seen, last_seen, uptime, tx_bytes, rx_bytes  }'|jtbl -t --cols=350 -m


