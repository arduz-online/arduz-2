<?php
if(ANTIHACK===true){
	$mercader_act = array();
	
	function cargar_mercader($id=1,$hash=''){
		global $mercader_act,$database;
		$m_sql			= $database->query('SELECT `mercader`.* FROM `mercader` WHERE ID='.intval($id).' LIMIT 1');
		$mercader_act	= mysql_fetch_assoc($m_sql);
		if( $mercader_act['hash']===$hash )
			return true;
		else
			return false;
	}
	
	function check_mercader($id=1,$d=false){
		global $mercader_act;
		$rehacer = false;
		
		if( $mercader_act['items'] === '0' )
			$rehacer = true;
		if( $mercader_act['tiempo'] < time() )
			$rehacer = true;
		if( $rehacer == true )
			if(actualizar_mercader($id)===true){
				if($d==true)cargar_mercader($id);
			}
		return false;
	}

	function actualizar_mercader($id=1){
		global $database,$mercader_act,$items_array,$item_props,$calidades;

		$id				= intval($id);
		$contador 		= $antiloop = 1;
		$tmp_flags 		= 0;
		$tmp_precio		= 0;
		$tmp_calidad	= 0;
		if( $mercader_act['ID'] != $id ) return false;
		$items_array 	= array();
		cargar_items($id);
		
		while($contador < 31 and $antiloop < 200){
			$item = &$items_array[array_rand($items_array)];
			$tmp_precio = intval($item['Valor'])+1;
			if( mt_rand(0,99)<intval($item['posibilidad']) ){
				$tmp_flags = 0;
				if(($item['posibilidad']<<4)!=0){
					for($i=0;$i<=28;$i++){
						if(($item['posibilidad'] & (1 << $i))!==0){
							if( mt_rand(0,99)<$item_props[$i]['p'] ){
								$tmp_flags |= (1 << $i);
								$tmp_precio += $tmp_precio*$item_props[$i]['a']/100;
							}
						}
					}
				}
				$tmp_calidad = mt_rand(0,100);
				
				if( $tmp_calidad < 30 ){
					$tmp_calidad = 0;//inferior
				} elseif( $tmp_calidad < 50 ) {
					$tmp_calidad = 1;//normal
				} elseif( $tmp_calidad < 75 ) {
					$tmp_calidad = 2;//superior
				} else { //$tmp_calidad > 95 
					$tmp_calidad = 3;//excepcional
				}
				$tmp_precio += $tmp_precio*$calidades['a'][$tmp_calidad]/100;
				
				set_calidad($tmp_flags,$tmp_calidad);
				
				$mitems['o'.$contador]=$item['ID'];
				$mitems['f'.$contador]=(string)$tmp_flags;
				$mitems['t'.$contador]=(string)$calidades['duracion'][$tmp_calidad];
				$mitems['p'.$contador]=(string)intval($tmp_precio);
				
				++$contador;
			}// else echo 'mal'.intval($item['posibilidad']);
			
			++$antiloop;
		}
		
		$mitems['hash']		= hash('md4', time().date('ymd'));
		$mitems['tiempo']	= (string)(time()+rand(1800,7200));
		$mitems['items']	= (string)($contador-1);
		
		$database->query(mysql_update_array('mercader',$mitems,'ID',$id));
		return true;
	}
	
	function get_item_precio_venta(&$item){
		$precio_venta = $item['Valor']/2;
		$precio_venta -= $precio_venta*(1-$item['calidad']/get_calidad_int($item['flags']));
		return round($precio_venta);
	}
}
?>