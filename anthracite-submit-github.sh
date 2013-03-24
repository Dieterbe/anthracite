#!/bin/bash
prog="$(basename $0)"

anthracite_host=localhost
anthracite_port=8081
event_desc_file_pattern=/tmp/anthracite-submit-github-event-desc

function die_error () {
    echo -e "$1" >&2
    if [ -n "$template_file" -a -f "$template_file" ]; then
        echo "template file: $template_file" >&2
    fi
    exit 2
}

function usage () {
cat << EOF
== USAGE ==
invocation: $0 options

Generate anthracite message from a code checkout and revision spec and submit to anthracite

OPTIONS:
   -c <directory>       git project checkout dir
   -h                   Show this message
   -H <anthracite host> (default: $anthracite_host)
   -p <anthracite port> (default: $anthracite_port)
   -n <new commit spec>
   -o <old commit spec>
   -t <tags>            (e.g. 'deploy app=<foo> initiator=<person> env=prod')
   -u <github_url>
   -a <github_account>
   -P <github_project>
EOF
}
print_event_desc () {
    local spec="$commit_old..$commit_new"
    local base_uri=$github_url/$github_account/$github_project
    git_log=$(git log --pretty=format:"<li><a href='$base_uri/commit/%h'>%s</a>%n<br/>&nbsp;&nbsp;&nbsp;by %an on %ai</li>%n" $spec) || die_error "Could not get git log $spec"
    cat << EOF
<ul>
$git_log
</ul>
<a href='$base_uri/compare/$commit_old...$commit_new'>$github_account/$github_project/compare/$commit_old...$commit_new</a>
EOF
}

function submit () {
    event_desc_file=$(mktemp $event_desc_file_pattern.XXXXX) || die_error "Couldn't make tmp event_desc_file"
    cd "$checkout_dir" || die_error "could not cd into $checkout_dir"
    print_event_desc > $event_desc_file || die_error "could not write to event desc file $event_desc_file"
    output=$(curl -s -S -F "event_timestamp=$(date +%s)" -F "event_tags=$event_tags" -F "event_desc=<$event_desc_file" http://$anthracite_host:$anthracite_port/events/add/script)
    if grep -q 'The new event was added' <<< "$output"; then
        echo "$output"
        rm $event_desc_file || die_error "Could not delete event_desc file $event_desc_file"
        exit
    else
        rm $event_desc_file || die_error "Could not delete event_desc file $event_desc_file\nsending failed:\n$output"
        die_error "$output"
    fi
}
action=
while getopts "c:hH:p:n:o:t:u:a:P:" opt; do
    case $opt in
        c) checkout_dir=$OPTARG;;
        h) action=usage;;
        H) anthracite_host=$OPTARG;;
        p) anthracite_port=$OPTARG;;
        n) commit_new=$OPTARG;;
        o) commit_old=$OPTARG;;
        t) event_tags="$OPTARG";;
        u) github_url=$OPTARG;;
        a) github_account=$OPTARG;;
        P) github_project=$OPTARG;;
        ?) echo "Invalid option: -$OPTARG" >&2; usage >&2; exit 1;;
    esac
done
if [ "$action" == usage ]; then
    usage
else
    [ -n "$checkout_dir" -a -d "$checkout_dir" ] || die_error "set checkout_dir to an existing dir"
    [ -n "$commit_new" ] || die_error "set commit_new"
    [ -n "$commit_old" ] || die_error "set commit_old"
    [ -n "$github_url" ] || die_error "set github_url"
    [ -n "$github_account" ] || die_error "set github_account"
    [ -n "$github_project" ] || die_error "set github_project"
    submit
fi
