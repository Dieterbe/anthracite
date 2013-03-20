#!/usr/bin/env python2
from twisted.internet.protocol import Factory
from twisted.protocols.basic import LineReceiver
from twisted.internet import reactor
from backend import Backend, Event
import sqlite3
import sys


class Store(LineReceiver):

    def __init__(self, db):
        # each TCP request handler gets its own sqlite cursor
        # this should be sufficient for proper concurrent behavior,
        # but if anyone can confirm this, that would be appreciated
        self.backend = Backend(db, exists=True)
        # support both \n and (default) \r\n delimiters
        # http://stackoverflow.com/questions/5087559/twisted-server-nc-client
        self.delimiter = "\n"

    def lineReceived(self, line):
        # line: <timestamp> <some> <tags=here> -- description text of the event goes here
        event = line.rstrip("\r").split(" -- ", 1)
        event[0] = event[0].split(' ', 1)
        timestamp = int(event[0][0])
        tags = event[0][1].split(' ')
        desc = event[1]
        try:
            event = Event(timestamp=timestamp, desc=desc, tags=tags)
            print "line:", line
            self.backend.add_event(event)
        except sqlite3.OperationalError, e:
            sys.stderr.write("sqlite error, aborting. : %s" % e)
            sys.exit(2)
        except Exception, e:
            sys.stderr.write("bad line: %s  --> error: %s\n" % (line, e))


class StoreFactory(Factory):

    def __init__(self, db):
        self.db = db
        self.backend = Backend(db)
        try:
            self.backend.assure_db()
        except sqlite3.OperationalError, e:
            sys.stderr.write("sqlite error, aborting. : %s" % e)
            sys.exit(2)

    def buildProtocol(self, addr):
        return Store(self.db)

reactor.listenTCP(2005, StoreFactory("anthracite.db"))
print "anthracite TCP receiver listening on port 2005"
print "only supports single-line events."
print "use anthracite-web to get multi-line event support"
reactor.run()
