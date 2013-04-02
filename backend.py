import sqlite3


class Event():

    def __init__(self, timestamp=None, desc=None, tags=[], rowid=None):
        if not timestamp:
            raise Exception("timestamp must be set")
        if not desc:
            raise Exception("desc must be set to a non-zero string")
        self.timestamp = timestamp
        self.desc = desc
        self.tags = tags  # just a list of strings
        self.rowid = rowid

    def __str__(self):
        pretty_desc = self.desc
        if "\n" in self.desc:
            pretty_desc = "%s..." % self.desc[:self.desc.find('\n')]
        return "Event object. rowid=%s, ts=%i, tags=%s, desc=%s" % (str(self.rowid), self.timestamp, ','.join(self.tags), pretty_desc)

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

    def __init__(self, db, exists=False):
        self.conn = sqlite3.connect(db)
        self.cursor = self.conn.cursor()
        self.exists = exists  # only set this to True if you're sure the db is already set up correctly

    def assure_db(self):
        if self.exists:
            return True
        self.cursor.execute("""CREATE TABLE IF NOT EXISTS tags
                (tag_id text primary key)""")
        self.cursor.execute("""CREATE TABLE IF NOT EXISTS events
                (time int, desc text)""")
        self.cursor.execute("""CREATE TABLE IF NOT EXISTS events_tags
                (tag_id text, event_id integer,
                FOREIGN KEY(tag_id) REFERENCES tags(tag_id),
                FOREIGN KEY(event_id) REFERENCES events(ROWID))""")
        self.exists = True

    def add_event(self, event):
        """
        can raise sqlite3 exceptions and any other exception means something's wrong with the data
        """
        # TODO transaction, performance
        self.assure_db()
        for tag in event.tags:
            self.cursor.execute("INSERT OR IGNORE INTO tags (tag_id) VALUES (?)", (tag,))
        self.cursor.execute("INSERT INTO events VALUES (?,?)", (event.timestamp, event.desc))
        event_id = self.cursor.lastrowid
        for tag_id in event.tags:
            self.cursor.execute("INSERT INTO events_tags VALUES (?,?)", (tag_id, event_id))
        self.conn.commit()

    def delete_event(self, event_id):
        self.assure_db()
        # TODO transaction
        self.cursor.execute("DELETE FROM events_tags WHERE event_id == " + str(event_id))
        self.cursor.execute("DELETE FROM events WHERE ROWID == " + str(event_id))
        self.conn.commit()
        # note, this doesn't check if the event existed in the first place..

    def edit_event(self, event):
        self.assure_db()
        self.cursor.execute('''UPDATE events SET time=(?), desc=(?) WHERE ROWID ==(?)''', (event.timestamp, event.desc, event.rowid))
        self.cursor.execute('''DELETE from events_tags WHERE event_id == (?)''', (event.rowid,))
        for tag in event.tags:
            self.cursor.execute("INSERT OR IGNORE INTO tags (tag_id) VALUES (?)", (tag,))
            self.cursor.execute("INSERT INTO events_tags VALUES (?,?)", (tag, event.rowid))
        self.conn.commit()

    def get_event_rows(self):
        self.assure_db()
        # retuns a list of lists like (rowid int, timestamp int, desc str, tags [])
        # TODO performance
        #self.cursor.execute("""SELECT events.ROWID, events.time, events.desc, tags.tag_id
        #    FROM events, events_tags, tags
        #    WHERE events.ROWID == events_tags.event_id AND events_tags.tag_id == tags.tag_id
        #    ORDER BY time DESC""")
        self.cursor.execute('SELECT events.ROWID, events.time, events.desc FROM events ORDER BY events.time DESC')
        rows = self.cursor.fetchall()
        for (i, row) in enumerate(rows):
            rows[i] = list(rows[i])
            rows[i].append(self.event_get_tags(row[0]))
        return rows

    def get_events(self):
        self.assure_db()
        # retuns a list of event objects
        # TODO performance
        self.cursor.execute('SELECT events.ROWID, events.time, events.desc FROM events ORDER BY events.time DESC')
        rows = self.cursor.fetchall()
        events = []
        for row in rows:
            events.append(Event(timestamp=row[1], desc=row[2], tags=self.event_get_tags(row[0]), rowid=row[0]))
        return events

    def get_event(self, rowid):
        self.assure_db()
        self.cursor.execute('SELECT events.time, events.desc FROM events WHERE events.ROWID = %i' % rowid)
        event = self.cursor.fetchone()
        event = Event(timestamp=event[0], desc=event[1], tags=self.event_get_tags(rowid), rowid=rowid)
        return event

    def event_get_tags(self, event_id):
        self.assure_db()
        self.cursor.execute('SELECT tag_id FROM events_tags WHERE event_id == %i' % event_id)
        return [row[0] for row in self.cursor.fetchall()]

    def get_tags(self):
        self.assure_db()
        self.cursor.execute("""SELECT tag_id FROM tags""")
        return [row[0] for row in self.cursor.fetchall()]

    def get_events_range(self):
        self.assure_db()
        self.cursor.execute("""select time from events order by time desc limit 1""")
        high = self.cursor.fetchone()[0]
        self.cursor.execute("""select time from events order by time asc limit 1""")
        low = self.cursor.fetchone()[0]
        return (low, high)

    def get_events_count(self):
        self.assure_db()
        self.cursor.execute("""SELECT count(*) FROM events""")
        return self.cursor.fetchone()[0]

    def get_outage_events(self):
        # TODO sanity checking (order of detected, resolved tags, etc)
        self.assure_db()
        self.cursor.execute("""SELECT events.ROWID, events.time, events.desc
        FROM events, events_tags
        WHERE events_tags.tag_id LIKE "outage=_%" AND events_tags.event_id = events.ROWID ORDER BY events.time ASC""")
        events = self.cursor.fetchall()
        event_objects = []
        for (i, event) in enumerate(events):
            event_object = Event(timestamp=event[1], desc=event[2], tags=self.event_get_tags(event[0]), rowid=event[0])
            event_objects.append(event_object)
        return event_objects
