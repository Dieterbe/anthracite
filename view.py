from bottle import template


def page(config, backend, state, **kwargs):
    # accepts lists of warnings, errors, infos, successes for which we'll show
    # blocks
    kwargs['events_count'] = backend.get_events_count()
    kwargs['extra_urls'] = state['extra_urls']
    return template('tpl/page', kwargs)


def page_light(config, backend, state, **kwargs):
    kwargs['events_count'] = backend.get_events_count()
    return template('tpl/page_light', kwargs)
