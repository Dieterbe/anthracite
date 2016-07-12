%import datetime
%format = '%Y-%m-%d %H:%M:%S'

<div class="row" xmlns="http://www.w3.org/1999/html">
    <br>
    To silence a warning temporarily, click <i>ignore</i>. <br>
    Use <i>close</i> to mark an item as resolved.  Note: this has a different behavior for each notification type <br>
    <ul>
    <li>Late Files: closed events will reopen if the file is still deemed late</li>
    <li>Quarantine: closed events will reopen if the file is still found in quarantine</li>
    <li>Data Quality Checks: closed events remain closed for the marked ToPeriod.  If values are still out of range
    next ToPeriod, a new notification is issued</li>
    <li>Build Failures: closed events remain closed forever</li>
    </ul>
	Current User: <a href="#modal-session" role="button" class="open-modal-session btn" data-toggle="modal" id="usersession">
	% if user:
		{{user}}
	% else:
		Unknown
	% end

</a>

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

<div class="row">
    <div class="col-md-6">
        <h4>Filter by Type</h4>
        <div class="filter-type">
            <form>
            <fieldset>
            <div style="float:left; overflow:hidden; padding-left:15px">
            <label>
                <input type="checkbox" name="type" value="LateFiles" id="LateFiles"/>
                Late Files
            </label>
            </div>

            <div style="float:left; overflow:hidden; padding-left:15px">
            <label>
                <input type="checkbox" name="type" value="Quarantine" id="Quarantine"/>
                Quarantine
            </label>
            </div>

            <div style="float:left; overflow:hidden; padding-left:15px">
            <label>
                <input type="checkbox" name="type" value="FileLoadErrors" id="FileLoadErrors"/>
                File Load Errors
            </label>
            </div>

            <div style="float:left; overflow:hidden; padding-left:15px">
            <label>
                <input type="checkbox" name="type" value="ConfigWarnings" id="ConfigWarnings"/>
                Configuration Warnings
            </label>
            </div>


            <div style="float:left; overflow:hidden; padding-left:15px">
            <label>
                <input type="checkbox" name="type" value="DataQualityCheck" id="DataQualityCheck"/>
                Data Quality
            </label>
            </div>

            <div style="float:left; overflow:hidden; padding-left:15px">
            <label>
                <input type="checkbox" name="type" value="BuildFailures" id="BuildFailures"/>
                Build Failures
            </label>
            </div>
        </fieldset>
        </form>
        </div>

    </div>
</div>

