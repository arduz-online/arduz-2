<?php

$data	=	array();
$data	=	mysql_fetch_array($database->query('SELECT * FROM `configuracion` LIMIT 1'));

require '_inc/game.logic.php';

function render_ranking($by='1'){
	global $database, $timenow, $session,$data;
	?><table class="rank"><tr><td style="width:16px;" class="rh"></td><td style="width:200px;" class="rh"><?php echo get_header_title_cases('Usuario',10);?></td><td style="width:80px;" class="rh"><?php echo get_header_title_cases('Puntos',10);?></td><td style="width:80px;" class="rh"><?php echo get_header_title_cases('Honor',10);?></td><td style="width:45px;" class="rh"><?php echo get_header_title_cases('Frags',10);?></td><td style="width:45px;" class="rh"><?php echo get_header_title_cases('Muertes',10);?></td></tr><?php
	if( ($data['ultimoupd'.$by]<($timenow-3600)) and $session->logged_in ){
		$data['ultimoupd'.$by]=$timenow;
		$sql = $database->query('SELECT `ID` , `username` , `frags` , `muertes` , `puntos` , `honor` , `rank` , `rank_old` FROM `users` WHERE ban<120 ORDER BY `'.($by=='1'?'puntos':'honor').'` DESC LIMIT 0 , 100');
		$ii=1;
		while($datos = mysql_fetch_array($sql)){
			$contenido.='<tr><td class="j0">'.$ii.'</td><td class="j1"><b><!--<a href="usuario_'.$datos['ID'].'.php?'.$datos['username'].'">-->'.$datos['username'].'<!--</a>--></b></td><td class="j2'.($by==='1'?' boldi':'').'">'.$datos['puntos'].'</td><td class="j2'.($by==='2'?' boldi':'').'">'.$datos['honor'].'</td><td class="j3">'.$datos['frags'].'</td><td class="j4">'.$datos['muertes'].'</td></tr>'."\n";
			++$ii;
		}
		$contenido .= "<!--Actualizado el dia ". date("d-m-y") ." a las $timenow ". date("H:i:s") ." horas-->";
		$fch= fopen('_content/rana'.$by.'.html', "w"); // Abres el archivo para escribir en él
		fwrite($fch, $contenido); // Grabas
		fclose($fch); // Cierras el archivo.
		echo $contenido;
		unset($contenido);
		$database->uquery("UPDATE `configuracion` SET `ultimoupd$by`='$timenow' LIMIT 1");
	} else {
		readfile('_content/rana'.$by.'.html');
	}

	$tiempo =intval(($timenow-$data['ultimoupd'.$by])/60);
	if ($tiempo > 2) {
		$add = '<b style="color:cyan;">Hace '.$tiempo. ' minutos.</b>';
	} elseif ($timenow==$data['ultimoupd3']) {
		$add = '<b style="color:cyan;">Hace 1 segundo.</b>';
	} else {
		$add = '<b style="color:cyan;">Hace menos de un minuto</b>';
	}
	echo '<tr><td colspan="5"><br/>Ultima actualizaci&oacute;n: ',$add,'</td></tr></table>';
}

