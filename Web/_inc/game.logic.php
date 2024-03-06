<?php
/**                ____________________________________________
 *                /_____/  http://www.arduz.com.ar/ao/   \_____\
 *               //            ____   ____   _    _ _____      \\
 *              //       /\   |  __ \|  __ \| |  | |___  /      \\
 *             //       /  \  | |__) | |  | | |  | |  / /        \\
 *            //       / /\ \ |  _  /| |  | | |  | | / /   II     \\
 *           //       / ____ \| | \ \| |__| | |__| |/ /__          \\
 *          / \_____ /_/    \_\_|  \_\_____/ \____//_____|_________/ \
 *          \________________________________________________________/  
 *
 *		@writer: 		Agustín Nicolás Méndez (aka Menduz)
 *		@contact: 		lord.yo.wo@gmail.com
 *		@start-date: 	17-5-09
 *		@desc: 			GAME LOGIC FILE.
 */
$timenow 	= time();

$razas 		= array(
	1=>'Humano',
	2=>'Elfo',
	3=>'Elfo Oscuro',
	4=>'Gnomo',
	5=>'Enano'
);

$clases 	= array(
	1=>'Mago',
	2=>'Cl&eacute;rigo',
	3=>'Guerrero',
	4=>'Asesino',
	5=>'Caballero oscuro',/* NOSEUSA */
	6=>'Bardo',
	7=>'Druida',
	8=>'Nigromante',
	9=>'Paladin',
	10=>'Arquero'/*Cazador*/
);

$clases_puede 	= array(
	1=>true,
	2=>true,
	3=>true,
	4=>true,
	5=>false,/* NOSEUSA */
	6=>true,
	7=>true,
	8=>false,
	9=>true,
	10=>true/*Cazador*/
);

$cabezas 	= array(
	1=>array(
		1=>array(1=>1,2=>38),
		2=>array(1=>70,2=>79)),
	2=>array(
		1=>array(1=>101,2=>112),
		2=>array(1=>170,2=>178)),
	3=>array(
		1=>array(1=>200,2=>210),
		2=>array(1=>270,2=>278)),
	4=>array(
		1=>array(1=>401,2=>406),
		2=>array(1=>470,2=>476)),
	5=>array(
		1=>array(1=>300,2=>306),
		2=>array(1=>370,2=>372))

);

$rangos 	= array(
	1=>	array(
		1=>'Aprendiz',
		2=>'Escudero',
		3=>'Guardian',
		4=>'Defensor',
		5=>'Protector',
		6=>'Capit&aacute;n',
		7=>'Coronel',
		8=>'Brigadier',
		9=>'General',
		10=>'Campe&oacute;n de la luz'
	),
	2=>	array(
		1=>'Acolito',
		2=>'Esbirro',
		3=>'Maldito',
		4=>'Hereje',
		5=>'Torturador',
		6=>'Caballero Oscuro',
		7=>'Destructor',
		8=>'Corruptor',
		9=>'Adorador del Demonio',
		10=>'Devorador de almas'
	)
);

$skills 	= array(
	'precio'	=>	array(1=>100,		2=>100,			3=>100,			4=>100),
	'fprecio'	=>	array(1=>900000,		2=>900000,		3=>900000,		4=>900000),
	'tiempo'	=>	array(1=>80,			2=>100,			3=>70,			4=>70),
	'ftiempo'	=>	array(1=>70000,		2=>70000,		3=>70000,		4=>70000),
	'nombres' 	=>	array(1=>'Magia',	2=>'Combate',	3=>'Defensa',	4=>'Resistencia'),
	'nombres_db'=>	array(1=>'magia',	2=>'combate',	3=>'defenza',	4=>'resistencia')
);

$item_props = array(
	1=>array(
		'n'=>'Daño de fuego',
		'p'=>30,
		'a'=>8,/* % */
	),
	2=>array(
		'n'=>'Daño electico',
		'p'=>30,
		'a'=>8,/* % */
	),
	3=>array(
		'n'=>'Daño de hielo',
		'p'=>80,
		'a'=>8,/* % */
	),
	4=>array(
		'n'=>'Forjado',
		'p'=>30,
		'a'=>8,/* % */
	),
	5=>array(
		'n'=>'Daño vampiro',
		'p'=>30,
		'a'=>8,/* % */
	),
	5=>array(
		'n'=>'Precision',
		'p'=>30,
		'a'=>8,/* % */
	),
	7=>array(
		'n'=>'Geomante',
		'p'=>30,
		'a'=>8,/* % */
	),
	8=>array(
		'n'=>'Envenenado',
		'p'=>30,
		'a'=>8,/* % */
	),
	9=>array(
		'n'=>'Fortalecido',
		'p'=>30,
		'a'=>8,/* % */
	)
);
$calidades = array(
	'name'		=>	array(0=>'inferior',	1=>'normal',	2=>'superior',	3=>'excepcional',	4=>'legendaria'),
	'duracion'	=>	array(0=>150,		1=>300,		2=>500,			3=>750,				4=>65535),
	'a'			=>	array(0=>0,			1=>100,		2=>150,			3=>200,				4=>2000)
);

