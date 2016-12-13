# -*- encoding: utf-8 -*-
import os

listen_host = '0.0.0.0'  # defaults to "all interfaces"
listen_port = 8081
opsreport_start = '01/01/2013 12:00:00 AM'
timezone = os.environ.get('ANTHRACITE_TZ', 'America/New_York')
es_url = os.environ.get('ES_URL', 'http://localhost:9200')
es_index = os.environ.get('ES_INDEX', 'anthracite')

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
    Attribute('outage_key', 'Outage key'),
    Attribute('owner', 'Owner'),
    Attribute('file', 'Late File'),
    Attribute('status', 'Open or Closed', mandatory=True, choices=['open', 'closed']),
    Attribute('days_late', 'Number of Days Late'),
    Attribute('SampleDate', 'Data Quality Sample'),
    Attribute('DataPoint', 'Data Point code'),
    Attribute('Change', 'Data Quality Change')

]
# "help" text to appear on forms
helptext = {
    'outage_key': 'key to uniquely identify particular outages'
}

plugins = []
# you can try the vimeo plugins to get an idea:
#plugins = ['vimeo_analytics', 'vimeo_add_forms']

# SQ specific constants
USERS = ['Archit Jain', 'Farzad Vafaee', 'Joachim Hubele', 'John Jardel', 'Jun Xue', 'Mark Gorman', 'Mark Schwarz', 'Niral Patel', 'Qiong Zeng', 'Hitesh Singh', 'Samuel Taylor', 'Jeff Killeen', 'Vijayant Soni']
SERVERS = ['etl-dev-1.private.square-root.com', 'etl-stg-1.private.square-root.com', 'etl-prd-1.private.square-root.com', 'etl-dev-vw-1.private.square-root.com', 'etl-stg-vw-1.private.square-root.com', 'etl-prd-vw-1.private.square-root.com', 'etl-dev-mt-1.private.square-root.com', 'etl-stg-mt-1.private.square-root.com', 'etl-prd-mt-1.private.square-root.com']
EVENT_TYPES = ['LateFiles', 'Quarantine', 'FileLoadErrors', 'ConfigWarnings', 'DataQualityCheck', 'BuildFailures', 'etl_milestones']
