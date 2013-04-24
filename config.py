listen_host = '0.0.0.0'  # defaults to "all interfaces"
listen_port = 8081
opsreport_start = '01/01/2013 12:00:00 AM'
timezone = "America/New_York"

# list of tuples: first value of the tuple is a tag that you recommend/make
# extra visible on the forms, and 2nd value is a user friendly explanation.
recommended_tags = [
    ('Marketing', 'campaign launches/changes, strategy changes, ..'),
    ('TrackingError', 'problem with Google Analytics tracking'),
    ('Product', 'feature launches/changes'),
    ('SiteActivity', 'i.e. famous person joins vimeo and brings his following'),
    ('Promotion', 'partnerships/events/ad sales'),
    ('External', 'factor we dont control (google algorithm, FB sharing, ISP problems, ...)'),
    ('logins', 'engineering change to logins'),
    ('registration', 'engineering change to registration'),
    ('conversion', 'engineering change to conversion'),
    ('plays', 'engineering change to plays'),
    ('uploads', 'engineering change to uploads')
    #('start', 'start of an outage, campaign, ..'),
    #('detected', 'detected an issue(outage'),
    #('resolved', 'resolved an outage')
]

# use this to add optional fields to your event documents:
# i.e. you can create events that have the field set, and ones that don't. and
# you can add it later if you have to.

optional_fields = [
    ('outage', 'key to uniquely identify particular outages'),
    ('expected_result', 'text to describe expected result for this change')
]
