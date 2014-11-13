%import datetime
%format = '%Y-%m-%d %H:%M:%S'

<div class="row" xmlns="http://www.w3.org/1999/html">
    <br>

    <div class="col-md-6">
        <h4>Filter by User</h4>

        <div class="filter-user">
        <form>
            % for owner in set([x.extra_attributes['owner'] for x in events]):
            % if ";" not in owner:
            <div style="float:left; overflow:hidden; padding-left:15px">
            <label>
                <input type="checkbox" name="user" value="{{owner.replace(' ', '-')}}" id="{{owner.replace(' ', '-')}}">
                {{owner}}
            </label>
            </div>
            % end
            % end
        </form>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-6">
        <h4>Filter by Status</h4>
        <div class="filter-status">
            <form>
            <fieldset>
            <div style="float:left; overflow:hidden; padding-left:15px">
            <label>
                <input type="checkbox" name="status" value="open" id="open"/>
                Open
            </label>
            </div>

            <div style="float:left; overflow:hidden; padding-left:15px">
            <label>
                <input type="checkbox" name="status" value="ignore" id="ignore"/>
                Ignore
            </label>
            </div>

            <div style="float:left; overflow:hidden; padding-left:15px">
            <label>
                <input type="checkbox" name="status" value="closed" id="closed"/>
                Closed
            </label>
            </div>
        </fieldset>
        </form>
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
<tr><th></th><th>Date-Time</th><th>Description</th><th>Operations</th></tr>
    <tbody>
    %for i, event in enumerate(events):
        % event_type = event.tags[0]
            % owner = event.extra_attributes['owner'].replace(' ', '-')
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
  <tr class="event" data-id="{{event.event_id}}" data-category="{{owner}} {{status}}"><!-- href="/events/edit/{{event.event_id}}">-->
    <td>
        <div class="btn-group-vertical">
        <a data-id="{{event.event_id}}" href="#modal-ignore" role="button" class="open-modal-ignore btn" data-toggle="modal">Ignore</a>
        <a data-id="{{event.event_id}}" href="#modal-reassign" role="button" class="open-modal-reassign btn" data-toggle="modal">Reassign</a>
        <a data-id="{{event.event_id}}" href="#modal-close" role="button" class="open-modal-close btn" data-toggle="modal">Close</a>
        <a data-id="{{event.event_id}}" href="#modal-comment" role="button" class="open-modal-comment btn btn-primary" data-toggle="modal">Comment</a>
        </div>
    </td>
    <td>{{datetime.datetime.fromtimestamp(event.timestamp).strftime(format)}}</td>
    <td>
        <b>{{!event.desc}}</b>
        <br/>
        <br>
        % comments = ''
        % resolution = ''
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

        <!-- don't show valid flag -->
        % del event.extra_attributes['valid']

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
            % if k == 'comments':
               % comments = v
            % end
            % if k == 'resolution':
                % resolution = v
            % end

        %end
        <br>
        % if comments != '' or resolution != '':
        <hr>
        <b>Comments:</b> &nbsp {{comments}} {{resolution}}

        % end
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




 <!-- Close Modal -->

  <div id="modal-close" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modal1" aria-hidden="true">
    <div class="modal-dialog">
    <div class="modal-content">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
      <h3 id="closeLabel">Enter resolution</h3>
    </div>

    <div class="modal-body">
     <form id="modal-form-close" method="post">

      <!-- have to pass these fields for events_edit_post_script(), but their values get overwritten -->
      <input type="hidden" name="event_timestamp" value="GARBAGE">
      <input type="hidden" name="event_desc" value="GARBAGE">

      <!-- now for the attributes that matter -->
      <input type="hidden" name="status"  value="closed">
      <input type="hidden" name="event_id" id="close-event_id" value="">
      <input type="text" name="resolution"  value="">

     </form>
    </div>

    <div class="modal-footer">
      <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
      <button id="close-submit" class="btn btn-primary" data-dismiss="modal">Save changes</button>
    </div>
    </div>
    </div>
    </div>

<!-- Ignore Modal -->

  <div id="modal-ignore" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modal1" aria-hidden="true">
    <div class="modal-dialog">
    <div class="modal-content">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
      <h3 id="ignoreLabel">Ignore for how many days?</h3>
    </div>

    <div class="modal-body">
     <form id="modal-form-ignore" method="post">

      <!-- have to pass these fields for events_edit_post_script(), but their values get overwritten -->
      <input type="hidden" name="event_timestamp" value="GARBAGE">
      <input type="hidden" name="event_desc" value="GARBAGE">

      <!-- now for the attributes that matter -->
      <input type="hidden" name="status"  value="ignore">
      <input type="hidden" name="event_id" id="ignore-event_id" value="">
      <input type="text" name="ignore"  value="">

     </form>
    </div>

    <div class="modal-footer">
      <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
      <button id="ignore-submit" class="btn btn-primary" data-dismiss="modal">Save changes</button>
    </div>
    </div>
    </div>
    </div>

