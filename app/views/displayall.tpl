<!DOCTYPE html>
<html lang="en">
<head>
    <title>Twitter Influence Analyzer</title>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <meta charset="utf-8">
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">

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
	background-color: #D8D8D8;
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
	
	 #myModal .modal-body {
  max-height: 600px;
   }

   #myModal {
  width: 700px; /* SET THE WIDTH OF THE MODAL */
}
	
  </style>

	<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>

<style type="text/css" id="holderjs-style">.holderjs-fluid {font-size:16px;font-weight:bold;text-align:center;font-family:sans-serif;margin:0}</style>
</head>

<body>
  <!-- <img src="http://www.logomaker.com/logo-images/555b7084659959ad.gif"/>
  <a href="http://www.logomaker.com"><img src="http://www.logomaker.com/images/logos.gif" alt="logo design" border="0"/></a> -->

<!-- Modal -->
 <div id="myModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    <h3 id="myModalLabel">Send Email</h3>
  </div>
  <div class="modal-body">
    <p>Enter the details below to send the email: </p>
	<form method="post" action="/sendmail">
		<input type="text" placeholder="Enter Receiver Address" name="receiver" class="input-large">
		<input type="text" placeholder="Enter Sender Address" name="sender" class="input-large">
		<p class="muted">Attached here: output.csv</p>
		<input type="submit" class="btn" value="Send">
	</form>
  </div>
</div>

  <script src="http://code.jquery.com/jquery.js"></script>
  <script src="/static/bootstrap-transition.js"></script>
    <script src="/static/bootstrap-alert.js"></script>
    <script src="/static/bootstrap-modal.js"></script>
    <script src="/static/bootstrap-dropdown.js"></script>
    <script src="/static/bootstrap-scrollspy.js"></script>
    <script src="/static/bootstrap-tab.js"></script>
    <script src="/static/bootstrap-tooltip.js"></script>
    <script src="/static/bootstrap-popover.js"></script>
    <script src="/static/bootstrap-button.js"></script>
    <script src="/static/bootstrap-collapse.js"></script>
    <script src="/static/bootstrap-carousel.js"></script>
    <script src="/static/bootstrap-typeahead.js"></script>

  <div class="navbar navbar-inverse navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container">
          
          <a class="brand pull-left" href="/"><em>Twitter Influence Analyzer </em><small>v1.0</small></a>
	  
          <div class="nav-collapse collapse">
           	<form action="/dispcalc" method="post" class="navbar-form pull-right">
 		<input class="span3" type="text" name="twitter_name" value="" placeholder="Enter Twitter Name" />
		<input type="submit" value="Analyze!" class= "btn btn-info">
  		</form>
          </div><!--/.nav-collapse -->
        </div>
      </div>
  </div>  <!-- end of div for nav bar-->

  <div class="container">
  <div class="hero-unit">

  
  <h2>Influencer List:</h2>
  <h4>Record count: {{totinf}}</h4>
  <div style="background-color:white">
  	<table class="table table-hover">
  	<tr>
  	<td>Twitter Name</td><td>Mentions</td><td>Followers</td><td>Follower Score</td><td>Retweets</td><td>Retweet Score</td><td>Total Score</td>
  	</tr>
		%include
  	</table>
  </div>
  	<br>
  <div style="text-align:center">
  	<!-- </form> -->
  	<p style="text-align:center">
  		<form action="/clearall" method="post">
  		<input type="submit" value="Delete All Records" class="btn btn-danger">
  		</form>
	
		<form action="/outputcsv" method="post">
		<input type="submit" value="Export the Data to CSV " class="btn btn-success">
		</form>
		<!-- Button to trigger modal -->
		<!-- Uncomment this part to use the SMTP service if its available on Bluemix -->
% include email smtp_flag=smtp_flag
	</p>
	 
  </div>

  </div> <!-- end of the hero-unit-->
  </div> <!-- end of the container-->



</body>
  </html>
