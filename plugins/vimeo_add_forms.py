from plugins.vimeo_add_forms_config import extra_attributes, helptext
from bottle import route, template
from view import page
from backend import Backend

add_urls = [
    ('/events/add/analytics',   'add analytics event'),
    ('/events/add/engineering', 'add engineering event'),
    ('/events/add/marketing',   'add marketing event'),
    ('/events/add/product',     'add product event')
]
remove_urls = ['/events/add']


@route('/events/add/engineering', method='GET')
def add_engineering_get(**kwargs):
    backend = Backend()
    return page(config, backend, state,
                body=template('tpl/events_add', tags=backend.get_tags(), extra_attributes=extra_attributes['engineering'], event_type='engineering',
                              helptext=helptext['engineering'], recommended_tags=[], handler='vimeo_engineering', timestamp_feeder=True),
                page='add_engineering', **kwargs)


@route('/events/add/marketing', method='GET')
def add_marketing_get(**kwargs):
    backend = Backend()
    return page(config, backend, state,
                body=template('tpl/events_add', tags=backend.get_tags(), extra_attributes=extra_attributes['marketing'], event_type='marketing',
                              helptext=helptext['marketing'], recommended_tags=[], handler='vimeo_marketing'),
                page='add_marketing', **kwargs)


@route('/events/add/product', method='GET')
def add_product_get(**kwargs):
    backend = Backend()
    return page(config, backend, state,
                body=template('tpl/events_add', tags=backend.get_tags(), extra_attributes=extra_attributes['product'], event_type='product',
                              helptext=helptext['product'], recommended_tags=[], handler='vimeo_product'),
                page='add_product', **kwargs)


@route('/events/add/analytics', method='GET')
def add_analytics_get(**kwargs):
    backend = Backend()
    return page(config, backend, state,
                body=template('tpl/events_add', tags=backend.get_tags(), extra_attributes=extra_attributes['analytics'], event_type='analytics',
                              helptext=helptext['analytics'], recommended_tags=[], handler='vimeo_analytics', timestamp_feeder=True),
                page='add_analytics', **kwargs)


def add_post_handler_vimeo_engineering(request, config):
    dummy_config = config.copy()
    dummy_config['extra_attributes'] = extra_attributes['engineering']
    return add_post_handler_default(request, dummy_config)


def add_post_handler_vimeo_marketing(request, config):
    dummy_config = config.copy()
    dummy_config['extra_attributes'] = extra_attributes['marketing']
    return add_post_handler_default(request, dummy_config)


def add_post_handler_vimeo_product(request, config):
    dummy_config = config.copy()
    dummy_config['extra_attributes'] = extra_attributes['product']
    return add_post_handler_default(request, dummy_config)


def add_post_handler_vimeo_analytics(request, config):
    dummy_config = config.copy()
    dummy_config['extra_attributes'] = extra_attributes['analytics']
    return add_post_handler_default(request, dummy_config)