<div class="row">
    <div class="col-md-6">
        <h4>Filter by Environment</h4>
        <div class="filter-env">
            <form>
            <fieldset>
            <div style="float:left; overflow:hidden; padding-left:15px">
            <label>
                <input type="checkbox" name="env" value="etl-dev-nissan.private.square-root.com" id="etl-dev-nissan.private.square-root.com"/>
                etl-dev-nissan
            </label>
            </div>

            <div style="float:left; overflow:hidden; padding-left:15px">
            <label>
                <input type="checkbox" name="env" value="etl-stg-nissan.private.square-root.com" id="etl-stg-nissan.private.square-root.com"/>
                etl-stg-nissan
            </label>
            </div>

            <div style="float:left; overflow:hidden; padding-left:15px">
            <label>
                <input type="checkbox" name="env" value="etl-prd-nissan.private.square-root.com" id="etl-prd-nissan.private.square-root.com"/>
               etl-prd-nissan
            </label>

            </div>
                <div style="float:left; overflow:hidden; padding-left:15px">
            <label>
                <input type="checkbox" name="env" value="etl-dev-1.private.square-root.com" id="etl-dev-1.private.square-root.com"/>
               etl-dev-1
            </label>
            </div>
                <div style="float:left; overflow:hidden; padding-left:15px">
            <label>
                <input type="checkbox" name="env" value="etl-stg-1.private.square-root.com" id="etl-stg-1.private.square-root.com"/>
               etl-stg-1
            </label>
            </div>
                <div style="float:left; overflow:hidden; padding-left:15px">
            <label>
                <input type="checkbox" name="env" value="etl-prd-1.private.square-root.com" id="etl-prd-1.private.square-root.com"/>
               etl-prd-1
            </label>
            </div>

                <div style="float:left; overflow:hidden; padding-left:15px">
            <label>
                <input type="checkbox" name="env" value="etl-dev-vw-1.private.square-root.com" id="etl-dev-vw-1.private.square-root.com"/>
               etl-dev-vw-1
            </label>
            </div>

                <div style="float:left; overflow:hidden; padding-left:15px">
            <label>
                <input type="checkbox" name="env" value="etl-stg-vw-1.private.square-root.com" id="etl-stg-vw-1.private.square-root.com"/>
               etl-stg-vw-1
            </label>
            </div>

                <div style="float:left; overflow:hidden; padding-left:15px">
            <label>
                <input type="checkbox" name="env" value="etl-prd-vw-1.private.square-root.com" id="etl-prd-vw-1.private.square-root.com"/>
               etl-prd-vw-1
            </label>
            </div>

                <div style="float:left; overflow:hidden; padding-left:15px">
            <label>
                <input type="checkbox" name="env" value="etl-dev-mt-1.private.square-root.com" id="etl-dev-mt-1.private.square-root.com"/>
               etl-dev-mt-1
            </label>
            </div>

                <div style="float:left; overflow:hidden; padding-left:15px">
            <label>
                <input type="checkbox" name="env" value="etl-stg-mt-1.private.square-root.com" id="etl-stg-mt-1.private.square-root.com"/>
               etl-stg-mt-1
            </label>
            </div>

                <div style="float:left; overflow:hidden; padding-left:15px">
            <label>
                <input type="checkbox" name="env" value="etl-prd-mt-1.private.square-root.com" id="etl-prd-mt-1.private.square-root.com"/>
               etl-prd-mt-1
            </label>
            </div>

        <br>
        </fieldset>
        </form>
        </div>

    </div>
</div>

<!--
<pre id="result"></pre>
-->

<table class="table table-hover table-condensed" id="resultsTable">
<tr><th></th><th>Date-Time</th><th>Description</th><th>Operations</th></tr>
    <tbody id="myTable">
    %for i, event in enumerate(events):
        % event_type = event.tags[0]
            % owner = event.extra_attributes['owner'].replace(' ', '-')
            % status = event.extra_attributes['status']
            % if event.extra_attributes.has_key('host'):
                % env = event.extra_attributes['host']
            % else:
                % env = 'UNKNOWN'
            % end
            %row_class = ''
            %if event.outage is not None:
                %row_class = 'error'
                %if 'resolved' in event.tags:
                    %css_class = 'success'
                %elif 'detected' in event.tags:
                    %css_class = 'warning'
                %end
            %end

  <tr class="event" data-id="{{event.event_id}}" data-category="{{owner}} {{status}} {{event_type}} {{env}}"><!-- href="/events/edit/{{event.event_id}}">-->
    <td>
        <div class="btn-group-vertical">
	% if user:
        <a data-id="{{event.event_id}}" href="#modal-ignore" role="button" class="open-modal-ignore btn" data-toggle="modal">Ignore</a>
        <a data-id="{{event.event_id}}" href="#modal-reassign" role="button" class="open-modal-reassign btn" data-toggle="modal">Reassign</a>
        <a data-id="{{event.event_id}}" href="#modal-close" role="button" class="open-modal-close btn" data-toggle="modal">Close</a>
        <a data-id="{{event.event_id}}" href="#modal-comment" role="button" class="open-modal-comment btn btn-primary" data-toggle="modal">Comment</a><br>
        <a data-id="{{event.event_id}}" href="#modal-quality" role="button" class="open-modal-quality btn btn-info" data-toggle="modal">Feedback</a>
	% else:
	
        <a href="#modal-unknown" role="button" class="open-modal-ignore btn" data-toggle="modal">Ignore</a>
        <a href="#modal-unknown" role="button" class="open-modal-reassign btn" data-toggle="modal">Reassign</a>
        <a href="#modal-unknown" role="button" class="open-modal-close btn" data-toggle="modal">Close</a>
        <a href="#modal-unknown" role="button" class="open-modal-comment btn btn-primary" data-toggle="modal">Comment</a><br>
        <a href="#modal-unknown" role="button" class="open-modal-quality btn btn-info" data-toggle="modal">Feedback</a>
	% end
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
        % if 'comments' in event.extra_attributes:
            % comments = event.extra_attributes['comments']
            % del event.extra_attributes['comments']
        % end

        % if 'resolution' in event.extra_attributes:
            % resolution = event.extra_attributes['resolution']
            % del event.extra_attributes['resolution']
        % end


        % for k, v in event.extra_attributes.items():
        <!-- don't show comments/resolution in tags -->
            <br/><span class="text-info">{{k}}</span>:
            &nbsp;&nbsp;
            % if type(v) is list:
                % for val in v:
                    <span class="label">{{val}}</span>
                % end
            % else:
                <span id="{{event.event_id}}-{{k}}">{{!v}}</span>
            % end
        %end

        % if comments != '':
        <hr>
        <b>Comments:</b> <br> {{!comments}}
        % end

        % if resolution != '':
        <hr>
        <b>Resolution:</b> &nbsp {{resolution}}
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

