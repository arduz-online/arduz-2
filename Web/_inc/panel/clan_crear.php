<?php

if($session->logged_in){
	if($session->numpjs > 0){
		include '_inc/game.logic.php';
		include '_inc/panel/clanes.inc.php';

		$page['title']='Arduz Online - Crear Clan';	
		$page['head']='';
		template_header();
		$puedo_seguir=true;
		
		if($session->userinfo['clan_fundado']>0){
		header('Location: clan_'.$session->userinfo['clan_fundado'].'.php');
		exit();
		}
		
		echo '<span class="pj_link margen_imagena" id="clan"><span class="pj">',get_header_title_cases('Crear clan',22),'<div class="clear"></div></span></span>';

		echo '<div class="ma20">';
		echo get_header_title_cases('Paso 1 - Honor',20),'Conseguir <b>150000</b> puntos de honor. <br/>';
		if( $session->userinfo['honor'] < 150000 ){
			$puedo_seguir=false;
			echo 'Puntos de honor conseguidos: <b class="cred">'.$session->userinfo['honor'].'</b><br/>';
		} else {
			echo 'Puntos de honor conseguidos: <b class="cgreen">'.$session->userinfo['honor'].'</b><br/>';
		}
		echo get_header_title_cases('Paso 2 - Oro',20),'Conseguir <b class="idv">250000</b> monedas de oro.<br/>';
		if( $session->userinfo['puntos'] < 250000 ){
			$puedo_seguir=false;
			echo 'Oro conseguido: <b class="idv"><b class="cred">'.$session->userinfo['puntos'].'</b></b><br/>';
		} else {
			echo 'Oro conseguido: <span class="idv"><b class="cgreen">'.$session->userinfo['puntos'].'</b></span><br/>';
		}
		echo get_header_title_cases('Paso 3 - Fundar',20);
		if($puedo_seguir){
			$imprimir=true;
			if(isset($_POST['submit'])){
				if(strlen($_POST['name'])>3 and strlen($_POST['name'])<25 and IsValidStr($_POST['name'])){
					if($session->userinfo['PIN']==$_POST['pin']){
						$clan = mysql_fetch_array(mysql_query("SELECT * FROM `clanes` WHERE `Nombre`='".$_POST['name']."';"));
						if($clan['ID']>0){
							$error='<b id="err">El clan ya existe.</b><br/>';
						} else {
							mysql_query('INSERT INTO `clanes` (`ID`, `Nombre`, `puntos`, `matados`, `muertos`, `rank_puntos`, `rank_puntos_old`, `rank_mm`, `rank_mm_old`, `fundador`, `miembros`, `lvl`) VALUES (NULL, \''.$_POST['name'].'\', \'0\', \'0\', \'0\', \'0\', \'0\', \'0\', \'0\', \''.$session->uid.'\', \'0\', \'1\');');
							$clanid=mysql_insert_id();
							mysql_query("UPDATE users SET clan_fundado='$clanid',puntos=puntos-'250000' WHERE ID='$session->uid'");
							$imprimir=false;
						}
					} else $error = '<b id="err">Clave pin incorrecta.</b><br/>';
				} else $error = '<b id="err">El nombre es muy largo, muy corto o tiene caracteres invalidos.</b><br/>';
			}
			if($imprimir){
				echo'<span>&bull; Elegir el nombre del clan.</span><br/><br/>
					<span>&bull; Ten&eacute; cuidado en este paso, se te descontar&aacute;n <b class="idv">250000</b> puntos/oro, esto te har&aacute; bajar varios puntos en el ranking de puntos.</span><br/><br/>
					<span>&bull; El clan reci&eacute;n creado admite 6 personajes, este numero puede aumentar a cambio de puntos de clan, estos no bajan tu ranking, son la suma de todos los conseguidos EN EL CLAN.</span><br/><br/>
					<form method="POST" action="crear-clan.php" id="formulario">'.$error.'
					<label for="name">Nombre del Clan</label>
					<span class="input">
					<input type="text" name="name" id="name" value="'.$_POST['name'].'" maxlength="13"></span>
					<label for="pin">Clave pin:</label>
					<span class="input"><input type="password" name="pin" id="pin" maxlength="27" value=""></span>
					<div style="clear:both;"></div>
					<div><label></label><input type="submit" name="submit" id="Submit" value="Crear clan!"><br/></div>
					</form>';
			} else {
				echo '<b id="oka">Felicidades, haz creado el clan '.$_POST['name'].'. Ahora debes ingresar tus personajes en el.<br/>Click <a href="solicitud-clan_'.$clanid.'.php" class="mini_bt">Ac&aacute;</a> para ingresar personajes.</b>';
			}
		} else {
			echo '<b id="err">A&uacute;n no conseguiste los requisitos para fundar clan.</b>';
		}
		echo '</div>';
		echo '<div class="clear"></div><br/>&nbsp;<div class="clear"></div>';
		template_divisor();
		template_menu();
		template_footer();
	} else header('Location: panel.php');
} else go_login_page();


?>