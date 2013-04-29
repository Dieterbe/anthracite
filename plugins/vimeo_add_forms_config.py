from model import Attribute
from config import extra_attributes as default_extra_attributes
from config import helptext as default_helptext

extra_attributes = {
    'engineering': [
        Attribute('expected_effect', 'Expected effect', True,
                  ['logins', 'registrations', 'conversion', 'plays', 'uploads', 'none'],
                  True),
        Attribute('known_effect', 'Known effect', False, False),
        Attribute('category', 'Analytics category', True, ['engineering'])
    ] + default_extra_attributes,
    'marketing': [
        Attribute('expected_effect', 'Expected effect', True,
                  ['registrations', 'conversion', 'conversion mix', 'retention', 'winback/returning', 'offsite engage', 'site traffic', 'none'],
                  True),
        Attribute('known_effect', 'Known effect', False, False),
        Attribute('landing_page', 'Landing page', True, False),
        Attribute('event_owner', 'Event owner', True,
                  ['Abe', 'Billy', 'Cameron', 'Diddy', 'Ellen', 'Franky-Z']),
        Attribute('category', 'Analytics category', True, ['marketing'])
    ],
    'analytics': [
        Attribute('expected_effect', 'Expected effect', True,
                  ['logins', 'registrations', 'conversion', 'conversion mix', 'plays', 'uploads', 'retention', 'winback/returning', 'offsite engage', 'site traffic', 'none'],
                  True),
        Attribute('category', 'Analytics category', True,
                  ['tracking_error', 'product', 'site_activity', 'promotion', 'external', 'engineering', 'marketing'])
    ] + default_extra_attributes
# TODO show this in help text labels again
#     ('Marketing', 'campaign launches/changes, strategy changes, ..'),
#     ('TrackingError', 'problem with Google Analytics tracking'),
#     ('Product', 'feature launches/changes'),
#     ('SiteActivity', 'i.e. famous person joins vimeo and brings his following'),
#     ('Promotion', 'partnerships/events/ad sales'),
#     ('External', 'factor we dont control (google algorithm, FB sharing, ISP problems, ...)'),
# ]

}
helptext = {
    'engineering': dict({
        'expected_outcome': 'Check all that apply'
    }.items() + default_helptext.items()),
    'marketing': {
        'event_desc': 'High-level yet detailed. What is the before state? Include product, messaging and targeting details. No longer than 2 sentences.',
        'landing_page': 'For marketing campaigns, where is traffic being driven, or what page changed? Ex: /upgrade1, /joinfree',
        'expected_outcome': 'Check all that apply',
        'event_owner': 'Go-to person for more info'
    },
    'analytics': dict({
        'expected_outcome': 'Check all that apply'
    }.items() + default_helptext.items())
}