</table>




 <!-- Close Modal -->

  <div id="modal-close" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modal1" aria-hidden="true">
    <form id="modal-form-close" method="post">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
      <h3 id="closeLabel">Enter resolution</h3>
    </div>

    <div class="modal-body">

      <!-- have to pass these fields for events_edit_post_script(), but their values get overwritten -->
      <input type="hidden" name="event_timestamp" value="GARBAGE">
      <input type="hidden" name="event_desc" value="GARBAGE">

      <!-- now for the attributes that matter -->
      <input type="hidden" name="status"  value="closed">
      <input type="hidden" name="event_id" id="close-event_id" value="">
      <input type="text" name="resolution"  value="" id="close-form-resolution" required>
    </div>

    <div class="modal-footer">
      <button type="button" class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
        <button id="close-submit" class="btn btn-primary" type="submit">Save changes</button>
    </div>
    </form>
    </div>

<!-- Unknown Modal -->

  <div id="modal-unknown" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modal1" aria-hidden="true">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
      <h3 id="ignoreLabel">Please select a user from up top</h3>
    </div>

    <div class="modal-body">
    </div>

    <div class="modal-footer">
    </div>
    </div>

<!-- Ignore Modal -->

  <div id="modal-ignore" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modal1" aria-hidden="true">
   <form id="modal-form-ignore" method="post">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
      <h3 id="ignoreLabel">Ignore for how many days?</h3>
    </div>

    <div class="modal-body">


      <!-- have to pass these fields for events_edit_post_script(), but their values get overwritten -->
      <input type="hidden" name="event_timestamp" value="GARBAGE">
      <input type="hidden" name="event_desc" value="GARBAGE">

      <!-- now for the attributes that matter -->
      <input type="hidden" name="status"  value="ignore">
      <input type="hidden" name="event_id" id="ignore-event_id" value="">
      <input type="number" min="1" max="365"  name="ignore"  value="" id="ignore-form-ndays">

    </div>

    <div class="modal-footer">
      <button type="button" class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
      <button id="ignore-submit" class="btn btn-primary" type="submit">Save changes</button>
    </div>
    </form>
    </div>

<!-- Reassign Modal -->

  <div id="modal-reassign" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modal1" aria-hidden="true">
    <form id="modal-form-reassign" method="post">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
      <h3 id="reassignLabel">Reassign to whom?</h3>
    </div>

    <div class="modal-body">

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

    </div>

    <div class="modal-footer">
      <button type="button" class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
      <button id="reassign-submit" class="btn btn-primary" type="submit">Save changes</button>
    </div>
    </form>
    </div>

<!-- Session Modal -->

  <div id="modal-session" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modal1" aria-hidden="true">
    <form id="modal-form-session" method="post">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
      <h3 id="sessionLabel">Who are you?</h3>
    </div>

    <div class="modal-body">

      <!-- have to pass these fields for events_edit_post_script(), but their values get overwritten -->
      <input type="hidden" name="event_timestamp" value="GARBAGE">
      <input type="hidden" name="event_desc" value="GARBAGE">

      <!-- now for the attributes that matter -->
      <select name="session" id="session">
          % for name in set([x.extra_attributes['owner'] for x in events]):
          % if ";" not in name:
              <option value="{{name}}">{{name}}</option>
          % end
          % end
      </select>

    </div>

    <div class="modal-footer">
      <button type="button" class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
      <button id="session-submit" class="btn btn-primary" type="submit">Save changes</button>
    </div>
    </form>
    </div>

