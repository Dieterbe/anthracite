    <link rel="stylesheet" type="text/css" media="screen" href="/assets/bootstrap-datetimepicker/build/css/bootstrap-datetimepicker.min.css">
    <script type="text/javascript" src="/assets/bootstrap-datetimepicker/build/js/bootstrap-datetimepicker.min.js"> </script>
    <link href="/assets/select2/select2.css" rel="stylesheet"/>
    <script src="/assets/select2/select2.js"></script>

<div class="hero-unit">
<h3>Add an event</h3>
    <form action="/events/add" method="POST">
      <fieldset>
        <label>Date-Time (enter manually, use the picker, or populate from a unix timestamp)</label>
  <div id="event_datetime" class="input-append date">
    <input data-format="MM/dd/yyyy HH:mm:ss PP" type="text" name="event_datetime"></input>
    <span class="add-on">
      <i data-time-icon="icon-time" data-date-icon="icon-calendar">
      </i>
    </span>
  </div>
        <input type="text" size="10" maxlength="10" id="event_timestamp" name="event_timestamp" placeholder="unix timestamp"/>
        <label>Description</label>
        <textarea rows="10" name="event_desc">
        </textarea>
        <label>Tags (use space to separate)</label>
        <input type="text" size="10" style="width:300px" id="event_tags" name="event_tags"/>
        <br/><button type="submit" class="btn">Submit</button>
      </fieldset>
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
    $('#event_timestamp').change(function() {
        var myDate = new Date($(this).val() * 1000);
        var picker = $('#event_datetime').data('datetimepicker');
        picker.setLocalDate(myDate);
    });
  });
</script>
