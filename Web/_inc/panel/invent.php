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
		$page['title']='Arduz Online - Panel - B&oacute;veda';	
		$page['head']='<script type="text/javascript">var pjid = \''.$pj.'\';var txt_compra=\'Retirar\';var txt_vender=\'Depositar\';var ajax_url=\'invajax\';</script>';
		template_header();
		$tipografia	=	get_tipografia_pj($infoPJ['armcao']);
		
		echo '<a class="pj_link margen_imagena" href="pj.php?pj='.$infoPJ['ID'].'" id="inv"><span class="pj">',get_header_title_cases($infoPJ['nick'],$tipografia),'<div class="clear"></div><span class="arial11 ma15">Volver al panel del personaje</span></span></a><b id="err" style="display:none;"></b>';

		if( $infoPJ['cuando_termina']>0 ){
			if( $infoPJ['cuando_termina'] > $timenow ){
				header('Location: panel.php');
				exit();
			} else {
				$gamelogic->completar_tarea($session->pjs,$session->pjs_times,$session->uid);
				$database->ActualizarPjs($session->uid);
				header('Location: pj.php?pj='.$infoPJ['ID']);
				exit();
			}
		}
		$items = array();

		if($gamelogic->actualizar_inventario($pj,$items_db)===false){
			$database->query("INSERT INTO `mochila` (`UID`,`CuentaID`,`last_death`) VALUES('$infoPJ[ID]','$session->uid','$infoPJ[muertes]')");
			rellenar_items($infoPJ);
			$items_sql	= $database->query('SELECT `mochila`.*, `pjs`.`muertes` AS `muertes` FROM `mochila`,`pjs` WHERE `mochila`.`UID`=\''.$infoPJ['ID'].'\' AND `pjs`.`ID`=`mochila`.`UID` LIMIT 1;');
			$items_db	= mysql_fetch_assoc($items_sql);
		}
		
		echo '<table class="invent"><th colspan="4">',get_header_title_cases('Inventario',22),'</th>';
		for($y=1;$y<=4;++$y){
			echo '<tr>';
			for($x=1;$x<=4;++$x){
				$ic++;
				echo '<td class="initem" id="I'.$ic.'" onclick="click_item(\'I'.$ic.'\','.$ic.',true);">';
				if($items_db['o'.$ic]!=='0'){
					$item 			 	= &$items_array[$items_db['o'.$ic]];
					$item['flags']		= intval($items_db['f'.$ic]);
					$item['calidad']	= intval($items_db['t'.$ic]);
					echo '<div><a class="tooltip" title="';
					echo_item_tooltip($item);
					echo '"><span><img src="'.$urls[2].'_images/_items/'.$item['grh'].'.gif" alt="IMG"/></span></a></div>';
					echo '</td>';
				}
				echo '</td>';				
				
				
			}
			echo '</tr>';
		}
		
		echo '<tr><td colspan="4" class="inbutton"><a class="mini_bt" id="boton_inv" onclick="post_inventario_action();" style="float:right;">Depositar</a></td><!--<td colspan="4" class="inbutton"><a class="mini_bt">Retirar</a></td>--></tr></table>';
		
		$items_sql	= $database->query('SELECT `boveda`.* FROM `boveda` WHERE `CuentaID`=\''.$session->uid.'\' LIMIT 1;');
		if(mysql_num_rows($items_sql)===0){
			$database->query("INSERT INTO `boveda` (`CuentaID`) VALUES ('".$session->uid."')");
			$items_sql	= $database->query('SELECT `boveda`.* FROM `boveda` WHERE `CuentaID`=\''.$session->uid.'\' LIMIT 1;');
		}
		$items_db	= mysql_fetch_assoc($items_sql);
		
		echo '<table class="boveda"><th colspan="6">',get_header_title_cases('Boveda',22),'</th>';
		$ic=0;
		for($y=1;$y<=5;++$y){
			echo '<tr>';
			for($x=1;$x<=6;++$x){
				$ic++;
				echo '<td class="initem" id="Bvd'.$ic.'" onclick="click_item(\'Bvd'.$ic.'\','.$ic.',false);">';
				if($items_db['o'.$ic]!=='0'){
					$item 			 	= &$items_array[$items_db['o'.$ic]];
					$item['flags']		= intval($items_db['f'.$ic]);
					$item['calidad']	= intval($items_db['t'.$ic]);
					echo '<div><a class="tooltip" title="';
					echo_item_tooltip($item);
					echo '"><span><img src="'.$urls[2].'_images/_items/'.$item['grh'].'.gif" alt="IMG"/></span></a></div>';
					echo '</td>';
				}
				echo '</td>';				

			}
			echo '</tr>';
		}
		echo '</table>';
		
		echo '<div class="clear"></div><br/>&nbsp;<div class="clear"></div>';
		template_divisor();
		template_menu();
		template_footer();
	} else header('Location: panel.php');
} else go_login_page();
?>