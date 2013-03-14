## Anthracite event manager ##

* what: track and manage all changes and events that can have a business and/or operational impact.
* why: to increase operational visibility and collaboration

some use cases:

* changelog for troubleshooting and keeping people informed
* enriching monitoring dashboards with markers and annotation text
* aiding with visual and numerical analysis of events that affect performance (MTTD, MTTR, etc)

## Design goals ##

* do one thing and do it well.  aim for simplicity, flexibility and integration.
* deliver events in various formats and support querying for tags and text (full text search)
* support arbitrary tags, allow events with multiple lines, even rich text and hyperlinks.


## Components ##

* anthracite-receiver.py is the TCP receiver (will be revised/deprecated with the advent of multi-line events with tags)
* anthracite-web.py is the web app
* anthracite-submit.sh to interactively compose and submit events from the CLI.
* an sqlite database is automatically created, it suffices.


## Methods of submitting events ##

* TCP receiver on port 2005 (for one line events) in `<unix timestamp> <type> <description>` format
* HTTP POST reicever in the web app (use curl, see source of anthracite-submit.sh)
* manually, in the web interface
* manually, with a CLI script


## Integration ##

* [Timeserieswidget](https://github.com/Dieterbe/timeserieswidget) shows graphite graphs with anthracite's events
* The [Graph-Explorer graphite dashboard](https://github.com/Dieterbe/graph-explorer) uses that.
* At Vimeo we submit deploy events using curl


## Dependencies ##

* python2
* python2-pysqlite
* twisted (only needed for the TCP receiver)


## Installation ##

should be super easy...

* install dependencies
* clone repo
* there is no third step. you're ready.


## About "relevant events" ##

I recommend you submit any event that **has** or **might have** a **relevant** effect on:
* your application behavior
* monitoring itself (for example you fixed a bug in metrics reporting. it shouldn't look like the app behavior changed)
* the business (press coverage, viral videos, etc), because this also affects your app usage and metrics.

## Formats and conventions (DEPRECATED) ##

The TCP receiver listens for lines in this format:

    <unix timestamp> <type> <description>

Type must be a non-empty string not containing whitespace; description must be a non-empty string.
I have some suggestions and recommendations, which I'll demonstrate through fictive examples:
(but note that there's room for improvement, see the section below)

    # a deploy_* type for each project
    <ts> deploy_vimeo.com deploy e8e5e4 initiated by Nicolas -- github.com/Vimeo/main/compare/foobar..e8e5e4
    <ts> puppet all nodes of class web_cluster_1: modified apache.conf; restart service apache
    <ts> incident_sev2_start mysql2 crashed, site degraded
    <ts> incident_sev2_resolved replaced db server
    <ts> incident hurricane Sandy, systems unaffected but power outages among users, expect lower site usage
    <ts> backup backup from database slave vimeomysql22
    # in those cases of manual production changes, try to not forget adding your event
    <ts> manual_dieter i have to try this firewall thing on the LB

Note that `<description>` can have whitespace.  It's trivial to work with tags and give your events
more structure.  Note that you can mix with text, for example to include more arbitrary keywords like so:

    <ts> deploy_vimeo.com commit_old=foobar commit_new=e8e5e4 author=Nicolas memcache fixes.. should lower network traffic

## FAQ (DEPRECATED) ##

* What's up with the incident severity levels?  
Because there are so many unique and often subtle pieces of information pertaining to each individual incident, it's often hard to map an incident to
a simple severity level or keyword.
When displaying events as popups on graphs I think no severity levels are needed, the graphs and event descriptions are much more clear than any
severity level could convey.  
However, I do think these levels are very useful for reporting and numerical analysis.  
On slide 53 of [the metametrics slidedeck](http://www.slideshare.net/jallspaw/ops-metametrics-the-currency-you-pay-for-change) Allspaw
mentions severity levels, which can be paraphrased in terms of service degradation for the end user:
1 (full), 2 (major), 3 (minor), 4 (no)  
I would like to extend this notion into the opposite spectrum, and have the same levels but on the positive scale,
so that they represent positive incidents (like viral videos, press mentions, ...) as opposed to problematic ones (outage).
I just need to think of good nomenclature.  
<!--- (score, gain, boom) -->
Also, speaking of incident analysis, I want a way to differentiate between incidents that are self-induced and those are not,
in addition to (presumably) good and bad.

* no support for daemonizing and/or making sure only one instance runs?  
use a proper initsystem that can take care of this (like upstart, systemd or anything that has start-stop-daemon)

* why not just show git commit logs on my monitoring dashboard, isn't this extra work?  
commits might not be deployed straight away, and multiple are often deployed in 1 go. the info should be concise and contain everything you need.
And then there are those events that have nothing to do with commits.

* why the explicit timestamp, why not get current time when message is accepted?  
some events are reported after the fact, due to their nature or due to temp. connectivity issues.


## TODO ##

* plugins for puppet, chef to automatically submit their relevant events
* avoid adding the exact same event twice
* make web UI table use colors to denote outages according to their severity
* auto-update events on web interface to make semi-realtime
* on graphs in dashboards, show timeframs from start to end, and start to "cause found", to "resolved" etc.
* actually provide features to do statistics on events and analysis such as TTD, TTR, with colors for severity levels etc




