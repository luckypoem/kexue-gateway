#!/usr/bin/env bash

if ! command -v ansible-playbook >/dev/null 2>&1; then
    echo "Please make sure Ansible is installed on your local machine."
    exit 1
fi

BASENAME=$(basename $0)
INVENTORY=inventory

if [[ "$1" == "" ]]; then
    echo "Usage: $BASENAME <variable_file> [-|<options_to_ansible>]"
    exit 2
fi

if [[ ! -f "$INVENTORY" ]]; then
    while [[ "$IP" == "" ]]; do
        printf "Please input your NanoPi IP: "
        read IP
    done;
    echo "$IP" > "$INVENTORY"
fi

EXTRA_VARS=$1
shift

if [[ "$@" == "" ]]; then
    MORE_OPTIONS="-vvv --ask-pass"
elif [[ "$1" == "-" ]]; then
    MORE_OPTIONS=""
else
    MORE_OPTIONS="$@"
fi

ansible-playbook $MORE_OPTIONS -i "$INVENTORY" -e "@$EXTRA_VARS" playbook.yml
