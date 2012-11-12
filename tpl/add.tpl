<p>Add a new event:</p>
<form action="/add" method="POST">
<b>timestamp:</b><input type="text" size="10" maxlength="10" name="event_time">
<br/>
<b>type:</b><input type="text" size="30" maxlength="100" name="event_type">
<br/>
<b>description:</b>
<textarea rows="10" cols="80" name="event_desc">
</textarea>
<br/><br/>
<input type="submit" name="save" value="save">
</form>
