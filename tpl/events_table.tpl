%import datetime
%format = '%Y-%m-%d %H:%M:%S'
<table class="table table-striped table-condensed" 
<tr><th>Date-Time</th><th>Description</th><th>Operations</th></tr>
%for row in rows:
  <tr>
    <td>{{datetime.datetime.fromtimestamp(row[1]).strftime(format)}}</td>
    <td>
        {{!row[2]}}
        <br/>
            % for tag in row[3]:
                <span class="label label-info">{{tag}}</span>
            %end
    </td>
    <td>
        <!-- TODO <a href="/events/edit/{{row[0]}}"><i class="icon-pencil"></i></a> -->
        <a href="#" event_id="{{row[0]}}" class="delete-link"><i class="icon-remove"></i></a>
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
