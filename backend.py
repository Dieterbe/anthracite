from types import IntType, StringType, UnicodeType
from config import EVENT_TYPES
import time
import datetime
import calendar
import os
import sys


class Config(dict):
    '''
    based on http://stackoverflow.com/questions/4984647/accessing-dict-keys-like-an-attribute-in-python
    create a config object based on an imported module.
    with the module, you have nice config.key attrib access, but you can't config.copy() it
    so we convert it into a dict... but then we loose the nice attrib access again.
    so this class gives an object that supports both config.key and config.copy() basically
    '''
    def __init__(self, module_or_dict):
        try:
            # it's a module
            d = module_or_dict.__dict__
        except:
            # it's a dict:
            d = module_or_dict
        for k, v in d.items():
            if not k.startswith('__'):
                self[k] = v

    def __getattr__(self, attr):
        return self[attr]

    def __setattr__(self, attr, value):
        self[attr] = value

    def copy(self):
        return Config(self)


class Event():
    '''
    timestamp must be a unix timestamp (int)
    desc is a string in whatever markup you want (html usually)
    tags is a list of strings (usally simple words)
    event_id is optional, it's the elasticsearch _id field
    '''


    def __init__(self, timestamp=None, desc=None, tags=[], event_id=None, extra_attributes={}):

        assert type(timestamp) is IntType, "timestamp must be an integer: %r" % timestamp
        assert type(desc) in (StringType, UnicodeType), "desc must be a non-empty string: %r" % desc
        assert desc, "desc must be a non-empty string: %r" % desc

        self.timestamp = timestamp
        self.desc = desc
        self.tags = tags  # just a list of strings
        self.event_id = event_id
        self.extra_attributes = extra_attributes

    def __str__(self):
        pretty_desc = self.desc
        if "\n" in self.desc:
            pretty_desc = "%s..." % self.desc[:self.desc.find('\n')]
        return "Event object. event_id=%s, ts=%i, tags=%s, desc=%s" % (self.event_id, self.timestamp, ','.join(self.tags), pretty_desc)

    def __getattr__(self, nm):
        if nm == 'outage':
            for tag in self.tags:
                if tag.startswith('outage='):
                    return tag.replace('outage=', '')
            return None
        if nm == 'impact':
            for tag in self.tags:
                if tag.startswith('impact='):
                    return tag.replace('impact=', '')
            return None
        raise AttributeError("no attribute %s" % nm)


class Reportpoint():

    def __init__(self, event, outages, muptime, ttf, tttf, ttd, tttd, ttr, tttr):
        self.event = event
        self.outages = outages  # number of outages occured until now (including this one, if appropriate)
        self.muptime = muptime
        self.ttf = ttf
        self.tttf = tttf
        self.ttd = ttd
        self.tttd = tttd
        self.ttr = ttr
        self.tttr = tttr

    def __getattr__(self, nm):
        divisor = self.outages
        if divisor == 0:
            divisor = 1
        if nm == 'mttf':
            return self.tttf / divisor
        if nm == 'mttd':
            return self.tttd / divisor
        if nm == 'mttr':
            return self.tttr / divisor
        raise AttributeError("no attribute %s" % nm)