$items_array = array();
$items_cargados = false;

class clsByte{
    protected $bitmask = 0;
    public function set_si 	( $bit )	{$this->bitmask |= 1 << $bit;}
    public function set_no 	( $bit )	{$this->bitmask &= ~ (1 << $bit);}
    public function toggle 	( $bit )	{$this->bitmask ^= 1 << $bit;}
    public function get 	( $bit )	{return (bool)(($this->bitmask & (1 << $bit))!==0);}
    public function in  	( $int )	{$this->bitmask = intval($int);}
    public function out		()			{return $this->bitmask;}
}

function set_calidad(&$flags,$calidad){
	$calidad 	 = ((intval($calidad)%5)<<28);
	$flags 		&=0xFFFFFFF;//~0xF0000000;
	$flags		|= $calidad;
	return $flags;
}

function get_calidad($flags){
	return intval(abs(intval($flags)>>28));
}

function get_calidad_int($flags){
	global $calidades;
	return $calidades['duracion'][ abs(intval($flags)>>28) ];
}
function get_calidad_str($flags){
	global $calidades;
	return $calidades['name'][ abs(intval($flags)>>28) ];
}

function cargar_items($mercader=-1){
	global $database,$items_array,$items_cargados;
	if( $mercader === -1 ){
		if( $items_cargados === false ){
			$items_sql	= $database->query('SELECT * FROM items');
			
			while($itmp = mysql_fetch_assoc($items_sql))
				$items_array[$itmp['ID']]=$itmp;
				
			$items_cargados = true;
			mysql_free_result($items_sql);
		}
	} else {
		$items_sql	= $database->query('SELECT * FROM items WHERE (habespecial>>28) = \''.abs(intval($mercader)%5)."'");
		
		while($itmp = mysql_fetch_assoc($items_sql))
			$items_array[$itmp['ID']]=$itmp;
			
		mysql_free_result($items_sql);
	}
}

function pj_puede_tener_item(&$infoPJ, $item,&$itmp=array()){
	global $database,$items_array,$items_cargados;
	$item	= intval($item);
	if( $item === 0 ) return false;
	if( $items_cargados !== true ){
		$items_sql	= $database->query("SELECT magia,combate,defenza,resistencia,NEWBIE FROM items WHERE items.ID ='$item'");
		$itmp 		= mysql_fetch_assoc($items_sql);
	} else $itmp	= &$items_array[$item];
	
	return 
		(
			( $infoPJ['magia']		>= $itmp['magia']		) &&
			( $infoPJ['combate']		>= $itmp['combate']		) &&
			( $infoPJ['defenza']		>= $itmp['defenza']		) &&
			( $infoPJ['resistencia']	>= $itmp['resistencia']	)
		);
}

function rellenar_items(&$infoPJ){
	global $database,$calidades;
	$sql	= $database->query('SELECT inicial FROM razas WHERE raza = \''.$infoPJ['raza'].'\' AND  clase = \''.$infoPJ['clase'].'\'');
	$tmp 	= mysql_fetch_assoc($sql);
	$items	= explode('-',$tmp['inicial']);
	$calidad =0;
	set_calidad($calidad,3);
	
	foreach ($items as $value) {
		$value=intval($value);
		if($value>0){
			$contador++;
			$mitems['o'.$contador]=$value;
			$mitems['f'.$contador]=(string)$calidad;
			$mitems['t'.$contador]=(string)$calidades['duracion'][3];
		}
	}
	
	$database->query(mysql_update_array('mochila',$mitems,'UID',$infoPJ['ID']));
}

