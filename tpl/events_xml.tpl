<data>
%from time import strftime, localtime
%for event in events:
    % # see http://simile-widgets.org/wiki/Timeline_EventSources#XML_Data_Format
    % start = strftime("%a, %b %d %Y %H:%M:%S +0000", localtime(event[0]))
    % type = event[1]
    % desc= event[2]
    % # for now, make title just the first line
    <event start="{{start}}" title="{{desc[:desc.find('\n')]}}">
        {{desc}}
    </event>
%end
</data>
