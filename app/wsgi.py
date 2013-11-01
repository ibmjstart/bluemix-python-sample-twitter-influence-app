"""
/*-------------------------------------------------------------------*/
/*                                                                   */
/* Copyright IBM Corp. 2013 All Rights Reserved                      */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*        NOTICE TO USERS OF THE SOURCE CODE EXAMPLES                */
/*                                                                   */
/* The source code examples provided by IBM are only intended to     */
/* assist in the development of a working software program.          */
/*                                                                   */
/* International Business Machines Corporation provides the source   */
/* code examples, both individually and as one or more groups,       */
/* "as is" without warranty of any kind, either expressed or         */
/* implied, including, but not limited to the warranty of            */
/* non-infringement and the implied warranties of merchantability    */
/* and fitness for a particular purpose. The entire risk             */
/* as to the quality and performance of the source code              */
/* examples, both individually and as one or more groups, is with    */
/* you. Should any part of the source code examples prove defective, */
/* you (and not IBM or an authorized dealer) assume the entire cost  */
/* of all necessary servicing, repair or correction.                 */
/*                                                                   */
/* IBM does not warrant that the contents of the source code         */
/* examples, whether individually or as one or more groups, will     */
/* meet your requirements or that the source code examples are       */
/* error-free.                                                       */
/*                                                                   */
/* IBM may make improvements and/or changes in the source code       */
/* examples at any time.                                             */
/*                                                                   */
/* Changes may be made periodically to the information in the        */
/* source code examples; these changes may be reported, for the      */
/* sample code included herein, in new editions of the examples.     */
/*                                                                   */
/* References in the source code examples to IBM products, programs, */
/* or services do not imply that IBM intends to make these           */
/* available in all countries in which IBM operates. Any reference   */
/* to the IBM licensed program in the source code examples is not    */
/* intended to state or imply that IBM's licensed program must be    */
/* used. Any functionally equivalent program may be used.            */
/*-------------------------------------------------------------------*/
"""

import bottle
from bottle import *
import os,sys,logging, traceback, json, string, urllib, urllib2,oauth2
import tweepy
from klout import *
import pymongo
from pymongo import *
from pymongo import Connection
import csv
from StringIO import StringIO
from smtplib import SMTPException
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.MIMEBase import MIMEBase
from email import Encoders
from email.Utils import COMMASPACE, formatdate


# Twitter OAuth Authentication params:
# Enter the keys here that you get after registering the app with Bluemix
consumer_key =   "consumer key here"
consumer_secret= "consumer secret here"
access_token=  "access token here"
access_token_secret= "access secret here"

auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)

api = tweepy.API(auth)
# ---- end of twitter constants ---- 



# Klout Constants and Objects 
# Here the Klout Developer Key should be entered after registering the app with Klout
k = Klout('klout key here')
# ----- 

smtp_flag = False;

# MongoDB configs from BlueMix 
vcap_config = os.environ.get('VCAP_SERVICES')
decoded_config = json.loads(vcap_config)

for key, value in decoded_config.iteritems():
	if key.startswith('mongodb'):
		mongo_creds = decoded_config[key][0]['credentials']
	if 'SMTP' in key:
		smtp_creds = decoded_config[key][0]['credentials']
		smtp_flag = True

if smtp_flag:
	smtp_host = str(smtp_creds['smtpHost'])   
	smtp_port = str(smtp_creds['smtpPort'])

mongo_host = mongo_creds['hostname']
mongo_port = int(mongo_creds['port'])
mongo_username = mongo_creds['username']
mongo_password = mongo_creds['password']
mongo_db = mongo_creds['db']
mongo_url = str(mongo_creds['url'])
mongo_name = mongo_creds['name']

# --- configuring mongo 
client = pymongo.Connection(mongo_url)
mongoDB = client[mongo_db]
infcoll = mongoDB.infcollection

# ---- end of mongo config ---------- 

# ---- SMTP configs from Bluemix
# Uncomment this part if the SMTP service becomes available in BlueMix


# print "This is the smtp host: ", smtp_host, " and this is the smtp port: ", smtp_port

# -- end of SMTP configs  

#Provide all the static css and js files under the static dir to browser
@route('/static/:filename#.*#')
def server_static(filename):
	""" This is for JS files """
	return static_file(filename, root='static')

# Displays the home page
@bottle.get("/")
def testFunc():
	return bottle.template('home')


