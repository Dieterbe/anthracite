%import datetime
%format = '%Y-%m-%d %H:%M:%S'
<table class="table table-striped table-condensed" 
<tr><th>Time</th><th>Type</th><th>Description</th></tr>
%for row in rows:
  <tr>
    <td>{{datetime.datetime.fromtimestamp(row[0]).strftime(format)}}</td>
    <td>row[1]</td>
    <td>row[2]</td>
  </tr>
%end
</table>
