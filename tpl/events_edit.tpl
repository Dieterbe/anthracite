    <link rel="stylesheet" type="text/css" media="screen" href="/assets/bootstrap-datetimepicker/build/css/bootstrap-datetimepicker.min.css">
    <script type="text/javascript" src="/assets/bootstrap-datetimepicker/build/js/bootstrap-datetimepicker.min.js"> </script>
    <link href="/assets/select2/select2.css" rel="stylesheet"/>
    <script src="/assets/select2/select2.js"></script>


<div class="hero-unit">
<h3>Edit an event</h3>
    <form action="/events/edit/{{event.event_id}}" method="POST">
      <fieldset>
        <label>Date-Time (enter manually, use the picker, or populate from a unix timestamp)</label>
  <div id="event_datetime" class="input-append date">
    <input data-format="MM/dd/yyyy HH:mm:ss PP" type="text" name="event_datetime"></input>
    <span class="add-on">
      <i data-time-icon="icon-time" data-date-icon="icon-calendar">
      </i>
    </span>
  </div>
        <label>Description</label>
        <textarea rows="10" name="event_desc">{{event.desc}}
        </textarea>
        <label>Tags (use space to separate)</label>
        <input type="text" size="10" style="width:300px" id="event_tags" name="event_tags" value="{{!','.join(event.tags)}}"/>
        <label>Status</label>

          <!-- change this to make current status the default -->
          <select name="status" id="status">
              <option value="open" selected>Open</option>
              <option value="closed">Closed</option>
              <option value="ignore">Ignore</option>
          </select>

          <!-- show the Ignore N days field if status is set to ignore -->
          <div class="hide" id="ignore">
          <label>Number of Days to Ignore</label>
          <input type="text" size="10" name="ignore"/>

          </div>


        <br/><button type="submit" class="btn">Submit</button>
      </fieldset>

      <!-- http://stackoverflow.com/questions/8646907/hide-a-form-based-on-the-selected-option-in-drop-down-menu?rq=1 -->
      <script>
          $('#status').on('change', function() {
            var val = $(this).val();
            $('#ignore').hide();
            $('#' + val).show();
        });
      </script>

    <script>
        $(document).ready(function() { $("#event_tags").select2({
          tags:{{![u.encode() for u in tags]}},
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
    var picker = $('#event_datetime').data('datetimepicker');
    picker.setLocalDate(new Date({{event.timestamp}} * 1000));
  });
</script>
