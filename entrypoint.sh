#!/bin/bash
set -e


# shellcheck source=src/util.sh
[ -r "$OVPN_ENV" ] && . "$OVPN_ENV"

# 启动openvpn
if [ ! -z "$*" ];then
  exec "$@"
fi


if [ ! -r "$OVPN_SERVER_CONF" ]; then
    echo "[ERROR]请先执行命令:ovpn_init" >&2
    exit 1
fi


echo "openvpn --status-version 2 --suppress-timestamps --config ${OVPN_SERVER_CONF}"
echo ""
openvpn --status-version 2 --suppress-timestamps --config "$OVPN_SERVER_CONF"