# calculates the influencer information
@bottle.post("/dispcalc")
def calcInfo():
	t_name = request.forms.get('twitter_name')
	t_name = t_name.replace('#', '')
	a_user = api.get_user(t_name)
	fcount = a_user.followers_count
	rtweets = api.user_timeline(t_name)
	
	mcount = 0
	url_params = {}
	url_params['q'] = '@'+t_name
	url_params['count']= 20
	url_params['result_type']='recent'
	result = rest_req('api.twitter.com','/1.1/search/tweets.json',url_params,consumer_key,consumer_secret,access_token,access_token_secret)
	# print result
	
	main_params = {}
	main_params['q'] = '@'+t_name
	main_params['count'] = 100
	main_params['result_type'] = 'recent'
	main_result = rest_req('api.twitter.com','/1.1/search/tweets.json',main_params,consumer_key,consumer_secret,access_token,access_token_secret)
	
	for i in main_result['statuses']:
		mcount = mcount +1
	
	
	rtcount = 0
	for j in range(0,10):
		"""tabletext = "{{tabletext}}" + '<tr><td>' + rtweets[j].text+ '</td>' + '<td>' + str(rtweets[j].retweet_count) + '</td></tr>'"""
		rtcount = rtcount + rtweets[j].retweet_count
	rtscore = 0
	fscore = 0
	
	if rtcount >= 100000:
		rtscore = 60
	elif rtcount >= 20000:
		rtscore = 50
	elif rtcount >= 10000:
		rtscore = 40
	elif rtcount >= 5000:
		rtscore = 30
	elif rtcount >= 1000:
		rtscore = 20
	elif rtcount >= 500:
		rtscore = 10
	elif rtcount >= 100:
		rtscore = 5
	elif rtcount >= 10:
		rtscore = 1
	
	if fcount >= 10000000:
		fscore = 40
	elif fcount >= 1000000:
		fscore = 35
	elif fcount >= 500000:
		fscore = 30
	elif fcount >= 100000:
		fscore = 25
	elif fcount >= 1000:
		fscore = 20
	elif fcount >= 500:
		fscore = 15
	elif fcount >= 100:
		fscore = 10
	elif fcount >= 10:
		fscore = 5
	
	totalscore = rtscore + fscore + mcount
	try: 
		
		# Get kloutId of the user by inputting a twitter screenName
		kloutId = k.identity.klout(screenName=t_name).get('id')
		
		# Get klout score of the user
		score = k.user.score(kloutId=kloutId).get('score')
	
		# User Influences information
		influences = k.user.influence(kloutId=kloutId)
		
		# User topics 
		topics = k.user.topics(kloutId=kloutId)
	except:
		score = "n/a"
	
	print "User's klout score is: %s" % (score)
	# print "User's Influences: \n %s" % json.dumps(influences)
	# print "User's topics: \n %s" % json.dumps(topics)
	# return bottle.template('test', topics=topics, influences=influences)
	return bottle.template('tweet', totalscore=totalscore,t_name=t_name,fcount=fcount,fscore=fscore,rtcount=rtcount,rtscore=rtscore,mcount=mcount, rtweets=rtweets, score=score, result=result)



# The OAuth request for new Twitter API v1.1
def rest_req(host, path, url_params, consumer_key, consumer_secret, token, token_secret):
  """Returns response for API request."""
  # Unsigned URL
  encoded_params = ''
  if url_params:
    encoded_params = urllib.urlencode(url_params)
  url = 'https://%s%s?%s' % (host, path, encoded_params)

  # Sign the URL
  consumer = oauth2.Consumer(consumer_key, consumer_secret)
  oauth_request = oauth2.Request('GET', url, {})
  oauth_request.update({'oauth_nonce': oauth2.generate_nonce(),
                        'oauth_timestamp': oauth2.generate_timestamp(),
                        'oauth_token': token,
                        'oauth_consumer_key': consumer_key})

  token = oauth2.Token(token, token_secret)
  oauth_request.sign_request(oauth2.SignatureMethod_HMAC_SHA1(), consumer, token)
  signed_url = oauth_request.to_url()

  # Connect
  try:
    conn = urllib2.urlopen(signed_url, None)
    try:
      response = json.loads(conn.read())
    finally:
      conn.close()
  except urllib2.HTTPError, error:
    response = json.loads(error.read())

  return response

# Saves the data to the mongoDB
@bottle.post('/savedata')
def saveData():
	t_name = str(request.forms.get('t_name'))
	totalscore = int(request.forms.get('totalscore'))
	fcount = int(request.forms.get('fcount'))
	fscore = int(request.forms.get('fscore'))
	rtcount = int(request.forms.get('rtcount'))
	rtscore = int(request.forms.get('rtscore'))
	mcount = int(request.forms.get('mcount'))
	existTest = infcoll.find({'twitname': t_name}).count()
	if existTest == 0:
		doc = {'twitname': t_name, 'totalscore': totalscore,'fcount': fcount,'fscore':fscore,'rtcount':rtcount,'rtscore': rtscore,'mcount': mcount}
		insert_id = infcoll.insert(doc)
		print "Document inserted"
	else:
		infcoll.update({'twitname': t_name},{"$set" : {'totalscore':totalscore}})
		infcoll.update({'twitname': t_name},{"$set" : {'fcount':fcount}})
		infcoll.update({'twitname': t_name},{"$set" : {'fscore': fscore}})
		infcoll.update({'twitname': t_name},{"$set" : {'rtcount': rtcount}})
		infcoll.update({'twitname': t_name},{"$set" : {'rtscore': rtscore}})
		infcoll.update({'twitname': t_name},{"$set": {'mcount': mcount}})
		print "Document Updated"
	cursor = list(infcoll.find())
	totinf = int(infcoll.count())
	# print "this is the value: %d" % totinf
	return bottle.template ('records',totinf=totinf,cursor=cursor, smtp_flag=smtp_flag)


