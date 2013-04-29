from bottle import route, response, template
from backend import Backend
from view import page_light

urls = [
    ('/events/csv/vimeo_analytics', 'csv'),
    ('/events/table/vimeo_analytics', 'table')
]


def events_vimeo_analytics():
    import config
    backend = Backend()
    recommended_tags = set([t[0] for t in config.recommended_tags])
    events = []
    for event in backend.get_events_raw():
        desc = event['desc'].replace('\n', '  ')
        expected_result = event.get('expected_result', '')
        characterizing_tags = set(event['tags']).intersection(recommended_tags)
        for k in characterizing_tags:
            if k in config.engineering_tags:
                characterizing_tags.remove(k)
                characterizing_tags.add('engineering')
        if not characterizing_tags:
            return None
        category = '-'.join(sorted(characterizing_tags))
        tags = ' '.join(sorted(set(event['tags']).difference(characterizing_tags)))
        formatted = [event['id'], str(event['date']), desc, tags, category, expected_result]
        events.append(formatted)
    return events


@route('/events/csv/vimeo_analytics')
def events_csv_vimeo_analytics():
    '''
    desc is the entire desc, with '\n' replaced with '  '. this output doesn't attempt to shorten the desc string.
    '''
    response.content_type = 'text/plain'
    return "\n".join([','.join(event) for event in events_vimeo_analytics()])


@route('/events/table/vimeo_analytics')
def events_table_vimeo_analytics():
    import config
    return page_light(config, Backend(), {}, body=template('plugins/vimeo_analytics_table', events=events_vimeo_analytics()))
