% from time import strftime, gmtime
    <script src="/assets/timeline_2.3.0/timeline_js/timeline-api.js" type="text/javascript"></script>
    <script>
      Timeline_ajax_url="/assets/timeline_2.3.0/timeline_ajax/simile-ajax-api.js";
      Timeline_urlPrefix="/assets/timeline_2.3.0/timeline_js/";
      Timeline_parameters='bundle=true';
    </script>
    <script>
        var tl;
        function onLoad() {
            var eventSource = new Timeline.DefaultEventSource();
           % # we want something like "Fri Nov 22 1963 00:00:00 GMT-0600"
        % start = strftime("%a, %b %d %Y %H:%M:%S +0000", gmtime(range_low))
        % end = strftime("%a, %b %d %Y %H:%M:%S +0000", gmtime(range_high))
            var zones = [
                {   start:    "{{start}}",
                    end:      "{{end}}",
                    magnify:  10,
                    unit:     Timeline.DateTime.DAY
                }
            ];
            
            var theme = Timeline.ClassicTheme.create();
            theme.event.bubble.width = 250;
            
            var date = "{{start}}"
            var bandInfos = [
                Timeline.createHotZoneBandInfo({
                    width:          "80%", 
                    intervalUnit:   Timeline.DateTime.WEEK, 
                    intervalPixels: 220,
                    zones:          zones,
                    eventSource:    eventSource,
                    date:           date,
                    timeZone:       -6,
                    theme:          theme
                })
            ];
 //           bandInfos[1].syncWith = 0;
  //          bandInfos[1].highlight = true;
            
            for (var i = 0; i < bandInfos.length; i++) {
                bandInfos[i].decorators = [
                    new Timeline.SpanHighlightDecorator({
                        startDate:  "{{start}}",
                        endDate:    "{{end}}",
                        color:      "#FFC080", // set color explicitly
                        opacity:    50,
                        startLabel: "first event",
                        endLabel:   "last event",
                        theme:      theme
                    })
                ];
            }
            
            tl = Timeline.create(document.getElementById("tl"), bandInfos, Timeline.HORIZONTAL);
            tl.loadXML("/events/xml", function(xml, url) { eventSource.loadXML(xml, url); });
            
            setupFilterHighlightControls(document.getElementById("controls"), tl, [0,1], theme);
        }
        var resizeTimerID = null;
        function onResize() {
            if (resizeTimerID == null) {
                resizeTimerID = window.setTimeout(function() {
                    resizeTimerID = null;
                    tl.layout();
                }, 500);
            }
        }
    onLoad();
    onResize();
    </script>
    <p>
        Experimental timeline feature, work in progress.
    </p>
<div onload="onLoad();" onresize="onResize();">
      <div id="tl" class="timeline-default" style="height: 300px;"></div>
      <div class="footnotes">
          <!-- All times are in Dallas CST (GMT-0600). -->
      </div>
      <div class="controls" id="controls"></div>
    </div>
</div>
