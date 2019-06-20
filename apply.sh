#!/usr/bin/env bash

ensure_dep() {
    if ! command -v "$1" &>/dev/null; then
        echo "Please make sure $2 is installed on your local machine."
        exit 1
    fi
}

preflight() {
    ensure_dep "ansible-playbook" "Ansible"
    ensure_dep "git-lfs" "Git LFS"
}

main() {
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
        ssh-copy-id "root@$IP"
        echo "$IP ansible_user=root" > "$INVENTORY"
    fi

    EXTRA_VARS=$1
    shift

    if [[ "$@" == "" ]]; then
        MORE_OPTIONS="-vv"
    elif [[ "$1" == "-" ]]; then
        MORE_OPTIONS=""
    else
        MORE_OPTIONS="$@"
    fi

    (
        export ANSIBLE_STDOUT_CALLBACK=debug
        ansible-playbook $MORE_OPTIONS -i "$INVENTORY" -e "@$EXTRA_VARS" playbook.yml
    )
}

preflight
main $@
