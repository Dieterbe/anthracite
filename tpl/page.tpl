% setdefault('page', '')
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Anthracite</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">

    <!-- Le styles -->
    <link href="/assets/journal/bootstrap.css" rel="stylesheet">
    <style type="text/css">
      body {
        padding-top: 60px;
        padding-bottom: 40px;
      }
      .sidebar-nav {
        padding: 9px 0;
      }

      @media (max-width: 980px) {
        /* Enable use of floated navbar text */
        .navbar-text.pull-right {
          float: none;
          padding-left: 5px;
          padding-right: 5px;
        }
      }
    </style>
    <link href="/assets/bootstrap/css/bootstrap-responsive.css" rel="stylesheet">

    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="../assets/js/html5shiv.js"></script>
    <![endif]-->

    <!-- Fav and touch icons -->
    <!--
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="../assets/ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="../assets/ico/apple-touch-icon-114-precomposed.png">
      <link rel="apple-touch-icon-precomposed" sizes="72x72" href="../assets/ico/apple-touch-icon-72-precomposed.png">
                    <link rel="apple-touch-icon-precomposed" href="../assets/ico/apple-touch-icon-57-precomposed.png">
                                   <link rel="shortcut icon" href="../assets/ico/favicon.png">
    -->
    <script src="/assets/jquery/jquery-1.9.1.js"></script>
    <script src="/assets/bootstrap/js/bootstrap.js"></script>
    <script src="/assets/bootboxjs/bootbox.js"></script>
    <script>
        // will be overridden on timeline page
        function onLoad() {};
        function onResize() {};
    </script>
	<script>
		$().ready(function() {
			// change active link based on "page"
			var page="{{page}}";
			$('ul.nav-list').find("a[name=\'" + page +"\']").parent().attr("class","active");
		});
	</script>
  </head>
  <body onload="onLoad();" onresize="onResize();">

    <div class="navbar navbar-inverse navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container-fluid">
          <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="brand" href="/">Anthracite event manager</a>
          <div class="nav-collapse collapse">
            <!-- <p class="navbar-text pull-right">
              Logged in as <a href="#" class="navbar-link">Username</a>
            </p> -->
            <p class="navbar-text pull-right">
              showing 500 of {{events_count}} events

            </p>
            <!-- <ul class="nav">
              <li class="active"><a href="#">Home</a></li>
              <li><a href="#about">About</a></li>
              <li><a href="#contact">Contact</a></li>
            </ul> -->
          </div><!--/.nav-collapse -->
        </div>
      </div>
    </div>

    <div class="container-fluid">
      <div class="row-fluid">
        <div class="span3">
          <div class="well sidebar-nav">
            <ul class="nav nav-list">
                % urls = [('main', '/', 'main'), ('add', '/events/add', 'add event'), ('report', '/report', 'operational report')]
                % # with remove_urls you don't control everything (yet):
                % for (name, href, visual) in urls:
                    % if href not in remove_urls:
              <li><a name="{{name}}" href="{{href}}">{{visual}}</a></li>
                    % end
                % end
              <li class="nav-header">Event views</li>
              <li><a name="table" href="/events/table">table</a></li>
              <li><a name="timeline" href="/events/timeline">timeline</a></li>
              <li><a href="/events/json">json</a></li>
              <li><a href="/events/jsonp">jsonp</a></li>
              <li><a href="/events/csv">csv</a></li>
              <li><a href="/events/xml">xml</a></li>
              % for (plugin, urls) in add_urls.items():
                  <li class="nav-header">{{plugin}} plugin</li>
                  % for (path, desc) in urls:
                      <li><a href="{{path}}">{{desc}}</a></li>
                  %end
            %end
            </ul>
          </div><!--/.well -->
            % if page == 'report':
            % include tpl/sidebar.report
            % end
        </div><!--/span-->
        <div class="span9">
        % if defined('successes'):
            <div class="row">
                % for s in successes:
                    %include tpl/success msg=s
                % end
            </div>
        % end
        % if defined('infos'):
            <div class="row">
                % for i in infos:
                    %include tpl/info msg=i
                % end
            </div>
        % end
        % if defined('warnings'):
            <div class="row">
                % for w in warnings:
                    %include tpl/warning msg=w
                % end
            </div>
        % end
        % if defined('errors'):
            <div class="row">
                % for (title, msg) in errors:
                    %include tpl/error title=title, msg=msg
                % end
            </div>
        % end
        <div class='container'>
            {{!body}}
        </div>
        </div><!--/span-->
      </div><!--/row-->

      <hr>

      <!-- <footer>
        <p>&copy; Company 2013</p>
      </footer> -->

    </div><!--/.fluid-container-->

    <!-- Le javascript (jquery and bootstrap)
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->

  </body>
</html>
