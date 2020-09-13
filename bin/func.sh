#!/bin/bash

# Convert 1.2.3.4/24 -> 255.255.255.0
cidr2mask()
{
    local i
    local subnetmask=""
    local cidr=${1#*/}
    local full_octets=$(($cidr/8))
    local partial_octet=$(($cidr%8))

    for ((i=0;i<4;i+=1)); do
        if [ $i -lt $full_octets ]; then
            subnetmask+=255
        elif [ $i -eq $full_octets ]; then
            subnetmask+=$((256 - 2**(8-$partial_octet)))
        else
            subnetmask+=0
        fi
        [ $i -lt 3 ] && subnetmask+=.
    done
    echo $subnetmask
}

# Used often enough to justify a function
get_route() {
    echo ${1%/*} $(cidr2mask $1)
}

ERROR() {
  echo -e '\u001b[91m'\[`date +%H:%M:%S`\] \[ERROR\] $@
}

SUCCESS() {
  echo -e '\u001b[92m'\[`date +%H:%M:%S`\] \[SUCCESS\] $@
}

WARNING() {
  echo -e '\u001b[33m'\[`date +%H:%M:%S`\] \[WARNING\] $@
}

INFO() {
  echo -e '\u001b[1m'\[`date +%H:%M:%S`\] \[INFO\] $@
}

step_exec() {
    echo -e "\033[1;36m[`date +%H:%M:%S`] [执行命令] $*"
    "$@" 2>&1
    return "${PIPESTATUS[0]}"
}
