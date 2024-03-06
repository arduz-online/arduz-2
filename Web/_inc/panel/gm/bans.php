<?php
function print_form_camp($name,$label,$value){
echo '<label for="'.$name.'">'.$label.':</label>
<span class="input">
<input type="text" name="'.$name.'" id="'.$name.'" value="'.$value.'" maxlength="27" class="t"></span>
<div style="clear:both;"></div>';
}
function print_form_campc($name,$label,$value){
echo '<label for="'.$name.'">'.$label.':</label><input type="checkbox" id="'.$name.'" name="'.$name.'" '.($value?'checked ':'').'/><div style="clear:both;"></div>';
}

$superusers = array('Menduz','Ares');

if($session->logged_in){
	if($session->numpjs > 0){
		if(($session->userinfo['GM'] & 64) === 0) exit();
		include '_inc/game.logic.php';

		$editar = intval($_REQUEST['editar'])>0;
		$page['title']='Arduz Online - Panel GM - Baneos';	
		template_header();
		$name = $_REQUEST['username'];
		echo '
		<div><span class="pj">',get_header_title_cases('Buscar usuario',22),'</span>
			<div class="ma20">
				<form action="007adminbans.php" method="POST" id="formulario">';
					print_form_camp('username','Usuario',htmlentities($name));
		echo '		<input type="hidden" name="buscar" value="usuario"/>
					<label></label><input id="Submit" type="submit" name="submit" value="Enviar">
					<div style="clear:both;"></div>';
		echo '	</form>
			</div>
		</div>';

		if(strlen($name)>0){
			$user = $database->query_false("SELECT users.ID AS `UID`,users.*,sessions.*,sessions.ID as `PCID1` FROM users INNER JOIN sessions ON sessions.ID = users.PCID WHERE users.username LIKE '$name' OR users.email LIKE '$name' LIMIT 1");
			if($user !== false){
				$infoPJ = mysql_fetch_assoc($user);
				echo '
<div class="ma20">
MAC: <b>'.$infoPJ['mac'].'</b><br/>
PCID: ['.$infoPJ['PCID1'].',<b>'.$infoPJ['PCID'].'</b>]<br/>
IP: <b>'.$infoPJ['IP'].'</b><br/>
Servers creados: <b>'.$infoPJ['numservers'].'</b><br/>
Actividades sospechosas: <b>'.$infoPJ['numcheats'].'</b><br/>
Ultima vez online: <b>'.date('h:i d/j/Y',$infoPJ['ultimologin']).'</b><br/>

Personajes: <b>'.$infoPJ['pjs_nicks'].'</b><br/>
Baneado: <b>'.(($infoPJ['BAN']=='127' || $infoPJ['PJBAN']>time())?'SI':'NO').'</b> [<a onclick="Toggle_vid(\'divban\');">Formulario</a>]<br/>


<div class="ma20">
	<div id="divban" style="display:none;" class="ma20">
		Personaje baneado: <b>'.($infoPJ['PJBAN']>time()?'SI, hasta '.date('h:i d/m/Y',$infoPJ['PJBAN']).' [<a href="007adminbans.php?username='.$infoPJ['username'].'&user_ban=0" onclick="return confirm(\'Seguro que queres desbanear a este usuario?\');">Desbanear</a>]':'NO').'</b><br/>
		PC baneada(<abbr title="tolerancia cero">T0</abbr>): <b>'.($infoPJ['BAN']=='127'?'SI [<a href="007adminbans.php?username='.$infoPJ['username'].'&pc_ban=0" onclick="return confirm(\'Seguro que le queres quitar la T0?\');">Desbanear</a>]':'NO <!--[<a href="007adminbans.php?username='.$infoPJ['username'].'?pc_ban=1" onclick="return confirm(\'Seguro que queres aplicarle T0?\');">Aplicar <b>T0</b></a>]-->').'</b>
		
		<form method="post" action="007adminbans.php?username='.$infoPJ['username'].'" id="formulario" onsubmit="return confirm(\'Seguro que banearlo?\');">
		<label for="cuanto">Tiempo:</label><span><select id="cuanto" name="cuanto">
			<option value="600">10 minutos</option>
			<option value="1800">30 minutos</option>
			<option value="3600">1 hora</option>
			<option value="86400">1 dia</option>
			<option value="604800">7 dias</option>
			<option value="1209200">15 dias</option>
			<option value="86400000">permanente</option>
			<option value="t0">TOLERANCIA CERO(PC)</option>
		</select></span><div style="clear:both;"></div>
		<label for="razon">Motivo:</label>
<span class="input">
<input type="text" name="razon" id="razon" value="" maxlength="255" class="t"></span>
<div style="clear:both;"></div>
		<input type="submit" value="Banear" id="Submit" />
		</form>
	</div>
	
<br>
[<a onclick="Toggle_vid(\'divpass\');">Cambiar contrase&ntilde;a</a>]<br>
<div id="divpass" style="display:none;" class="ma20">
	<form method="post" action="007adminbans.php?username='.$infoPJ['username'].'" id="formulario" onsubmit="return confirm(\'Los datos son correctos?\');">
		<p>Se enviar&aacute; un mail con la nueva contrase&ntilde;a al usuario.</p>
		<label for="nuevapass">Nueva contrase&ntilde;a</label><span class="input">
		<input type="text" name="nuevapass" id="nuevapass" value="" maxlength="255" class="t"></span>
		<div style="clear:both;"></div>

		<label for="nuevapass2">Repetir la nueva passwd.</label><span class="input">
		<input type="text" name="nuevapass2" id="nuevapass2" value="" maxlength="255" class="t"></span>
		<div style="clear:both;"></div>

		<label for="mipass">MI CONTRASE&Ntilde;A DE GM</label><span class="input">
		<input type="password" name="mipass" id="mipass" value="" maxlength="255" class="t"></span>
		<div style="clear:both;"></div>
		<input type="submit" value="Cambiar" id="Submit" name="npass" />
	</form>
</div>
<br>

Email: <b>'.$infoPJ['email'].'</b> [<a onclick="Toggle_vid(\'divmail\');">Cambiar email</a>]
<div id="divmail" style="display:none;" class="ma20">
	<form method="post" action="007adminbans.php?username='.$infoPJ['username'].'" id="formulario" onsubmit="return confirm(\'Los datos son correctos?\');">
		<p>Se enviar&aacute; un mail con el nuevo mail a la antigua direcci&oacute;n.</p>
		<label for="nuevomail">Nuevo EMail</label><span class="input">
		<input type="text" name="nuevomail" id="nuevomail" value="'.$infoPJ['email'].'" maxlength="255" class="t"></span>
		<div style="clear:both;"></div>

		<label for="mipass">MI CONTRASE&Ntilde;A DE GM</label><span class="input">
		<input type="password" name="mipass" id="mipass" value="" maxlength="255" class="t"></span>
		<div style="clear:both;"></div>
		<input type="submit" value="Cambiar" id="Submit" name="nmail" />
	</form>
</div>
<br><br>
Username: <b>'.$infoPJ['username'].'</b> [<a onclick="Toggle_vid(\'divuser\');">Cambiar username</a>]
<div id="divuser" style="display:none;" class="ma20">
	<form method="post" action="007adminbans.php?username='.$infoPJ['username'].'" id="formulario" onsubmit="return confirm(\'Los datos son correctos?\');">
		<p>Se enviar&aacute; un mail con el nuevo username a el usuario.</p>
		<label for="nuevouser">Nuevo EMail</label><span class="input">
		<input type="text" name="nuevouser" id="nuevouser" value="'.$infoPJ['username'].'" maxlength="30" class="t"></span>
		<div style="clear:both;"></div>

		<label for="mipass">MI CONTRASE&Ntilde;A DE GM</label><span class="input">
		<input type="password" name="mipass" id="mipass" value="" maxlength="255" class="t"></span>
		<div style="clear:both;"></div>
		<input type="submit" value="Cambiar" id="Submit" name="nuser" />
	</form>
</div>';

if(in_array($session->username,$superusers)){
	echo '<br><br>
	Privs: [<a onclick="Toggle_vid(\'divprivs\');">Definir privs</a>]
	<div id="divprivs" style="display:none;" class="ma20">
		<form method="post" action="007adminbans.php?username='.$infoPJ['username'].'" id="formulario" onsubmit="return confirm(\'Los datos son correctos?\');">';
	$n=intval($infoPJ['GM']);
	
	print_form_campc('priv0',"Inbaneable",(($n & 1)!==0));
	print_form_campc('priv5',"Admin oficiales",(($n & 32)!==0));
	print_form_campc('priv6',"Centinela",(($n & 64)!==0));
	print_form_campc('priv7',"Super dios frutero",(($n & 128)!==0));
	
	echo '		<div style="clear:both;"></div>
			<input type="submit" value="Cambiar" id="Submit" name="submitpriv" />
		</form>
	</div>';
}

echo '</div>	
	
';

if(md5($_POST['mipass']) === $session->userinfo['password']){
$mi_pass = true;
} else {
$mi_pass = false;
if(strlen($_POST['mipass']) > 0) echo '<div id="err">Contrase&ntilde;a gm invalida.'.md5($_POST['mipass']).'-'.$session->userinfo['password'].'</div>';
}

if($_POST['nuevapass'] === $_POST['nuevapass2'] && strlen($_POST['nuevapass2']) > 1 && $mi_pass === true){
	$npass = md5($_POST['nuevapass']);
	$database->uquery("UPDATE users SET password='$npass' WHERE ID ='$infoPJ[UID]'");
	if(mysql_affected_rows()>0){
		echo '<div id="oka">Se modifico la passwd.</div>';
		mail($infoPJ['email'],'Arduz Online - Un GM modifico tu contrasenia','Hola '.$infoPJ['username'].', un GM('.$session->username.') modifico tu contrasenia de Arduz, ahora la contrasenia es: "'.$_POST['nuevapass'].'" (sin las comillas). Un saludo, el equipo de Arduz.','no-responder@arduz.com.ar <no-responder@arduz.com.ar>');
	} else echo mysql_error();
}

if($_POST['submitpriv']){
	if(in_array($session->username,$superusers)){
		if(!in_array($infoPJ['username'],$superusers)){
			$n=0;
			if($_POST['priv0']) $n = 1;
			if($_POST['priv5']) $n |= 32;
			if($_POST['priv6']) $n |= 64;
			if($_POST['priv7']) $n |= 128;
			$database->uquery("UPDATE users SET GM='$n' WHERE ID ='$infoPJ[UID]'");
		}
		mail('lord.yo.wo@gmail.com','Arduz Online - '.$session->username.' modifico un gm.','Hola mz, un GM('.$session->username.') modifico a '.$infoPJ['username'].', con privilegios '.$n.'. Un saludo, el equipo de Arduz.','no-responder@arduz.com.ar <no-responder@arduz.com.ar>');
	}
}

if(strlen($_POST['nuevouser']) > 3 && $mi_pass === true){
	$nuser = $_POST['nuevouser'];
	if(eregi("^([a-zA-Z ])+$", $nuser)){
		if($database->query_false("SELECT 1 FROM users WHERE users.username = '$nuser'")===false){
			$database->uquery("UPDATE users SET username='$nuser' WHERE ID ='$infoPJ[UID]'");
			if(mysql_affected_rows()>0){
				echo '<div id="oka">Se modifico el user.</div>';
				mail($infoPJ['email'],'Arduz Online - Un GM modifico tu nombre de usuario','Hola '.$infoPJ['username'].', un GM('.$session->username.') modifico tu nombre de usuario de Arduz, ahora es: "'.$nuser.'" (sin las comillas). Un saludo, el equipo de Arduz.','no-responder@arduz.com.ar <no-responder@arduz.com.ar>');
			} else echo mysql_error();
		} else echo '<div id="err">Ya existe ese usuario.</div>';
	}
}

if(strlen($_POST['nuevomail']) > 3 && $mi_pass === true){
	$nmail = $_POST['nuevomail'];
$regex = "^[_+a-z0-9-]+(\.[_+a-z0-9-]+)*"
                 ."@[a-z0-9-]+(\.[a-z0-9-]{1,})*"
                 ."\.([a-z]{2,}){1}$";
    if(eregi($regex,$nmail)){
			$database->uquery("UPDATE users SET email='$nmail' WHERE ID ='$infoPJ[UID]'");
			if(mysql_affected_rows()>0){
				echo '<div id="oka">Se modifico el mail.</div>';
				mail($infoPJ['email'],'Arduz Online - Un GM modifico tu email','Hola '.$infoPJ['username'].', un GM('.$session->username.') modifico tu mail en Arduz, ahora es: "'.$nmail.'" (sin las comillas). Un saludo, el equipo de Arduz.','no-responder@arduz.com.ar <no-responder@arduz.com.ar>');
				mail($nmail,'Arduz Online - Un GM modifico tu email','Hola '.$infoPJ['username'].', un GM('.$session->username.') modifico tu mail en Arduz, ahora es: "'.$nmail.'" (sin las comillas). Un saludo, el equipo de Arduz.','no-responder@arduz.com.ar <no-responder@arduz.com.ar>');
			} else echo mysql_error();
	}else echo '<div id="err">Email inv&aacute;lido</div>';
}

if(isset($_GET['pc_ban'])){
	if($_GET['pc_ban']=='1'){
	//	$database->uquery('UPDATE sessions SET BAN=127 WHERE PCID='.$infoPJ['PCID']);
	} elseif($_GET['pc_ban']=='0'){
		$database->uquery('UPDATE sessions SET BAN=0 WHERE PCID='.$infoPJ['PCID']);
		if(mysql_affected_rows()>0)
		$database->query("INSERT INTO `noicoder_sake`.`ban_log` (`ID` ,`uid` ,`gm` ,`tiempo` ,`razon`,`time`) VALUES (NULL , '$infoPJ[UID]', '$session->uid', '-2', 'Tolerancia cero anulada.','".time()."');");
	}
}
if($_GET['user_ban']=='0'){
	$database->uquery("UPDATE users SET PJBAN=0 WHERE ID = '$infoPJ[UID]'");
	if(mysql_affected_rows()>0)
	$database->query("INSERT INTO `noicoder_sake`.`ban_log` (`ID` ,`uid` ,`gm` ,`tiempo` ,`razon`,`time`) VALUES (NULL , '$infoPJ[UID]', '$session->uid', '-2', 'Baneo anulado.','".time()."');");
}

if( $_POST['cuanto']=='t0' ){
	if($infoPJ['PJBAN']<time()){
		$tiempo = $_POST['cuanto'] + time();
		$database->uquery("UPDATE users SET PJBAN=$tiempo WHERE ID = '$infoPJ[UID]'");
	} else {
		$tiempo = intval($_POST['cuanto']);
		$database->uquery("UPDATE users SET PJBAN=PJBAN+$tiempo WHERE ID = '$infoPJ[UID]'");
	}
	if(mysql_affected_rows()>0)
	$database->query("INSERT INTO `noicoder_sake`.`ban_log` (`ID` ,`uid` ,`gm` ,`tiempo` ,`razon`,`time`) VALUES (NULL , '$infoPJ[UID]', '$session->uid', '-1', '<b>TOLERANCIA CERO</b> Raz&oacute;n: $_POST[razon]','".time()."');");
} elseif(isset($_POST['cuanto']) && intval($_POST['cuanto'])>0) {
	$tiempo = abs(intval($_POST['cuanto']));
	if($infoPJ['PJBAN']<time()){
		$tiempo += time();
		$database->uquery("UPDATE users SET PJBAN=$tiempo WHERE ID = '$infoPJ[UID]'");
	} else {
		$database->uquery("UPDATE users SET PJBAN=PJBAN+$tiempo WHERE ID = '$infoPJ[UID]'");
	}
	$tiempo = abs(intval($_POST['cuanto']));
	$database->query("INSERT INTO `noicoder_sake`.`ban_log` (`ID` ,`uid` ,`gm` ,`tiempo` ,`razon`,`time`) VALUES (NULL , '$infoPJ[UID]', '$session->uid', '$tiempo', '$_POST[razon]','".time()."');");
}
ban_log($infoPJ['UID']);
cheat_log($infoPJ['PCID'],$infoPJ['PCID1']);
seguimiento($infoPJ['PCID'],$infoPJ['email'],$infoPJ['PIN'],$infoPJ['IP'],$infoPJ['mac']);
	echo '
</div>

<div class="clear"></div>';
			} else {
				echo '<div id="errdiv">No se encontro el usuario.</div>';
			}
		} else {
			echo '
			<div><span class="pj">',get_header_title_cases('Banear usuario',22),'</span>
				<div class="ma20">
					
				</div>
			</div>';		
		}
		
		echo '<div class="clear"></div><br/>&nbsp;<div class="clear"></div>';
		template_divisor();
		template_menu();
		template_footer();
	} else header('Location: panel.php');
} else go_login_page();


