<?php
if($session->logged_in){
	if($session->numpjs > 0){
		$pj			=	intval($_REQUEST['cual']);
		$infoPJ		=	$session->get_pj($pj);
		
		$depositar	=	(bool)($_REQUEST['depo']==='1');
		$slot		=	intval($_POST['slot']);
		
		if( $infoPJ === 0 || $slot === 0 ){
			exit();
		}
		
		include '_inc/game.logic.php';

		if( $infoPJ['cuando_termina']>0 ){
			if( $infoPJ['cuando_termina'] > $timenow ){
				exit();
			}
		}

		$gamelogic->actualizar_inventario($pj,$items_db);
		cargar_items($id);
		if($depositar===true){
			//$items_sql	= $database->query('SELECT `o'.$slot.'`,`t'.$slot.'`,`f'.$slot.'` FROM `mochila` WHERE `UID`=\''.$infoPJ['ID'].'\' LIMIT 1;');
			//$items_db	= mysql_fetch_assoc($items_sql);
			
			if($items_db['o'.$slot]==='0'){
				exit();
			}
		
			if($items_array[$items_db['o'.$slot]]['NEWBIE']==='1') die('-4');

			$items_sql	= $database->query('SELECT `boveda`.* FROM `boveda` WHERE `CuentaID`=\''.$session->uid.'\' LIMIT 1;');
			$items_db	= mysql_fetch_assoc($items_sql);
			
			for($ic=1;$ic<=31;++$ic){
				if($items_db['o'.$ic]==='0') break;
			}
			
			if($ic > 30) die('0');
			
			$items_sql	= $database->query('UPDATE `boveda`,`mochila` SET `boveda`.`o'.$ic.'`=`mochila`.`o'.$slot.'`,`boveda`.`t'.$ic.'`=`mochila`.`t'.$slot.'`,`boveda`.`f'.$ic.'`=`mochila`.`f'.$slot.'`,`mochila`.`o'.$slot.'`=0,`mochila`.`t'.$slot.'`=0,`mochila`.`f'.$slot.'`=0 WHERE `mochila`.`UID`=\''.$infoPJ['ID'].'\' AND `boveda`.`CuentaID`=\''.$session->uid.'\'');
		} else {
			$items_sql	= $database->query('SELECT `o'.$slot.'`,`t'.$slot.'`,`f'.$slot.'` FROM `boveda` WHERE `CuentaID`=\''.$session->uid.'\' LIMIT 1;');
			$items_db	= mysql_fetch_assoc($items_sql);
			
			if($items_db['o'.$slot]==='0'){
				exit();
			}
			
			if(pj_puede_tener_item($infoPJ,$items_db['o'.$slot])==false) die('-3');
			
			$items_sql	= $database->query('SELECT * FROM `mochila` WHERE `UID`=\''.$infoPJ['ID'].'\' LIMIT 1;');
			$items_db	= mysql_fetch_assoc($items_sql);
			
			for($ic=1;$ic<=17;++$ic){
				if($items_db['o'.$ic]==='0') break;
			}
			
			if($ic > 16) die('0');
			
			$items_sql	= $database->query('UPDATE `mochila`,`boveda` SET `mochila`.`o'.$ic.'`=`boveda`.`o'.$slot.'`,`mochila`.`t'.$ic.'`=`boveda`.`t'.$slot.'`,`mochila`.`f'.$ic.'`=`boveda`.`f'.$slot.'`,`boveda`.`o'.$slot.'`=0,`boveda`.`t'.$slot.'`=0,`boveda`.`f'.$slot.'`=0 WHERE `mochila`.`UID`=\''.$infoPJ['ID'].'\' AND `boveda`.`CuentaID`=\''.$session->uid.'\'');
			//echo mysql_error();
		}
		
		$gamelogic->actualizar_inventario($pj);
		echo $ic;
		exit();
}}
?>