<?php
if($session->logged_in){
	if($session->numpjs > 0){
		
		$clanID		=	intval($_REQUEST['cual']);
		
		include '_inc/game.logic.php';
		include '_inc/panel/clanes.inc.php';
		if($clanID === 0) header('Location: index.php');
		if(cargar_clan($clanID) === false) header('Location: index.php');
		
		$page['title']='Arduz Online - Clan - '.$clan_act['Nombre'];	
		$page['head']='';
		template_header();
		
		echo '<a class="pj_link margen_imagena" href="clan_'.$clanID.'.php" id="clan"><span class="pj">',get_header_title_cases($clan_act['Nombre'],22),'<div class="clear"></div><!--<span class="arial11 ma15">Volver al panel del clan</span>--></span></a><b id="err" style="display:none;">No ten&eacute;s suficiente oro para comprar &eacute;ste objeto</b>';
		echo '<div class="ma20">'.get_header_title_cases('Solicitud de ingreso',20);
		if( intval($_POST['pj'])>0 ){
			$req	= intval($_POST['pj']);
			$infoPJ	= $session->get_pj($req);
			if( $infoPJ === 0 ){ echo "<b id='err'>Error en el personaje.</b>"; } else {
				if( $infoPJ['clan']==='0' ){
					$soli=$database->query("SELECT * FROM `solicitud-clan` WHERE `clan`='$clanID' AND `userid`='$infoPJ[ID]'");
					if( mysql_num_rows($soli)===0 ){
						$database->uquery("INSERT INTO `solicitud-clan` VALUES (NULL , '$clanID', '$infoPJ[ID]', '".time()."');");
						$database->uquery("DELETE FROM `solicitud-clan` WHERE fecha < '".(time()-302400)."'");
						echo "<b id='oka'>Se envi&oacute; la solicitud de ingreso al clan.</b>";
					} else {
						echo "<b id='oka'>Ya enviaste solicitud a este clan.</b>";
					}
				} else {
					echo "<b id='err'>Ya perteneces a un clan.</b>";
				}
			}
		
		}		
		echo '<div class="margen_"><form method="POST" action="" id="formulario"><label>Selecciona tu personaje</label><select name="pj">';
		for($i=0;$i<$session->numpjs;$i++){
			if($session->pjs_clanes[$i]==0) echo '<option value="'.$session->pjs[$i].'">'.$session->pjs_nicks[$i].'</option>';
		}
		echo '</select><div class="clear"></div><label></label><input type="submit" value="Enviar solicitud" id="Submit"/></form></div></div>';
		echo '<div class="clear"></div><br/>&nbsp;<div class="clear"></div>';
		template_divisor();
		template_menu();
		template_footer();
	} else header('Location: panel.php');
} else go_login_page();
?>