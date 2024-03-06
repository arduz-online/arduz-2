<?php
if($session->logged_in){
	if($session->numpjs > 0){
		
		$pj			=	intval($_REQUEST['pj']);
		$infoPJ		=	$session->get_pj($pj);
		
		if( $infoPJ === 0 ){
			header('Location: panel.php');
			exit();
		}
		
		include '_inc/game.logic.php';
		$page['title']='Arduz Online - Panel - Ver personaje';
		$page['head']='<link href="'.$urls[2].'heads.css" type="text/css" rel="stylesheet" />';
		template_header();
		$tipografia	=	get_tipografia_pj($infoPJ['armcao']);
		
		echo '<a class="pj_link" href="pj.php?pj='.$infoPJ['ID'].'"><div class="shpj">',get_header_title_cases(utf8_decode($infoPJ['nick']),$tipografia),'</div></a>';

		if( $infoPJ['cuando_termina']>0 ){
			if( $infoPJ['cuando_termina'] > $timenow ){
				header('Location: panel.php');
				exit();
			} else {
				$gamelogic->completar_tarea($session->pjs,$session->pjs_times,$session->uid);
				$database->ActualizarPjs($session->uid);
				header('Location: pj.php?pj='.$infoPJ['ID']);
				exit();
			}
		}
		
		$gamelogic->actualizar_inventario($pj);

		echo '
<div class="right">
	<div id="render_pj" class="right"><div id="rpjcabeza" class="heads_'.$infoPJ['cabeza'].'"></div></div>
	<div style="clear:both;"></div>
</div>
<div class="paupj">
'.$clases[$infoPJ['clase']],' ',$razas[$infoPJ['raza']].'
<br/>
Vida: <b'.($infoPJ['vidaup']<0?' style="color:#F00"':($infoPJ['vidaup']>0?' style="color:#0F0"':'')).'>['.($infoPJ['vidaup']>0?'+':'').$infoPJ['vidaup'],']</b><br/>
	<div id="jj">
		<div class="jjk">Magia: <span>'.$infoPJ['magia'].'/30</span><br/><span class=\'barras\'><div class=\'barra_fondo\'><div class=\'barra_verde\' style=\'width:'.($infoPJ['magia']/30*100).'%\'></div></div></span></div>
		<div class="jjk">Resistencia: <span>'.$infoPJ['resistencia'].'/30</span><br/><span class=\'barras\'><div class=\'barra_fondo\'><div class=\'barra_verde\' style=\'width:'.($infoPJ['resistencia']/30*100).'%\'></div></div></span></div>
		<div class="jjk">Defensa: <span>'.$infoPJ['defenza'].'/30</span><br/><span class=\'barras\'><div class=\'barra_fondo\'><div class=\'barra_verde\' style=\'width:'.($infoPJ['defenza']/30*100).'%\'></div></div></span></div>
		<div class="jjk">Combate: <span>'.$infoPJ['combate'].'/30</span><br/><span class=\'barras\'><div class=\'barra_fondo\'><div class=\'barra_verde\' style=\'width:'.($infoPJ['combate']/30*100).'%\'></div></div></span></div>
	</div>
</div>
<div class="clear"></div>
<div class="margen_">
<ul id="menu_pj">
<li id="inv"><a href="inventario_'.$infoPJ['ID'].'.php" class="tooltip" title="B&oacute;veda/Inventario">B&oacute;veda<span class="desc">Muestra los objetos de tu personaje y la b&oacute;veda de tu cuenta para depositar o retirar objetos.</span></a></li>
<li id="skills"><a href="trainer_'.$infoPJ['ID'].'.php">Entrenador<span class="desc">En este lugar pod&eacute;s entrenar distintas habilidades de tu personaje.</span></a></li>
<li id="trade"><a href="mercado_'.$infoPJ['ID'].'.php">Mercado<span class="desc">Compra el equipo adecuado para salir a luchar.</span></a></li>
<!--
<li id="attr"><a href="index.php?a=stats&pj='.$infoPJ['ID'].'">Secretos<span class="desc">Aqu&iacute; se muestran los secretos y premios desbloqueados en el juego!</span></a></li>-->
'.($infoPJ['clan']>0?'<li id="clan"><a href="clan_'.$infoPJ['clan'].'.php">Panel del clan<span class="desc">Chatea y encontr&aacute; a tus compa&ntilde;eros de clan en &eacute;sta p&aacute;gina.</span></a></li>':'').'

'.($infoPJ['order']<50000?'<li id="borra"><a href="borrarpj_'.$infoPJ['ID'].'.php">Borrar personaje<span class="desc">Pod&eacute;s borrar un personaje si este no est&aacute; muy avanzado en el juego.</span></a></li>':'').'
</ul>
</div>';
		
		echo '<div class="clear"></div>';
		template_divisor();
		template_menu();
		template_footer();
	} else header('Location: panel.php');
} else go_login_page();
?>