import sqlite3


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
        event_time = int(event[0])
        event_type = str(event[1])
        event_desc = str(event[2])
        if (len(event_type) < 1):
            raise Exception("event_type must be a non-zero string")
        if (len(event_desc) < 1):
            raise Exception("event_desc must be a non-zero string")

        self.assure_db()
        self.cursor.execute("INSERT OR IGNORE INTO event_types (name) VALUES (?)", (event_type,))
        self.cursor.execute("SELECT type_id FROM event_types WHERE name =?", (event_type,))
        type_id = self.cursor.fetchone()[0]
        self.cursor.execute("INSERT INTO events VALUES (?,?,?)", (type_id, event_time, event_desc))
        self.conn.commit()

    def get_events(self):
        self.assure_db()
        self.cursor.execute("""SELECT events.time, event_types.name, events.desc
            FROM events, event_types
            WHERE events.type_id == event_types.type_id
            ORDER BY time DESC""")
        return self.cursor.fetchall()

    def get_events_count(self):
        self.assure_db()
        self.cursor.execute("""SELECT count(*) FROM events""")
        return self.cursor.fetchone()[0]
