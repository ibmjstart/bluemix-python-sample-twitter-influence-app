% for j in range(0, totinf):
%	twitname = cursor[j]['twitname']
%	mcount = cursor[j]['mcount']
%	fcount = cursor[j]['fcount']
%	fscore = cursor[j]['fscore']
%	rtcount = cursor[j]['rtcount']
%	rtscore = cursor[j]['rtscore']
%	totalscore= cursor[j]['totalscore']
<tr>
	<form action="/delselected" method = "post">
	<td>{{twitname}}</td>
	<td>{{mcount}}</td>
	<td>{{fcount}}</td>
	<td>{{fscore}}</td>
	<td>{{rtcount}}</td>
	<td>{{rtscore}}</td>
	<td>{{totalscore}}</td>
	<td><input type="submit" value="Delete" class="btn btn-warning"></td>
	<input type="hidden" value={{twitname}} name="twitname">
	</form>
</tr>
% end
% rebase displayall totinf=totinf, smtp_flag=smtp_flag
