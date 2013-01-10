#!/usr/bin/env python2
from bottle import route, run, debug, template, request, static_file, error, response
from backend import Backend


@route('/')
def main():
    options = [('/table', 'table list'), ('/raw', 'raw list'), ('/json', 'json list'), ('/sqlite', 'sqlite file'), ('/add', 'add event')]
    return '<ul>%s</ul>' % ''.join('<li><a href="%s">%s</a></li>' % e for e in options)


@route('/table')
def table():
    return template('tpl/table', rows=backend.get_events())


@route('/raw')
def raw():
    response.content_type = 'text/plain'
    return "\n".join(','.join(map(str, record)) for record in backend.get_events())


@route('/json')
def json():
    return {"events": [{"time": record[0], "type": record[1], "desc": record[2]} for record in backend.get_events()]}


@route('/sqlite')
def sqlite():
    # TODO: root is not good when run from other dir
    # for some reason python's mimetype module can't autoguess this
    return static_file("anthracite.db", root=".", mimetype='application/octet-stream')


@route('/add', method='GET')
def add_get():
    return template('tpl/add.tpl')


@route('/add', method='POST')
def add_post():
    try:
        event = (request.forms.event_time, request.forms.event_type, request.forms.event_desc)
        backend.add_event(event)
        return '<p>The new event was added into the database<a href="/">main</a></p>'
    except Exception, e:
        return template('tpl/add.tpl', error=e)

@error(404)
def error404(code):
    return '404 page not found.<br/><a href="/">main</a>'

backend = Backend("anthracite.db")

import config
debug(True)
run(reloader=True, host=config.listen_host, port=config.listen_port)
