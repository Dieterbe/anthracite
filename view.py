from bottle import template


def page(config, backend, state, **kwargs):
    # accepts lists of warnings, errors, infos, successes for which we'll show
    # blocks
    kwargs['events_count'] = backend.get_events_count()
    kwargs['add_urls'] = state['add_urls']
    kwargs['remove_urls'] = state['remove_urls']
    return template('tpl/page', kwargs)


def page_light(config, backend, state, **kwargs):
    kwargs['events_count'] = backend.get_events_count()
    return template('tpl/page_light', kwargs)
