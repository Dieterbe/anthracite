class Attribute:
    '''
    choices:
    * False: freeform input
    * []: must be one of the values in the list
    * a list with 1 value means "has this value, and is not editable by user"
    '''
    def __init__(self, key, label, mandatory=False, choices=False, select_many=False):
        self.key = key
        self.label = label
        self.mandatory = mandatory
        self.choices = choices
        self.select_many = select_many

    def freeform(self):
        return (type(self.choices) is not list)

    def __str__(self):
        return "Attribute(key '%s', label '%s', mandatory %s)" % (self.key, self.label, self.mandatory)
