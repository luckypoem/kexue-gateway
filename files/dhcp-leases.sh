#!/bin/bash

set -euo pipefail

TITLE="[Expires]	[MAC Address]	[IP]	[Hostname]	[Client ID]"

CONTENT=$(while read -r row; do

  row=$(echo "$row" | tr ' ' '\t')
  expires=$(date -d @$(echo "$row" | cut -f1) +"%Y-%m-%d %H:%M:%S")
  columns=$(echo "$row" | cut -f2-)

  printf "%s\t%s\n" "$expires" "$columns"

done < /var/lib/misc/dnsmasq.leases)

CONTENT=$(echo -e "$TITLE\n$CONTENT" | column -ts $'\t')
LENGTH=$(echo "$CONTENT" | wc -L)
DELIMITER=$(printf %${LENGTH}s | tr ' ' '-')

echo "$CONTENT" | sed '2i\'$DELIMITER