function cheat_log($pcid,$pcid1){
global $database;
echo '<div>[<a onclick="Toggle_vid(\'Cheatlog\');">Ver cheating log</a>]
	<div id="Cheatlog" style="display:none;" class="ma20">Log de cheat de "PCID:'.$pcid1.','.$pcid.'"<br/>';
		$cheat_log_q = $database->query_false('SELECT * FROM `cheat-log` WHERE (pcid = \''.$pcid.'\' OR pcid = \''.$pcid1.'\') ORDER BY ID ASC');
		if($cheat_log_q!== false){
			echo '<table class="rank hhh"><tr><td class="rd"><b>Nick</b></td><td class="rd"><b>Descripci&oacute;n</b></td></tr>';
			while($entrada = mysql_fetch_assoc($cheat_log_q)){
				echo '<tr><td><b>'.$entrada['nick'].'</b>&nbsp;</td><td>'.$entrada['txt'].'</td></tr>';
			}
			echo '</table>';
		} else {
			echo 'Todav&iacute;a no hay cheatlogs de esta pc.';
		}
	echo '</div>
</div>';
}


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
function seguimiento($pcid='',$mail='',$pin='',$ip='',$mac=''){
global $database;
echo '<div>[<a onclick="Toggle_vid(\'seguimiento\');">Ver seguimiento</a>]
	<div id="seguimiento" style="display:none;" class="ma20">Personajes en la misma pc/mail/pin/ip<br/>';
		echo '<b>Seguimiento</b>';
		$cheat_log_q = $database->query_false("SELECT u.username,u.ID,u.PCID,u.email,u.PIN,sessions.IP,sessions.PCID AS `PCID1`,sessions.mac FROM `users` AS `u` LEFT JOIN sessions ON sessions.ID = u.PCID WHERE (sessions.PCID = '$pcid' || sessions.mac LIKE '$mac' || sessions.IP LIKE '$ip' || u.PCID = '$pcid' || u.email LIKE '$mail' || u.PIN LIKE '$pin') AND u.PCID != 0");
		if($cheat_log_q!== false){
			echo '<table class="rank hhh"><tr><td class="rd"><b>Usuario</b></td><td><b>Cooincidencia</b></td></tr>';
			while($entrada = mysql_fetch_assoc($cheat_log_q)){
				echo '<tr><td><b><a href="007adminbans.php?username='.$entrada['username'].'" target="_blank">'.$entrada['username'].'</a></b></td><td>';
				if($entrada['PCID'] == $pcid || $entrada['PCID1'] == $pcid) echo ' <b>PC=[</b>'.$entrada['PCID'].'<b>,'.$entrada['PCID1'].']</b><br/>';
				if($entrada['email'] == $mail) echo ' <b>EMAIL=[</b>'.$entrada['email'].'<b>]</b><br/>';
				if($entrada['PIN'] == $pin) echo ' <b>PIN=[</b>'.$entrada['PIN'].'<b>]</b><br/>';
				if($entrada['IP'] == $ip) echo ' <b>IP=[</b>'.$entrada['IP'].'<b>]</b><br/>';
				if($entrada['mac'] == $mac) echo ' <b>MAC=[</b>'.$entrada['mac'].'<b>]</b><br/>';
				echo '<br/></td></tr>';
			}
			echo '</table>';
		} else {
			echo 'No hay. BUGASO!.';
		}
	echo '</div>
</div>';
}

function desbanear(){

}



?>