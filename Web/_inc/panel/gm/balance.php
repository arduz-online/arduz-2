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

$intervalos=array(1=>'Intervalo U',2=>'Int. Doble Click',3=>'Puede atacar',4=>'Puede hechizo',5=>'int e flechas',6=>'int e ataques');
$modificadores=array(
0=>'Evasion',
1=>'Ataque Armas',
2=>'Ataque Proyectiles',
3=>'Danio Armas',
4=>'Danio Proyectiles',
5=>'Wrestling',
6=>'Escudo',
);
if($session->logged_in){
	if($session->numpjs > 0){
		if($session->userinfo['GM']<255) exit();
		
		include '_inc/game.logic.php';
		$editar = intval($_REQUEST['editar'])>0;
		$page['title']='Arduz Online - Panel GM - BALANCE';	
		template_header();
		echo '<span class="pj">',get_header_title_cases('Editar Balance',22),'</span>';
		
		if($editar){
			$items_sql	= $database->query('SELECT * FROM clases WHERE ID='.intval($_REQUEST['editar']).' LIMIT 1');
		} else {
			$items_sql	= $database->query('SELECT * FROM clases');
		}
		
		echo '<table class="ma20">';
		while($item = mysql_fetch_assoc($items_sql)) {
			$items[$item['ID']]=$item;
			echo '<tr><td>'.$item['name'].'</td>';
			if(!$editar) echo '<td><a class="mini_bt" id="boton_inv" style="float:right;" href="?editar='.$item['ID'].'">Editar</a></td>';
			echo '</tr>';
		}
		
		echo '</table>';
		mysql_free_result($items_sql);
		if(intval($_REQUEST['raza']) === 0){
			if(intval($_REQUEST['editar']) !== 0){
				$item=&$items[intval($_REQUEST['editar'])];
				echo '<form action="?" method="POST" id="formulario" class="ma20">';
				echo get_header_title_cases('Hechizos',20);
				for($i=1;$i<=12;$i++){
					print_form_camp('h'.$i,'Hechizo '.$i,$item['h'.$i]);
				}
				echo get_header_title_cases('Intervalos',20);
				for($i=1;$i<=6;$i++){
					print_form_camp('i'.$i,$intervalos[$i],$item['i'.$i]);
				}
				echo get_header_title_cases('Modificadores',20);
				for($i=0;$i<=6;$i++){
					print_form_camp('m'.$i,$modificadores[$i],$item['m'.$i]);
				}			
			
				echo '<input type="hidden" name="ID" value="'.$item['ID'].'"/><label></label><input id="Submit" type="submit" name="submit" value="Guardar"><div style="clear:both;"></div></form>';
				echo '<div class="ma20">'.get_header_title_cases('Editar por razas',20).'<table class="ma20">';
				for($i=1;$i<=5;$i++){
					echo '<tr><td>'.$item['name'].' '.$razas[$i].'</td>
					<td><a class="mini_bt" id="boton_inv" style="float:right;" href="?editar='.$item['ID'].'&raza='.$i.'">Editar</a></td>
					</tr>';
				}
				echo '</table></div>';
			}elseif(!empty($_POST['ID'])){
				for($i=1;$i<=12;$i++){
					$item['h'.$i]=(string)intval($_POST['h'.$i]);
				}
				for($i=1;$i<=6;$i++){
					$item['i'.$i]=(string)intval($_POST['i'.$i]);
				}
				for($i=0;$i<=6;$i++){
					$item['m'.$i]=(string)($_POST['m'.$i]+0);
				}
				$database->query(utf8_decode(mysql_update_array('clases',$item,'ID',$_POST['ID'])));
				$modificado=true;
			}
		} else {
			if(intval($_REQUEST['editar']) !== 0){
				$raza	= mysql_fetch_assoc($database->query('SELECT * FROM razas WHERE clase='.intval($_REQUEST['editar']).' AND raza='.intval($_REQUEST['raza'])));
				echo '<form action="?" method="POST" id="formulario" class="ma20">';
				echo get_header_title_cases('Modificar '.$items[$raza['clase']]['name'].' '.$razas[$raza['raza']],20);
				print_form_camp('vida','Vida',$raza['vida']);
				print_form_camp('mana','Mana',$raza['mana']);
				print_form_camp('max_hit','Golpe Maximo',$raza['max_hit']);
				print_form_camp('min_hit','Golpe Minimo',$raza['min_hit']);
				print_form_camp('inicial','Items Iniciales',$raza['inicial']);
				echo '<input type="hidden" name="ID" value="'.$raza['clase'].'"/><input type="hidden" name="raza" value="'.$raza['raza'].'"/><label></label><input id="Submit" type="submit" name="submit" value="Guardar"><div style="clear:both;"></div></form>';

			} elseif( !empty($_POST['ID']) ){
				$item['vida']=(string)intval($_POST['vida']);
				$item['mana']=(string)intval($_POST['mana']);
				$item['max_hit']=(string)intval($_POST['max_hit']);
				$item['min_hit']=(string)intval($_POST['min_hit']);
				$t=explode('-',$_POST['inicial']);
				$ta='';
				foreach($t as $v){
					if(intval($v)>0){$ti[]=intval($v);
					$kk++;
					}
				}
				if($kk>1){
					$ta=implode('-',$ti);
				}else{
					$ta=intval($_POST['inicial']);
				}
				$item['inicial']=$ta;
				$database->query(utf8_decode(mysql_update_array('razas',$item,'clase',$_POST['ID']).' AND `raza` = '.intval($_POST['raza'])));
				$modificado=true;
			}
		}
		if($modificado){
			echo '<b id="oka">Balance guardado.</b>';
			$database->query("UPDATE `configuracion` SET `ultimobalance` = `ultimobalance`+1 ");
		}
		echo '<div class="clear"></div><br/>&nbsp;<div class="clear"></div>';
		template_divisor();
		template_menu();
		template_footer();
	} else header('Location: panel.php');
} else go_login_page();
?>