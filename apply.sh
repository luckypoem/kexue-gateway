#!/usr/bin/env bash

if ! command -v ansible-playbook >/dev/null 2>&1; then
    echo "Please make sure Ansible is installed on your local machine."
    exit 1
fi

BASENAME=$(basename $0)
INVENTORY=inventory

if [[ $1 == "" ]]; then
    echo "Usage: $BASENAME <variable_file>"
    exit 2
fi

if [ ! -f "$INVENTORY" ]; then
    while [ "$IP" == "" ]; do
        printf "Please input your NanoPi IP: "
        read IP
    done;
    echo "$IP" > "$INVENTORY"
fi

ansible-playbook -vvv --ask-pass -i "$INVENTORY" -e "@$1" playbook.yml
