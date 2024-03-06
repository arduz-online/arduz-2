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


if($session->logged_in){
	if($session->numpjs > 0){
		if($session->userinfo['GM']<255) exit();
		
		include '_inc/game.logic.php';
		
		$page['title']='Arduz Online - Panel GM - Items ('.intval($_REQUEST['editar']).')';	
		template_header();
		echo '<span class="pj">',get_header_title_cases('Editar Items',22),'</span>';
		
		/*
		if( @intval($_REQUEST['borrar'])>0 ){
			$sql = 'DELETE FROM items WHERE ID ='.intval($_REQUEST['borrar']);
			$database->query($sql);
			echo mysql_error();
			$_REQUEST['editar']=0;
			if( mysqli_affected_rows() )
				echo '<b id="oka">Se borro correctamente el item.</b>';
				
		}
		*/
		
		if( isset($_REQUEST['agregarnuevo']) ){
			$sql = 'INSERT INTO items (`ID` ,`Name`)'
			. 'VALUES (NULL , \'ItemNuevo\');';
			$database->query($sql);
			echo mysql_error();
			$_REQUEST['editar'] = mysql_insert_id();
		}
		
		$editar = intval($_REQUEST['editar'])>0;
		
		if($editar){
			$items_sql	= $database->query('SELECT * FROM items WHERE ID='.intval($_REQUEST['editar']).' LIMIT 1');
		} else {
			$items_sql	= $database->query('SELECT * FROM items');
		}
		
		echo '<table class="ma20">';
		while($item = mysql_fetch_assoc($items_sql)) {
			$items[$item['ID']]=$item;
			echo '<tr><td class="initem"><span><img src="'.$urls[2].'_images/_items/'.$item['grh'].'.gif" alt="IMG"/></span></td><td class="lh8 matb5">'.$item['Name'].($item['NEWBIE']==='1'?' <b>(NEWBIE)</b>':'').'<br/>
			<table>
			<tr><td><b><small class="mtahoma">M</small></b></td><td><b><small class="mtahoma">C</small></b></td><td><b><small class="mtahoma">D</small></b></td><td><b><small class="mtahoma">R</small></b></td><td><b class="idv">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'.$item['Valor'].'</b></td></tr>
			<tr><td><small class="mtahoma">'.$item['magia'].'</small></td><td><small class="mtahoma">'.$item['combate'].'</small></td><td><small class="mtahoma">'.$item['defenza'].'</small></td><td><small class="mtahoma">'.$item['resistencia'].'</small></td></tr></table>';
			if(!$editar) echo '<td><a class="mini_bt" id="boton_inv" style="float:right;" href="007adminitems.php?editar='.$item['ID'].'">Editar</a></td>';
			echo '</tr>';
		}
		
		echo '</table>';
		mysql_free_result($items_sql);
		if($editar){
			$item=&$items[intval($_REQUEST['editar'])];
			echo '<form action="007adminitems.php" method="POST" id="formulario">';
			print_form_camp('name','Nombre',$item['Name']);
			print_form_camp('precio','Precio',$item['Valor']);
			print_form_camp('desc','Descripcion',$item['desc']);
			print_form_camp('grh','N&uacute;mero en OBJ.DAT',$item['grh']);
			print_form_campc('NEWBIE','NEWBIE',$item['NEWBIE']==='1');
			for($i=1;$i<=4;$i++){
				print_form_camp($skills['nombres_db'][$i],$skills['nombres'][$i],$item[$skills['nombres_db'][$i]]);
			}
			$n=intval($item['habespecial']);
			for($i=0;$i<=27;$i++){
				print_form_campc('he'.$i,$i,(($n & (1 << $i))!==0));
			}
			print_form_camp('mercader','<a class="tooltip" title="0=NO SE VENDE<br/>1=Armero<br/>2=Herrero<br/>3=Carpintero<br/>4=Sastre">Mercader</a>',get_calidad($n));
			print_form_camp('pos','Posibilidad de aparecer %',$item['posibilidad']);
			echo '<input type="hidden" name="ID" value="'.$item['ID'].'"/><label></label><input id="Submit" type="submit" name="submit" value="Enviar"><div style="clear:both;"></div></form>';
		}elseif(!empty($_POST['ID'])){
			$item_flags = &new clsByte;
			$item_flags->in(0);
			for($i=0;$i<=27;$i++){
				if($_POST['he'.$i]) $item_flags->set_si($i);
			}
			$item['Name'] 			= $_POST['name'];
			$item['Valor'] 			= (string)intval($_POST['precio']);
			$item['desc'] 			= $_POST['desc'];
			$item['grh'] 			= (string)intval($_POST['grh']);
			for($i=1;$i<=4;$i++){
				$item[$skills['nombres_db'][$i]]=(string)intval($_POST[$skills['nombres_db'][$i]]);
			}
			$item['habespecial'] 	= $item_flags->out();
			set_calidad($item['habespecial'],intval($_POST['mercader']));
			$item['habespecial']	= (string)$item['habespecial'];
			$item['posibilidad'] 	= (string)(intval($_POST['pos']) % 101);
			if( $_POST['NEWBIE'] ){
				$item['NEWBIE'] 		= '1';
			} else {
				$item['NEWBIE'] 		= '0';
			}
			$database->query(utf8_decode(mysql_update_array('items',$item,'ID',$_POST['ID'])));
			header('Location: 007adminitems.php?ok=a');
		}
		echo '<div class="clear"></div><br/>&nbsp;<div class="clear"></div>';
		template_divisor();
		template_menu();
		template_footer();
	} else header('Location: panel.php');
} else go_login_page();
?>