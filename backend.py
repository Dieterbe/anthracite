import sqlite3

class Event():

    def __init__(self, desc=None, t=None, timestamp=None):
        if not desc:
            raise Exception("desc must be set to a non-zero string")
        if not t:
            raise Exception("type must be set to a non-zero string")
        if not timestamp:
            raise Exception("timestamp must be set")
        self.desc = desc
        self.t = t
        self.timestamp = timestamp

class Backend():

    def __init__(self, db, exists=False):
        self.conn = sqlite3.connect(db)
        self.cursor = self.conn.cursor()
        self.exists = exists  # only set this to True if you're sure the db is already set up correctly

    def assure_db(self):
        if self.exists:
            return True
        self.cursor.execute("""CREATE TABLE IF NOT EXISTS event_types
                (type_id integer primary key autoincrement, name text unique)""")
        self.cursor.execute("""CREATE TABLE IF NOT EXISTS events
                (type_id integer, time int, desc text,
                FOREIGN KEY(type_id) REFERENCES event_types(type_id))""")
        self.exists = True

    def add_event(self, event):
        """
        can raise sqlite3 exceptions and any other exception means something's wrong with the data
        """
        self.assure_db()
        self.cursor.execute("INSERT OR IGNORE INTO event_types (name) VALUES (?)", (event.t,))
        self.cursor.execute("SELECT type_id FROM event_types WHERE name =?", (event.t,))
        type_id = self.cursor.fetchone()[0]
        self.cursor.execute("INSERT INTO events VALUES (?,?,?)", (type_id, event.timestamp, event.desc))
        self.conn.commit()

    def get_events(self):
        self.assure_db()
        self.cursor.execute("""SELECT events.time, event_types.name, events.desc
            FROM events, event_types
            WHERE events.type_id == event_types.type_id
            ORDER BY time DESC""")
        return self.cursor.fetchall()

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
