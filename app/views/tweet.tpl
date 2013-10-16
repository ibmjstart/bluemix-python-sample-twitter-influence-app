% for j in range(0,10):
% 	tweettext = rtweets[j].text
% 	retweetCount = rtweets[j].retweet_count
% 	location = rtweets[j].user.location
<tr>
	<td>{{tweettext}}</td>
	<td>{{retweetCount}}</td>
</tr>
% end
%rebase result totalscore=totalscore,t_name=t_name,fcount=fcount,fscore=fscore,rtcount=rtcount,rtscore=rtscore,mcount=mcount, score=score, result=result
