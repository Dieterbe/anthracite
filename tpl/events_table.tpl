%import datetime
%format = '%Y-%m-%d %H:%M:%S'

<div class="row">
    <br>

    <div class="col-md-6">
        <h4>Filter by User</h4>
        <div class="filter-user">
            % for owner in set([x.extra_attributes['owner'] for x in events]):
            % if ";" not in owner:
            <div style="float:left; overflow:hidden; padding-left:15px">
            <label>
                <input type="checkbox" rel="{{owner}}"/>
                {{owner}}
            </label>
            </div>
            % end
            % end
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-6">
        <h4>Filter by Status</h4>
        <div class="filter-status">
            <div style="float:left; overflow:hidden; padding-left:15px">
            <label>
                <input type="checkbox" rel="open"/>
                Open
            </label>
            </div>

            <div style="float:left; overflow:hidden; padding-left:15px">
            <label>
                <input type="checkbox" rel="ignore"/>
                Ignore
            </label>
            </div>

            <div style="float:left; overflow:hidden; padding-left:15px">
            <label>
                <input type="checkbox" rel="closed"/>
                Closed
            </label>
            </div>
        </div>
    </div>
</div>


<br>

<ul class="nav nav-pills" data-tabs="tabs">
    <li class="active"><a href="#LateFiles" data-toggle="tab">Late Files</a></li>
    <li><a href="#DataQualityCheck" data-toggle="tab">Data Quality</a></li>
</ul>


<div class="tab-content">

% active_tab = "in active"
% for tab in ['LateFiles', 'DataQualityCheck']:

<div class="tab-pane fade {{active_tab}}" id="{{tab}}">

<table class="table table-hover table-condensed">
<tr><th>Date-Time</th><th>Description</th><th>Operations</th></tr>
    <tbody>
    %for i, event in enumerate(events):
        % event_type = event.tags[0]
            % owner = event.extra_attributes['owner']
            % status = event.extra_attributes['status']
            %row_class = ''
            %if event.outage is not None:
                %row_class = 'error'
                %if 'resolved' in event.tags:
                    %css_class = 'success'
                %elif 'detected' in event.tags:
                    %css_class = 'warning'
                %end
            %end

  % if event_type == tab:
  <!-- make this class="hide" if it's not equal to the value in the javascript-->
  <tr class="{{owner}} {{status}}">
    <td>{{datetime.datetime.fromtimestamp(event.timestamp).strftime(format)}}</td>
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
  </tbody>
   %end

</table>

</div>
% active_tab = ""
% end

</div>






<script>
    $('.delete-link').on("click", function(e) {
        bootbox.confirm("Are you sure you want to delete this event?", function(result) {
          if(result) {
              window.location.href = "/events/delete/" + e.currentTarget.getAttribute("event_id");
          }
        });
    });
</script>


<!-- http://stackoverflow.com/questions/5430254/jquery-selecting-table-rows-with-checkbox -->
<script>
var updateRows1 = function()
{
    // Get ones to show
    var toShow = [];
    $('div.filter-user input[type=checkbox]:checked').each(function(){
        var box = $(this);
        toShow.push('.' + box.attr('rel'));
    });
    toShow = toShow.join(', ');

    // Filter rows
    $('table > tbody > tr').each(function() {
        var row = $(this);
        row.toggle( row.is(toShow) );
    });
};
$('div.filter-user input[type=checkbox]').click(updateRows1);
updateRows1();
</script>

<script>
var updateRows2 = function()
{
    // Get ones to show
    var toShow = [];
    $('div.filter-status input[type=checkbox]:checked').each(function(){
        var box = $(this);
        toShow.push('.' + box.attr('rel'));
    });
    toShow = toShow.join(', ');

    // Filter rows
    $('table > tbody > tr ').each(function() {
        var row = $(this);
        row.toggle( row.is(toShow) );
    });
};
$('div.filter-status input[type=checkbox]').click(updateRows2);
updateRows2();
</script>


<script>
jQuery(document).ready(function ($) {
    $('.nav-tabs a').click(function (e) {
      e.preventDefault();
      $(this).tab('show');
    });
});
</script>