function render_pj_ranking(){
	global $database, $timenow, $session, $data;
	echo '<span class="right margen">',get_header_title_cases('Clan',10),'</span><span class="left margen">',get_header_title_cases('Personaje',10),'</span><div class="clear"></div>';
	if (($data['ultimorankeo']<($timenow-86400)) and $session->logged_in) {
		rank_update();
		readfile('_content/rana3.html');
	} else {
		if( ($data['ultimoupd3']<($timenow-3600)) and $session->logged_in ){
			$clan=$database->getClanArray();
			$data['ultimoupd3']=$timenow;
			$sql = $database->query('SELECT `ID`,`nick` , `clan` , `armcao` FROM `pjs` WHERE IDCuenta>0 ORDER BY `order` DESC LIMIT 0 , 100');
			$ii=1;
			while($datos = mysql_fetch_array($sql)){
				$clanx='';
		
				if( $datos['clan']>0 ){
					$clanx=' <a href="clan_'.$datos['clan'].'.php?'.str_replace(' ','_',$clan[$datos['clan']]).'" title="Ver clan '.$clan[$datos['clan']].'" class="right">&lt;'.$clan[$datos['clan']].'&gt;</a>';
				}
				$contenido.='<div class="rpj">'.$clanx.'<span class="left">'.$ii.' <b><!--<a href="personaje_'.$datos['ID'].'.php?'.$datos['nick'].'" class="acao'.get_tipografia_pj($datos['armcao']).'">-->'.$datos['nick'].'<!--</a>--></b></span></div><div class="clear"></div>';
				++$ii;
			}
			$contenido .= "<!--Actualizado el dia ". date("d-m-y") ." a las $timenow ". date("H:i:s") ." horas-->";
			$fch= fopen("_content/rana3.html", "w"); // Abres el archivo para escribir en él
			fwrite($fch, $contenido); // Grabas
			fclose($fch); // Cierras el archivo.
			$database->uquery("UPDATE `configuracion` SET `ultimoupd3`='$timenow' LIMIT 1");
			echo $contenido;
			unset($contenido);
		} else {
			readfile('_content/rana3.html');
		}
	}
	$tiempo =intval(($timenow-$data['ultimoupd3'])/60);
	if ($tiempo > 2) {
		$add = '<b style="color:cyan;">Hace '.$tiempo. ' minutos.</b>';
	} elseif ($timenow==$data['ultimoupd3']) {
		$add = '<b style="color:cyan;">Hace 1 segundo.</b>';
	} else {
		$add = '<b style="color:cyan;">Hace menos de un minuto</b>';
	}
	echo '<br/>Ultima actualizaci&oacute;n: ',$add; 
}

	function rank_update(){
		global $database,$timenow;
		/*$start = 1;
		$query = $database->query('SELECT `ID`, `puntos`,`rank` FROM `users` WHERE `honor`>0 ORDER BY `honor` DESC;'); 
	    while ($row = mysql_fetch_assoc($query)){
		    $database->uquery('UPDATE `users` SET `rank_old`=\''.$row['rank'].'\',`rank`=\''.$start.'\' WHERE `ID` = \''.$row['ID'].'\' LIMIT 1;');       
		    ++$start;
		}*/
		$database->query('SET @rank:=0;');
		$database->query('UPDATE `users` SET `rank_old`=`rank`,`rank`=@rank:=@rank+1 ORDER BY `honor` DESC;');
		$database->uquery("UPDATE `configuracion` SET `ultimorankeo`='$timenow' LIMIT 1");
	}

if($_GET['cual']==='puntos'){
	$page['title']='Arduz Online - Ranking de usuarios - Puntos';
	$page['desc']='Ranking de usuarios por puntos en Arduz Online';
	template_header();
	echo '<div class="margen_">',get_header_title_cases('Ranking por Puntos',23,'h1');
	render_ranking('1');
} elseif($_GET['cual']==='honor'){
	$page['title']='Arduz Online - Ranking de usuarios - Honor';
	$page['desc']='Ranking de usuarios por honor en Arduz Online';
	template_header();
	echo '<div class="margen_">',get_header_title_cases('Ranking por honor',23,'h1');
	render_ranking('2');
} elseif($_GET['cual']==='clanes'){
	$page['title']='Arduz Online - Ranking de clanes';
	$page['desc']='Ranking de clanes en Arduz Online';
	template_header();
	echo '<div class="margen_">',get_header_title_cases('Ranking de clanes',23,'h1');
	$qery=$database->query("SELECT * FROM `clanes` ORDER BY puntos DESC");
	$o=9;
	$c=0;
	$ac=0;
	while ($c=mysql_fetch_array($qery)){
		if($o>0){$o--;$o--;}
		echo '<div style="font-size:'.(10+$o).'pt;" id="divclan"><a title="<b>'.$c['Nombre'].'</b> #'.$c['rank_puntos'].'<br/><b>Puntos: '.$c['puntos'].'</b><br/><b>Frags: '.$c['matados'].'</b><br/><b>Miembros: '.$c['miembros'].'</b>" href="clan_'.$c['ID'].'.php?'.$c['Nombre'].'" class="tooltip">&lt;'.$c['Nombre'].'&gt;</a></div>';
	}
} else {
	$page['title']='Arduz Online - Ranking';
	$page['desc']='Ranking de personajes en Arduz Online';
	template_header();
	echo '<div class="margen_">',get_header_title_cases('Ranking de personajes',23,'h1');
	render_pj_ranking();
}
echo '</div>';
template_divisor();
?>
<div id="toolbox">
<?php echo get_header_title_cases('Ranking',23);?>
<a href="ranking.php" title="Personajes">Personajes</a><br/>
<a href="ranking_puntos.php" title="Puntos">Puntos</a><br/>
<a href="ranking_honor.php" title="Honor">Honor</a><br/>
<a href="ranking_clanes.php" title="Clanes">Clanes</a>
</div><div class="clear"></div>
<?php template_footer(); ?>