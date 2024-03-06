<?php
if($session->logged_in){
	include '_inc/game.logic.php';
	
	
	
	$page['title']='Arduz Online - Panel - Crear personaje';
	$page['head']='<link href="'.$urls[2].'heads.css" type="text/css" rel="stylesheet" />';
	template_header();
	$database->ActualizarPjs($session->uid);
	echo '<div class="pj">',get_header_title_cases('Crear personaje',4),'</div>';
	if( $session->numpjs<10 ){
		if( !empty($_POST['submit']) ){
			$nick = $_POST['user'];
			if( IsValidStr($nick)===true ){
				$raza	= (($_POST['raza']>0 && $_POST['raza']<6)?intval($_POST['raza']):1);
				$clase	= (($_POST['clase']>0 && $_POST['clase']<11)?intval($_POST['clase']):1);
				if($clases_puede[$clase]===true || $session->userinfo['GM']>250){
					$genero	= ($_POST['genero']!=='1'?2:1);
					$cabeza=intval($_POST['cabeza']);
					if( ($cabeza>=$cabezas[$raza][$genero][1]) && ($cabeza<=$cabezas[$raza][$genero][2]) ){
					
					}else{
						$cabeza	=	rand($cabezas[$raza][$genero][1],$cabezas[$raza][$genero][2]);
					}
					
					$result	=	$database->query("SELECT `ID` FROM `pjs` WHERE (`raza` =$raza AND `clase` =$clase AND `genero` =$genero AND IDCuenta =$session->uid) OR (`nick` LIKE '$nick' AND `nick` NOT LIKE '$session->username') LIMIT 1");
					$num	=	(!$result?0:mysql_num_rows($result));
					if($num===0){
						//CREAMOS EL PJ
						$database->query("INSERT INTO `pjs` (`ID` ,`IDCuenta` ,`nick` ,`clan` ,`magia` ,`combate` ,`defenza` ,`vidaup` ,`raza` ,`clase` ,`cabeza` ,`genero` ,`armcao` ,`order`) VALUES (NULL , '$session->uid', '$nick', '0', '0', '0', '0', '0', '$raza', '$clase', '$cabeza', '$genero', '0', '0');");
						$pjid	= mysql_insert_id();
						//CREAMOS EL INVENTARIO
						$database->query("INSERT INTO `mochila` (`UID`,`CuentaID`,`last_death`) VALUES('$pjid','$session->uid','$session->userinfo[muertes]')");
						$infoPJ['raza']		= $raza;
						$infoPJ['clase']	= $clase;
						$infoPJ['ID']		= $pjid;
						//LE PONEMOS ITEMS AL INVENTARIO
						rellenar_items($infoPJ);
						//ACTUALIZAMOS LOS DATOS DE LA CUENTA
						$gamelogic->actualizar_inventario($pjid);
						$database->ActualizarPjs($session->uid);
						$database->uquery("UPDATE users SET users.last_mod='".time()."' WHERE users.ID='$session->uid'");
						header('Location: panel.php?msj=pjoka&id='.$pjid);
					} else {
						echo '<b id="err">Ya ten&eacute;s un personaje id&eacute;ntico o el nombre est&aacute; en uso. O ya existe el personaje.<br/><small><em>Nota: Varios personajes pueden tener el mismo nombre si este es igual al de la cuenta.</em></small></b>';
					}
				}
			} else echo '<b id="err">Nombre invalido.</b>';
		}

?>
<div class="right"><div id="render_pj" class="right"><div id="rpjcabeza" class="heads_4"></div></div><div style="clear:both;"></div><div id="render_pj_cabeza"><a href="#" onclick="movc();">&lt;</a> Cabeza <a href="#" onclick="movx();">&gt;</a></div></div>
<div style="float:left">

<form action="agregarpj.php" method="POST" id="formulario">
<label for="user">Nombre:</label>
<span class="input">
<input type="text" name="user" id="user" value="<?php echo ucfirst($session->username);?>" maxlength="27"></span>
<div style="clear:both;"></div>
<label>Raza:</label>
<select name="raza" onchange="act_cab();" id="raza"><?php for($i=1;$i<6;++$i){ echo '<option value="'.$i.'">'.$razas[$i].'</option>';}?></select>
<div style="clear:both;"></div>
<label>Clase:</label>
<select name="clase"><?php for($i=1;$i<11;++$i){ if($clases_puede[$i]===true || $session->userinfo['GM']>250) echo '<option value="'.$i.'">'.$clases[$i].'</option>';}?></select>
<div style="clear:both;"></div>
<label>Genero:</label>
<select name="genero" onchange="act_cab();" id="genero"><option value="1">Hombre</option><option value="2">Mujer</option></select>
<div style="clear:both;"></div>
<input type="hidden" name="cabeza" id="cabeza" value="1"/>
<label></label>
<input type="submit" name="submit" value="Crear personaje" id="Submit">
<div style="clear:both;"></div>
</form>

</div>
<div class="clear"></div>
<?php
	} else {
		echo '<b id="err">Ten&eacute;s demasiados personajes en tu cuenta.</b><div class="clear"></div>';
	}
	template_divisor();
	template_menu();
	template_footer();
} else {
	go_login_page();
}
?>