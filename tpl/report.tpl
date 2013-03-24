<script src="/assets/timeserieswidget/jquery.tswidget.js" type="text/javascript"></script>
<script src="/assets/timeserieswidget/jquery-ui.min.js" type="text/javascript"></script>
<script src="/assets/timeserieswidget/graphite_helpers.js" type="text/javascript"></script>
<script src="/assets/timeserieswidget/flot/jquery.flot.js" type="text/javascript"></script>
<script src="/assets/timeserieswidget/flot/jquery.flot.time.js" type="text/javascript"></script>
<script src="/assets/timeserieswidget/jquery.flot.axislabels.js" type="text/javascript"></script>
<link type="text/css" rel="stylesheet" href="/assets/timeserieswidget/tswidget.css">
<script src="/assets/timeserieswidget/timezone-js/src/date.js"></script>

<script src="/assets/timeserieswidget/rickshaw/vendor/d3.min.js"></script>
<script src="/assets/timeserieswidget/rickshaw/vendor/d3.layout.min.js"></script>
<script src="/assets/timeserieswidget/rickshaw/rickshaw.js"></script>
<link type="text/css" rel="stylesheet" href="/assets/timeserieswidget/rickshaw/rickshaw.css">
Terminology:
<table class="table table-condensed">
<tr><td>foo</td><td>foo this event</td></tr>
<tr><td>Mfoo</td><td>mean foo since start</td></tr>
<tr><td>Tfoo</td><td>total foo since start</td></tr>
<tr><td>TTF</td><td>Time to failure (days between outage starts)</td></tr>
<tr><td>TTD</td><td>Time to detection (minutes between outage start and detection)</td></tr>
<tr><td>TTR</td><td>Time to recovery (minutes between outage start and full recovery)</td></tr>
<tr><td>uptime</td><td>% of time without any downtime</td></tr>
</table>
        <div class="chart_container rickshaw" id="chart_container_rickshaw">
            <div class="chart_y_axis" id="y_axis_rickshaw"></div>
            <div class="chart" id="chart_rickshaw"></div>
            <div class="legend" id="legend_rickshaw"></div>
            <form class="toggler" id="line_stack_form_rickshaw"></form>
        </div>
        <script language="javascript">
	    $(document).ready(function () {
            var settings = {
                graphite_url: "/report/data/", // we actually just mimic graphite's output format and serve the data ourself
                from: "{{reportpoints[0].event.timestamp}}",
                until: "{{reportpoints[-1].event.timestamp}}",
                height: "300",
                width: "740",
                targets: [
                    {name: 'TTD',
                    color: 'orange',
                    target: 'ttd'
                    },
                    {name: 'TTR',
                    color: 'green',
                    target: 'ttr'
                    }
                ],
                title: 'Uptime/Downtime',
                vtitle: 'meh',
                y_axis: 'y_axis_rickshaw',
                x_axis: true,
                legend: 'legend_rickshaw',
                legend_highlight: true,
                hoover_details: true,
                line_stack_toggle: 'line_stack_form_rickshaw',
            };
            $("#chart_rickshaw").graphiteRick(settings, function(err) { console.log(err); });
        });
        </script>
    </body>
</html>

        <!--<div class="chart_container flot" id="chart_container_flot_stats">
            <div class="chart" id="chart_flot_stats" height="300px" width="700px"></div>
            <div class="legend" id="legend_flot_stats"></div>
            <form class="toggler" id="line_stack_form_flot_stats"></form>
        </div> -->
        <script language="javascript">
//        $("#chart_flot_stats").graphiteRick(settings, function(err) { $("#chart_flot_stats").append('<span class="label label-important">' + err + '</span>'); });
        </script>
<p>
<table class="table">
%from datetime import datetime
<tr>
    <th>Time</th>
    <th>Outage</th>
    <th>Event</th>
    <th>TTF/MTTF/TTTF</th>
    <th>TTD/MTTD/TTTD</th>
    <th>TTR/MTTR/TTTR</th>
    <th>M Uptime</th>
</tr>
% for r in reportpoints:
    % outage = '-'
    % if r.event.outage is not None:
    % outage = '<a href="/events/q=%s">%s</a>' % (r.event.outage, r.event.outage)
    % end
    % print r.event.tags
    % if 'start' in r.event.tags:
    % css_class = 'error'
    % elif 'detected' in r.event.tags:
    % css_class = 'warning'
    % elif 'resolved' in r.event.tags:
    % css_class = 'success'
    % else:
    % css_class = ''
    % end
    % event_str = ' '.join([t for t in r.event.tags if not t.startswith('outage=')])
    % # no other tags? this should be only the case for non-outage events
    % if not event_str:
    % event_str = r.event.desc
    % css_class = 'info'
    % end
<tr class="{{css_class}}">
    <td>{{datetime.fromtimestamp(r.event.timestamp).strftime('%Y-%m-%d %H:%M:%S')}}</td>
    <td>{{!outage}}</td>
    <td><a href="/events/view/{{r.event.rowid}}">{{event_str}}</a></td>
    <td>{{int(r.ttf/86400)}}/{{int(r.mttf/86400)}}/{{int(r.tttf/86400)}}</td>
    <td>{{r.ttd/60}}/{{r.mttd/60}}/{{r.tttd/60}}</td>
    <td>{{r.ttr/60}}/{{r.mttr/60}}/{{r.tttr/60}}</td>
    <td>{{round(r.muptime, 3)}}%</td>
</tr>
% end
</table>
