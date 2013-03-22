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

    def get_events(self):
        self.assure_db()
        # retuns a list of lists like (rowid int, timestamp int, desc str, tags [])
        # TODO performance
        #self.cursor.execute("""SELECT events.ROWID, events.time, events.desc, tags.tag_id
        #    FROM events, events_tags, tags
        #    WHERE events.ROWID == events_tags.event_id AND events_tags.tag_id == tags.tag_id
        #    ORDER BY time DESC""")
        self.cursor.execute('SELECT events.ROWID, events.time, events.desc FROM events ORDER BY events.time DESC')
        events = self.cursor.fetchall()
        for (i, event) in enumerate(events):
            events[i] = list(events[i])
            events[i].append(self.event_get_tags(event[0]))
        return events

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

    def get_outages(self):
        self.assure_db()
        self.cursor.execute('SELECT tag_id FROM tags WHERE tag_id LIKE "outage=_%"')
        outage_tags = [row[0].encode() for row in self.cursor.fetchall()]
        outages = {}
        for outage_tag in outage_tags:
            self.cursor.execute("SELECT events.ROWID, events.time, events.desc FROM events, events_tags WHERE events_tags.tag_id = '%s' AND events_tags.event_id = events.ROWID ORDER BY events.time ASC" % outage_tag)
            events = self.cursor.fetchall()
            for (i, event) in enumerate(events):
                events[i] = list(events[i])
                events[i].append(self.event_get_tags(event[0]))
            relevant_events = []
            for event in events:
                if len(relevant_events) < 1 and 'start' in event[3]:
                    relevant_events.append(event)
                if len(relevant_events) < 2 and 'detect' in event[3]:
                    relevant_events.append(event)
                if len(relevant_events) < 3 and 'fix' in event[3]:
                    relevant_events.append(event)
            if len(relevant_events) != 3:
                import sys
                sys.stderr.write("warning. improper events for outage %s (need start,detect,fix in the right order)" % outage_tag)
            outages[outage_tag] = relevant_events
        for key in outages:
            print key
            for l in outages[key]:
                print l
        return outages
