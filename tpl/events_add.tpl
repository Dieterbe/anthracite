    <link rel="stylesheet" type="text/css" media="screen" href="/assets/bootstrap-datetimepicker/build/css/bootstrap-datetimepicker.min.css">
    <script type="text/javascript" src="/assets/bootstrap-datetimepicker/build/js/bootstrap-datetimepicker.min.js"> </script>

<div class="hero-unit">
<h3>Add an event</h3>
    <form action="/add" method="POST">
      <fieldset>
        <label>Enter a Unix Timestamp (left) or a Date+Time (right)</label>
        <input type="text" size="10" maxlength="10" name="event_timestamp" placeholder="unix timestamp">
  <div id="event_datetime" class="input-append date">
    <input data-format="MM/dd/yyyy HH:mm:ss PP" type="text"></input>
    <span class="add-on">
      <i data-time-icon="icon-time" data-date-icon="icon-calendar">
      </i>
    </span>
  </div>
<script type="text/javascript">
  $(function() {
    $('#event_datetime').datetimepicker({
      language: 'en',
      pick12HourFormat: true
    });
  });
</script>
        <label>Type</label>
        <input type="text" name="event_type" placeholder="type">
        <label>Description</label>
        <textarea rows="10" name="event_desc">
        </textarea>
        <br/><button type="submit" class="btn">Submit</button>
      </fieldset>
    </form>
</div>

