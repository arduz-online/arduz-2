<?php
if(ANTIHACK===true){
	$clan_act = array();
	
	function cargar_clan($id=1){
		global $session,$clan_act,$database;
		$m_sql			= $database->query('SELECT `clanes`.* FROM `clanes` WHERE ID='.intval($id).' LIMIT 1');
		$clan_act	= mysql_fetch_assoc($m_sql);
		if( $clan_act['ID'] == $id ){
			$clan_act['necesarios']		= ($clan_act['lvl']*200000);
			$clan_act['permite_nuevos']	= (($clan_act['lvl']+5)>$clan_act['miembros']);
			$clan_act['permite_ver']	= in_array($clan_act['ID'], $session->pjs_clanes);
			$clan_act['permite_admin']	= ($session->uid == $clan_act['fundador']);
			$clan_act['pertenezco']		= $clan_act['permite_ver']==false;
			if($session->userinfo['GM']==255){
				$clan_act['permite_admin'] = $clan_act['permite_ver'] = true;
				
			}
			return true;
		}else return false;
	}
	
	function agrandar_clan(){
	
	}
	
	function echar_pj_del_clan($pj){
		global $clan_act,$database;
		if(intval($pj)===0) return;
		$database->uquery("UPDATE pjs SET clan='0' WHERE ID='".intval($pj)."'");
		$database->uquery("UPDATE clanes SET miembros=miembros-1 WHERE ID='".$clan_act['ID']."'");
		actualizar_cuenta($pj);
	}
	
	function agregar_pj_al_clan($pj){
		global $clan_act,$database;
		if(intval($pj)===0) return false;
		if(!$clan_act['permite_nuevos']) return false;
		$database->uquery("UPDATE pjs SET clan='".$clan_act['ID']."' WHERE ID='".intval($pj)."'");
		$database->uquery("UPDATE clanes SET miembros=miembros+1 WHERE ID='".$clan_act['ID']."'");
		$database->uquery("DELETE FROM `solicitud-clan` WHERE userid=".intval($pj));
		echo mysql_error();
		return actualizar_cuenta($pj);
	}	
	
	function aportar_al_clan($ptos){
		global $session,$clan_act,$database;
		$ptos=abs(intval($ptos));
		$puntos=$session->userinfo['puntos']-$ptos;
		if($puntos<0 || $ptos < 499) return false;
		$database->updateUserField($session->username,'puntos',$puntos);
		$database->uquery("INSERT INTO `aportes_clanes` (`ID` ,`UID` ,`clan` ,`cantidad` ,`fecha`) VALUES (NULL , '".$session->uid."', '".$clan_act['ID']."', '$ptos', '".time()."');");
		$database->uquery("UPDATE clanes SET puntos=puntos+".$ptos." WHERE ID='".$clan_act['ID']."'");
		return true;
	}
	
	function actualizar_cuenta($pj){
		global $clan_act,$database;
		$s = mysql_fetch_assoc($database->query('SELECT IDCuenta FROM pjs WHERE ID='.intval($pj)));
		if($s['IDCuenta']>0){
			return $database->ActualizarPjs($s['IDCuenta']);
		} else {
			return false;
		}
	}
	
	function aportes_al_clan(){
		global $clan_act,$database;
		echo '
		<div>'.get_header_title_cases('Aportes al clan',20);
		$alertaspen = $database->query('SELECT `users`.`username`,`aportes_clanes`.* FROM `aportes_clanes`,`users` WHERE `aportes_clanes`.`clan`=\''.$clan_act['ID'].'\' AND `users`.`ID`=`aportes_clanes`.`UID`');
		if(mysql_num_rows($alertaspen)){
			while ($pj = mysql_fetch_array($alertaspen)){
				echo '<b>'.$pj['username'].'</b> aport&oacute; <b class="idv">'.$pj['cantidad'].'</b> al clan.<br/>';
				$total+=$pj['cantidad'];
			}
		} else {
			echo 'Nadie aport&oacute; nada al clan a&uacute;n.';
		}
		echo '<br/>Total recaudado: <b class="idv">'.intval($total).'</b>
		</div>
		<br/>
		<div class="clear"></div>';
		return $total;
	}
	
	function formulario_aporte(){
		global $clan_act,$session;
		$codigo_x = ((int)$clanID ^ (int)intval($clan_act['miembros']) ^ (int)($clan_act['lvl']*3) ^ (int)intval(date('yH')) );
		echo '
			<div><a class="mini_bt" onclick="Toggle_vid(\'aportar\');">Aportar</a>
				<div id="aportar" style="display:none;">
					<form method="POST" action="?" id="formulario">
						<label>Escriba la verificaci&oacute;n:</label>
						<div class="clear"></div>
						<label for="ver">"'.$codigo_x.'"</label>
							<span class="input">
								<input id="ver" name="ver" type="text"/>
							</span>
						<div class="clear"></div>
						<label for="cant" class="tooltip" title="Minimo: 500 monedas.">Cantidad</label>
							<span class="input">
								<input id="cant" name="cant" type="text"/>
							</span>
						<div class="clear"></div>
						<label><b class="idv" id="oroo">'.$session->userinfo['puntos'].'</b></label>
						<input type="submit" value="Realizar aporte" id="Submit"/>
					</form>
				</div>
			</div>';
		if(intval($_POST['cant'])>0){
			if(intval($_POST['ver'])==$codigo_x){
				if(aportar_al_clan($_POST['cant'])===false) 
					echo "<div class='ma20'><b id='err'>Cantidad incorrecta, minimo 500.</b></div>";
				else
					echo "<div class='ma20'><b id='oka'>Aporte realizado.</b></div>";
			} else {
				echo "<div class='ma20'><b id='err'>Verifiaci&oacute;n incorrecta.</b></div>";
			}
		}
	}
	
	function chat_clan(){
		global $clan_act;
		echo '<div>'.get_header_title_cases('Chat del clan',20);
		echo '<div>
	<script type="text/javascript"><!-- // --><![CDATA[
		$(document).ready(function(){
			timestamp = 0;
			updateMsg();
			var mtoc = /<([^<>]*)>/g;
			$("form#chatform").submit(enviar_chat);

		});
		function enviar_chat(){
				$.ajax({
					url: "ajax-clanes-chat_'.$clan_act['ID'].'.php",
					global: false,
					type: "POST",
					dataType: "json",
					data: {
							message: $("#msg").val(),
							action: "postmsg",
							time: timestamp
					},
					success: function(data){
						$("#msg").empty();
						addMessages(data);
					}
				});
				document.form1.ch.value="";
				return false;
		}
		function addMessages(xml) {
			if(xml.status == "2") return;
			timestamp = xml.time;

			for(var i in xml){
				var j = xml[i];
				if(j.c==true){
					$("#messagewindow").prepend("<div><b>"+j.author+"</b>: "+j.text+"</div>");
				}
			}
				
		}
		function updateMsg() {
			$.ajax({
				url: "ajax-clanes-chat_'.$clan_act['ID'].'.php",
				global: false,
				type: "POST",
				dataType: "json",
				data: {
						time: timestamp
				},
				success: function(data){
					addMessages(data);
				}
			});
			setTimeout(\'updateMsg()\', 15000);
		}
	// ]]></script>
	<style type="text/css">
		#messagewindow {
			height: 128px;
			width: 435px;
			border-top:solid 1px #533;
			border-left:solid 1px #533;
			border-right:solid 1px #333;
			border-bottom:solid 1px #333;
			padding: 5px;
			font-family: Tahoma,Verdana,Arial,Helvetica,sans-serif;
			color: #F0F0F0;
			font-size: 11px;
			overflow: auto;
			background:black url(./_images/common/fondo_m.png) no-repeat scroll center 0;
			-moz-border-radius:2px;
		}
	</style>
	<div id="wrapperx">
	<div id="messagewindow"></div>
	</div>
		<form name="form1" id="chatform" style="padding:5px ;margin:2px;" action="">
		Mensaje: <input type="text" id="msg" class="edit" name="ch" style="display:inline"/>    
		<!--<input class="mini_bt" type="submit" value="Enviar" />--><a class="mini_bt" onclick="enviar_chat();">Enviar</a><br />
		</form>
		</div></div>
		<div class="clear"></div>';
	}
	function lista_miembros($comun = true){
		global $clan_act,$database;
		echo '
		<div>'.get_header_title_cases('Lista de miembros',20);
		$alertaspe = $database->query('SELECT * FROM `pjs` WHERE clan=\''.$clan_act['ID'].'\'');
		if($comun == true){
			while ($pj = mysql_fetch_array($alertaspe)){
				echo '<a class="tooltip" href="#" style="float:left;" title="Frags: '.$pj['frags'].'<br/>Muertes: '.$pj['muertes'].'"><b>'.$pj['nick'].'</b></a><div style="clear:both;"></div>';
			}
		} else {
			while ($pj = mysql_fetch_array($alertaspe)){
				if($_REQUEST['echar']===$pj['ID'])
					echar_pj_del_clan($pj['ID']);
				else
					echo '<a class="tooltip" href="#" style="float:left;" title="Frags: '.$pj['frags'].'<br/>Muertes: '.$pj['muertes'].'"><b>'.$pj['nick'].'</b></a><a style="float:right;" href="clan_'.$clan_act['ID'].'.php?echar='.$pj['ID'].'" class="tooltip mini_bt" title="Echar a <b>'.$pj['nick'].'</b> del clan.">Echar</a><div style="clear:both;"></div>';
			}		
		}
		echo '
		</div>
		<div class="clear"></div>';
	}
	function formulario_salir_clan(){
		global $session,$clan_act;
		$buff = '';
		$tiene_pjs = false;
		for($i=0;$i<$session->numpjs;$i++){
			if($session->pjs_clanes[$i]==$clan_act['ID']){
				if($session->pjs[$i]==$_POST['salir_pj']){
					echar_pj_del_clan($session->pjs[$i]);
				} else {
					$buff .= '<option value="'.$session->pjs[$i].'">'.$session->pjs_nicks[$i].'</option>';
					$tiene_pjs = true;
				}
			}
		}
		if( $tiene_pjs === true )
			echo '
			<div>
				'.get_header_title_cases('Salir del clan',20).'
				<a class="mini_bt" onclick="Toggle_vid(\'salirclan\');">Ver lista</a>
				<div class="ma20" id="salirclan" style="display:none;">
					<form method="POST" action="?" id="formulario">
						<label>Selecciona tu personaje</label><select name="salir_pj">'.$buff.'</select>
						<div class="clear"></div>
						<label></label><input type="submit" value="Salir del clan" id="Submit"/>
					</form>
				</div>
			</div>';
	}
}
?>