<!-- Reassign Modal -->

  <div id="modal-reassign" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modal1" aria-hidden="true">
    <div class="modal-dialog">
    <div class="modal-content">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
      <h3 id="reassignLabel">Reassign to whom?</h3>
    </div>

    <div class="modal-body">
     <form id="modal-form-reassign" method="post">

      <!-- have to pass these fields for events_edit_post_script(), but their values get overwritten -->
      <input type="hidden" name="event_timestamp" value="GARBAGE">
      <input type="hidden" name="event_desc" value="GARBAGE">

      <!-- now for the attributes that matter -->
      <input type="hidden" name="event_id" id="reassign-event_id" value="">
      <select name="owner" id="owner">
          % for name in set([x.extra_attributes['owner'] for x in events]):
          % if ";" not in name:
              <option value="{{name}}">{{name}}</option>
          % end
          % end
      </select>

     </form>


    </div>

    <div class="modal-footer">
      <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
      <button id="reassign-submit" class="btn btn-primary" data-dismiss="modal">Save changes</button>
    </div>
    </div>
    </div>
    </div>

<!-- Comment Modal -->

  <div id="modal-comment" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modal1" aria-hidden="true">
    <div class="modal-dialog">
    <div class="modal-content">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
      <h3 id="editLabel">Record Comments</h3>
    </div>

    <div class="modal-body">
     <form id="modal-form-comment" method="post">

      <!-- have to pass these fields for events_edit_post_script(), but their values get overwritten -->
      <input type="hidden" name="event_timestamp" value="GARBAGE">
      <input type="hidden" name="event_desc" value="GARBAGE">

      <!-- now for the attributes that matter -->
      <input type="hidden" name="event_id" id="comment-event_id" value="">
      <input type="text" name="comments" size="500" value="">
     </form>


    </div>

    <div class="modal-footer">
      <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
      <button id="comment-submit" class="btn btn-primary" data-dismiss="modal">Save changes</button>
    </div>
    </div>
    </div>
    </div>


<!-- submit JS for close modal -->
<script>
$(function(){
$('button#close-submit').on('click', function(e){
      e.preventDefault();
      var eventID = $('#close-event_id').val();
      $.ajax({
              url: '/events/edit/' + eventID + '/script',
              data: $('#modal-form-close').serialize(),
              type: 'POST',
              error: function(data){
                  alert('something went wrong')
              }
         });
    $('#modal-close').dialog('close');
     return false;
    });
});
</script>

<!-- get Event ID for close modal -->
<script>
    $(document).on('click', '.open-modal-close', function(e){
        e.preventDefault();
        var _self = $(this);
        var eventID = _self.data('id');
        $('#close-event_id').val(eventID);

        $(_self.attr('href')).modal('show');
    });

</script>



<!-- submit JS for ignore modal -->
<script>
$(function(){
$('button#ignore-submit').on('click', function(e){
      e.preventDefault();
      var eventID = $('#ignore-event_id').val();
      $.ajax({
              url: '/events/edit/' + eventID + '/script',
              data: $('#modal-form-ignore').serialize(),
              type: 'POST',
              error: function(data){
                  alert('something went wrong')
              }
         });
    $('#modal-ignore').dialog('close');
     return false;
    });
});
</script>

<!-- get Event ID for ignore modal -->
<script>
    $(document).on('click', '.open-modal-ignore', function(e){
        e.preventDefault();
        var _self = $(this);
        var eventID = _self.data('id');
        $('#ignore-event_id').val(eventID);

        $(_self.attr('href')).modal('show');
    });

</script>


<!-- submit JS for reassign modal -->
<script>
$(function(){
$('button#reassign-submit').on('click', function(e){
      e.preventDefault();
      var eventID = $('#reassign-event_id').val();
      $.ajax({
              url: '/events/edit/' + eventID + '/script',
              data: $('#modal-form-reassign').serialize(),
              type: 'POST',
              error: function(data){
                  alert('something went wrong')
              }
         });
    $('#modal-reassign').dialog('close');
     return false;
    });
});
</script>

<!-- get Event ID for reassign modal -->
<script>
    $(document).on('click', '.open-modal-reassign', function(e){
        e.preventDefault();
        var _self = $(this);
        var eventID = _self.data('id');
        $('#reassign-event_id').val(eventID);

        $(_self.attr('href')).modal('show');
    });

</script>

