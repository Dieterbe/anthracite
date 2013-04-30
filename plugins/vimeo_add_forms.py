from plugins.vimeo_add_forms_config import extra_attributes, helptext
from bottle import route, template
from view import page
from backend import Backend
add_urls = [
    ('/events/add/marketing',   'add marketing event'),
    ('/events/add/engineering', 'add engineering event'),
    ('/events/add/analytics',   'add event any (for analytics)')
]
remove_urls = ['/events/add']


@route('/events/add/engineering', method='GET')
def add_engineering_get():
    import config
    backend = Backend()
    return page(config, backend, state,
                body=template('tpl/events_add', tags=backend.get_tags(), extra_attributes=extra_attributes['engineering'], event_type='engineering',
                              helptext=helptext['engineering'], recommended_tags=[], timestamp_feeder=True), page='add_engineering')


@route('/events/add/marketing', method='GET')
def add_marketing_get():
    import config
    backend = Backend()
    return page(config, backend, state,
                body=template('tpl/events_add', tags=backend.get_tags(), extra_attributes=extra_attributes['marketing'], event_type='marketing',
                              helptext=helptext['marketing'], recommended_tags=[]), page='add_marketing')


@route('/events/add/analytics', method='GET')
def add_analytics_get():
    import config
    backend = Backend()
    return page(config, backend, state,
                body=template('tpl/events_add', tags=backend.get_tags(), extra_attributes=extra_attributes['analytics'], event_type='analytics',
                              helptext=helptext['analytics'], recommended_tags=[], timestamp_feeder=True), page='add_analytics')
