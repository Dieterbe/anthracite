from bottle import route, response, template
from backend import Backend
from view import page_light

add_urls = [
    ('/events/csv/vimeo_analytics', 'csv analytics'),
    ('/events/table/vimeo_analytics', 'table analytics')
]


def events_vimeo_analytics():
   #
   # we should be aware that engineering events get submitted through various
   # means (incl scripts), so if category is not set, but expected FX is, we
   # count those as engineering

    backend = Backend()
    events = []
    query = {
        "field": {
            "category": {
                "query": "*"
            }
        }
    }

    for event in backend.get_events_raw(query):
        desc = event['desc'].replace("\n", '  ').replace("\r", ' ').strip()
        tags = '-'.join(event['tags'])
        expected_effect = event.get('expected_effect', '')
        if type(expected_effect) is list:
            expected_effect = '-'.join(expected_effect)
        known_effect = event.get('known_effect', '')
        event = [event['id'], event['date'], desc, tags, event['category'], expected_effect, known_effect]
        events.append(event)
    return events


@route('/events/csv/vimeo_analytics')
def events_csv_vimeo_analytics():
    '''
    desc is the entire desc, with '\n' replaced with '  '. this output doesn't attempt to shorten the desc string.
    '''
    response.content_type = 'text/plain'

    def line_yielder(events):
        for event in events:
            yield ','.join([str(field).replace(',', '') for field in event])

    return "\n".join(line_yielder(events_vimeo_analytics()))


@route('/events/table/vimeo_analytics')
def events_table_vimeo_analytics(**kwargs):
    return page_light(config, Backend(), {}, body=template('plugins/vimeo_analytics_table', events=events_vimeo_analytics()), **kwargs)
