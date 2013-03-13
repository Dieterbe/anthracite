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
def json():
    return {"events": [{"time": record[0], "type": str(record[1]), "desc": str(record[2])} for record in backend.get_events()]}


@route('/events/jsonp')
def jsonp():
    response.content_type = 'application/x-javascript'
    jsonp = request.query.jsonp or 'jsonp'
    return '%s(%s);' % (jsonp, str(json()))


@route('/events/xml')
def xml():
    response.content_type = 'application/xml'
    return template('tpl/events_xml', events = backend.get_events())


@route('/events/sqlite')
def sqlite():
    # TODO: root is not good when run from other dir
    # for some reason python's mimetype module can't autoguess this
    return static_file("anthracite.db", root=".", mimetype='application/octet-stream')


@route('/events/add', method='GET')
def add_get():
    return page(body=template('tpl/events_add'))


@route('/events/add', method='POST')
def add_post():
    try:
        import time
        import datetime
        # we receive something like 12/31/1969 10:25:35 PM
        ts = time.mktime(datetime.datetime.strptime(request.forms.event_datetime, "%m/%d/%Y %I:%M:%S %p").timetuple())
        event = Event(timestamp=ts, t=request.forms.event_type, desc=request.forms.event_desc)
    except Exception, e:
        return page(body=template('tpl/events_add'), errors=[('Could not create new event', e)])
    try:
        backend.add_event(event)
        return page(body=template('tpl/events_add'), successes=['The new event was added into the database'])
    except Exception, e:
        return page(body=template('tpl/events_add'), errors=[('Could not save new event', e)])


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
