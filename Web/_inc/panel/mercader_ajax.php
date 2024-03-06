<?php
if($session->logged_in){
	if($session->numpjs > 0){
		$pj			=	intval($_REQUEST['cual']);
		$infoPJ		=	$session->get_pj($pj);
		
		$mercaderID	=	intval($_POST['IDA']);
		
		$mercaderHASH=	$_REQUEST['hash'];
		
		$vendiendo	=	(bool)($_REQUEST['depo']==='1');
		$slot		=	intval($_POST['slot']);
		
		if( $infoPJ === 0 || $slot === 0 ){
			exit();
		}
		
		if($mercaderID < 1 || $mercaderID > 4) exit();
		
		include '_inc/game.logic.php';
		if( $infoPJ['cuando_termina']>0 ){
			if( $infoPJ['cuando_termina'] > $timenow ){
				exit();
			}
		}

		include '_inc/panel/mercader.inc.php';

		if(cargar_mercader($mercaderID,$mercaderHASH)===false) die('-4|<'.$mercaderHASH.'|<'.$mercader_act['hash'].'|<');

		$gamelogic->actualizar_inventario($pj);
		$puntos=$session->userinfo['puntos'];
		if( $vendiendo===true ){ //vendiendo
			$items_sql	= $database->query('SELECT `o'.$slot.'`,`t'.$slot.'`,`f'.$slot.'` FROM `mochila` WHERE `UID`=\''.$infoPJ['ID'].'\' LIMIT 1;');
			$items_db	= mysql_fetch_assoc($items_sql);
			
			if($items_db['o'.$slot]==='0'){
				exit();
			}
			
			$item 			 	= &$items_array[$items_db['o'.$slot]];
			$item['flags']		= intval($items_db['f'.$slot]);
			$item['calidad']	= intval($items_db['t'.$slot]);
			if($item['NEWBIE']!=='1'){
				$puntos=($session->userinfo['puntos']+get_item_precio_venta($item));
			}
			$database->updateUserField($session->username,'puntos',$puntos);
			$items_sql	= $database->query('UPDATE `mochila` SET `mochila`.`o'.$slot.'`=0,`mochila`.`t'.$slot.'`=0,`mochila`.`f'.$slot.'`=0 WHERE `mochila`.`UID`=\''.$infoPJ['ID'].'\'');
			$ic = '-2';
		} else { //COMPRANDO
			if($session->userinfo['GM']=='255'){$mercader_act['p'.$slot]=0;}
			if($session->userinfo['puntos']<$mercader_act['p'.$slot]) die('-1|<'.$session->userinfo['puntos']);
			
			if($mercader_act['o'.$slot]==='0'){
				exit();
			}
			
			$actualizar	= ($mercader_act['items']=='1');
			
			if(pj_puede_tener_item($infoPJ,$mercader_act['o'.$slot])==false && $session->userinfo['GM']!='255') die('-3|<'.$session->userinfo['puntos']);
			
			$puntos		= ($session->userinfo['puntos']-$mercader_act['p'.$slot]);
			
			$items_sql	= $database->query('SELECT * FROM `mochila` WHERE `UID`=\''.$infoPJ['ID'].'\' LIMIT 1;');
			$items_db	= mysql_fetch_assoc($items_sql);
			
			for($ic=1;$ic<=17;++$ic){
				if($items_db['o'.$ic]==='0') break;
			}
			
			if($ic > 16) die('0|<'.$session->userinfo['puntos']);
			
			$items_sql	= $database->query('UPDATE `mochila`,`mercader` SET `mochila`.`o'.$ic.'`=`mercader`.`o'.$slot.'`,`mochila`.`t'.$ic.'`=`mercader`.`t'.$slot.'`,`mochila`.`f'.$ic.'`=`mercader`.`f'.$slot.'`,`mercader`.`o'.$slot.'`=0,`mercader`.`t'.$slot.'`=0,`mercader`.`f'.$slot.'`=0,`mercader`.`p'.$slot.'`=0,`mercader`.`items`=`mercader`.`items`-1 WHERE `mochila`.`UID`=\''.$infoPJ['ID'].'\' AND mercader.ID='.$mercaderID);
			
			$database->updateUserField($session->username,'puntos',$puntos);

			if( $actualizar ){
				actualizar_mercader($mercaderID);
				$ic = '-4';
			}
			//echo mysql_error();
		}

		$gamelogic->actualizar_inventario($pj);
		echo $ic.'|<'.$puntos;
		exit();
}}
?>