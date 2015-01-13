listen_host = '0.0.0.0'  # defaults to "all interfaces"
listen_port = 8081
opsreport_start = '01/01/2013 00:00:00'
es_url = 'http://localhost:9200'
es_index = 'anthracite'

# list of tuples: first value of the tuple is a tag that you recommend/make
# extra visible on the forms, and 2nd value is a user friendly explanation.
recommended_tags = [
]

# Flexible schema:
# use this to add (optional) attributes to your event documents.
# forms will adjust themselves and the events will be stored accordingly.
# i.e. you can create events that have the field set, and ones that don't. and
# you can add it later if you have to.
from model import Attribute
extra_attributes = [
    Attribute('outage_key', 'Outage key')
]
# "help" text to appear on forms
helptext = {
    'outage_key': 'key to uniquely identify particular outages'
}

plugins = []
# you can try the vimeo plugins to get an idea:
#plugins = ['vimeo_analytics', 'vimeo_add_forms']
