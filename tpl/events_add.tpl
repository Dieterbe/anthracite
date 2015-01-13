% # the following vars must be set: recommended_tags, extra_attributes
% # optional: timestamp_feeder True, helptext {}, event_type '', handler ''
% setdefault('timestamp_feeder', False)
% setdefault('helptext', {})
% setdefault('event_type', '')
% setdefault('handler', '')
% if timestamp_feeder:
%     default_helptext_event_datetime = 'use the picker, enter manually, or populate from a unix timestamp'
% else:
%     default_helptext_event_datetime = 'use the picker or enter manually'
% end
% default_helptext = {
%     'event_datetime': default_helptext_event_datetime
% }
% default_helptext.update(helptext)
% helptext = default_helptext
% setdefault('timestamp_from_url', '')

    <link rel="stylesheet" type="text/css" media="screen" href="/assets/bootstrap-datetimepicker/build/css/bootstrap-datetimepicker.min.css">
    <script type="text/javascript" src="/assets/bootstrap-datetimepicker/build/js/bootstrap-datetimepicker.min.js"> </script>
    <link href="/assets/select2/select2.css" rel="stylesheet"/>
    <script src="/assets/select2/select2.js"></script>

<div class="hero-unit">
<h3>Add {{event_type}} event</h3>
    % if handler:
        % action = '/events/add/%s' % handler
    % else:
        % action = '/events/add'
    % end
    <form action="{{action}}" method="POST" class="form-horizontal">
      <fieldset>

    <div class="control-group">
        <label class="control-label"><b>Date-Time, UTC</b></label>
        <div class="controls">
            <div id="event_datetime" class="input-append date">
                <input data-format="MM/dd/yyyy hh:mm:ss" type="text" name="event_datetime"></input>
                <span class="add-on"><i data-time-icon="icon-time" data-date-icon="icon-calendar"></i></span>
            </div>
            % if timestamp_feeder:
                <input type="text" size="10" maxlength="10" id="event_timestamp" name="event_timestamp" placeholder="unix timestamp"/>
            % end
            <span class="help-block">{{helptext.get('event_datetime', '')}}</span>
        </div>
    </div>

    <div class="control-group">
        <label class="control-label"><b>Description</b></label>
        <div class="controls">
            <textarea rows="10" name="event_desc"></textarea>
            <span class="help-block">{{helptext.get('event_desc', '')}}</span>
        </div>
    </div>

    % if len(recommended_tags):
        <label>Commonly used/recommended tags</label>
        % for (tag, desc) in recommended_tags:
            <div class="control-group">
                <div class="controls">
                    <label class="checkbox control-label">
                        <input type="checkbox" name="event_tags_recommended" value="{{tag}}"/> <!-- checked="checked"> -->
                    </label>
                    <span class="help-block">{{helptext.get('event_tags_recommended', '')}}</span>
                </div>
                <span style="display: inline-block; width: 150px;">{{tag}}</span><i>{{desc}}</i>
            </div>
        % end
    % end

    <div class="control-group">
        % if len(recommended_tags):
            <label class="control-label">Other tags (use space to separate)</label>
        % else:
            <label class="control-label">tags (use space to separate)</label>
        % end
        <div class="controls">
            <input type="text" size="10" style="width:300px" id="event_tags" name="event_tags"/>
            <span class="help-block">{{helptext.get('event_tags', '')}}</span>
        </div>
    </div>

    % if len(extra_attributes):
        % for attribute in extra_attributes:
            % label = attribute.label
            % if attribute.mandatory:
                % label = '<b>%s</b>' % label
            % end
            <div class="control-group">
                <label class="control-label">{{!label}}</label>
                <div class="controls">
                    % if attribute.freeform():
                        <input type="text" size="10" style="width:300px" name="{{attribute.key}}"/>
                    % elif not attribute.select_many:
                        % if len(attribute.choices) == 1:
                            <select class="uneditable-input" name="{{attribute.key}}">
                        % else:
                            <select name="{{attribute.key}}">
                        % end
                        % for choice in attribute.choices:
                            <option>{{choice}}</option>
                        % end
                        </select>
                    % else:
                        % for choice in attribute.choices:
                            <label class="checkbox"> <!-- control-label"> -->
                                <input type="checkbox" name="{{attribute.key}}" value="{{choice}}"/>
                                {{choice}}
                            </label>
                            <span class="help-block">{{helptext.get('event_tags_recommended', '')}}</span>
                        % end
                    % end
                <span class="help-block">{{helptext.get(attribute.key, '')}}</span>
                </div>
            </div>
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
      pick12HourFormat: false
    });
    var set_date = function(ts) {
        var myDate = new Date(ts * 1000);
        var picker = $('#event_datetime').data('datetimepicker');
        picker.setDate(myDate);
    }
    if ('{{timestamp_from_url}}' != '') {
        set_date({{timestamp_from_url}});
    }
  });
</script>
