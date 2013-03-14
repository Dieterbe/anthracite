%import datetime
%format = '%Y-%m-%d %H:%M:%S'
<table class="table table-striped table-condensed" 
<tr><th>Date-Time</th><th>Description</th><th>Operations (TODO not implemented yet)</th></tr>
%for row in rows:
  <tr>
    <td>{{datetime.datetime.fromtimestamp(row[1]).strftime(format)}}</td>
    <td>
        {{row[2]}}
        <br/>
            % for tag in row[3]:
                <span class="label label-info">{{tag}}</span>
            %end
    </td>
    <td>
        <a href="/events/edit/{{row[0]}}"><i class="icon-pencil"></i></a>
        <a href="/events/delete/{{row[0]}}"><i class="icon-remove"></i></a>
    </td>
  </tr>
%end
</table>
