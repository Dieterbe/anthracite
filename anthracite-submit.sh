#!/bin/bash
prog="$(basename $0)"

type=manual_$USER
server=$HOSTNAME
anthracite_host=localhost
anthracite_port=2005
date="$(date +%s)"
msg=

function die_error () {
    echo "$1" >&2
    exit 2
}

function usage () {
cat << EOF
usage: $0 options <msg>

Submit a message to anthracite
date=$date [$(date -d "@$date")]
type=$type
description="server=$server <msg>"

OPTIONS:
   -h          Show this message
   -H          anthracite host (default: $anthracite_host)
   -p          anthracite port (default: $anthracite_port)
   -d <datestr> use date described by <datestr> (date -d '<datestr>')
   -s <msg>    submit message
   
EOF
}

function submit () {
    local msg=$1
    [ -n "$msg" ] || die_error "message must be non-zero"
    msg="$date $type server=$server $1"
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
        die_error failed
    fi
}

action=
while getopts ":hH:p:s:d:" opt; do
    case $opt in
        h) action=usage
            ;;
        H) anthracite_host=$OPTARG
            ;;
        p) anthracite_port=$OPTARG
            ;;
        s) action=submit
           msg="$OPTARG"
            ;;
        d) date=$(date -d "$OPTARG" +%s) || die_error "could not run date -d $OPTARG to get a unix timestamp from your date"
            ;;
        ?) echo "Invalid option: -$OPTARG" >&2; usage >&2; exit 1;;
    esac
done
if [ -z "$action" ]; then
    echo 'nothing to do. bye.'
elif [ "$action" == usage ]; then
    usage
elif [ "$action" == submit ]; then
    submit "$msg"
fi
