<?php
/*
ESTRUCTURA

	chat_clanes
		id
		user - varchar
		msg - varchar 255
		time - int
		clan - int
		
CREATE TABLE `noicoder_sake`.`chat_clanes` (
	`ID` INT UNSIGNED NULL DEFAULT NULL AUTO_INCREMENT PRIMARY KEY ,
	`nick` VARCHAR( 255 ) NOT NULL ,
	`msg` VARCHAR( 255 ) NOT NULL ,
	`time` INT NOT NULL ,
	`clan` INT NOT NULL
) ENGINE = MYISAM ;
	
*/
if($session->logged_in == true && $session->numpjs > 0){
	$display_num = 30;

	$clanID		=	intval($_REQUEST['cual']);
	
	include '_inc/game.logic.php';
	include '_inc/panel/clanes.inc.php';
	if($clanID > 0){
		if(cargar_clan($clanID) !== false){
			if($clan_act['permite_admin'] === true || $clan_act['permite_ver'] === true){
				//header("Content-type: text/xml");
				header("Cache-Control: no-cache");

				if($_POST['action'] === 'postmsg' && !empty($_POST['message'])){
					$message = mysql_real_escape_string(UTF8_DECODE(bbcode(htmlspecialchars(stripslashes(htmlentities($_POST['message']))))));
					if(strlen(trim($message)) > 3){
						/*if($clan_act['permite_admin'] === true){
							$name = '<u>'.$session->username.'</u>';
						} else {*/
							$name = $session->username;
						//}
						
						if($clan_act['permite_ver']){
							for($i=0;$i<$session->numpjs;$i++){
								if($session->pjs_clanes[$i]==$clanID){
									if(strtoupper($session->pjs_nicks[$i]) != strtoupper($name)){
										$name .= ' ('.$session->pjs_nicks[$i].')';
									}
									break;
								}
							}
						}
						
						$database->query("INSERT INTO chat_clanes (`nick`,`msg`,`time`,`clan`) VALUES ('$name','$message',".time().",'$clanID')");
					}
				}

				$messages = $database->query("SELECT nick,msg FROM chat_clanes WHERE time>".intval($_POST['time'])." AND clan = '$clanID' ORDER BY id ASC LIMIT $display_num");
				if(mysql_num_rows($messages) == 0) $status_code = 2;
				else $status_code = 1;


				$response = array(
					'status'	=> $status_code,
					'time'		=> time()
				);
				if($status_code == 1){
					while($message = mysql_fetch_array($messages)){
						$tmp_array['message'] = array(
							'c' => true,
							'author'	=> $message['nick'],
							'text' 		=> $message['msg']
						);
						$response[] = $tmp_array['message'];
					}
				}
				echo json_encode($response);
			}
		}
	}
}
function bbcode($texto) {
	return $texto;
}
function secsimple($texto) {
	$texto = str_replace(">","&raquo;",$texto);
	$texto = str_replace("<","&laquo;",$texto);
	return $texto;
}
?>


