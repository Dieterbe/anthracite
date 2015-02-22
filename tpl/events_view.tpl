<h3>View event {{event.event_id}}</h3>
%import datetime
%format = '%Y-%m-%d %H:%M:%S'
<table class="table table-striped table-condensed" 
<tr><th>Date-Time</th><th>Description</th><th>Operations</th></tr>
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
        {{!event.desc}}
        <br/>
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
            <br/><span class="text-info">{{k}}</span>:
            &nbsp;&nbsp;
            % if type(v) is list:
                % for val in v:
                    <span class="label">{{val}}</span>
                % end
            % else:
                {{!v}}
            %end
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
        <a href="/events/edit/{{event.event_id}}"><i class="icon-pencil"></i></a>
        <a href="#" event_id="{{event.event_id}}" class="delete-link"><i class="icon-remove"></i></a>
    </td>
  </tr>


<!-- Ignore Modal -->

  <div id="modal-ignore" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modal1" aria-hidden="true">
    <form id="modal-form-ignore" method="post" action="/events/edit/{{event.event_id}}/script">
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
      <input type="number" min="1" max="365" name="ignore"  value="">

    </div>

    <div class="modal-footer">
      <button type="button" class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
      <button id="ignore-submit" class="btn btn-primary" type="submit">Save changes</button>
    </div>
    </form>
    </div>

<!-- Close Modal -->

  <div id="modal-close" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modal1" aria-hidden="true">
    <form id="modal-form-close" method="post" action="/events/edit/{{event.event_id}}/close">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
      <h3 id="closeLabel">Enter resolution</h3>
    </div>

    <div class="modal-body">

      <!-- now for the attributes that matter -->
      <input type="hidden" name="status"  value="closed">
      <input type="hidden" name="event_id" id="close-event_id" value="">
      <input type="text" name="resolution"  value="" required>
    </div>

    <div class="modal-footer">
      <button type="button" class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
        <button id="close-submit" class="btn btn-primary" type="submit">Save changes</button>
    </div>
    </form>
    </div>

<!-- Reassign Modal -->

  <div id="modal-reassign" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modal1" aria-hidden="true">
    <form id="modal-form-reassign" method="post" action="/events/edit/{{event.event_id}}/script">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
      <h3 id="reassignLabel">Reassign to whom?</h3>
    </div>

    <div class="modal-body">

      <!-- have to pass these fields for events_edit_post_script(), but their values get overwritten -->
      <input type="hidden" name="event_timestamp" value="GARBAGE">
      <input type="hidden" name="event_desc" value="GARBAGE">

      <!-- can't dynamically populate this in here since we don't have access to all events-->
      <input type="hidden" name="event_id" id="reassign-event_id" value="">
      <select name="owner" id="owner">
          <option value="Archit Jain">Archit Jain</option>
          <option value="Ben Dundee">Ben Dundee</option>
          <option value="Joachim Hubele">Joachime Hubele</option>
          <option value="John Jardel">John Jardel</option>
          <option value="Mark Gorman">Mark Gorman</option>
          <option value="Mark Schwarz">Mark Schwarz</option>
          <option value="Niral Patel">Niral Patel</option>
          <option value="Qiong Zeng">Qiong Zeng</option>

      </select>

    </div>

    <div class="modal-footer">
      <button type="button" class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
      <button id="reassign-submit" class="btn btn-primary" type="submit">Save changes</button>
    </div>
    </form>
    </div>

<!-- Comment Modal -->

  <div id="modal-comment" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modal1" aria-hidden="true">
    <form id="modal-form-comment" method="post" action="/events/edit/{{event.event_id}}/comment">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
      <h3 id="editLabel">Record Comments</h3>
    </div>

    <span class="modal-body">

      <!-- now for the attributes that matter -->
      <input type="hidden" name="event_id" id="comment-event_id" value="">
      <select name="user" id="comments_user">
          <option value="Archit Jain">Archit Jain</option>
          <option value="Ben Dundee">Ben Dundee</option>
          <option value="Joachim Hubele">Joachime Hubele</option>
          <option value="John Jardel">John Jardel</option>
          <option value="Mark Gorman">Mark Gorman</option>
          <option value="Mark Schwarz">Mark Schwarz</option>
          <option value="Niral Patel">Niral Patel</option>
          <option value="Qiong Zeng">Qiong Zeng</option>

      </select>
      <br>
        <textarea rows="5" cols="50" style="width:95%" name="comments" value=""></textarea>

    </span>

    <div class="modal-footer">
      <button type="button" class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
      <button id="comment-submit" class="btn btn-primary" type="submit">Save changes</button>
    </div>
    </form>
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
</table>
