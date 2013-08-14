#!/bin/bash
prog="$(basename $0)"

anthracite_host=localhost
anthracite_port=8081
template_file_pattern=/tmp/anthracite-template-${USER}
event_desc_file_pattern=/tmp/anthracite-event_desc-${USER}

function die_error () {
    echo -e "$1" >&2
    if [ -n "$template_file" -a -f "$template_file" ]; then
        echo "template file: $template_file" >&2
    fi
    exit 2
}

print_template () {
cat << EOF
# date can be any value accepted by 'date -d'
# no strict format.  any text (html, ..) is allowed.
# use the last 2 lines for date and tags.
# if the event (i.e. this file) is empty, submission will be aborted.
# everything upto the line below will be ignored
# please type your message below. what happened?

DATE:$(date)
TAGS:source_host=$HOSTNAME source=$prog manual $USER
EOF
}

template_get_content () {
    local template_file=$1
    event_desc_file=$(mktemp $event_desc_file_pattern.XXXXX) || die_error "Couldn't make tmp event_desc_file"
    sed '1,/# please type your message below/d' $template_file | egrep -v '^(DATE|TAGS):' | cat - > $event_desc_file || die_error "Couldn't write to $event_desc_file"
    date=$(sed -n 's#^DATE:##p' $template_file)
    tags=$(sed -n 's#^TAGS:##p' $template_file)
    # sanity checks..
    # by default, it'll just contain \n, i.e. size 1B
    if [ $(stat --printf="%s" $event_desc_file) -lt 3 ]; then
        rm -f "$template_file"
        die_error "empty file (or practically empty). aborting.."
    fi
    [ -n "$date" ] || die_error "Couldn't find a date in the template. aborting.."
    [ -n "$tags" ] || die_error "Couldn't find tags in the template. aborting.."
    event_tags=$tags
    event_timestamp=$(date +%s -d "$date") || die_error "Couldn't parse date from $date. aborting.."
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

== MESSAGE TEMPLATE: ==
EOF
print_template
}

function submit () {
    [ -n "$EDITOR" ] || die_error "\$EDITOR must be set (protip: export EDITOR=vim in ~/.bashrc; source ~/.bashrc;)"
    which $EDITOR > /dev/null || die_error "can't find your editor, $EDITOR"
    templates=($(shopt -s nullglob; echo $template_file_pattern*))
    if [ ${#templates[@]} -gt 1 ]; then
        die_error "More than 1 existing template found:\n${templates[*]}\nPlease clean them up\nYou can leave one which we'll reuse"
    elif [ ${#templates[@]} -eq 1 ]; then
        template_file=${templates[0]}
    else
        template_file=$(mktemp $template_file_pattern.XXXXX) || die_error "Couldn't make tmpfile"
        print_template > $template_file || die_error "Couldn't write to tmpfile $tmp_file"
    fi
    $EDITOR $template_file || die_error "Editor exited $?. aborting..."
    template_get_content $template_file # this function will die if anything is wrong

    echo "submitting to $anthracite_host:$anthracite_port:"
    output=$(curl -s -S -F "event_timestamp=$event_timestamp" -F "event_tags=$event_tags" -F "event_desc=<$event_desc_file" http://$anthracite_host:$anthracite_port/events/add/script)
    if grep -q 'ok event_id=' <<< "$output"; then
        event_id=$(sed 's/^ok event_id=//' <<< "$output")
        echo "ok http://$anthracite_host:$anthracite_port/events/view/$event_id"
        rm $template_file || die_error "Could not delete template file $template_file"
        rm $event_desc_file || die_error "Could not delete event_desc file $event_desc_file"
        exit
    else
        rm $event_desc_file || die_error "Could not delete event_desc file $event_desc_file\nsending failed:\n$output"
        die_error "$output"
    fi
}

# if script is sourced, return. we wouldn't want to execute anything
if [ "$0" == 'bash' ]; then
    return
fi

action=
while getopts ":hH:p:s" opt; do
    case $opt in
        h) action=usage
            ;;
        H) anthracite_host=$OPTARG
            ;;
        p) anthracite_port=$OPTARG
            ;;
        s) action=submit
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
