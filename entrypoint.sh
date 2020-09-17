#!/bin/bash

set -e

# 加载函数
. /usr/local/bin/func.sh

# 启动openvpn
if [[ -z $* ]];then
  step_exec vpn-cli check
  # shellcheck source=src/util.sh
  [[ -r "$OVPN_ENV" ]] && . "$OVPN_ENV"

  [[ ! -d /dev/net ]] && mkdir -p /dev/net
  [[ ! -c /dev/net/tun ]] && mknod /dev/net/tun c 10 200

  step_exec openvpn --status-version 2 --suppress-timestamps --config "$VPN_FILE_SERVER"
fi

exec "$@"




