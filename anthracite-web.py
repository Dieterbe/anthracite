#!/usr/bin/env python2
from bottle import route, run, debug, template, request, static_file, error, response
from backend import get_backend, Event, Reportpoint
import json
import os


@route('/')
def main():
    return page(body=template('tpl/index'))


@route('/events')
def table():
    return page(body=template('tpl/events_table', events=backend.get_events()))


@route('/events/timeline')
def timeline():
    rows = backend.get_event_rows()
    (range_low, range_high) = backend.get_events_range()

    return page(body=template('tpl/events_timeline', rows=rows, range_low=range_low, range_high=range_high))


@route('/events/json')
def events_json():
    return {"events": [{"id": record[0], "time": record[1], "desc": record[2], "tags": record[3]} for record in backend.get_event_rows()]}


@route('/events/csv')
def events_csv():
    '''
    returns the first line of every event
    '''
    response.content_type = 'text/plain'
    events = []
    for r in backend.get_event_rows():
        event = ','.join([str(r[0]), str(r[1]), r[2][:r[2].find('\n')], ' '.join(r[3])])
        events.append(event)
    return "\n".join(events)


@route('/events/jsonp')
def events_jsonp():
    response.content_type = 'application/x-javascript'
    jsonp = request.query.jsonp or 'jsonp'
    return '%s(%s);' % (jsonp, json.dumps(events_json()))


@route('/events/xml')
def xml():
    response.content_type = 'application/xml'
    return template('tpl/events_xml', events=backend.get_event_rows())


@route('/events/sqlite')
def sqlite():
    # TODO: root is not good when run from other dir
    # for some reason python's mimetype module can't autoguess this
    return static_file("anthracite.db", root=".", mimetype='application/octet-stream')


@route('/events/delete/<event_id>')
def delete(event_id):
    try:
        backend.delete_event(event_id)
        return page(body=template('tpl/events_table', events=backend.get_events()), successes=['The event was deleted from the database'])
    except Exception, e:
        return page(body=template('tpl/events_table', events=backend.get_events()), errors=[('Could not delete event', e)])
    # TODO redirect back to original page


@route('/events/edit/<event_id>')
def edit(event_id):
    try:
        event = backend.get_event(event_id)
        return page(body=template('tpl/events_edit', event=event, tags=backend.get_tags()))
    except Exception, e:
        raise
        return page(body=template('tpl/events_table', events=backend.get_events()), errors=[('Could not load event', e)])


@route('/events/edit/<event_id>', method='POST')
def edit_post(event_id):
    try:
        import time
        import datetime
        # we receive something like 12/31/1969 10:25:35 PM
        ts = int(time.mktime(datetime.datetime.strptime(request.forms.event_datetime, "%m/%d/%Y %I:%M:%S %p").timetuple()))
        # (select2 tags form field uses comma)
        tags = request.forms.event_tags.split(',')
        event = Event(timestamp=ts, desc=request.forms.event_desc, tags=tags, rowid=event_id)
    except Exception, e:
        return page(body=template('tpl/events_table', events=backend.get_events()), errors=[('Could recreate event from received information', e)])
    try:
        backend.edit_event(event)
        return page(body=template('tpl/events_table', events=backend.get_events()), successes=['The event was updated'])
    except Exception, e:
        raise
        return page(body=template('tpl/events_table', events=backend.get_events()), errors=[('Could not update event', e)])


@route('/events/add', method='GET')
def add_get():
    return page(body=template('tpl/events_add', tags=backend.get_tags()))


@route('/events/add', method='POST')
def add_post():
    try:
        import time
        import datetime
        # we receive something like 12/31/1969 10:25:35 PM
        ts = int(time.mktime(datetime.datetime.strptime(request.forms.event_datetime, "%m/%d/%Y %I:%M:%S %p").timetuple()))
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
        event = Event(timestamp=int(request.forms.event_timestamp),
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
    start = int(time.mktime(datetime.datetime.strptime(config.opsreport_start, "%m/%d/%Y %I:%M:%S %p").timetuple()))
    return page(page='report', body=template('tpl/report', config=config, reportpoints=get_report_data(start, int(time.time()))))


def get_report_data(start, until):
    events = backend.get_outage_events()
    # see report.tpl for definitions
    # this simple model ignores overlapping outages!
    tttf = 0
    tttd = 0
    tttr = 0
    age = 0  # time spent since start
    last_failure = start
    reportpoints = []
    # TODO there's some assumptions on tag order and such. if your events are
    # badly tagged, things could go wrong.
    # TODO honor start/until
    origin_event = Event(start, "start", [])
    reportpoints.append(Reportpoint(origin_event, 0, 100, 0, tttf, 0, tttd, 0, tttr))
    outages_seen = {}
    for event in events:
        if event.timestamp > until:
            break
        age = float(event.timestamp - start)
        ttd = 0
        ttr = 0
        if 'start' in event.tags:
            outages_seen[event.outage] = {'start': event.timestamp}
            ttf = event.timestamp - last_failure
            tttf += ttf
            last_failure = event.timestamp
        elif 'detected' in event.tags:
            ttd = event.timestamp - outages_seen[event.outage]['start']
            tttd += ttd
            outages_seen[event.outage]['ttd'] = ttd
        elif 'resolved' in event.tags:
            ttd = outages_seen[event.outage]['ttd']
            ttr = event.timestamp - outages_seen[event.outage]['start']
            tttr += ttr
            outages_seen[event.outage]['ttr'] = ttr
        else:
            # the outage changed impact. for now just ignore this, cause we
            # don't do anything with impact yet.
            pass
        muptime = float(age - tttr) * 100 / age
        reportpoints.append(Reportpoint(event, len(outages_seen), muptime, ttf, tttf, ttd, tttd, ttr, tttr))

    age = until - start
    end_event = Event(until, "end", [])
    muptime = float(age - tttr) * 100 / age
    reportpoints.append(Reportpoint(end_event, len(outages_seen), muptime, 0, tttf, 0, tttd, 0, tttr))
    return reportpoints


@route('/report/data/<catchall:re:.*>')
def report_data(catchall):
    response.content_type = 'application/x-javascript'
    start = int(request.query['from'])
    until = int(request.query['until'])
    jsonp = request.query['jsonp']
    reportpoints = get_report_data(start, until)
    data = [
        {
            "target": "ttd",
            "datapoints": [[r.ttd / 60, r.event.timestamp] for r in reportpoints]
        },
        {
            "target": "ttr",
            "datapoints": [[r.ttr / 60, r.event.timestamp] for r in reportpoints]
        }
    ]
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

app_dir = os.path.dirname(__file__)
if app_dir:
    os.chdir(app_dir)

import config
backend = get_backend(config.backend)
debug(True)
run(reloader=True, host=config.listen_host, port=config.listen_port)
