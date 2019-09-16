#!/usr/bin/env bash

set -euo pipefail

download_file() {
    wget -O "dist/$1" "$2"
}

mkdir -p dist/ &>/dev/null
download_file "v2ray-linux-64.zip" "https://github.com/v2ray/v2ray-core/releases/download/v4.18.0/v2ray-linux-64.zip"