<!-- Comment Modal -->

  <div id="modal-comment" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modal1" aria-hidden="true">
    <form id="modal-form-comment" method="post">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
      <h3 id="editLabel">Record Comments</h3>
    </div>

    <span class="modal-body">

      <!-- now for the attributes that matter -->

      <input type="hidden" name="event_id" id="comment-event_id" value="">
        <select name="user" required>
            <option value="">Select a user</option>
          % for name in set([x.extra_attributes['owner'] for x in events]):
          % if ";" not in name:
              <option value="{{name}}">{{name}}</option>
          % end
          % end
      </select>
      <br>
        <textarea rows="5" cols="50" style="width:95%" name="comments" value="" maxlength=50></textarea>
        <!-- <input type="text" name="comments" size="500" value=""> -->

    </span>

    <div class="modal-footer">
      <button type="button" class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
      <button id="comment-submit" class="btn btn-primary" type="submit">Save changes</button>
    </div>
    </form>

    </div>

<!-- Quality Modal -->

  <div id="modal-quality" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modal1" aria-hidden="true">
    <form id="modal-form-quality" method="post">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
      <h3 id="QualityLabel">Select an option</h3>
    </div>

    <div class="modal-body">

        <!-- have to pass these fields for events_edit_post_script(), but their values get overwritten -->
      <input type="hidden" name="event_timestamp" value="GARBAGE">
      <input type="hidden" name="event_desc" value="GARBAGE">

        <input type="hidden" name="event_id" id="quality-event_id" value="">
      <select name="quality_flag">
          <option value="unclear">Notification is unclear</option>
          <option value="wrong">Notification is wrong/misguided</option>
          <option value="deprecated">Notification is for deprecated behavior</option>
          <option value="helpful">Notification is helpful but not urgent</option>
          <option value="saved-non-PRD">Notification saved the day (non-PRD)</option>
          <option value="saved-PRD">Notification saved the day in PRD</option>

      </select>


    </div>

    <div class="modal-footer">
      <button type="button" class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
      <button id="quality-submit" class="btn btn-primary" type="submit">Save changes</button>
    </div>
    </form>

    </div>



