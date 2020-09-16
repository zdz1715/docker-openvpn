#!/bin/bash

# Convert 1.2.3.4/24 -> 255.255.255.0
cidr2mask()
{
    local i
    local subnetmask=""
    local cidr=${1#*/}
    local full_octets=$((cidr/8))
    local partial_octet=$((cidr%8))

    for ((i=0;i<4;i+=1)); do
        if [ $i -lt $full_octets ]; then
            subnetmask+=255
        elif [ $i -eq $full_octets ]; then
            subnetmask+=$((256 - 2**(8-partial_octet)))
        else
            subnetmask+=0
        fi
        [ $i -lt 3 ] && subnetmask+=.
    done
    echo $subnetmask
}

date_format() {
  time=$(date -d "$1" +"%Y-%m-%d %H:%M:%S")
  echo "$time"
  return 0
}

step()
{
  echo "# ========================================================= #"
  echo "# $1 "
  echo "# ========================================================= #"
}

# Used often enough to justify a function
get_route() {
    echo "${1%/*}" "$(cidr2mask $1)"
}

ERROR() {
  echo "[$(date +%H:%M:%S)] [ERROR] $*"
}

SUCCESS() {
  echo "[$(date +%H:%M:%S)] [SUCCESS] $*"
}

WARNING() {
   echo "[$(date +%H:%M:%S)] [WARNING] $*"
}

INFO() {
  echo "[$(date +%H:%M:%S)] [INFO] $*"
}

step_exec() {
    echo -e "[$(date +%H:%M:%S)] [执行命令] $*"
    "$@" 2>&1
    return "${PIPESTATUS[0]}"
}

check_ip() {
  if [[ ! "$1" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]];then
        ERROR "$2" >&2 && exit 1
  fi

  VALID_CHECK=$(echo "$1"|awk -F. '$1<=255&&$2<=255&&$3<=255&&$4<=255{print "yes"}')
  if [[ ${VALID_CHECK:-no} != "yes" ]]; then
        ERROR "$2" >&2 && exit 1
  fi
  return 0
}