<!DOCTYPE html>
<html>
 <head>
    <title>Twitter Influence Analyzer</title>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <meta charset="utf-8">
    <link href="/static/default.css" rel="stylesheet"> 
    <!-- <link href="/static/todc-bootstrap.css" rel="stylesheet"> -->
 
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
    <!--
    Include the maps javascript with sensor=true because this code is using a
    sensor (a GPS locator) to determine the user's location.
    See: https://developers.google.com/apis/maps/documentation/javascript/basics#SpecifyingSensor
    -->
    <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false"></script>

   <script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>

    <script>
var mapOptions;
var geocoder;
var map;
function initialize() {
  var address = 'United States';
  
  geocoder = new google.maps.Geocoder();
  geocoder.geocode( 
	{ 'address': address}, function(results, status) {
	    if (status == google.maps.GeocoderStatus.OK) {
	      console.debug('Debug information: ' + results[0].geometry.location);
	      mapOptions = {
	    	zoom: 3,
	    	center: results[0].geometry.location ,
	    	mapTypeId: google.maps.MapTypeId.ROADMAP
	  	};
		map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
		% for i in result['statuses']:
		%   text = i['text'].replace("\"", "'").replace("\n", " ")
		%   location = i['user']['location']
		%   screenName = i['user']['screen_name']
		%   prof_img = i['user']['profile_image_url']
		var loc = '{{location}}';
		console.debug('{{location}}');
		geocoder.geocode({'address':'{{location}}'}, function (new_result) {
		console.debug("Check here: ", new_result)
		var contentString = '<div id="content">'+
		      '<div id="siteNotice">'+
		      '</div>'+
		      '<h3 id="firstHeading" class="firstHeading"><img src={{prof_img}} class="img-rounded">  {{screenName}}</h3>'+
		      '<div id="bodyContent">'+
		      "{{text}}"+
		      '</div>'+
		      '</div>';

		var infowindow = new google.maps.InfoWindow({
		      content: contentString
		  });

		var marker = new google.maps.Marker({
		      position: new_result[0].geometry.location,
		      map: map,
		      title: 'Tweet'
		  });
		google.maps.event.addListener(marker, 'click', function() {
		    infowindow.open(map,marker);
		});
		});
		% end	
	    
	}	
		else {
	      alert('Geocode was not successful for the following reason: ' + status);
	    }
  });

  var myLatlng = new google.maps.LatLng(-25.363882,131.044922);
  

  // var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
  /*
  var contentString = '<div id="content">'+
      '<div id="siteNotice">'+
      '</div>'+
      '<h1 id="firstHeading" class="firstHeading">Uluru</h1>'+
      '<div id="bodyContent">'+
      '<p><b>Uluru</b>, also referred to as <b>Ayers Rock</b>, is a large ' +
      'sandstone rock formation in the southern part of the '+
      'Northern Territory, central Australia. It lies 335&#160;km (208&#160;mi) '+
      'south west of the nearest large town, Alice Springs; 450&#160;km '+
      '(280&#160;mi) by road. Kata Tjuta and Uluru are the two major '+
      'features of the Uluru - Kata Tjuta National Park. Uluru is '+
      'sacred to the Pitjantjatjara and Yankunytjatjara, the '+
      'Aboriginal people of the area. It has many springs, waterholes, '+
      'rock caves and ancient paintings. Uluru is listed as a World '+
      'Heritage Site.</p>'+
      '<p>Attribution: Uluru, <a href="http://en.wikipedia.org/w/index.php?title=Uluru&oldid=297882194">'+
      'http://en.wikipedia.org/w/index.php?title=Uluru</a> '+
      '(last visited June 22, 2009).</p>'+
      '</div>'+
      '</div>';

  var infowindow = new google.maps.InfoWindow({
      content: contentString
  });

  var marker = new google.maps.Marker({
      position: myLatlng,
      map: map,
      title: 'Uluru (Ayers Rock)'
  });
  google.maps.event.addListener(marker, 'click', function() {
    infowindow.open(map,marker);
  }); */ 
 
}

