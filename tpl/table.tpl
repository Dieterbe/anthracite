<table border="1">
<tr><th>time</th><th>type</th><th>description</th></tr>
%for row in rows:
  <tr>
  %for col in row:
    <td>{{col}}</td>
  %end
  </tr>
%end
</table>
