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
        event = tuple(line.rstrip("\r").split(" ", 2))
        try:
            event = Event(timestamp=int(event[0]), desc=event[2], tags=[event[1]])
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
print "anthracite receiver listening on port 2005"
reactor.run()
