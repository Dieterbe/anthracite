#!/usr/bin/env python2
from backend import get_backend, Event
import time

sqlite = get_backend('sqlite')
es = get_backend('elasticsearch')
print "sqlite has %i events" % sqlite.get_events_count()
print "elasticsearch has %i events" % es.get_events_count()

for (i, event) in enumerate(sqlite.get_events()):
    print "copying event %i: %s" % (i, event)
    es.add_event(event)

print "sleeping to let elasticsearch settle.."
time.sleep(4)
print "sqlite has %i events" % sqlite.get_events_count()
print "elasticsearch has %i events" % es.get_events_count()


