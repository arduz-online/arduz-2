<?php
$page['title']='Arduz Online - Estad&iacute;sticas de los servidores';
template_header(2);
echo '<div class="margen_">'.utf8_decode(get_header_title_cases('Estadísticas de los servidores',24));

function strTime($s) {
	$d = intval($s/86400);
	$s -= $d*86400;

	$h = intval($s/3600);
	$s -= $h*3600;

	$m = intval($s/60);
	$s -= $m*60;
	$str='';
	if ($d) $str = $d . ' dias ';
	if ($h) $str .= $h . ' horas ';
	if ($m) $str .= $m . ' minutos ';
	if ($s) $str .= $s . ' segs ';
	
	return $str;
}
?>
	<table class="est">
		<tr>
			<th>Nombre del servidor</th>
			<th>Mapa</th>
			<th>Jugadores</th>
		</tr>
	<?php
		$ii=0;
		$database->uquery("DELETE FROM `servers` WHERE `ultima` < '".(time()-900)."'");
		$result = $database->query('SELECT * FROM `servers` ORDER BY `players` DESC');
		$tn=time();
		while ($row=mysql_fetch_array($result))
		{
			$add='';
			if($session->userinfo['GM']>100){
				$add='<br/>Contrase&ntilde;a privada:'.$row['passwd'].'';
				$add.='<br/>Host:'.$row['IP'].':'.$row['PORT'].' ('.$row['HOST'].')';
				$add.='<br/>Ultimo ping:'.strTime($tn-$row['ultima']).'';
			}
				echo '
			<tr>
				<td class="j1"><a title="Iniciado hace '.strTime($tn-$row['inicio']).'<br/><b>'.$row['players'].' Jugadores</b>'.$add.'" href="#" class="tooltip" title="'.$ii.'">'.htmlspecialchars($row['Nombre']).'</a></td>
				<td>'.$row['Mapa'].'</td>
				<td class="tctr"><b>'.$row['players'].'/'.$row['maxusers'].'</b></td>
			</tr>
			';
			$total+=$row['players'];
			$total1+=$row['maxusers'];
			++$ii;
		}
		if ($ii===0)
		{
			echo '
		<tr>
			<td colspan="5" id="no-hay-servidores"><b>No hay servidores online.</b></td>
		</tr>
		';
		}
	?>
	<tr>
		<th>Personajes</th>
		<th>Usuarios</th>
		<th>Usuarios online</th>
	</tr>
	<?php
		echo '<tr>';
		$result	= $database->query('SELECT COUNT(*) as `ct` FROM pjs;');
		$row	= mysql_fetch_array($result);		
		echo '<td class="tctr">'.$row['ct'].'</td>';
		$result	= $database->query('SELECT COUNT(*) as `ct` FROM users;');
		$row	= mysql_fetch_array($result);		
		echo '<td class="tctr">'.$row['ct'].'</td>';		
		echo '<td class="tctr">'.($total+0).'/'.($total1+0).'</td></tr></table>';

	$i=0;
	$tmp=0;
	$estad = $database->query('SELECT * FROM `est-online` WHERE unica > '.date('ymd',time()-1739000).' ORDER BY `order` ASC LIMIT 24;');
	
	while ($estadx = mysql_fetch_array($estad)){
			if ($i !== 0)
				$varsx.=',';
			$varsx.='{"Value":["'.$estadx['num'].'","'.$estadx['num'].''.'"],"Label":["'.$i.'","'.date('d-m-Y',$estadx['order']).'"]}';
			if($estadx['num']>$tmp){$tmp=$estadx['num'];}
			++$i;
	}
	
	$fillcolor='10386257';////COLOR DE LA LINEA WTF?? 30668
	$activecolor='3351057';////COLOR DE LA LINEA WTF?? 30668
	$fillalpha='50';/////////ALPHA DE LO DE ABAJO DE LA LINEA

	$radio='3';
	$leyenda='Maximos online';
	$marca=date('Y').date('m');

	$vars='"Graph":{"ShowHover":true,"Format":"DASHBOARD","ValueLabel":"'.$leyenda.'","StateQuery":"id\u003d8423173\u0026pdr\u003d'.date('Y').date('m').'01-'.date('Y').date('m').'31\u0026cmp\u003daverage\u0026trows\u003d5\u0026gdfmt\u003dnth_day\u0026\u0026eid\u003dDashboardRequest\u0026rpt\u003dVisitorsOverviewReport\u0026tab\u003d0\u0026tchcol\u003d0\u0026tst\u003d0\u0026tscol\u003d0\u0026tsdir\u003d0\u0026mdet\u003dWORLD\u0026midx\u003d0\u0026gidx\u003d0\u0026gdfmt\u003dnth_day","Compare":false,"SummaryValue":["458","458"],"XAxisLabels":[["'.$marca.'07","'.$marca.'"],["'.$marca.'14","'.$marca.'"],["'.$marca.'21","'.$marca.'"],["'.$marca.'28","'.$marca.'"]]';
	$vars.=',"Link":"index.php?\u003d1","HoverType":"primary_compare","UrlPath":"/","StateBaseQuery":"id\u003d8423173\u0026pdr\u003d';
	$vars.=date('Y').date('m').'01-'.date('Y').date('m').'31';//'20080701-20080731';
	$vars.='\u0026cmp\u003daverage\u0026trows\u003d5\u0026gdfmt\u003dnth_day","SelectedSeries":["primary","compare"],"Series":[{"SelectionStartIndex":0,"SelectionEndIndex":30,"Style":{"PointShape":"CIRCLE","PointRadius":3,"FillColor":10386257,"FillAlpha":50,"LineThickness":5,"ActiveColor":3351057,"InactiveColor":8022354},"Label":"'.$leyenda.'","Id":"primary","YLabels":[';
	$vars.='["0","Usuarios/dia"],["'.($tmp+1).'","'.($tmp+1).'"]],"ValueCategory":"visitors","Points":['.$varsx.']}],"Id":"DashboardComponent_853096142"';
	echo "<embed height='90' width='100%' salign='tl' scale='noScale' quality='high' bgcolor='#000000' 
	flashvars='input={".rawurlencode($vars)."}}&locale=es-ES' pluginspage='http://www.macromedia.com/go/getflashplayer' type='application/x-shockwave-flash' src='$urls[2]OverTime.swf'/>";
		
echo'</div>';
template_footer(); ?>