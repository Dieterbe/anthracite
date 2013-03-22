#!/usr/bin/env python2
from bottle import route, run, debug, template, request, static_file, error, response
from backend import Backend, Event


@route('/')
def main():
    return page(body=template('tpl/index'))


@route('/events')
def table():
    return page(body=template('tpl/events_table', rows=backend.get_events()))


@route('/events/timeline')
def timeline():
    rows = backend.get_events()
    (range_low, range_high) = backend.get_events_range()

    return page(body=template('tpl/events_timeline', rows=rows, range_low=range_low, range_high=range_high))


@route('/events/raw')
def raw():
    response.content_type = 'text/plain'
    return "\n".join(','.join(map(str, record)) for record in backend.get_events())


@route('/events/json')
def events_json():
    return {"events": [{"id": record[0], "time": record[1], "desc": str(record[2])} for record in backend.get_events()]}


@route('/events/jsonp')
def events_jsonp():
    response.content_type = 'application/x-javascript'
    jsonp = request.query.jsonp or 'jsonp'
    return '%s(%s);' % (jsonp, str(events_json()))


@route('/events/xml')
def xml():
    response.content_type = 'application/xml'
    return template('tpl/events_xml', events=backend.get_events())


@route('/events/sqlite')
def sqlite():
    # TODO: root is not good when run from other dir
    # for some reason python's mimetype module can't autoguess this
    return static_file("anthracite.db", root=".", mimetype='application/octet-stream')


@route('/events/delete/<event_id:int>')
def delete(event_id):
    try:
        backend.delete_event(event_id)
        return page(body=template('tpl/events_table', rows=backend.get_events()), successes=['The event was deleted from the database'])
    except Exception, e:
        return page(body=template('tpl/events_table', rows=backend.get_events()), errors=[('Could not delete event', e)])
    # TODO redirect back to original page


@route('/events/add', method='GET')
def add_get():
    return page(body=template('tpl/events_add', tags=backend.get_tags()))


@route('/events/add', method='POST')
def add_post():
    try:
        import time
        import datetime
        # we receive something like 12/31/1969 10:25:35 PM
        ts = time.mktime(datetime.datetime.strptime(request.forms.event_datetime, "%m/%d/%Y %I:%M:%S %p").timetuple())
        # (select2 tags form field uses comma)
        tags = request.forms.event_tags.split(',')
        event = Event(timestamp=ts, desc=request.forms.event_desc, tags=tags)
    except Exception, e:
        return page(body=template('tpl/events_add', tags=backend.get_tags()), errors=[('Could not create new event', e)])
    try:
        backend.add_event(event)
        return page(body=template('tpl/events_add', tags=backend.get_tags()), successes=['The new event was added into the database'])
    except Exception, e:
        return page(body=template('tpl/events_add', tags=backend.get_tags()), errors=[('Could not save new event', e)])


@route('/events/add/script', method='POST')
def add_post_script():
    try:
        event = Event(timestamp=request.forms.event_timestamp,
                      desc=request.forms.event_desc,
                      tags=request.forms.event_tags.split())
    except Exception, e:
        return 'Could not create new event: %s' % e
    try:
        backend.add_event(event)
        return 'The new event was added into the database'
    except Exception, e:
        return 'Could not save new event: %s' % e


@route('/report')
def report():
    import time
    import datetime
    start = time.mktime(datetime.datetime.strptime(config.opsreport_start, "%m/%d/%Y %I:%M:%S %p").timetuple())
    return page(body=template('tpl/report', config=config, data=get_report_data(start, time.time())))


def get_report_data(start, until):
    outages = backend.get_outages()
    downtime = 0
    reportpoints = []
    # TODO bring all stats into single datapoint, only split up when actually
    # feeding to graphite. so that we can easily have 1 table with all stats on
    # report page
    # id timestamp desc tags
    origin_event = [None, start, "start of ops reporting", []]
    reportpoints.append(ReportPoint(uptime=100, downtime=downtime, start=start, outage=None, event=origin_event)
    for (outage, events) in outages.items():
        start_ts = events[0][1]
        detect_ts = events[1][1]
        fix_ts = events[2][1]
        # at the beginning of the outage..
        #if start_ts > until:
        #    break
        age = float(fix_ts - start)
        uptime = float(age - downtime) / age
        reportpoints.append(ReportPoint(uptime * 100, downtime, start_ts, outage, events[0]))
        # when detected
        outage_duration_part1 = detect_ts - start_ts
        downtime += outage_duration_part1 / 60
        age = detect_ts - start
        uptime = (age - downtime) / age
        datapoints_uptime.append((uptime * 100, detect_ts, outage_key, events[1]))
        datapoints_downtime.append((downtime, detect_ts, outage_key, events[1]))

        # at the end..
        #if fix_ts > until:
        #    break
        outage_duration_part2 = fix_ts - detect_ts
        downtime += outage_duration_part2 / 60
        age = fix_ts - start
        uptime = (age - downtime) / age
        datapoints_uptime.append((uptime * 100, fix_ts, outage_key, events[2]))
        datapoints_downtime.append((downtime, fix_ts, outage_key, events[2]))

    import time
    now = int(time.time())
    age = now - start
    end_event = [None, now, "now", []]
    uptime = (age - downtime) / age
    datapoints_uptime.append((uptime * 100, now, None, end_event))
    datapoints_downtime.append((downtime, now, None, end_event))
    return ({'uptime': datapoints_uptime, 'downtime': datapoints_downtime})


@route('/report/data/<catchall:re:.*>')
def report_data(catchall):
    response.content_type = 'application/x-javascript'
    import json
    import datetime
    import time
    start = time.mktime(datetime.datetime.strptime(request.query['from'], "%m/%d/%Y %I:%M:%S %p").timetuple())  # pretty much ignored so far
    until = request.query['until']
    jsonp = request.query['jsonp']
    datapoints = get_report_data(start, until)
    data = [
        {
            "target": "uptime",
            "datapoints": [[d[0], d[1]] for d in datapoints['uptime']]
        },
        {
            "target": "downtime",
            "datapoints": [[d[0], d[1]] for d in datapoints['downtime']]
        }
    ]
    print 'JSON', data
    return '%s(%s)' % (jsonp, json.dumps(data))


@route('<path:re:/assets/.*>')
def static(path):
    return static_file(path, root='.')


@error(404)
def error404(code):
    return page(body=template('tpl/error', title='404 page not found', msg='The requested page was not found'))


def page(**kwargs):
    # accepts lists of warnings, errors, infos, successes for which we'll show
    # blocks
    kwargs['events_count'] = backend.get_events_count()
    return template('tpl/page', kwargs)

backend = Backend("anthracite.db")

import config
debug(True)
run(reloader=True, host=config.listen_host, port=config.listen_port)
