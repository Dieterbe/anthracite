<!-- http://www.slideshare.net/jallspaw/ops-metametrics-the-currency-you-pay-for-change
uptime
ttr/ttd
time to detect, time to resolve
start, detect resolve
-->
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
                from: "{{config.opsreport_start}}",
                until: "now",
                height: "300",
                width: "740",
                targets: [
                    {name: 'uptime (in %)',
                    color: 'green',
                    target: 'uptime'
                    },
                    {name: 'downtime (minutes)',
                    color: 'red',
                    target: 'downtime'
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
<table>
%from datetime import datetime
<tr><th>DateTime</th><th>Outage</th><th>Event</th><th>Uptime %</th><th>Downtime this event (minutes)</th><th>Downtime (minutes total)</th><th>TTD</th><th>TTR</th><th>MTTD</th><th>MTTR</th></tr>
% for entry in data['uptime']:
% outage = '-'
% if entry[2] is not None:
% outage = '<a href="/events/q=%s">%s</a>' % (entry[2], entry[2].replace('outage=', ''))
% end
<tr>
    <td>{{datetime.fromtimestamp(entry[1]).strftime('%Y-%m-%d %H:%M:%S')}}</td>
    <td>{{!outage}}</td>
    <td><a href="/events/view/{{entry[0]}}">{{' '.join([t for t in entry[3][3] if not t.startswith('outage=')])}}</a></td>
    <td>{{entry[0]}}</td>
</tr>
% end
</table>
% for entry in data['downtime']:
{{entry[0]}} 
{{entry[1]}} 
% end
