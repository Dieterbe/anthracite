from plugins.vimeo_add_forms_config import extra_attributes, helptext
from bottle import route, template
from view import page
from backend import Backend
import __builtin__

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
                              helptext=helptext['engineering'], recommended_tags=[], handler='vimeo_engineering', timestamp_feeder=True), page='add_engineering')


@route('/events/add/marketing', method='GET')
def add_marketing_get():
    import config
    backend = Backend()
    return page(config, backend, state,
                body=template('tpl/events_add', tags=backend.get_tags(), extra_attributes=extra_attributes['marketing'], event_type='marketing',
                              helptext=helptext['marketing'], recommended_tags=[], handler='vimeo_marketing'), page='add_marketing')


@route('/events/add/analytics', method='GET')
def add_analytics_get():
    import config
    backend = Backend()
    return page(config, backend, state,
                body=template('tpl/events_add', tags=backend.get_tags(), extra_attributes=extra_attributes['analytics'], event_type='analytics',
                              helptext=helptext['analytics'], recommended_tags=[], handler='vimeo_analytics', timestamp_feeder=True), page='add_analytics')


def add_post_handler_vimeo_engineering(request, config):
    dummy_config = config.copy()
    dummy_config.extra_attributes = extra_attributes['engineering']
    return add_post_handler_vimeo_engineering(request, dummy_config)


def add_post_handler_vimeo_marketing(request, config):
    dummy_config = config.copy()
    dummy_config.extra_attributes = extra_attributes['marketing']
    return add_post_handler_vimeo_engineering(request, dummy_config)


def add_post_handler_vimeo_analytics(request, config):
    dummy_config = config.copy()
    dummy_config.extra_attributes = extra_attributes['analytics']
    return add_post_handler_vimeo_engineering(request, dummy_config)


__builtin__.add_post_handler_vimeo_engineering = add_post_handler_vimeo_engineering
__builtin__.add_post_handler_vimeo_marketing = add_post_handler_vimeo_marketing
__builtin__.add_post_handler_vimeo_analytics = add_post_handler_vimeo_analytics


def add_post_handler_vimeo_add_forms(request, config):
    (ts, desc, tags) = add_post_validate_and_parse_base_attributes(request)
    extra_attributes = add_post_validate_and_parse_extra_attributes(request, config)
    unknown_attributes = add_post_validate_and_parse_unknown_attributes(request, config)
    extra_attributes.update(unknown_attributes)

    event = Event(timestamp=ts, desc=desc, tags=tags, extra_attributes=extra_attributes)
    return event
