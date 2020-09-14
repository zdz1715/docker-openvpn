#!/bin/bash
set -e

# 加载函数
. /usr/local/bin/func.sh

# 启动openvpn
if [[ -z $* ]];then
  step_exec vpn-cli check
  # shellcheck source=src/util.sh
  [[ -r "$OVPN_ENV" ]] && . "$OVPN_ENV"
  step_exec openvpn --status-version 2 --suppress-timestamps --config "$VPN_FILE_SERVER"
fi

step_exec "$@"