class Backend():

    def __init__(self, config=None):
        sys.path.append("%s/%s" % (os.getcwd(), 'python-dateutil'))
        sys.path.append("%s/%s" % (os.getcwd(), 'requests'))
        sys.path.append("%s/%s" % (os.getcwd(), 'rawes'))
        import rawes
        import requests
        from rawes.elastic_exception import ElasticException
        # pyflakes doesn't like globals()['ElasticException'] = ElasticException  so:
        self.ElasticException = ElasticException
        if config is None:
            import config
            config = Config(config)
        self.config = config
        self.es = rawes.Elastic(config.es_url, except_on_error=True)
        # make sure the index exists
        try:
            # to explain the custom mapping:
            # * _source enabled is maybe not really needed, but it's easiest at
            # least. we just need to be able to reconstruct the original document.
            # * tags are not analyzed so that when we want to get a list of all
            # tags (a facet search) it returns the original tags, not the
            # tokenized terms.
            self.es.post(config.es_index, data={
                "mappings": {
                    "event": {
                        "_source": {
                            "enabled": True
                        },
                        "properties": {
                            "tags": {
                                "type": "string",
                                "index": "not_analyzed"
                            },
                            "DWDataSource": {
                                "type": "multi_field",
                                "fields": {
                                    "DWDataSource" : {
                                        "type": "string",
                                        "index" : "analyzed",
                                        "index_analyzer": "whitespace",
                                        "search_analyzer": "whitespace"},
                                    "exact": {
                                        "type": "string",
                                        "index": "not_analyzed"}
                                }
                            },
                            "data_point": {
                                "type": "multi_field",
                                "fields":{
                                    "data_point": {
                                        "type": "string",
                                        "index": "analyzed",
                                        "index_analyzer": "whitespace",
                                        "search_analyzer": "whitespace"},
                                    "exact": {
                                        "type": "string",
                                        "index": "not_analyzed"}
                                    }
                            },
                            "sql_query": {
                                "type": "multi_field",
                                "fields":{
                                    "sql_query": {
                                        "type": "string",
                                        "index": "analyzed",
                                        "index_analyzer": "whitespace",
                                        "search_analyzer": "whitespace"},
                                    "exact": {
                                        "type": "string",
                                        "index": "not_analyzed"}
                                    }
                            },
                            "owner": {
                                "type": "multi_field",
                                "fields":{
                                    "owner": {
                                        "type": "string",
                                        "index": "analyzed",
                                        "index_analyzer": "whitespace",
                                        "search_analyzer": "whitespace"},
                                    "exact": {
                                        "type": "string",
                                        "index": "not_analyzed"}
                                    }
                            },
                            "desc": {
                                "type": "multi_field",
                                "fields":{
                                    "desc": {
                                        "type": "string",
                                        "index": "analyzed",
                                        "index_analyzer": "whitespace",
                                        "search_analyzer": "whitespace"},
                                    "exact": {
                                        "type": "string",
                                        "index": "not_analyzed"}
                                    }
                            },
                            "FileName": {
                                "type": "multi_field",
                                "fields":{
                                    "FileName": {
                                        "type": "string",
                                        "index": "analyzed",
                                        "index_analyzer": "whitespace",
                                        "search_analyzer": "whitespace"},
                                    "exact": {
                                        "type": "string",
                                        "index": "not_analyzed"}
                                    }
                            },
                            "host": {
                                "type": "multi_field",
                                "fields":{
                                    "host": {
                                        "type": "string",
                                        "index": "analyzed",
                                        "index_analyzer": "whitespace",
                                        "search_analyzer": "whitespace"},
                                    "exact": {
                                        "type": "string",
                                        "index": "not_analyzed"}
                                    }
                            } ,
                            "job": {
                                "type": "multi_field",
                                "fields":{
                                    "job": {
                                        "type": "string",
                                        "index": "analyzed",
                                        "index_analyzer": "whitespace",
                                        "search_analyzer": "whitespace"},
                                    "exact": {
                                        "type": "string",
                                        "index": "not_analyzed"}
                                    }
                            },
                            "file": {
                                "type": "multi_field",
                                "fields":{
                                    "file": {
                                        "type": "string",
                                        "index": "analyzed",
                                        "index_analyzer": "whitespace",
                                        "search_analyzer": "whitespace"},
                                    "exact": {
                                        "type": "string",
                                        "index": "not_analyzed"}
                                    }
                            },
                            "last_file_load": {
                                "type": "multi_field",
                                "fields":{
                                    "last_file_load": {
                                        "type": "string",
                                        "index": "analyzed",
                                        "index_analyzer": "whitespace",
                                        "search_analyzer": "whitespace"},
                                    "exact": {
                                        "type": "string",
                                        "index": "not_analyzed"}
                                    }
                            },
                            "sample_date": {
                                "type": "multi_field",
                                "fields":{
                                    "sample_date": {
                                        "type": "string",
                                        "index": "analyzed",
                                        "index_analyzer": "whitespace",
                                        "search_analyzer": "whitespace"},
                                    "exact": {
                                        "type": "string",
                                        "index": "not_analyzed"}
                                    }
                            }
                        }
                    }
                }
            })
            print "created new ElasticSearch Index"
        except ElasticException as e:
            import re
            if 'IndexAlreadyExistsException' in e.result['error']:
                pass
            else:
                raise
        except requests.exceptions.ConnectionError as e:
            sys.stderr.write("Could not connect to ElasticSearch: %s" % e)
            sys.exit(2)

    def object_to_dict(self, event):
        iso = self.unix_timestamp_to_iso8601(event.timestamp)
        data = {
            'date': iso,
            'tags': event.tags,
            'desc': event.desc
        }
        data.update(event.extra_attributes)
        return data

    def unix_timestamp_to_iso8601(self, unix_timestamp):
        return datetime.datetime.utcfromtimestamp(unix_timestamp).isoformat()

    def iso8601_to_unix_timestamp(self, iso8601):
        '''
            elasticsearch returns something like 2013-03-20T20:41:16

        '''
        unix = calendar.timegm(datetime.datetime.strptime(iso8601, "%Y-%m-%dT%H:%M:%S").timetuple())
        return unix

    def hit_to_object(self, hit):
        event_id = hit['_id']
        hit = hit['_source']
        unix = self.iso8601_to_unix_timestamp(hit['date'])
        extra_attributes= {}
        for (k, v) in hit.items():
            if k not in ('desc', 'tags', 'date'):
                extra_attributes[k] = v
        return Event(timestamp=unix, desc=hit['desc'], tags=hit['tags'], event_id=event_id, extra_attributes=extra_attributes)

    def add_event(self, event):
        ret = self.es.post('%s/event' % self.config.es_index, data=self.object_to_dict(event))
        return ret['_id']

    def delete_event(self, event_id):
        try:
            self.es.delete('%s/event/%s' % (self.config.es_index, event_id))
        except self.ElasticException as e:
            if 'found' in e.result and not e.result['found']:
                raise Exception("Document %s can't be found" % event_id)
            else:
                raise

    def edit_event(self, event):
        self.es.post('%s/event/%s/_update' % (self.config.es_index, event.event_id), data={'doc': self.object_to_dict(event)})

    @staticmethod
    def prepare_tag_match_query():
        query_params = []
        for event_type in EVENT_TYPES:
            query_params.append({ "match": { "tags": event_type}})
        return query_params

    def es_get_events(self, query = None):
        if query is None:
            query = {
                "bool": {
                    "should": self.prepare_tag_match_query()
                }
            }

        return self.es.get('%s/event/_search?size=5000' % self.config.es_index, data={
            "query": query,
            "sort": [
                {
                    "date": {
                        "order": "desc",
                        "ignore_unmapped": True  # avoid 'No mapping found for [date] in order to sort on' when we don't have data yet
                    }
                }
            ]
        })

    def get_events_raw(self, query=None):
        '''
        return format that's optimized for elasticsearch
        '''
        hits = self.es_get_events(query)
        events = hits['hits']['hits']
        for (i, event) in enumerate(events):
            event_id = event['_id']
            events[i] = event['_source']
            events[i]['id'] = event_id
            events[i]['date'] = self.iso8601_to_unix_timestamp(events[i]['date'])
        return events

    def get_events_objects(self, limit=500):
        # retuns a list of event objects
        hits = self.es_get_events()
        return [self.hit_to_object(event_hit) for event_hit in hits['hits']['hits']][:limit]

    def get_event(self, event_id):
        # http://localhost:9200/dieterfoobarbaz/event/PZ1su5w5Stmln_c2Kc4B2g
        event_hit = self.es.get('%s/event/%s' % (self.config.es_index, event_id))
        event_obj = self.hit_to_object(event_hit)
        return event_obj

    def get_tags(self):
        # get all different tags
        # curl -X POST "http://localhost:9200/anthracite/_search?pretty=true&size=0" -d '{  "query" : {"query_string" : {"query" : "*"}}, "facets":{"tags" : { "terms" : {"field" : "tags"} }}}"'
        tags = self.es.post('%s/_search?size=0' % self.config.es_index, data={
            'query': {
                'query_string': {
                    'query': '*'
                }
            },
            'facets': {
                'tags': {
                    'terms': {
                        'field': 'tags'
                    }
                }
            }
        })
        tags = tags['facets']['tags']['terms']
        tags = [t['term'] for t in tags]
        return tags

    def get_events_range(self):
        low = self.es.post('%s/_search?size=1' % self.config.es_index, data={
            "query": {
		"match_all": {
		}
            },
            "sort": [
                {
                    "date": {
                        "order": "asc",
                        "ignore_unmapped": True  # avoid 'No mapping found for [date] in order to sort on' when we don't have data yet
                    }
                }
            ]
        })
        # if there's not a single record in the database:
        if not len(low['hits']['hits']):
            return (0, time.time())
        high = self.es.post('%s/_search?size=1' % self.config.es_index, data={
            "query": {
		"match_all": {
		}
            },
            "sort": [
                {
                    "date": {
                        "order": "desc",
                        "ignore_unmapped": True  # avoid 'No mapping found for [date] in order to sort on' when we don't have data yet
                    }
                }
            ]
        })
        low = self.iso8601_to_unix_timestamp(low['hits']['hits'][0]['_source']['date'])
        high = self.iso8601_to_unix_timestamp(high['hits']['hits'][0]['_source']['date'])
        return (low, high)

    def get_events_count(self):
        count = 0
        query = {
            "bool": {
                "should": self.prepare_tag_match_query()
            }
        }

        #events = self.es.get('%s/event/_search' % self.config.es_index)
        events = self.es.get('%s/event/_search?size=5000' % self.config.es_index,
                             data={"query": query,
                             "sort": [{
                             "date": {
                             "order": "desc",
                             "ignore_unmapped": True  # avoid 'No mapping found for [date] in order to sort on' when we don't have data yet
                             }}]})
        count = events['hits']['total']
        return count

    def get_outage_events(self):
        # TODO sanity checking (order of detected, resolved tags, etc)
        hits = self.es.get('%s/event/_search' % self.config.es_index, data={
            'query': {
                'query_string': {
                    'query': 'tag like outage=_%'
                }
            },
            "sort": [
                {
                    "date": {
                        "order": "asc",
                        "ignore_unmapped": True  # avoid 'No mapping found for [date] in order to sort on' when we don't have data yet
                    }
                }
            ]
        })
        events = []
        for event_hit in hits['hits']['hits']:
            event_obj = self.hit_to_object(event_hit)
            events.append(event_obj)
        return events