#  Displays all the records in the database
@bottle.get('/displayall')
def displayData():
	cursor = list(infcoll.find())
	totinf = int(infcoll.count())

	"""'<a data-target="#myModal" class="btn btn-primary" data-toggle="modal">Send Records via Email</a>'"""
	
	return bottle.template ('records',totinf=totinf,cursor=cursor, smtp_flag=smtp_flag)

# Removes all the records from the database
@bottle.post('/clearall')
def clearAll():
	infcoll.remove()
	cursor = list(infcoll.find())
	totinf = int(infcoll.count())
	print "this is the value: %d" % totinf
	return bottle.template ('records',totinf=totinf,cursor=cursor, smtp_flag=smtp_flag)


# Removes only the selected stuff from the database
@bottle.post('/delselected')
def removeSelected():
	s = str(request.forms.get('twitname'))
	infcoll.remove({'twitname' : s})
	cursor = list(infcoll.find())
	totinf = int(infcoll.count())
	print "this is the value: %d" % totinf
	return bottle.template ('records',totinf=totinf,cursor=cursor, smtp_flag=smtp_flag)

# output the data to the csv file 
@bottle.post('/outputcsv')
def outputCSV():
	# csv_file = StringIO()
	fp = open('static/OUTPUT.csv', 'wb')
	c = csv.writer(fp, delimiter=',',quoting=csv.QUOTE_ALL)
	c.writerow(["Twitter Name","Mentions","Followers","Follower Score","Retweets","Retweet Score","Total Score"])
	cursor = list(infcoll.find())
	totinf = int(infcoll.count())
	for j in range(0, totinf):
		c.writerow([cursor[j]['twitname'],cursor[j]['mcount'],cursor[j]['fcount'],cursor[j]['fscore'],cursor[j]['rtcount'],cursor[j]['rtscore'],cursor[j]['totalscore']])
	fp.close()
	filename = 'OUTPUT.csv'
	return static_file(filename, root='static')


# sends the email and displays back the records page
# This part can be uncommented if the SMTP Service is available in BlueMix

@bottle.post('/sendmail')
def sendEmail():
	fp = open('static/OUTPUT.csv', 'wb')
	c = csv.writer(fp, delimiter=',',quoting=csv.QUOTE_ALL)
	c.writerow(["Twitter Name","Mentions","Followers","Follower Score","Retweets","Retweet Score","Total Score"])
	cursor = list(infcoll.find())
	totinf = int(infcoll.count())
	for j in range(0, totinf):
		c.writerow([cursor[j]['twitname'],cursor[j]['mcount'],cursor[j]['fcount'],cursor[j]['fscore'],cursor[j]['rtcount'],cursor[j]['rtscore'],cursor[j]['totalscore']])
	fp.close()
	
	receiver = request.forms.get('receiver')
	sender = request.forms.get('sender')
	message = 'Find attached the report from Twitter Influence Analyzer \n'
	# Create message container - the correct MIME type is multipart/alternative.
	msg = MIMEMultipart()
	msg['Subject'] = "Report from Twitter Influence Analyzer"
	msg['From'] = sender
	# Create the body of the message (a plain-text and an HTML version).
	text = ""
	html = message
	# Record the MIME types of both parts - text/plain and text/html.
	part1 = MIMEText(text, 'plain')
	part2 = MIMEText(html, 'html')
	# Attach parts into message container.
	# According to RFC 2046, the last part of a multipart message, in this case
	# the HTML message, is best and preferred.
	msg.attach(part1)
	msg.attach(part2)
	part = MIMEBase('application',"octet-stream")
	part.set_payload(open('static/OUTPUT.csv',"rb").read())
	Encoders.encode_base64(part)
	part.add_header('Content-Disposition', 'attachment; filename="OUTPUT.csv"')
	msg.attach(part)
	try:
		smtpObj = smtplib.SMTP(smtp_host,smtp_port)
		smtpObj.sendmail(sender, receiver, msg.as_string())
		print "Successfully sent email"
		smtpObj.quit()
	except smtplib.SMTPException:
		print "Error: unable to send email"
	
	return bottle.template ('records',totinf=totinf,cursor=cursor, smtp_flag=smtp_flag)


debug(True)

# Error Methods
@bottle.error(404)
def error404(error):
    return 'Nothing here, sorry!!'


application = bottle.default_app()

if __name__ == '__main__':
    port = int(os.getenv('PORT', '8000'))
    bottle.run(host='0.0.0.0', port=port)