function echo_item_tooltip(&$item){
	echo '<b class=\'n\'>',$item['Name'],' ',get_calidad_str($item['flags']),($item['NEWBIE']==='1'?' <b>(NEWBIE)</b>':''),'</b>';
	$calidadint = get_calidad_int($item['flags']);
	if($calidadint<60000){
		$por=($item['calidad']/$calidadint*100);
		echo ' <span>'.$item['calidad'].'/'.$calidadint.'</span><br><span class=\'barras\'><div class=\'barra_fondo\'><div class=\'';
		if($por>=90){
			echo 'barra_verde';
		}elseif($por>=30 && $por<90){
			echo 'barra_amarilla';
		}elseif($por<30){
			echo 'barra_roja';
		}
		echo '\' style=\'width:'.$por.'%\'></div></div></span>';
	} else {
		echo '<br/>';
	}
	if($item['desc']!=='') echo $item['desc'];
	
	if(($item['magia']+$item['combate']+$item['defenza']+$item['resistencia'])!==0){
		echo 
			'<br/><b>Requiere:</b><br/>'.
			($item['magia']!=='0'?'&nbsp;&nbsp;Magia: <b>'.$item['magia'].'</b><br/>':'').
			($item['combate']!=='0'?'&nbsp;&nbsp;Combate: <b>'.$item['combate'].'</b><br/>':'').
			($item['defenza']!=='0'?'&nbsp;&nbsp;Defensa: <b>'.$item['defenza'].'</b><br/>':'').
			($item['resistencia']!=='0'?'&nbsp;&nbsp;Resistencia: <b>'.$item['resistencia'].'</b>':'').'<br/>';
	}
	
	if($item['flags']!==0){
		echo return_item_spells($item['flags']);
	}
}

function return_item_spells($num){
	$result = '';
	$num=intval($num);
	if(($num & 1)!==0) $result.='<br/>Aumenta el golpe en un 5%'; //(1 << 1)
	if(($num & 2)!==0) $result.='<br/>Aumenta la posibilidad de apu&ntilde;alar en un 5%'; //(1 << 2)
	if(($num & 2)!==0) $result.='<br/><span class=\'idi\'>Aumenta 3 puntos de resitencia m&aacute;gica</span>'; //(1 << 2)
	if(($num & 0x80000000)!==0) $result.= '<br/><span class=\'idn\'>Item de los dioses</span>'; //(1 << 31)
	return ''.$result.'';
}

class game_logic{
	function game_logic()
	{
		
	}
	function actualizar_inventario( $pj_id, &$items_db=array() ){
		global $timenow,$database,$items_array;
		$times		= array();
		$itemsa		= array();
		$items_res	= array();
		$borraitems = '';
		$o 			= 0;
		//$itmp 		= array();
		cargar_items();
		$items_sql	= $database->query('SELECT `mochila`.*, `pjs`.`muertes` AS `muertes` FROM `mochila`,`pjs` WHERE `mochila`.`UID`=\''.$pj_id.'\' AND `pjs`.`ID`=`mochila`.`UID` LIMIT 1;');
		if(mysql_num_rows($items_sql)===0) return false;
		$items_db	= mysql_fetch_assoc($items_sql);
		
		/*$items_sql	= $database->query('SELECT * FROM items');
		while($itmp = mysql_fetch_assoc($items_sql)) $iarray[$itmp['ID']]=$itmp;
		mysql_free_result($items_sql);*/
		//cargar_items();
		
		$resta 		= ($items_db['muertes']-$items_db['last_death']);
		//if( $resta>0 ){
			for( $o = 1; $o <= 14; ++$o ){
				$times[$o]	= (int)$items_db['t'.$o];
				$tact		= &$times[$o];
				$itemsa[$o]	= $items_db['o'.$o];
				if(get_calidad($items_db['f'.$o])<4){
					if( $itemsa[$o]!=='0' ){
						$tact	= ($tact-$resta);
				
						if( $tact>0 ){
							if($resta>0) {
								++$ci;
								if($ci>1){$borraitems.=',';}
								$borraitems.='`mochila`.`o'.$o.'`=\''.$itemsa[$o].'\',`mochila`.`t'.$o.'`=\''.$tact.'\' ';
							}
							$items_res[]=$items_array[$itemsa[$o]]['grh'].' '.dechex($items_db['f'.$o]);
						} else {
							++$ci;
							if($ci>1){$borraitems.=',';}
							$borraitems.='`mochila`.`o'.$o.'`=\'0\',`mochila`.`t'.$o.'`=\'0\' ';
						}
					}
				}
			}
			if( $ci>1 ){
				$borraitems.=',';
			}
			if( $borraitems!=='' ){
				$database->uquery('UPDATE `mochila`,`pjs` SET '.$borraitems.'mochila.last_death=pjs.muertes WHERE `mochila`.`UID`=\''.$pj_id.'\' AND `pjs`.`ID`=\''.$pj_id.'\'');
			}
			$items			= implode(':',$items_res);
			$tiene_items	= sizeOf($items_res);
			$database->uquery("UPDATE pjs,users SET pjs.items = '".$items."' , pjs.items_act = '$timenow' , pjs.TieneItems = '$tiene_items', users.last_mod=$timenow WHERE pjs.ID='$pj_id' AND users.ID=pjs.IDCuenta");

		//}
		//UPDATE users SET `puntos`=`frags`*150 WHERE `frags`<`puntos`/150
		return $items;
	}

