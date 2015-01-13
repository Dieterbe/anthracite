%import datetime
%format = '%Y-%m-%d %H:%M:%SZ'
<table class="table table-striped table-condensed" 
<tr><th>Date-Time</th><th>Description</th><th>Operations</th></tr>
%for event in events:
    %row_class = ''
    %if event.outage is not None:
        %row_class = 'error'
        %if 'resolved' in event.tags:
            %css_class = 'success'
        %elif 'detected' in event.tags:
            %css_class = 'warning'
        %end
    %end
  <tr class="{{row_class}}">
    <td>{{datetime.datetime.utcfromtimestamp(event.timestamp).strftime(format)}}</td>
    <td>
        {{!event.desc}}
        <br/>
            % for tag in event.tags:
                %tag_classes_eq = {'resolved': 'success', 'detected': 'warning', 'start': 'important', 'outage=': 'inverse'}
                %tag_classes_startswith = {'outage=': 'inverse'}
                %tag_class = 'info'
                %if tag in tag_classes_eq:
                    %tag_class = tag_classes_eq[tag]
                %else:
                    %for (k,v) in tag_classes_startswith.items():
                        %if tag.startswith(k):
                            %tag_class = tag_classes_startswith[k]
                            %break
                        %end
                    %end
                %end
                <span class="label label-{{tag_class}}">{{tag}}</span>
            %end
        % for k, v in event.extra_attributes.items():
            <br/><span class="text-info">{{k}}</span>:
            &nbsp;&nbsp;
            % if type(v) is list:
                % for val in v:
                    <span class="label">{{val}}</span>
                % end
            % else:
                {{v}}
            %end
        %end
    </td>
    <td>
        <a href="/events/view/{{event.event_id}}"><i class="icon-zoom-in"></i></a>
        <a href="/events/edit/{{event.event_id}}"><i class="icon-pencil"></i></a>
        <a href="#" event_id="{{event.event_id}}" class="delete-link"><i class="icon-remove"></i></a>
    </td>
  </tr>
%end
<script>
    $('.delete-link').on("click", function(e) {
        bootbox.confirm("Are you sure you want to delete this event?", function(result) {
          if(result) {
              window.location.href = "/events/delete/" + e.currentTarget.getAttribute("event_id");
          }
        });
    });
</script>
</table>
