<?php
if($session->logged_in){
	if($session->numpjs > 0){
		$pj			=	intval($_REQUEST['cual']);
		$infoPJ		=	$session->get_pj($pj);
		
		if( $infoPJ === 0 ){
			header('Location: panel.php');
			exit();
		}
		
		include '_inc/game.logic.php';
		//include '_inc/_panel/clanes.inc.php';
		$tipografia	=	get_tipografia_pj($infoPJ['armcao']);
		$page['title']='Arduz Online - Panel - Borrar personaje';	
		template_header();	

		
		echo '<a class="pj_link margen_imagena" href="pj.php?pj='.$infoPJ['ID'].'" id="borra"><span class="pj">',get_header_title_cases(utf8_decode($infoPJ['nick']),$tipografia),'</span></a>';
		if($session->numpjs == 1){
			echo '<b id="err">No pod&eacute;s quedarte sin personajes.</b><div class="margen_">&nbsp;</div>';
		} else {
			if( $infoPJ['order']<50000 ){
				if( !empty($_POST['ver']) ){
					if( $_POST['ver'] == ($infoPJ['ID']^(int)date('yH')) ){
						$database->quitarPersonaje($infoPJ['ID'],$session->uid,($infoPJ['clan']>0));
						echo '<b id="oka">El personaje "'.$infoPJ['nick'].'" fue borrado de tu cuenta.</b><span class="ma20"><a href="panel.php">Volver a la lista de personajes</a></span>';
						$no=true;
					} else {
						echo '<b id="err">C&oacute;digo de verificaci&oacute;n es incorrecto.</b>';
					}
				}
				if($no!==true){
					echo '<div class="margen_">&iquest;Seguro quieres borrar el personaje "'.$infoPJ['nick'].'"?<br/><form method="POST" action="" id="formulario"><label>Escriba la verificaci&oacute;n:</label><div class="clear"></div><label for="ver">"'.($infoPJ['ID']^(int)date('yH')).'"</label><span class="input"><input id="ver" name="ver" type="text"/></span><div class="clear"></div><label></label><input type="submit" value="Borrar personaje" id="Submit"/></form></div>';
				}
			} else {
				echo '<b id="err">El personaje "'.$infoPJ['nick'].'" no puede ser borrado.</b><div class="margen_">&nbsp;</div>';
			}
		}
		echo '<div class="clear"></div>';
		
		template_divisor();
		template_menu();
		template_footer();
	} else header('Location: panel.php');
} else go_login_page();
?>