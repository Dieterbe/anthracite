% from config import recommended_tags, optional_fields

    <link rel="stylesheet" type="text/css" media="screen" href="/assets/bootstrap-datetimepicker/build/css/bootstrap-datetimepicker.min.css">
    <script type="text/javascript" src="/assets/bootstrap-datetimepicker/build/js/bootstrap-datetimepicker.min.js"> </script>
    <link href="/assets/select2/select2.css" rel="stylesheet"/>
    <script src="/assets/select2/select2.js"></script>

<div class="hero-unit">
<h3>Add an event</h3>
    <form action="/events/add" method="POST">
      <fieldset>
        <label><b>Date-Time</b> (use the picker, enter manually, or populate from a unix timestamp)</label>
  <div id="event_datetime" class="input-append date">
    <input data-format="MM/dd/yyyy HH:mm:ss PP" type="text" name="event_datetime"></input>
    <span class="add-on">
      <i data-time-icon="icon-time" data-date-icon="icon-calendar">
      </i>
    </span>
  </div>
        <input type="text" size="10" maxlength="10" id="event_timestamp" name="event_timestamp" placeholder="unix timestamp"/>
        <label><b>Description</b></label>
        <textarea rows="10" name="event_desc">
        </textarea>
        % if len(recommended_tags):
            <label>Commonly used/recommended tags</label>
            % for (tag, desc) in recommended_tags:
                <label class="checkbox">
                <input type="checkbox" name="event_tags_recommended" value="{{tag}}"> <!-- checked="checked"> -->
                <span style="display: inline-block; width: 150px;">{{tag}}</span><i>{{desc}}</i>
                </label>
            % end
        % end
        <label>Other tags (use space to separate)</label>
        <input type="text" size="10" style="width:300px" id="event_tags" name="event_tags"/>
        % if len(optional_fields):
            % for (field, desc) in optional_fields:
            <label>{{field}} <i>{{desc}}</i></label>
            <input type="text" size="10" style="width:300px" name="{{field}}"/>
            % end
        % end
        <br/><button type="submit" class="btn">Submit</button>
      </fieldset>
        % tags_set = set([u.encode() for u in tags])
        % recommended_tags_set = set([r[0] for r in recommended_tags])
    <script>
        $(document).ready(function() { $("#event_tags").select2({
          tags:{{!list(tags_set.difference(recommended_tags_set))}},
          tokenSeparators: [" "]});
        });
    </script>
    </form>
</div>

<script type="text/javascript">
  $(function() {
    $('#event_datetime').datetimepicker({
      language: 'en',
      pick12HourFormat: true
    });
    $('#event_timestamp').change(function() {
        var myDate = new Date($(this).val() * 1000);
        var picker = $('#event_datetime').data('datetimepicker');
        picker.setLocalDate(myDate);
    });
  });
</script>
