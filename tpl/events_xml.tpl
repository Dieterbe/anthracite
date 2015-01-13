<data>
%from time import strftime, gmtime
%for event in events:
    % # see http://simile-widgets.org/wiki/Timeline_EventSources#XML_Data_Format
    % start = strftime("%a, %b %d %Y %H:%M:%S +0000", gmtime(event['date']))
    % # for now, make title just the first line
    <event start="{{start}}" title="{{event['desc'][:event['desc'].find('\n')]}}">
        {{event['desc']}}
    </event>
%end
</data>