google.maps.event.addDomListener(window, 'load', initialize);

    </script>
  </head>

  <body>
  <!-- <img src="http://www.logomaker.com/logo-images/555b7084659959ad.gif"/>
  <a href="http://www.logomaker.com"><img src="http://www.logomaker.com/images/logos.gif" alt="logo design" border="0"/></a> -->

  
  <script src="/static/bootstrap.min.js"></script>
  <script src="/static/bootstrap.js"></script>
  <script src="/static/bootstrap-tooltip.js"></script>

  <div class="navbar navbar-inverse navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container">
          
          <a class="brand pull-left" href="/"><em>Twitter Influence Analyzer </em><small>v1.0</small></a>
	  
          <div class="nav-collapse collapse">
           	<form action="/dispcalc" method="post" class="navbar-form pull-right">
 		<input class="span3" type="text" name="twitter_name" value="" placeholder="Enter Twitter Name" />
		<input type="submit" value="Analyze!" class= "btn btn-info">
  		</form>
          </div>  <!--  /.nav-collapse  -->
        </div>
      </div>
  </div>  <!-- end of div for nav bar-->


<div class="container-fluid">
  <div class="row-fluid">

<div class="span4">
  <table class="table table-condensed">
  <h1>Influencer Score Result: {{totalscore}}/200</h1>
  <table class="table table-condensed">
  <tr>
  <td>Twitter Name:</td>
  <td>{{t_name}}</td>
  </tr>
  <tr>
  <td>Klout Score: </td>
  <td>{{score}}</td>
  </tr>
  <tr>
  <td># of Twitter Followers:</td>
  <td>{{fcount}}</td>
  </tr>
  <tr>
  <td>Follower Score:</td>
  <td>{{fscore}}</td>
  </tr>
  <tr>
  <td>Retweet Count:</td>
  <td>{{rtcount}}</td>
  </tr>
  <tr>
  <td>Retweet Score:</td>
  <td>{{rtscore}}</td>
  </tr>
  <tr>
  <td>Recent Mentions:</td>
  <td>{{mcount}} out of a possible 100</td>
  </tr>
  </table>
  <br>
  <table border=0>
  <tr>
  <td>
  <form action="/savedata" method="post">
  <input type="hidden" name="totalscore" value="{{totalscore}}">
  <input type="hidden" name="t_name" value="{{t_name}}">
  <input type="hidden" name="fcount" value="{{fcount}}">
  <input type="hidden" name="fscore" value="{{fscore}}">
  <input type="hidden" name="rtcount" value="{{rtcount}}">
  <input type="hidden" name="rtscore" value="{{rtscore}}">
  <input type="hidden" name="mcount" value="{{mcount}}">
  <input type="submit" value="Save User to Database" class="btn btn-success">
  </form>
  </td>
  <td>
  <form action="/displayall" method="post">
  <input type="submit" value="View Database" class="btn btn-primary">
  </form>
  </td>
  </table>
</div>   <!-- end of span 4 -->

<div class="span8">
  <div class="row-fluid">
  <div>
  <h3>Last 10 Tweets:</h3>
  	<table class="table table-condensed"> 
  	<tr>
  		<td>Tweet Text</td>
  		<td># Retweets</td>
  	</tr>
		%include
  	</table>
  </div> <!-- end of the span6 for table-->
  </div> <!-- end of row-fluid for span6 -->


<div class="row-fluid">
  <div>
  <h3>Recent Mentions: </h3>
  <div id="map-canvas"></div> 
  </div> <!-- end of span6 for map-canvas-->
</div> <!-- end of row fluid for span6-->
 
</div> <!-- end of the span8 div -->


</div>  <!-- end the div row-fluid -->
</div>  <!-- ends the div container-fluid --> 

</body>
  </html>
