<html><head><title>Anthracite nalytics table</title></head>
<body>
%import datetime
%format = '%Y-%m-%d %H:%M:%S'
<table class="table table-striped table-condensed">
<tr><th>Date-Time</th><th>Description</th><th>Tags</th><th>Expected result</th><th>Operations</th></tr>
%for event in events:
  <tr>
    %#datetime.datetime.fromtimestamp(event[1]).strftime(format)
    <td>{{event[1]}}</td>
    <td>{{!event[2]}}</td>
    <td>{{event[3]}}</td>
    <td>{{event[4]}}</td>
    <td>
        <a href="/events/edit/{{event[0]}}"><i class="icon-pencil"></i></a>
        <a href="#" event_id="{{event[0]}}" class="delete-link"><i class="icon-remove"></i></a>
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
</body>
