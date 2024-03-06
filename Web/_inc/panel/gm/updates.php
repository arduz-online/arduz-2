<?php
function print_form_camp($name,$label,$value){
echo '<label for="'.$name.'">'.$label.':</label>
<span class="input">
<input type="text" name="'.$name.'" id="'.$name.'" value="'.$value.'" class="t"></span>
<div style="clear:both;"></div>';
}
function print_form_campc($name,$label,$value){
echo '<label for="'.$name.'">'.$label.':</label><input type="checkbox" id="'.$name.'" name="'.$name.'" '.($value?'checked ':'').'/><div style="clear:both;"></div>';
}

if($session->logged_in){
	if($session->numpjs > 0){
		if($session->userinfo['GM']<255) exit();
		$page['title']='Arduz Online - Panel GM - UPDATES';	
		template_header();
		echo '<span class="pj">',get_header_title_cases('Editar UPDATES',22),'</span>';
		if(isset($_GET['agregarnuevo'])){
			$sql = 'INSERT INTO updates (`ID` ,`num` ,`url` ,`MD5` ,`filename` ,`version` ,`path`)'
			. 'VALUES (NULL , \'0\', \'http://xxx.com/update.asd\', \'md5\', \'update.asd\', \'0\', \'@\\\\\');';
			$database->query($sql);
			echo mysql_error();
			$_REQUEST['editar'] = mysql_insert_id();
		}
		if(isset($_GET['borrarnumcero'])){
			$database->query('DELETE FROM `updates` WHERE num=0');
			echo '<b id="oka">Se borraron los updates con numero=0</b>';
		}
		$editar = intval($_REQUEST['editar'])>0;
		if($editar){
			$upd_sql	= $database->query('SELECT * FROM updates WHERE ID='.intval($_REQUEST['editar']).' LIMIT 1');
		} else {
			$upd_sql	= $database->query('SELECT * FROM `updates` ORDER BY num ASC');
		}
		
		echo '<table class="ma20">';
		while($upd = mysql_fetch_assoc($upd_sql)) {
			$upds[$upd['ID']]=$upd;
			echo '<tr><td><em>#'.$upd['num'].'</em>  <b>'.$upd['filename'].'</b></td>';
			if(!$editar) echo '<td><a class="mini_bt" id="boton_inv" style="float:right;" href="?editar='.$upd['ID'].'">Editar</a></td>';
			echo '</tr>';
		}
		echo '</table>';
		
		mysql_free_result($upd_sql);
		if(intval($_REQUEST['editar']) !== 0){
			$upd=&$upds[intval($_REQUEST['editar'])];
			echo '<form action="?" method="POST" id="formulario" class="ma20">';
			echo get_header_title_cases('Actualizar Update existente',20);
			print_form_camp('num','Numero de actualizaci&oacute;n',$upd['num']);
			print_form_camp('filename','Nombre del archivo(cliente)',$upd['filename']);
			print_form_camp('url','URL a descargar',$upd['url']);
			print_form_camp('MD5','MD5 del archivo',$upd['MD5']);
			echo '<div class="ma20"><b>IMPORTANTE!:</b>Si el update es un ZIP o un parche de enpaquetado NO PONGAS MD5.</div>';
			print_form_camp('path','Ruta del archivo(cliente)',$upd['path']);
			echo '<div class="ma20">Comodines: <br/>
			"@"=Carpeta del cliente; <br>
			Sintax: "@"+"\"+[ruta_local]+"\"; ejemplo "@\Datos\wav\"<hr/>
			"#"=Numero de archivo a parchear en los enpaquetados; 
			Sintax: "#"+[enum_archivos]; <br>
			ejemplos: "#0" = Parchea en Mapas.res<br>
			ejemplos: "#1" = Parchea en Interface.res<br>
			ejemplos: "#2" = Parchea en Graficos.res<br><b>IMPORTANTE!:</b>Ten&eacute;s que poner SOLO un numero en filename cuando usas este comodin.</div>';
			echo '<input type="hidden" name="ID" value="'.$upd['ID'].'"/><label></label><input id="Submit" type="submit" name="submit" value="Guardar"><div style="clear:both;"></div></form>';
		}elseif(!empty($_POST['ID'])){
		
			$upd['num']=(string)intval($_POST['num']);
			$upd['filename']=(string)($_POST['filename']);
			$upd['url']=(string)($_POST['url']);
			$upd['MD5']=(string)($_POST['MD5']);
			$upd['path']=(string)($_POST['path']);
			$upd['version']++;
			if(strtolower(substr($upd['path'],-3))=='zip'){
				$upd['MD5']='1';
			}
			if(substr($upd['path'],0,1)=='#'){
				$upd['path']='#'.(intval(substr($upd['path'],1,1)) % 3);
				$upd['filename']=intval($upd['filename']);
			}
			$database->query(utf8_decode(mysql_update_array('updates',$upd,'ID',$_POST['ID'])));
			$modificado=true;
		}
		if($modificado){
			echo '<b id="oka">Updates guardados.</b>';
		}
		echo '<a href="?borrarnumcero=asd">Borrar updates con num=0</a>';
		echo '<div class="clear"></div><br/>&nbsp;<div class="clear"></div>';
		template_divisor();
		template_menu();
		template_footer();
	} else header('Location: panel.php');
} else go_login_page();
?>