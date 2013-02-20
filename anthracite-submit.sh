#!/bin/bash
prog="$(basename $0)"

type=manual_$USER
server=$HOSTNAME
anthracite_host=localhost
anthracite_port=2005
msg=

function usage () {
cat << EOF
usage: $0 options <msg>

Submit a message to anthracite
with type=$type
description="server=$server <msg>"

OPTIONS:
   -h          Show this message
   -H          anthracite host (default: $anthracite_host)
   -p          anthracite port (default: $anthracite_port)
   -s <msg>    submit message
   
EOF
}

function submit () {
    msg="$(date +%s) $type server=$server $1"
    echo "submitting to $anthracite_host:$anthracite_port:"
    echo "$msg"
    # note:
    # netcat: netcat -c $anthracite_host $anthracite_port <<< "$msg"
    # on centos, both bash and netcat approach work
    # debian bash is compiled without support for /dev/tcp
    # debian netcat doesn't support this syntax; without -c it stays open, waiting
    if echo "$msg" > /dev/tcp/$anthracite_host/$anthracite_port; then
        echo ok
        exit 0
    else
        echo failed >&2
        exit 1
    fi
}

while getopts ":hH:p:s:" opt; do
    case $opt in
        h) usage && exit 
            ;;
        H) anthracite_host=$OPTARG
            ;;
        p) anthracite_port=$OPTARG
            ;;
        s) msg="$OPTARG"
            ;;
        ?) echo "Invalid option: -$OPTARG" >&2; usage >&2; exit 1;;
    esac
done
[ -n "$msg" ] && submit "$msg"