	function completar_tarea(&$pjs_ids,&$pjs_times,$uid,$last_mod=true){
		global $timenow,$database,$skills;
		$i		 	= 0;
		$pjs_num 	= sizeOf($pjs_times);
		$next_check = 0;
		if( $pjs_num > 0 ){
			for( $i=0; $i<$pjs_num; ++$i ){
				if( $pjs_times[$i] < $timenow && $pjs_times[$i]!='0' ){
					$infoPj = $database->getPJInfo($pjs_ids[$i]);
					if( $infoPj['cuando_termina']!=='0' ){
						if( $infoPj['cuando_termina'] < $timenow ){
							$cual	= (int)$infoPj['cualskill'];
							$skill	= $skills['nombres_db'][$cual];
							$database->uquery("UPDATE pjs SET `$skill`=`$skill`+1, cuando_termina='0' , cualskill='0' , pagado='0', `order`=`order`+(`$skill`*1000) WHERE ID = '".$pjs_ids[$i]."'");
							$pjs_times[$i]=0;
						} else {
							if( $next_check===0 ){
								$next_check=$infoPj['cuando_termina'];
							}
							if( $infoPj['cuando_termina']<$next_check ){
								$next_check=$infoPj['cuando_termina'];
							}					
						}
					}
				}
			}
			$database->uquery("UPDATE users SET next_check = '$next_check' , last_check=$timenow".($last_mod===true?" , last_mod=$timenow":'')." , pjs_times = '".implode('-',$pjs_times)."' WHERE ID = '$uid' LIMIT 1");
		}
	}
}

function update_ranking(&$udata){
	global $database;
	$date	=	date('yzH');
	if ($udata['last_r'] < $date) {
		$rank = mysql_fetch_array($database->query("SELECT COUNT(ID) FROM users WHERE honor>={$udata['honor']}"));
		$udata['rank'] = intval($rank[0]);
		$database->uquery('UPDATE users SET rank_old=\''.$udata['rank'].'\',rank=\''.$udata['rank'].'\',`last_r` = \''.$date.'\' WHERE `ID` = \''.$udata['ID'].'\'');
	}
}

function calcular_tiempo($skill,$nivel){
	global $skills;
	// (tiempo_base * nivel ^ 2)*(tiempo_base * nivel / factor_tiempo) / 86400
	// devuelve segundos
	$tmp 	= ($skills['tiempo'][$skill] * $nivel);
	$va	 	= intval($tmp * $tmp * ($tmp / $skills['ftiempo'][$skill]) + 60);
	return 	$va;
}

function calcular_precio($skill,$nivel){
	global $skills;
	// (precio_base * nivel ^ 2)*(precio_base * nivel / factor_precio) + 800
	$tmp	= ($skills['precio'][$skill] * $nivel);
	$va		= intval($tmp * $tmp * ($tmp / $skills['fprecio'][$skill])) + 800;
	return 	$va;
}

function strTime($s) {
	$d = intval($s/86400);
	$s -= $d*86400;

	$h = intval($s/3600);
	$s -= $h*3600;

	$m = intval($s/60);
	$s -= $m*60;
	$str='';
	if ($d) $str = $d . 'd ';
	if ($h) $str .= $h . 'h ';
	if ($m) $str .= $m . 'm ';
	if ($s) $str .= $s . 's';
	return $str;
}

function get_tipografia_pj($pj_armcao){
	if( $pj_armcao>=1 && $pj_armcao<=10 ) {//army
		return 25;
	} elseif( $pj_armcao>10 && $pj_armcao<=20 ){//caos
		return 5;
	} else {//neutro
		return 4;
	}
}

function get_rango_pj($pj_armcao){
	global $rangos;
	if( $pj_armcao>=1 && $pj_armcao<=10 ) {//army
		return $rangos[1][$pj_armcao];
	} elseif( $pj_armcao>=10 && $pj_armcao<=20 ){//caos
		return $rangos[2][($pj_armcao-10)];
	} else {//neutro
		return '';
	}
}

	function tiempoban($delta) {
		if ($delta == -1) {
			return 'TOLERANCIA CERO';
		}if ($delta == -2) {
			return 'Anulado.';
		} elseif ($delta == 600) {
			return '10 minutos';
		} elseif ($delta == 1800) {
			return '30 minutos';
		} elseif ($delta == 3600) {
			return '1 hora';
		} elseif ($delta == 86400) {
			return '1 dia';
		} elseif ($delta == 604800) {
			return '7 dias';
		} elseif ($delta == 1209200) {
			return '15 dias';
		} elseif ($delta == 86400000) {
			return 'permanente';
		} else {
			return $delta.' segundos';
		}
	}

$gamelogic =& new game_logic;
/* FIN DE ARCHIVO */