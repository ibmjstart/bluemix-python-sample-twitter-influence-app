<!DOCTYPE html>
<html>
<head>
	<title> Twitter Influence Analyzer </title>
	<meta charset="utf8">  
  	<meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Bootstrap -->
   <link href="/static/bootstrap.min.css" rel="stylesheet" media="screen">
   <link href="/static/bootstrap-responsive.css" rel="stylesheet">
   <link href="/static/bootstrap.css" rel="stylesheet">

  <style type="text/css">
	body {
        padding-top: 60px; /* 60px to make the container go all the way to the bottom of the topbar */
	
      }
	
	/* Custom container */
      .container-narrow {
        margin: 0 auto;
        max-width: 900px;
	border-style: solid;
	border-color: transparent;
	background-color: #D8D8D8	;
	z-index: 9;
	height : 100%;
	-moz-border-radius: 15px;
	border-radius: 15px;
	
      }
      .container-narrow > hr {
        margin: 30px 0;
      }

	.sidebar-nav {
        padding: 20px 0;
      }

      @media (max-width: 980px) {
        /* Enable use of floated navbar text */
        .navbar-text.pull-right {
          float: none;
          padding-left: 5px;
          padding-right: 5px;
        }
	
  </style>

  <script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
</head>
<body>
  <!-- <img src="http://www.logomaker.com/logo-images/555b7084659959ad.gif"/>
  <a href="http://www.logomaker.com"><img src="http://www.logomaker.com/images/logos.gif" alt="logo design" border="0"/></a> -->
  <script src="http://code.jquery.com/jquery.js"></script>
  <script src="/static/bootstrap.min.js"></script>
  <script src="/static/bootstrap.js"></script>
  <script src="/static/bootstrap-tooltip.js"></script>

  <div class="navbar navbar-inverse navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container">
          
          <a class="brand pull-left" href="/"><em>Twitter Influence Analyzer </em><small>v1.0</small></a>
	  
          <div class="nav-collapse collapse">
           
          </div><!--/.nav-collapse -->
        </div>
      </div>
    </div>  <!-- end of div for nav bar-->
  
  <div class="container">
  <!-- <table class="table table-hover">
  <tr> -->
  <div class="hero-unit">
  <div>
  <h2 class="text-center"><img src="/static/twitter_logo.png" class="img-rounded"><em>Twitter Influence Analyzer</em><h2> </div>
  <br/>
  <div id="error"></div>
  <form action="/dispcalc" method="post" class="form-search" name="twitterQuery" id="twitterQuery">
  <p style="text-align: center"> 
  <input type="text" name="twitter_name" value="" placeholder="Enter Twitter Name" class="input-large"/>
  <input type="submit" value="Analyze!" class="btn btn-info">
  </p>
  </form>
  
  
  <form action="/displayall" method="post" class="form-search">
  <p style="text-align:center">
  <a href="/displayall" value="View Database" class="btn btn-primary">View Database</a>
 <p>
  </form>
 
  </div> <!-- end of the hero-unit-->
  </div> <!-- end of the container-->
  
  <script>
  $(document).ready(function() {
      $('#twitterQuery').submit(function( event ) {
        if(!document.forms["twitterQuery"]["twitter_name"].value.match(/^[0-9a-zA-Z]+$/)) {
         $('#error').html('<div class="alert alert-danger">Twitter name must only contain alphanumeric characters</div>');
         event.preventDefault();
        }
      });
    });
  </script>
</body>
</html>
