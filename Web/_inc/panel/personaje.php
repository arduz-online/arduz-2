<?php
	$pj			=	intval($_REQUEST['cual']);
	$infoPJ		=	$database->getPJInfo($pj);
	
	if( $infoPJ === 0 ){
		header('Location: index.php');
		exit();
	}
	
	include '_inc/game.logic.php';
	$page['title']='Arduz Online - Panel - Ver personaje - '.$infoPJ['nick'];		
	template_header();
	$tipografia	=	get_tipografia_pj($infoPJ['armcao']);
	
	echo '<div class="shpj">',get_header_title_cases(utf8_decode($infoPJ['nick']),$tipografia),'</div>';
	
	echo '
<div class="right">
<div id="render_pj" class="heads_'.$infoPJ['head'].'"></div>
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
<div class="clear"></div>';
	echo '<div class="clear"></div>';
	template_divisor();
	template_menu();
	template_footer();
?>