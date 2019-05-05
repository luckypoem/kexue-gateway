#!/bin/bash

set -euo pipefail

CONN=$(nmcli --get-values GENERAL.CONNECTION dev show eth0)
METHOD=$(nmcli --get-values ipv4.method conn show "$CONN")

if [[ $METHOD == "manual" ]]; then
    echo "OK"
    exit 0
fi

CIDR=$(ip -f inet addr show dev eth0 | grep -Po 'inet \K[\d./]+')
GATEWAY=$(ip -f inet route show default dev eth0 | grep -Po 'via \K[\d.]+')
DNS="114.114.114.114"

sudo nmcli connection modify "$CONN" \
    connection.autoconnect yes \
    ipv4.method manual \
    ipv4.address "$CIDR" \
    ipv4.gateway "$GATEWAY" \
    ipv4.dns "$DNS"

echo "CHANGED"