<!-- submit JS for close modal -->
<script>
$('#modal-form-close').on('submit', function(e){
      var eventID = $('#close-event_id').val();
      $.ajax({
              url: '/events/edit/' + eventID + '/close',
              data: $('#modal-form-close').serialize(),
              type: 'POST',
              error: function(data){
                  alert('something went wrong')
              },
              success: function(data){
              $("#" + eventID + "-status").replaceWith(("#" + eventID + "-status", "closed"));
              $("#" + eventID + "-resolution").replaceWith(("#" + eventID + "-resolution", $('#close-form-resolution').val()));
              }
         });
    $('#modal-close').modal('hide');
     return false;
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
$('#modal-form-ignore').on('submit', function(e){
      var eventID = $('#ignore-event_id').val();
      $.ajax({
              url: '/events/edit/' + eventID + '/script',
              data: $('#modal-form-ignore').serialize(),
              type: 'POST',
              error: function(data){
                  alert('something went wrong');
                  },
              success: function(data){
              $("#" + eventID + "-status").replaceWith(("#" + eventID + "-status", "ignore"));
              $("#" + eventID + "-ignore").replaceWith(("#" + eventID + "-ignore", $('#ignore-form-ndays').val()));
              }
         });
    $('#modal-ignore').modal('hide');
     return false;
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
$('#modal-form-reassign').on('submit', function(e){
      var eventID = $('#reassign-event_id').val();
      $.ajax({
              url: '/events/edit/' + eventID + '/script',
              data: $('#modal-form-reassign').serialize(),
              type: 'POST',
              error: function(data){
                  alert('something went wrong')
              },
              success: function(data){
              $("#" + eventID + "-owner").replaceWith(("#" + eventID + "-owner", $('#owner').val()));
              }
         });
    $('#modal-reassign').modal('hide');
     return false;
    });
</script>

<!-- submit JS for session modal -->
<script>
$('#modal-form-session').on('submit', function(e){
    $('#usersession').text($('#session').val());
    $.ajax({
              url: '/session',
              data: $('#modal-form-session').serialize(),
              type: 'POST',
              error: function(data){
                  alert('something went wrong')
              },
              success: function(data){
		console.log(data);
		location.reload();
              }
         });
    $('#modal-session').modal('hide');
     return false;
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
$('#modal-form-comment').on('submit', function(e){
      var eventID = $('#comment-event_id').val();
      $.ajax({
              url: '/events/edit/' + eventID + '/comment',
              data: $('#modal-form-comment').serialize(),
              type: 'POST',
              error: function(data){
                  alert('something went wrong')
              }
         });
    $('#modal-comment').modal('hide');
     return false;
    });
</script>

<!-- get Event ID for comment modal -->
<script>
    $(document).on('click', '.open-modal-comment', function(e){
        e.preventDefault();
        var _self = $(this);
        var eventID = _self.data('id');
        $('#comment-event_id').val(eventID);

        $(_self.attr('href')).modal('show');
    });

</script>


<!-- submit JS for quality modal -->
<script>
$('#modal-form-quality').on('submit', function(e){
      var eventID = $('#quality-event_id').val();
      $.ajax({
              url: '/events/edit/' + eventID + '/script',
              data: $('#modal-form-quality').serialize(),
              type: 'POST',
              error: function(data){
                  alert('something went wrong')

              }
         });
    $('#modal-quality').modal('hide');
     return false;
    });
</script>

<!-- get Event ID for quality modal -->
<script>
    $(document).on('click', '.open-modal-quality', function(e){
        e.preventDefault();
        var _self = $(this);
        var eventID = _self.data('id');
        $('#quality-event_id').val(eventID);

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
var byUser = [], byStatus = [], byType = [], byEnv = [];
		
		$("input[name=user]").on( "change", function() {
			if (this.checked) byUser.push("[data-category~='" + $(this).attr("value") + "']");
			else removeA(byUser, "[data-category~='" + $(this).attr("value") + "']");
		});
		
		$("input[name=status]").on( "change", function() {
			if (this.checked) byStatus.push("[data-category~='" + $(this).attr("value") + "']");
			else removeA(byStatus, "[data-category~='" + $(this).attr("value") + "']");
		});

		$("input[name=type]").on( "change", function() {
			if (this.checked) byType.push("[data-category~='" + $(this).attr("value") + "']");
			else removeA(byType, "[data-category~='" + $(this).attr("value") + "']");
		});

		$("input[name=env]").on( "change", function() {
			if (this.checked) byEnv.push("[data-category~='" + $(this).attr("value") + "']");
			else removeA(byEnv, "[data-category~='" + $(this).attr("value") + "']");
		});		
		
		$("input").on( "change", function() {
			var str = "Include items \n";
			var selector = '', cselector = '', nselector = '', eselector = '';
					
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
						$($('input[name=user]:checked')).each(function(index, byUser){
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

                if (byType.length) {
					if (str == "Include items \n") {
						str += "    " + "with (" +  byType.join(' OR ') + ")\n";
						$($('input[name=type]:checked')).each(function(index, byType){
							if(selector === '') {
								selector += "[data-category~='" + byType.id + "']";
							} else {
								selector += ",[data-category~='" + byType.id + "']";
							}
						});
					} else {
						str += "    AND " + "with (" +  byType.join(' OR ') + ")\n";
						$($('input[name=type]:checked')).each(function(index, byType){
							if(nselector === '') {
								nselector += "[data-category~='" + byType.id + "']";
							} else {
								nselector += ",[data-category~='" + byType.id + "']";
							}
						});
					}
				}
				
                if (byEnv.length) {
					if (str == "Include items \n") {
						str += "    " + "with (" +  byEnv.join(' OR ') + ")\n";
						$($('input[name=env]:checked')).each(function(index, byEnv){
							if(selector === '') {
								selector += "[data-category~='" + byEnv.id + "']";
							} else {
								selector += ",[data-category~='" + byEnv.id + "']";
							}
						});
					} else {
						str += "    AND " + "with (" +  byEnv.join(' OR ') + ")\n";
						$($('input[name=env]:checked')).each(function(index, byEnv){
							if(eselector === '') {
								eselector += "[data-category~='" + byEnv.id + "']";
							} else {
								eselector += ",[data-category~='" + byEnv.id + "']";
							}
						});
					}
				}
				

				$lis.hide(); 
				console.log(selector);
				console.log(cselector);
				console.log(nselector);
				console.log(eselector);
				
				if (cselector === '' && nselector === '' && eselector === '') {
					$('table > tbody > tr').filter(selector).show();
				} else if (cselector === '' && nselector === ''){
				    $('table > tbody > tr').filter(selector).filter(eselector).show();
				} else if (cselector === '' && eselector === ''){
				    $('table > tbody > tr').filter(selector).filter(nselector).show();
				} else if (nselector === '' && eselector === ''){
				    $('table > tbody > tr').filter(selector).filter(cselector).show();
				} else if (cselector === '') {
					$('table > tbody > tr').filter(selector).filter(nselector).filter(eselector).show();
				} else if (nselector === '') {
					$('table > tbody > tr').filter(selector).filter(cselector).filter(eselector).show();
				}  else if (eselector === '') {
					$('table > tbody > tr').filter(selector).filter(cselector).filter(nselector).show();
				} else {
					$('table > tbody > tr').filter(selector).filter(cselector).filter(nselector).filter(eselector).show();
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

<!-- http://www.bootply.com/lxa0FF9yhw (pagination)-->
<script>
$.fn.pageMe = function(opts){
    var $this = this,
        defaults = {
            perPage: 7,
            showPrevNext: false,
            hidePageNumbers: false
        },
        settings = $.extend(defaults, opts);

    var listElement = $this;
    var perPage = settings.perPage;
    var children = listElement.children();
    var pager = $('.pager');

    if (typeof settings.childSelector!="undefined") {
        children = listElement.find(settings.childSelector);
    }

    if (typeof settings.pagerSelector!="undefined") {
        pager = $(settings.pagerSelector);
    }

    var numItems = children.size();
    var numPages = Math.ceil(numItems/perPage);

    pager.data("curr",0);

    if (settings.showPrevNext){
        $('<li><a href="#" class="prev_link">«</a></li>').appendTo(pager);
    }

    var curr = 0;
    while(numPages > curr && (settings.hidePageNumbers==false)){
        $('<li><a href="#" class="page_link">'+(curr+1)+'</a></li>').appendTo(pager);
        curr++;
    }

    if (settings.showPrevNext){
        $('<li><a href="#" class="next_link">»</a></li>').appendTo(pager);
    }

    pager.find('.page_link:first').addClass('active');
    pager.find('.prev_link').hide();
    if (numPages<=1) {
        pager.find('.next_link').hide();
    }
  	pager.children().eq(1).addClass("active");

    children.hide();
    children.slice(0, perPage).show();

    pager.find('li .page_link').click(function(){
        var clickedPage = $(this).html().valueOf()-1;
        goTo(clickedPage,perPage);
        return false;
    });
    pager.find('li .prev_link').click(function(){
        previous();
        return false;
    });
    pager.find('li .next_link').click(function(){
        next();
        return false;
    });

    function previous(){
        var goToPage = parseInt(pager.data("curr")) - 1;
        goTo(goToPage);
    }

    function next(){
        goToPage = parseInt(pager.data("curr")) + 1;
        goTo(goToPage);
    }

    function goTo(page){
        var startAt = page * perPage,
            endOn = startAt + perPage;

        children.css('display','none').slice(startAt, endOn).show();

        if (page>=1) {
            pager.find('.prev_link').show();
        }
        else {
            pager.find('.prev_link').hide();
        }

        if (page<(numPages-1)) {
            pager.find('.next_link').show();
        }
        else {
            pager.find('.next_link').hide();
        }

        pager.data("curr",page);
      	pager.children().removeClass("active");
        pager.children().eq(page+1).addClass("active");

    }
};

$(document).ready(function(){

  $('#myTable').pageMe({pagerSelector:'#myPager',showPrevNext:true,hidePageNumbers:false,perPage:100});

});




</script>

