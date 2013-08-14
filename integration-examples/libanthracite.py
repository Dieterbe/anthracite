import urllib
import urllib2
import time

def submit_anthracite(url, tags_list, desc, timestamp=None):
    if timestamp is None:
        timestamp = int(time.time())
    params = {
        'event_timestamp': timestamp,
        'event_tags': ' '.join(tags_list),
        'event_desc': desc
    }
    req = urllib2.Request(url="%s/events/add/script" % url, data=urllib.urlencode(params))
    f = urllib2.urlopen(req)
    code = f.getcode()
    if code != 201:
        raise Exception("Couldn't submit anthracite event. Http %i: %s" % (code , f.read()))
    return True
