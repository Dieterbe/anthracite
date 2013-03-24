#!/bin/bash
dir=$(dirname "$0")
echo "mimicing some anthracite 'deploys' based on random commits in this project's history..."
gh_args="-c $dir -u https://github.com -a Dieterbe -P anthracite"
cd $dir
port=$(grep '^listen_port' config.py | cut -d' ' -f3)
./anthracite-submit-github.sh $gh_args -d '2013-03-14 22:57:22 -0400' -o 80b9f47 -n 2131ae2 -t 'deploy app=anthracite test'
# normally, you would add the outage start tags after the fact, of course. after detecting the outage..
./anthracite-submit-github.sh $gh_args -d '2013-03-14 23:35:00 -0400' -o 9e00473 -n 0b5d20e -t 'deploy app=anthracite test outage=test_outage start'
curl -s -S -F "event_timestamp=$(date -d '2013-03-14 23:41:16 -0400' +%s)" -F "event_tags=outage=test_outage detected" -F "event_desc=the issue seems to be foo bar." http://localhost:$port/events/add/script
./anthracite-submit-github.sh $gh_args -d '2013-03-14 23:55:55 -0400' -o 0b5d20e -n 161f24 -t 'deploy app=anthracite test outage=test_outage resolved'
curl -s -S -F "event_timestamp=$(date -d '2013-03-20 20:41:16 -0400' +%s)" -F "event_tags=dieter manual server=host123" -F "event_desc=made some space on /var." http://localhost:$port/events/add/script
