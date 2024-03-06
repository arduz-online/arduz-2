<?php
	$page['title']='Recordar contrase&ntilde;a - Arduz Online';

	if($session->logged_in){
	   header('Location: panel.php');
	   exit;
	}
	
	template_header(2);
	echo '<div id="Recordar-clave" class="margen_">',get_header_title_cases('Recordar contrase&ntilde;a',24);

	
	
$paso = 1;

if(isset($_POST['mail']) && $_POST['paso'] == '1'){
	$result = enviar_link();
	if($result === true){
		echo '<div class="okdiv">El correo se envi&oacute; correctamente.</div>';
		$paso = 0;
	} elseif($result === -1) {
		echo '<div class="errdiv">El usuario ingresado no es correcto.</div>';
	} elseif($result === -2) {
		echo '<div class="errdiv">Debes esperar 15 minutos para enviar otra solicitud.</div>';
	} elseif($result === false) {
		echo '<div class="errdiv">El Mail no se pudo enviar a tu casilla de correo. Intentelo denuevo m&aacute;s tarde.</div>';
		$paso = 0;
	}
} elseif(preg_match("/^([0-9a-z])+$/i", $_REQUEST['cual']) && strlen($_REQUEST['cual']) == 32) {
	$usuario = obtener_from_hash();
	if($usuario !== false){
		$hash = $_REQUEST['cual'];
		$paso = 2;
		if($_POST['paso'] == '2'){
			//update
			if($_POST['pass'] === $_POST['passrepeat']){
				$len = strlen($_POST['pass']);
				if($len > 4 && $len < 31){
					
					$paso = 0;
					$usuario = mysql_fetch_assoc($usuario);
					$database->query(mysql_update_array('users',array('userid'=>'','password'=>md5($_POST['pass'])),'ID',$usuario['ID']));
					echo '<div class="okdiv">La contrase&ntilde;a se cambi&oacute; correctamente.</div>';
					$database->query("DELETE FROM recuperar_password WHERE hash = '$hash'");
				} else {
					echo '<div class="errdiv">La contrase&ntilde;as tiene que medir entre 5 y 30 caracteres.</div>';
				}
			} else {
				echo '<div class="errdiv">Las contrase&ntilde;as tipeadas no son iguales.</div>';
			}
		}
	}
}

if($paso>0){
echo '
<form action="recordar.php" method="POST" id="formulario">
<div class="margen_"><b>Paso 1:</b> Vamos a enviarte un v&iacute;nculo a tu email para que puedas reestablecer tu contrase&ntilde;a.</div>
';
if($paso === 1){
echo '
<input type="hidden" name="paso" value="1"/>
<label for="mail">Usuario:</label><span><span class="input"><input type="text" name="mail" id="mail" maxlength="50" value=""/></span></span><div class="clear"></div>
<label></label><span><input type="submit" value="Continuar &gt;" id="Submit"/></span>';
} elseif($paso === 2) {
	echo '
<input type="hidden" name="paso" value="2"/>
<input type="hidden" name="cual" value="'.$hash.'"/>
<div class="margen_"><b>Paso 2:</b> Escriba su nueva contrase&ntilde;a.</div>
<label for="pass">Nueva contrase&ntilde;a:</label><span><span class="input"><input type="password" name="pass" id="pass" maxlength="28" value=""/></span></span><div class="clear"></div>
<label for="passrepeat">Repita la nueva contrase&ntilde;a:</label><span><span class="input"><input type="password" name="passrepeat" id="passrepeat" maxlength="28" value=""/></span></span><div class="clear"></div>
<label></label><span><input type="submit" value="Guardar" id="Submit"/></span>';
}
echo '</form>';
}

	echo '</div>';
	template_footer();

/* MODELO */

function obtener_from_hash(){
	global $database;
	if(preg_match("/^([0-9a-z])+$/i", $_REQUEST['cual']) && strlen($_REQUEST['cual']) === 32){
		$hash = $_REQUEST['cual'];
		$database->query('DELETE FROM `recuperar_password` WHERE vence < \''.time().'\'');
		return $database->query_false('SELECT * FROM `recuperar_password` INNER JOIN users ON users.ID = `recuperar_password`.`UID` WHERE recuperar_password.hash LIKE \''.$hash.'\'');
	} else {
		return false;
	}
}

function puedo_enviar($uid){
	global $database;
	$database->query('DELETE FROM `recuperar_password` WHERE vence < \''.time().'\'');
	return ($database->query_false("SELECT * FROM `recuperar_password` WHERE UID ='$uid' OR IP LIKE '$_SERVER[REMOTE_ADDR]'")===false?true:false);
}

function enviar_link(){
	include '_inc/phpmailer.class.php';
	global $database,$session,$urls;
	$user = strtolower(mysql_escape($_POST['mail']));
	$user_data = $database->getUserInfo($user);
	if($user_data !== NULL){
		if( $user === strtolower($user_data['username']) ){
			if(puedo_enviar($user_data['ID'])){
				$hash = md5($session->generateRandID() . time());
				$subject = 'Recuperar contraseña de Arduz Online';
				$body = "Hola,\r\n
éste email contiene un vínculo para recuperar la contraseña de tu cuenta en Arduz Online.\r\n
\r\n
$urls[1]recordar_$hash.php
\r\n
Nota: este vínculo tendrá validez sólo por 15 minutos a partir de su creación. Y sólo podés usarlo desde la misma IP($_SERVER[REMOTE_ADDR]) que lo solicitaste.\r\n
\r\n
Saludos, equipo de Arduz Online.";
				$vence = (string)(time() + 900);
				$database->query("INSERT INTO recuperar_password (`UID`,`hash`,`vence`,`IP`) VALUES ('$user_data[ID]','$hash','$vence','$_SERVER[REMOTE_ADDR]') ON DUPLICATE KEY UPDATE hash='$hash', vence='$vence', IP='$_SERVER[REMOTE_ADDR]'");
				//return mail_nuevo($user_data['email'],$subject,$body,false);
				return @mail($user_data['email'],$subject,$body,'no-responder@arduz.com.ar <no-responder@arduz.com.ar>');

			} else {
				return -2;
			}
		}
	}
	return -1;
}


?>