class PluginError(Exception):

    def __init__(self, plugin, msg, underlying_error):
        self.plugin = plugin
        self.msg = msg
        self.underlying_error = underlying_error

    def __str__(self):
        return "%s -> %s (%s)" % (self.plugin, self.msg, self.underlying_error)


def load_plugins(plugins_to_load, config):
    '''
    loads all the plugins sub-modules
    returns encountered errors, doesn't raise them because
    whoever calls this function defines how any errors are
    handled. meanwhile, loading must continue
    '''
    import plugins
    errors = []
    add_urls = {}
    remove_urls = []
    loaded_plugins = []
    plugins_dir = os.path.dirname(plugins.__file__)
    wd = os.getcwd()
    os.chdir(plugins_dir)
    for module in plugins_to_load:
        try:
            print "importing plugin '%s'" % module
            imp = __import__('plugins.' + module, {}, {}, ['*'])
            loaded_plugins.append(imp)
            try:
                add_urls[module] = imp.add_urls
            except Exception:
                pass
            try:
                remove_urls.extend(imp.remove_urls)
            except Exception:
                pass
        except Exception, e:
            errors.append(PluginError(module, "Failed to add plugin '%s'" % module, e))
            continue

    os.chdir(wd)
    state = {
        'add_urls': add_urls,
        'remove_urls': remove_urls,
        'loaded_plugins': loaded_plugins
    }
    #  make some vars accessible for all imported plugins
    __builtins__['state'] = state
    __builtins__['config'] = config
    return (state, errors)
