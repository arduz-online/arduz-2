<?php
$lang=array(
	1=>'<span class="desc">Son necesarios ',
	2=>'<b class="verde">',
	3=>'<b class="rojo">',
	4=>'Entrenar ',
	5=>' nivel ',
	6=>'magia',
	7=>'combate',
	8=>'defensa',
	9=>'resistencia',
	10=>'<a href="trainer_',
	11=>'</b> puntos y <b>',
	12=>'</b></span></a></li>');
if($session->logged_in){

	if( $session->numpjs > 0 ){
		$pj			=	intval($_REQUEST['cual']);
		$skill		=	intval($_REQUEST['cuals']);
		
		$infoPJ		=	$session->get_pj($pj);
		if( $infoPJ === 0 ){
			header('Location: panel.php');
			exit();
		}
		
		include '_inc/game.logic.php';
		$page['title']='Arduz Online - Panel - Entrenador';
		template_header();
		//$database->ActualizarPjs($session->uid);
		$tipografia	=	get_tipografia_pj($infoPJ['armcao']);
		
		echo '<a class="pj_link margen_imagena" href="pj.php?pj='.$infoPJ['ID'].'" id="skills"><span class="pj">',get_header_title_cases($infoPJ['nick'],$tipografia),'<div class="clear"></div><span class="arial11 ma15">Volver al panel del personaje</span></span></a>';
		
		if( $infoPJ['cuando_termina']>0 ){
			if( $infoPJ['cuando_termina'] > $timenow ){
				header('Location: panel.php');
				exit();
			} else {
				$gamelogic->completar_tarea($session->pjs,$session->pjs_times,$session->uid);
				$database->ActualizarPjs($session->uid);
				header('Location: trainer_'.$infoPJ['ID'].'.php');
				exit();
			}
		}
		if( $skill>=1 && $skill<=4 ){
			$puntos		=	calcular_precio($skill,($infoPJ[$skills['nombres_db'][$skill]]+1));
			if( $session->userinfo['puntos']>=$puntos ){
				if( $infoPJ[$skills['nombres_db'][$skill]]<30 ){
					$tiempo	=	$timenow + calcular_tiempo($skill,($infoPJ[$skills['nombres_db'][$skill]]+1));
					//$tiempo=$timenow + 360;
					if( $session->userinfo['next_check'] > $tiempo ) {$add=', next_check='.$tiempo;}
					
					$database->uquery('UPDATE users SET puntos=puntos-'.$puntos.$add.' WHERE ID = '.$session->uid.' LIMIT 1');
					$database->uquery('UPDATE pjs SET pagado='.$puntos.', cuando_termina='.$tiempo.', cualskill='.$skill.' WHERE ID='.$pj);
					$database->ActualizarPjs($session->uid);
					header('Location: panel.php&msg=entrenando');
					exit();
				} else {
					echo '<b id="err">No pod&eacute;s entrenar m&aacute;s esta habilidad.</b><br/>';
				}
			} else {
				echo '<b id="err">No ten&eacute;s los puntos necesarios para entrenar esta habilidad</b><br/>';
			}
		}
		echo '
		<div class="margen_">
';

		echo '<ul id="menu_ent">';
			if($infoPJ['magia']<30){
				$skill_n	=	$infoPJ['magia']+1;
				$precio		=	calcular_precio(1,$skill_n);
				$add		=	($session->userinfo['puntos']>=$precio?$lang[2]:$lang[3]);
				echo '<li id="magia">',$lang[10], $infoPJ['ID'].'.php?cuals=1">', $lang[4], $lang[6], $lang[5], $skill_n, $lang[1], $add, number_format($precio, 0, ',', '.'), $lang[11], strTime(calcular_tiempo(1,$skill_n)), '<div><span class=\'barras\'><div class=\'barra_fondo\'><div class=\'barra_verde\' style=\'width:'.($infoPJ['magia']/30*100).'%\'></div></div></span></div>', $lang[12];
			}
			if($infoPJ['combate']<30){
				$skill_n	=	$infoPJ['combate']+1;
				$precio		=	calcular_precio(2,$skill_n);
				$add		=	($session->userinfo['puntos']>=$precio?$lang[2]:$lang[3]);
				echo '<li id="combate">',$lang[10], $infoPJ['ID'],'.php?cuals=2">', $lang[4], $lang[7], $lang[5], $skill_n, $lang[1], $add, number_format($precio, 0, ',', '.'), $lang[11], strTime(calcular_tiempo(2,$skill_n)),'<div><span class=\'barras\'><div class=\'barra_fondo\'><div class=\'barra_verde\' style=\'width:'.($infoPJ['combate']/30*100).'%\'></div></div></span></div>', $lang[12];
			}
			if($infoPJ['defenza']<30){
				$skill_n	=	$infoPJ['defenza']+1;
				$precio		=	calcular_precio(3,$skill_n);
				$add		=	($session->userinfo['puntos']>=$precio?$lang[2]:$lang[3]);
				echo '<li id="defensa">',$lang[10], $infoPJ['ID'],'.php?cuals=3">', $lang[4], $lang[8], $lang[5], $skill_n, $lang[1], $add, number_format($precio, 0, ',', '.'), $lang[11], strTime(calcular_tiempo(3,$skill_n)),'<div><span class=\'barras\'><div class=\'barra_fondo\'><div class=\'barra_verde\' style=\'width:'.($infoPJ['defenza']/30*100).'%\'></div></div></span></div>', $lang[12];
			}
			if($infoPJ['resistencia']<30){
				$skill_n	=	$infoPJ['resistencia']+1;
				$precio		=	calcular_precio(4,$skill_n);
				$add		=	($session->userinfo['puntos']>=$precio?$lang[2]:$lang[3]);
				echo '<li id="resistencia">',$lang[10], $infoPJ['ID'],'.php?cuals=4">', $lang[4], $lang[9], $lang[5], $skill_n, $lang[1], $add, number_format($precio, 0, ',', '.'), $lang[11], strTime(calcular_tiempo(4,$skill_n)),'<div><span class=\'barras\'><div class=\'barra_fondo\'><div class=\'barra_verde\' style=\'width:'.($infoPJ['resistencia']/30*100).'%\'></div></div></span></div>', $lang[12];
			}
		echo '
		</ul>';
		echo '
		</div>';
		echo '<div class="clear"></div>';
		template_divisor();
		template_menu();
		template_footer();
	} else header('Location: panel.php');
} else go_login_page();
?>