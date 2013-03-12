% setdefault('page', 'index')
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Anthracite</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">

    <!-- Le styles -->
    <link href="../assets/journal/bootstrap.css" rel="stylesheet">
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
    <link href="../assets/bootstrap/css/bootstrap-responsive.css" rel="stylesheet">

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
    <script src="../assets/jquery/jquery-1.9.1.js"></script>
    <script src="../assets/bootstrap/js/bootstrap.js"></script>
  </head>

  <body>

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
              {{events_count}} events in database
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

		%# if page == key:
        %#      <li class="active"><a href="/{{key}}">{{title}}</a></li>
		%# else:
        %#      <li><a href="/{{key}}">{{title}}</a></li>
		%#end

    <div class="container-fluid">
      <div class="row-fluid">
        <div class="span3">
          <div class="well sidebar-nav">
            <ul class="nav nav-list">
              <li class="active"><a href="/">main</a></li>
              <li><a href="/events/add">add event</a></li>
              <li class="nav-header">Event views</li>
              <li><a href="/events">table</a></li>
              <li><a href="/events/raw">raw</a></li>
              <li><a href="/events/json">json</a></li>
              <li><a href="/events/jsonp">jsonp</a></li>
              <li><a href="/events/sqlite">sqlite</a></li>
            </ul>
          </div><!--/.well -->
        </div><!--/span-->
        <div class="span9">
            {{!body}}
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
