## Introduction ##

Graphite can show events such as [code deploys](http://codeascraft.etsy.com/2010/12/08/track-every-release/) and
[puppet changes](https://github.com/joemiller/puppet-graphite_event) as lines on your graph.
With the advent of new graphite dashboards and interfaces where we can have popups and annotations to show metadata for each event (by means of client-side rendering),
it's time we have a database to track all events along with categorization and text descriptions (which can include rich text and hyperlinks).
Graphite is meant for time series (metrics over time), Anthracite aims to be the companion for annotated events.  
More precisely, **Anthracite aims to be a database of "relevant events"** (see further down), **for the purpose of enriching monitoring dashboards,
as well as allowing visual and numerical analysis of events that have a business impact**  
It has a TCP receiver, a database (sqlite3), a HTTP interface to deliver event data in many formats and a simple web frontend for humans.

design goals:
* do one thing and do it well.  aim for integration.
* take inspiration from graphite:
 * simple TCP protocol
 * automatically create new event types as they are used
 * run on port 2005 by default (carbon is 2003,2004)
 * deliver events in various formats (html, raw, json, sqlite,...)
 * stay out of the way
* super easy to install and run: install dependencies, clone repo. <i>the app is ready to run</i>

## Dependencies ##

* python2
* python2-pysqlite
* twisted

## About "relevant events" ##

I recommend you submit any event that **has** or **might have** a **relevant** effect on:
* your application behavior
* monitoring itself (for example you fixed a bug in metrics reporting. it shouldn't look like the app behavior changed)
* the business (press coverage, viral videos, etc), because this also affects your app usage and metrics.

## Formats and conventions ##

The TCP receiver listens for lines in this format:

    <unix timestamp> <type> <description>

There are no restrictions for type and description, other than that they must be non-empty strings.
That said, I do have some suggestions and recommendations, which I'll demonstrate through fictive examples:

    # a deploy_* type for each project
    <ts> deploy_vimeo.com "deploy e8e5e4 initiated by Nicolas -- github.com/Vimeo/main/compare/foobar..e8e5e4"
    <ts> puppet "all nodes of class web_cluster_1: modified apache.conf; restart service apache"
    <ts> incident_sev2_start "mysql2 crashed, site degraded"
    <ts> incident_sev2_resolved "replaced db server"
    <ts> incident "hurricane Sandy, systems unaffected but power outages among users, expect lower site usage"
    # in those exceptional cases of manual production changes, try to not forget adding your event
    <ts> manual_dieter "i have to try this firewall thing on the LB"

## FAQ ##

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

* plugins for puppet, chef to automatically submit their stuff
* better web UI add form, with type selector, date picker
* avoid adding the exact same event twice
* make web UI table use colors to denote outages according to their severity
* time line widget, http://www.simile-widgets.org/timeline/
* auto-update events on web interface to make semi-realtime
