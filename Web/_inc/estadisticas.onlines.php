<?php 
	$i=0;
	$tmp=0;
	$estad = mysql_query('SELECT * FROM `est-online` ORDER BY `order` DESC LIMIT 24;');
	while ($estadx = mysql_fetch_array($estad))
	{
	if($estadx['num']>$dia[$estadx['fecha']])
	{
		$dia[$estadx['fecha']]=$estadx['num'];
	}
	if($i<39)
	{
		$leyendaitem=$estadx['hora']." Hs. ".$estadx['fecha'];
		if ($i != '0')
			$varsx.=',';
	    $varsx.='{"Value":["'.$estadx['num'].'","'.$estadx['num'].''.'"],"Label":["'.$i.'","'.$leyendaitem.'"]}';
		if($estadx['num']>$tmp){$tmp=$estadx['num'];}
		++$i;
	}
	}
	
	$fillcolor='30668';////COLOR DE LA LINEA WTF?? 30668
	$activecolor='30668';////COLOR DE LA LINEA WTF?? 30668
	$fillalpha='50';/////////ALPHA DE LO DE ABAJO DE LA LINEA
	$ancho='4';
	$radio='7';
	$leyenda='Maximos online';
	$marca=date('Y').date('m');

	$vars='"Graph":{"ShowHover":true,"Format":"DASHBOARD","ValueLabel":"';
	$vars.=$leyenda.'","StateQuery":"id\u003d8423173\u0026pdr\u003d'.date('Y').date('m').'01-'.date('Y').date('m').'31\u0026cmp\u003daverage\u0026trows\u003d5\u0026gdfmt\u003dnth_day\u0026\u0026eid\u003dDashboardRequest\u0026rpt\u003dVisitorsOverviewReport\u0026tab\u003d0\u0026tchcol\u003d0\u0026tst\u003d0\u0026tscol\u003d0\u0026tsdir\u003d0\u0026mdet\u003dWORLD\u0026midx\u003d0\u0026gidx\u003d0\u0026gdfmt\u003dnth_day","Compare":false,"SummaryValue":["458","458"],"';
	$vars.='XAxisLabels":';
	$vars.='[';
	$vars.='["'.$marca.'07","'.$marca.'"],';
	$vars.='["'.$marca.'14","'.$marca.'"],';
	$vars.='["'.$marca.'21","'.$marca.'"],';
	$vars.='["'.$marca.'28","'.$marca.'"]';
	$vars.=']';
	$vars.=',"Link":"index.php?\u003d1",';
	$vars.='"HoverType":"primary_compare","UrlPath":"/","StateBaseQuery":"id\u003d8423173\u0026pdr\u003d';
	$vars.=date('Y').date('m').'01-'.date('Y').date('m').'31';//'20080701-20080731';
	$vars.='\u0026cmp\u003daverage\u0026trows\u003d5\u0026gdfmt\u003dnth_day","SelectedSeries":["primary","compare"],"Series":[{"SelectionStartIndex":0,"SelectionEndIndex":30,"Style":{';
	$vars.='"';
	$vars.='PointShape":"CIRCLE","';
	$vars.='PointRadius":'.$radio.',"';
	$vars.='FillColor":';
	$vars.=$fillcolor;////COLOR DE LA LINEA WTF?? 30668
	$vars.=',"';
	$vars.='FillAlpha":';
	$vars.=$fillalpha;/////////ALPHA DE LO DE ABAJO DE LA LINEA
	$vars.=',"';
	$vars.='LineThickness":'.$ancho.',"';
	$vars.='ActiveColor":'.$activecolor.',"';
	$vars.='InactiveColor":11654895},"';
	$vars.='Label":"'.$leyenda.'","Id":"primary","YLabels":';
	$vars.='[';
	//$vars.='["100","100"],';
	//$vars.='["500","500"],';
	$vars.='["0","Usuarios/hora."],';
	$vars.='["'.($tmp+1).'","'.($tmp+1).'"]';
	$vars.='],"ValueCategory":"visitors","';
	$vars.='Points":['.$varsx;
	$vars.=']}],"Id":"DashboardComponent_853096142"';
	echo "<h2>Maximos users por hora</h2><embed height='90' width='100%' salign='tl' scale='noScale' quality='high' bgcolor='#000000' 
	flashvars='input={".rawurlencode($vars)."}}&locale=es-ES' pluginspage='http://www.macromedia.com/go/getflashplayer' type='application/x-shockwave-flash' src='OverTime.swf'/>";
	
	/*$i=0;
	$tmp=0;
	$varsx="";
	foreach($dia as $k => $v)
	{
		$leyendaitem=$k;
		if ($i != '0')
			$varsx.=',';
	    $varsx.='{"Value":["'.$v.'","'.$v.''.'"],"Label":["'.$i.'","'.$leyendaitem.'"]}';
		if($v>$tmp){$tmp=$v;}
		++$i;
	}
	$fillcolor='30668';////COLOR DE LA LINEA WTF?? 30668
	$activecolor='30668';////COLOR DE LA LINEA WTF?? 30668
	$fillalpha='50';/////////ALPHA DE LO DE ABAJO DE LA LINEA
	$ancho='4';
	$radio='7';
	$leyenda='Maximos online';
	$marca=date('Y').date('m');

	$vars='"Graph":{"ShowHover":true,"Format":"DASHBOARD","ValueLabel":"';
	$vars.=$leyenda.'","StateQuery":"id\u003d8423173\u0026pdr\u003d'.date('Y').date('m').'01-'.date('Y').date('m').'31\u0026cmp\u003daverage\u0026trows\u003d5\u0026gdfmt\u003dnth_day\u0026\u0026eid\u003dDashboardRequest\u0026rpt\u003dVisitorsOverviewReport\u0026tab\u003d0\u0026tchcol\u003d0\u0026tst\u003d0\u0026tscol\u003d0\u0026tsdir\u003d0\u0026mdet\u003dWORLD\u0026midx\u003d0\u0026gidx\u003d0\u0026gdfmt\u003dnth_day","Compare":false,"SummaryValue":["458","458"],"';
	$vars.='XAxisLabels":';
	$vars.='[';
	$vars.='["'.$marca.'07","'.$marca.'"],';
	$vars.='["'.$marca.'14","'.$marca.'"],';
	$vars.='["'.$marca.'21","'.$marca.'"],';
	$vars.='["'.$marca.'28","'.$marca.'"]';
	$vars.=']';
	$vars.=',"Link":"index.php?\u003d1",';
	$vars.='"HoverType":"primary_compare","UrlPath":"/","StateBaseQuery":"id\u003d8423173\u0026pdr\u003d';
	$vars.=date('Y').date('m').'01-'.date('Y').date('m').'31';//'20080701-20080731';
	$vars.='\u0026cmp\u003daverage\u0026trows\u003d5\u0026gdfmt\u003dnth_day","SelectedSeries":["primary","compare"],"Series":[{"SelectionStartIndex":0,"SelectionEndIndex":30,"Style":{';
	$vars.='"';
	$vars.='PointShape":"CIRCLE","';
	$vars.='PointRadius":'.$radio.',"';
	$vars.='FillColor":';
	$vars.=$fillcolor;////COLOR DE LA LINEA WTF?? 30668
	$vars.=',"';
	$vars.='FillAlpha":';
	$vars.=$fillalpha;/////////ALPHA DE LO DE ABAJO DE LA LINEA
	$vars.=',"';
	$vars.='LineThickness":'.$ancho.',"';
	$vars.='ActiveColor":'.$activecolor.',"';
	$vars.='InactiveColor":11654895},"';
	$vars.='Label":"'.$leyenda.'","Id":"primary","YLabels":';
	$vars.='[';
	//$vars.='["100","100"],';
	//$vars.='["500","500"],';
	$vars.='["0","Usuarios/hora."],';
	$vars.='["'.($tmp+1).'","'.($tmp+1).'"]';
	$vars.='],"ValueCategory":"visitors","';
	$vars.='Points":['.$varsx;
	$vars.=']}],"Id":"DashboardComponent_853096142"';
	echo "<h2>Maximos users por dia</h2><embed height='90' width='100%' salign='tl' scale='noScale' quality='high' bgcolor='#000000' 
	flashvars='input={".rawurlencode($vars)."}}&locale=es-ES' pluginspage='http://www.macromedia.com/go/getflashplayer' type='application/x-shockwave-flash' src='OverTime.swf'/>";
	*/
	?>