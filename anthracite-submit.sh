#!/bin/bash
prog="$(basename $0)"

anthracite_host=localhost
anthracite_port=8081
tmp_file_tpl=/tmp/anthracite-submit-${USER}

function die_error () {
    echo "$1" >&2
    if [ -n "$template_file" -a -f "$template_file" ]; then
        echo "template file: $template_file" >&2
    fi
    exit 2
}

template () {
cat << EOF
# date can be any value accepted by 'date -d'
# no strict format.  anything is allowed (tags, unstructured text, ..)
# if the event (i.e. this file) is empty, submission will be aborted.
# everything upto the line below will be ignored
# please type your event message below. what happened?
date=$(date)
user=$USER
type=manual
source_host=$HOSTNAME
source=$prog
EOF
}

template_get_content () {
    sed '1,/# please type your event message below/d'
}

template_filter_date () {
    sed -n 's#^date=##p'
}

function usage () {
cat << EOF
== USAGE ==
invocation: $0 options

Gives you an editable message and submits it to an anthracite server, if you want

OPTIONS:
   -h          Show this message
   -H          anthracite host (default: $anthracite_host)
   -p          anthracite port (default: $anthracite_port)
   -s          submit message
   -t <file>   start from template <file>

== MESSAGE TEMPLATE: ==
EOF
template
}

function submit () {
    [ -n "$EDITOR" ] || die_error "\$EDITOR must be set (protip: export EDITOR=vim in ~/.bashrc)"
    which $EDITOR > /dev/null || die_error "can't find your editor, $EDITOR"
    templates=($(shopt -s nullglob; echo $tmp_file_tpl*))
    if [ ${#templates[@]} -gt 1 ]; then
        die_error "More than 1 existing template found: ${templates[*]}.  Please clean them up"
    elif [ ${#templates[@]} -eq 1]; then
        template_file=${templates[0]}
    else
        template_file=$(mktemp /tmp/anthracite-submit.XXXXX) || die_error "Couldn't make tmpfile"
        template > $template_file  || die_error "Couldn't write to tmpfile $tmp_file"
    fi
    $EDITOR $template_file || die_error "Editor exited $?. aborting..."
    [ -n "$(cat $template_file | template_get_content)" ] || { rm -f "$template_file" ; die_error "empty file. aborting.." }
    submission_file=$(mktemp /tmp/anthracite-submit.XXXXX) || die_error "Couldn't make tmpfile"
    cat $template_file | template_get_content > $submission_file || die_error "Couldn't process template contents"
    date=$(cat $submission_file | template_filter_date) || die_error "Couldn't find a date in the template. aborting.."
    timestamp=$(date +%s -d "$date") || die_error "Couldn't parse date from $date. aborting.."

    echo "submitting to $anthracite_host:$anthracite_port:"
    echo curl -F "event_time=$timestamp;event_type=manual;event_desc=@$submission_file" http://$anthracite_host:$anthracite_port
    if curl -F 'event_time=$timestamp' - F 'event_type=manual' -F 'event_desc=<$submission_file' http://$anthracite_host:$anthracite_port/add | grep -q 'The new event was added'; then
        echo "submitted!"
        exit
    else
        die_error "failed"
    fi
}

action=
while getopts ":hH:p:st:" opt; do
    case $opt in
        h) action=usage
            ;;
        H) anthracite_host=$OPTARG
            ;;
        p) anthracite_port=$OPTARG
            ;;
        s) action=submit
            ;;
        t) template_file=$OPTARG
           [ -f "$template_file" ] || die_error "Can't read template file $template_file"
            ;;
        ?) echo "Invalid option: -$OPTARG" >&2; usage >&2; exit 1;;
    esac
done
if [ -z "$action" ]; then
    echo 'nothing to do. bye.'
elif [ "$action" == usage ]; then
    usage
elif [ "$action" == submit ]; then
    submit
fi
