<?php
function ban_log($uid){
global $database;
echo '<div>[<a onclick="Toggle_vid(\'banlog\');">Ver baneos</a>]
	<div id="banlog" style="display:none;" class="ma20">';
		$cheat_log_q = $database->query_false('SELECT users.username,ban_log.* FROM `ban_log` INNER JOIN users ON users.ID=ban_log.gm WHERE uid = '.$uid.' ORDER BY TIME ASC');
		if($cheat_log_q!== false){
			echo '<table class="rank hhh"><tr><td></td><td class="rd"><b>GM</b></td><td class="rd"><b>Raz&oacute;n</b></td><td class="rd"><b>Tiempo</b></td></tr>';
			while($entrada = mysql_fetch_assoc($cheat_log_q)){
				echo '<tr><td>'.date('h:i d/m/Y',$entrada['time']).'</td><td><b>'.$entrada['username'].'</b>&nbsp;</td><td>'.$entrada['razon'].'</td><td>'.tiempoban($entrada['tiempo']).'</td></tr>';
			}
			echo '</table>';
		} else {
			echo 'Todav&iacute;a no fue baneado.';
		}
	echo '</div>
</div>';
}
if($session->logged_in){
include '_inc/game.logic.php';
$page['title']='Arduz Online - Panel';
template_header();

	//$database->ActualizarPjs($session->uid);

	if($session->numpjs > 0){
		$pjs		=	$session->pjs;
		$time_now	=	time();
		$clanes		=	$database->getClanArray();
		
		//if( $session->userinfo['last_r'] < date('yzH') ){
		//	update_ranking($session->userinfo);
		//}
		if($session->userinfo['PJBAN']>$time_now){
			echo '<div id="err">Tu cuenta est&aacute; baneada hasta <b>'.date('j/m/Y h:i',$session->userinfo['PJBAN']).' hs</b> (<b class="countdown" secs="'.($session->userinfo['PJBAN']-$time_now).'">--:--</b>)</div>';
		}
		echo get_header_title_cases('Mis personajes',22);
		$count = $session->numpjs;
		for($i=0;$i<$count;++$i){
			$entrenando	=	false;
			$tipografia	=	get_tipografia_pj($session->pjs_armcao[$i]);
			$add		= 	'';
			if( $session->pjs_times[$i]>0 ){
				if( $session->pjs_times[$i] > $time_now ){
					if( ($session->pjs_times[$i]-5) > $time_now ){
						$add = '<span class="ma15 conteo"><b>Entrenando</b> <b class="countdown" secs="'.($session->pjs_times[$i]-$time_now).'">--:--</b></span>';
						$entrenando=true;
					}
				} else {
					$gamelogic->completar_tarea($session->pjs,$session->pjs_times,$session->uid);
					$database->ActualizarPjs($session->uid);
					header('Location: panel.php');
					exit;
				}
			}
			/*if( $entrenando===false ){
				echo '<a href="pj.php?pj='.$session->pjs[$i].'" class="pj_link">';
			}*/
			
			echo "\n".'<div class="pj">
			<div>
				'.($session->pjs_clanes[$i]!=='0'?'
				<div class="right">
					'.get_header_title_cases($clanes[$session->pjs_clanes[$i]],20).'
				</div>':'').'
				<div style="float:left;">
					',get_header_title_cases(utf8_decode($session->pjs_nicks[$i]),$tipografia),'
				</div>
				<div class="clear"></div>',$add;
			
			if( $entrenando===false ){
				echo '<span><a href="pj.php?pj='.$session->pjs[$i].'" class="ma15"><b>Ir al panel del personaje</b></a></span>';
			}
			echo '
			</div>
</div>';

			/*if($entrenando===false){
				echo "\n</a>";
			}*/
		}



?>
<div style="text-align:right;margin-right:10px"><a href="agregarpj.php">Agregar personaje <b>+</b></a></div>
<?php
	echo '<div class="margen_">',get_header_title_cases('Ranking',22),'Ranking: <b><big><big><big>',$session->userinfo['rank'],'</big></big></big></b><br/>Puntos/oro: <b class="idv">',$session->userinfo['puntos'],'</b><br/>Honor: <b>',$session->userinfo['honor'],'</b><br/>Asesinatos: <b>',$session->userinfo['frags'],'</b><br/>Muertes: <b>',$session->userinfo['muertes'],'</b><br/><br/>';
	ban_log($session->uid);
} else {
	echo '<div class="margen_">',get_header_title_cases('¡Bienvenido a Arduz!',22),'
	<b class="ma20">Esperamos que disfrutes del juego y puedas y aportes tu granito de arena en ayudarnos a nosotros a crecer. Nosotros vamos a seguir trabajando en el desarrollo del juego para la comodidad y goze de nuestros usuarios, asimismo pedimos que sepan comportarse y se manejen con un mínimo de conciencia. ¡Respetar las reglas y disfrutar el juego son las únicas dos condiciones!
<br/><br/>
Saludos, Arduz Staff.
</b><div class="clear"></div><form action="agregarpj.php" method="GET"><input type="hidden" name="first" value="1"/><input type="submit" value="Crear personaje"/></form>';
}
echo '<div class="clear"></div></div>';
template_divisor();
template_menu();
template_footer();
} else {
	go_login_page();
}
?>