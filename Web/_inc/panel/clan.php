<?php
		$clanID		=	intval($_REQUEST['cual']);
		
		include '_inc/game.logic.php';
		include '_inc/panel/clanes.inc.php';
		if($clanID === 0) header('Location: index.php');
		if(cargar_clan($clanID) === false) header('Location: index.php');
		
		$page['title']='Arduz Online - Clan - '.$clan_act['Nombre'];	
		$page['head']='';
		template_header();
		
		echo '<span class="pj_link margen_imagena" id="clan"><span class="pj">',get_header_title_cases($clan_act['Nombre'],22),'<div class="clear"></div>'.(($session->logged_in==true and $session->numpjs > 0)?'<div><a href="solicitud-clan_'.$clan_act['ID'].'.php" class="mini_bt">Solicitud</a></div>':'').'</span></span>';

		echo '
<div class="ma20">'.get_header_title_cases('Visión general',20).'Puntos del clan: <b>'.$clan_act['puntos'].'</b><br/>
Frags: <b>'.$clan_act['matados'].'</b><br/>
Muertes: <b>'.$clan_act['muertos'].'</b><br/>
Honor: <b>'.$clan_act['honor'].'</b><br/>
Miembros: <b>'.$clan_act['miembros'].'/'.($clan_act['lvl']+5).'</b>
</div>';
echo '
<div class="ma20"><div class="ma20">';

if($session->logged_in == true && $session->numpjs > 0){
	if($clan_act['permite_admin']===true){
		lista_miembros(false);
		chat_clan();
		$total = aportes_al_clan();
		formulario_aporte();
		
		echo '<div>'.get_header_title_cases('Agrandar clan',20);
				$necesarios=($clan_act['lvl']*1000);
				$puedeampliar=false;

				if(intval($clan_act['matados'])>$necesarios){
					$tooltip.="<span style='color:green;'>Nesecitan $necesarios frags (<b>NO</b> se descuentan) para poder ampliar el clan.</span><br/>";
					$puedeampliar=true;
				} else {
					$puedeampliar=false;
					$tooltip.="<span style='color:red;'>Nesecitan $necesarios frags (<b>NO</b> se descuentan) para poder ampliar el clan.</span><br/>";
				}
				
				if(intval($clan_act['puntos']+$total)>($clan_act['necesarios']-1) and $puedeampliar===true){
					$tooltip.="<span style='color:green;'>Nesecitan ".$clan_act['necesarios']." puntos (<b>SI</b> se descuentan) para poder ampliar el clan.</span><br/>";
					$puedeampliar=true;
				} else {
					$puedeampliar=false;
					$tooltip.="<span style='color:red;'>Nesecitan ".$clan_act['necesarios']." puntos (<b>SI</b> se descuentan) para poder ampliar el clan.</span><br/>";
				}
				$tooltip.="<b>Se aumentan 2 slots para el clan.</b>";
				
				if($puedeampliar===true){
					$urr=' href="clan_'.$clan_act['ID'].'.php?ampliar=clan"';
				}
				
		if($puedeampliar===true and $_REQUEST['ampliar']=="clan"){
			$resta = intval($clan_act['necesarios']);
			$total-= $resta;
			if($total>0){
				//Agregar el aporte sobrante
				$resta = 0;
				$agregar_aporte = $total;
			} else {
				$resta = -$total;
				$agregar_aporte = 0;
			}
			$database->uquery("UPDATE clanes SET lvl=lvl+2,puntos=puntos-".$resta." WHERE ID='".$clan_act['ID']."'");
			$database->uquery("DELETE FROM aportes_clanes WHERE clan=".$clan_act['ID']);
			if($agregar_aporte>0){
				$database->uquery("INSERT INTO `aportes_clanes` (`ID` ,`UID` ,`clan` ,`cantidad` ,`fecha`) VALUES (NULL , '".$session->uid."', '".$clan_act['ID']."', '$agregar_aporte', '".time()."');");
			}
			$clan_act['lvl']=$clan_act['lvl']+2;
			echo '<b id="oka">Se agregaron 2 slots al clan!</b>';
		} elseif ($puedeampliar===false and $_REQUEST['ampliar']=="clan") {
			echo '<b id="err">No se pudo agrandar el clan.</b>';
		} else {
			echo '<a class="tooltip mini_bt" title="'.$tooltip.'"'.$urr.'>Ampliar</a>';
		}
		
		echo '</div><div class="clear"></div>';
		
		$cantindad_solicitudes = 0;
		echo '<div>'.get_header_title_cases('Solicitudes de ingreso',20);
		//$alertaspen = $database->query("SELECT * FROM `solicitud-clan` WHERE clan='".$clan_act['ID']."'");
		$alertaspen = $database->query("
			SELECT `solicitud-clan`.`ID` AS `SID`, `pjs`.* 
			FROM `solicitud-clan` INNER JOIN `pjs` 
			ON `solicitud-clan`.`userid` = `pjs`.`ID`
			WHERE `solicitud-clan`.`clan`='".$clan_act['ID']."'");
		if(mysql_num_rows($alertaspen) && $_REQUEST['eliminartodas']!='si'){
			while ($alert = mysql_fetch_array($alertaspen)){
				if( $alert['clan']==='0' ){
					$add='';
					if($_REQUEST['borrar']==$alert['SID']){
						$database->query("DELETE FROM `solicitud-clan` WHERE ID='".intval($_REQUEST['borrar'])."' AND clan='".$clan_act['ID']."'");
					} elseif ($_REQUEST['aceptar']==$alert['SID'] and $clan_act['permite_nuevos']==true) {
						agregar_pj_al_clan($alert['ID']);
					} else {
						if($clan_act['permite_nuevos']===true){
							$add.= '<a style="float:right;" href="clan_'.$clan_act['ID'].'.php?aceptar='.$alert['SID'].'" class="mini_bt">Aceptar</a>';
						} else {
							$add.= '<a style="float:right;" class="tooltip mini_bt" title="El clan est&aacute; lleno. No podr&aacute;s aceptar m&aacute;s usuarios hasta que tu clan compre m&aacute;s slots.">Aceptar</a>';
						}
						$add .= '<a style="float:right;" class="mini_bt" href="clan_'.$clan_act['ID'].'.php?borrar='.$alert['SID'].'">Borrar</a>';
						echo '<b>'.$alert['nick'].'</b>'.$add.'<div style="clear:both;"></div>';
						$cantindad_solicitudes++;
					}
				} else {
					$database->query("DELETE FROM `solicitud-clan` WHERE userid='".$alert['ID']."'");echo's';
				}
			}
		} else {
			echo 'No hay solicitudes de ingreso.';
		}
		if($cantindad_solicitudes>1){
			echo '<br/><br/><b>[ <a href="?eliminartodas=si" class="tooltip" title="Al hacer esto agilizas el servidor, se agradece borrar las solicitudes periodicamente.">Eliminar todas las solicitudes</a> ]</b>';
			if($_REQUEST['eliminartodas']=='si'){
				$database->uquery("DELETE FROM `solicitud-clan` WHERE clan = '".$clan_act['ID']."'");
			}
		}
		echo '</div>';
		formulario_salir_clan();
		
	} elseif($clan_act['permite_ver']===true) {
		lista_miembros();
		chat_clan();
		
		aportes_al_clan();
		formulario_aporte();
		formulario_salir_clan();
	}
}
		echo '</div></div>
		<div class="clear"></div><br/>&nbsp;<div class="clear"></div>';
		template_divisor();
		template_menu();
		template_footer();



?>