<!-- submit JS for comment modal -->
<script>
$(function(){
$('button#comment-submit').on('click', function(e){
      e.preventDefault();
      var eventID = $('#comment-event_id').val();
      $.ajax({
              url: '/events/edit/' + eventID + '/script',
              data: $('#modal-form-comment').serialize(),
              type: 'POST',
              error: function(data){
                  alert('something went wrong')
              }
         });
    $('#modal-comment').dialog('close');
     return false;
    });
});
</script>

<!-- get Event ID for reassign modal -->
<script>
    $(document).on('click', '.open-modal-comment', function(e){
        e.preventDefault();
        var _self = $(this);
        var eventID = _self.data('id');
        $('#comment-event_id').val(eventID);

        $(_self.attr('href')).modal('show');
    });

</script>




<!-- delete event -->
<script>
    $('.delete-link').on("click", function(e) {
        bootbox.confirm("Are you sure you want to delete this event?", function(result) {
          if(result) {
              window.location.href = "/events/delete/" + e.currentTarget.getAttribute("event_id");
          }
        });
    });
</script>




<!-- try new implementation here http://jsfiddle.net/n3EmN/3/ -->
<script>        
var byUser = [], byStatus = [], byLocation = [];
		
		$("input[name=user]").on( "change", function() {
			if (this.checked) byUser.push("[data-category~='" + $(this).attr("value") + "']");
			else removeA(byUser, "[data-category~='" + $(this).attr("value") + "']");
		});
		
		$("input[name=status]").on( "change", function() {
			if (this.checked) byStatus.push("[data-category~='" + $(this).attr("value") + "']");
			else removeA(byStatus, "[data-category~='" + $(this).attr("value") + "']");
		});

		
		$("input").on( "change", function() {
			var str = "Include items \n";
			var selector = '', cselector = '', nselector = '';
					
			var $lis = $('table > tbody > tr'),
				$checked = $('input:checked');	
				
			if ($checked.length) {	
			
				if (byUser.length) {		
					if (str == "Include items \n") {
						str += "    " + "with (" +  byUser.join(',') + ")\n";				
						$($('input[name=user]:checked')).each(function(index, byUser){
							if(selector === '') {
								selector += "[data-category~='" + byUser.id + "']";  					
							} else {
								selector += ",[data-category~='" + byUser.id + "']";	
							}				 
						});					
					} else {
						str += "    AND " + "with (" +  byUser.join(' OR ') + ")\n";				
						$($('input[name=status]:checked')).each(function(index, byUser){
							selector += "[data-category~='" + byUser.id + "']";
						});
					}							
				}
				
				if (byStatus.length) {						
					if (str == "Include items \n") {
						str += "    " + "with (" +  byStatus.join(' OR ') + ")\n";					
						$($('input[name=status]:checked')).each(function(index, byStatus){
							if(selector === '') {
								selector += "[data-category~='" + byStatus.id + "']";  					
							} else {
								selector += ",[data-category~='" + byStatus.id + "']";	
							}				 
						});					
					} else {
						str += "    AND " + "with (" +  byStatus.join(' OR ') + ")\n";				
						$($('input[name=status]:checked')).each(function(index, byStatus){
							if(cselector === '') {
								cselector += "[data-category~='" + byStatus.id + "']";  					
							} else {
								cselector += ",[data-category~='" + byStatus.id + "']";	
							}					
						});
					}			
				}

				
				$lis.hide(); 
				console.log(selector);
				console.log(cselector);
				console.log(nselector);
				
				if (cselector === '' && nselector === '') {			
					$('table > tbody > tr').filter(selector).show();
				} else if (cselector === '') {
					$('table > tbody > tr').filter(selector).filter(nselector).show();
				} else if (nselector === '') {
					$('table > tbody > tr').filter(selector).filter(cselector).show();
				} else {
					$('table > tbody > tr').filter(selector).filter(cselector).filter(nselector).show();
				}
				
			} else {
				$lis.show();
			}	
								  
			$("#result").html(str);	
	
		});
		
		function removeA(arr) {
			var what, a = arguments, L = a.length, ax;
			while (L > 1 && arr.length) {
				what = a[--L];
				while ((ax= arr.indexOf(what)) !== -1) {
					arr.splice(ax, 1);
				}
			}
			return arr;
		}
</script>


<!-- http://stackoverflow.com/questions/5430254/jquery-selecting-table-rows-with-checkbox -->


<script>
jQuery(document).ready(function ($) {
    $('.nav-tabs a').click(function (e) {
      e.preventDefault();
      $(this).tab('show');
    });
});
</script>


<!--script>
    jQuery(document).ready(function($) {
      $(".event").click(function() {
            window.document.location = $(this).attr("href");
      });
});
</script>-->



