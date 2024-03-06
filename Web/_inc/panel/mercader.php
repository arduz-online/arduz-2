<?php
if($session->logged_in){
	if($session->numpjs > 0){
		
		$pj			=	intval($_REQUEST['cual']);
		$mercaderID	=	intval($_REQUEST['dato']);
		$infoPJ		=	$session->get_pj($pj);
		
		if( $infoPJ === 0 ){
			header('Location: panel.php');
			exit();
		}
		
		include '_inc/game.logic.php';
		

		
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
		
		if( $mercaderID < 1 || $mercaderID > 4 ){
			$page['title']='Arduz Online - Panel - Mercado';	
			$page['head']='';
			template_header();
			$tipografia	=	get_tipografia_pj($infoPJ['armcao']);
			echo '<a class="pj_link margen_imagena" href="pj.php?pj='.$infoPJ['ID'].'" id="trade"><span class="pj">',get_header_title_cases($infoPJ['nick'],$tipografia),'<div class="clear"></div><span class="arial11 ma15">Volver al panel del personaje</span></span></a>';
echo '<div class="margen_">
<ul id="menu_pj">
<li id="trade1"><a href="mercado_1_'.$infoPJ['ID'].'.php">Armero<span class="desc">Aqu&iacute; podr&aacute;s encontrar las mejores armas del lugar.</span></a></li>
<li id="trade2"><a href="mercado_2_'.$infoPJ['ID'].'.php">Herrero<span class="desc">Te ofrezco cualquier tipo de protecci&oacute;n.</span></a></li>
<li id="trade3"><a href="mercado_3_'.$infoPJ['ID'].'.php">Carpintero<span class="desc">Las piezas m&aacute;s trabajadas que puedas encontrar.</span></a></li>
<li id="trade4"><a href="mercado_4_'.$infoPJ['ID'].'.php">Sastre<span class="desc">Confeccionamos nuestras mercanc&iacute;as con las mejores telas y pieles.</span></a></li>
</ul>
</div>';
			echo '<div class="clear"></div><br/>&nbsp;<div class="clear"></div>';
		} else {
			
			include '_inc/panel/mercader.inc.php';
			cargar_mercader($mercaderID);
			check_mercader($mercaderID,true);
			
			$page['title']='Arduz Online - Panel - Mercader';	
			$page['head']='<script type="text/javascript">var pjid = \''.$pj.'\';var txt_compra=\'Comprar\';var txt_vender=\'Vender\';var ajax_url=\'ajaxmercader\';var mercader_id=\''.$mercaderID.'\';var mercader_hash=\''.$mercader_act['hash'].'\';</script>';
			template_header();
			$tipografia	=	get_tipografia_pj($infoPJ['armcao']);
			
			echo '<a class="pj_link margen_imagena" href="pj.php?pj='.$infoPJ['ID'].'" id="trade"><span class="pj">',get_header_title_cases($infoPJ['nick'],$tipografia),'<div class="clear"></div><span class="arial11 ma15">Volver al panel del personaje</span></span></a><b id="err" style="display:none;">No ten&eacute;s suficiente oro para comprar &eacute;ste objeto</b>';
			cargar_items();
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
						$precio_venta = get_item_precio_venta($item);
						echo '<br/><br/><b class=\'idv\'>Venta: '.round($precio_venta).'</b>"><span><img src="'.$urls[2].'_images/_items/'.$item['grh'].'.gif" alt="IMG"/></span></a></div>';
						echo '</td>';
					}
					echo '</td>';				
					
					
				}
				echo '</tr>';
			}
			
			echo '<tr><td colspan="4" class="inbutton"><a class="mini_bt" id="boton_inv" onclick="post_mercado_action();" style="float:right;">Comprar</a><span><b class="idv" id="oroo">'.$session->userinfo['puntos'].'</b></span></td></tr></table>';
			
			//actualizar_mercader();
			
			echo '<table class="boveda"><th colspan="6">',get_header_title_cases('Comerciante',22),'</th>';
			$ic=0;
			for($y=1;$y<=5;++$y){
				echo '<tr>';
				for($x=1;$x<=6;++$x){
					$ic++;
					echo '<td class="initem" id="Bvd'.$ic.'" onclick="click_item(\'Bvd'.$ic.'\','.$ic.',false);">';
					if($mercader_act['o'.$ic]!=='0'){
						$item 			 	= &$items_array[$mercader_act['o'.$ic]];
						$item['flags']		= intval($mercader_act['f'.$ic]);
						$item['calidad']	= intval($mercader_act['t'.$ic]);
						echo '<div><a class="tooltip" title="';
						echo_item_tooltip($item);
						echo '<br/><br/><b class=\'idv\'>Compra: '.$mercader_act['p'.$ic].'</b><br/><b class=\'idv\'>Venta: '.round($item['Valor']/2).'</b>"><span><img src="'.$urls[2].'_images/_items/'.$item['grh'].'.gif" alt="IMG"/></span></a></div>';
						echo '</td>';
					}
					echo '</td>';				

				}
				echo '</tr>';
			}
			echo '</table>';
			echo '<div class="clear"></div><!--<br/>-->&nbsp;<div class="clear"></div><div class="arial11 ma15" style="text-align:right;margin:16px;">Tiempo restante para que lleguen nuevos bienes: <b class="countdown" secs="'.($mercader_act['tiempo']-time()).'">--:--</b></div><div class="clear"></div>';
		}
		
		template_divisor();
		template_menu();
		template_footer();
	} else header('Location: panel.php');
} else go_login_page();
?>