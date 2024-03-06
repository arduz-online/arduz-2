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
 *		@writer: 		Agustín Nicoás Méndez (aka Menduz)
 *		@contact: 		lord.yo.wo@gmail.com
 *		@start-date: 	16-5-09
 *		@desc: 			SERVER FILE, Envia datos sobre el balance a los servidores del juego.
 */
 
 
 
 /* UPDATE clases,
balance_int SET `clases`.`i1` = `balance_int`.`use_u` ,
`clases`.`i2` = `balance_int`.`use_dclick` ,
`clases`.`i3` = `balance_int`.`cast_attack` ,
`clases`.`i4` = `balance_int`.`cast_spell` ,
`clases`.`i5` = `balance_int`.`arrows` ,
`clases`.`i6` = `balance_int`.`attack` WHERE `clases`.`ID` = `balance_int`.`clase` */


/*

 UPDATE clases,
balance_mod SET `clases`.`m0` = `balance_mod`.`evasion` ,
`clases`.`m1` = `balance_mod`.`ataquearmas` ,
`clases`.`m2` = `balance_mod`.`ataqueproyectiles` ,
`clases`.`m3` = `balance_mod`.`danioarmas` ,
`clases`.`m4` = `balance_mod`.`danioproyectiles` ,
`clases`.`m5` = `balance_mod`.`daniowrestling` ,
`clases`.`m6` = `balance_mod`.`escudo` WHERE `clases`.`ID` = `balance_mod`.`clase` 

*/

$clases_h 	= array(
	1=>'A',//'Mago'
	2=>'B',//'Cl&eacute;rigo',
	3=>'C',//'Guerrero',
	4=>'D',//'Asesino',
	5=>'E',//'Caballero oscuro',/* NOSEUSA */
	6=>'F',//'Bardo',
	7=>'G',//'Druida',
	8=>'H',//'Nigromante',
	9=>'I',//'Paladin',
	10=>'J',//'Arquero'/*Cazador*/
	11=>'K',
	12=>'L'
);
$razas_h 	= array(
	1=>'A',//humano
	2=>'B',//elfo
	3=>'C',//drow
	4=>'D',//gnomo
	5=>'E'//enano
);
	require 'class.php';
	//require '../_inc/game.logic.php';
/*
	function get_int(){
		global $database,$gamelogic;
		$query = $database->query('SELECT * FROM `balance_int`');
		echo '/';
		while( $res = mysql_fetch_assoc($query) ){
			echo ',', implode($res,'-');
		}
	}
	function get_mod(){
		global $database,$gamelogic;
		$query = $database->query('SELECT * FROM `balance_mod`');
		echo '0';
		while( $res = mysql_fetch_assoc($query) ){
			echo ',', implode($res,'-');
		}
	}*/
	function get_balance(){
		global $database,$clases_h,$razas_h;
		if(strlen($_POST['cs'])!==32) {echo '0'; return false;};
		$md5 = mysql_fetch_assoc($database->query("SELECT balancemd5,ultimobalance,ultimobalancecreado FROM `configuracion` LIMIT 1"));
		if(($md5['balancemd5'] === $_POST['cs']) && ($md5['ultimobalance']===$md5['ultimobalancecreado'])){
			echo '2';
		} else {
			echo '1';
			/*if($md5['ultimobalance']!==$md5['ultimobalancecreado']){
				$query = $database->query('SELECT `ID` AS `ID`,`h1` AS `AA`,`h2` AS `AB`,`h3` AS `AC`,`h4` AS `AD`,`h5` AS `AE`,`h6` AS `AF`,`h7` AS `AG`,`h8` AS `AH`,`h9` AS `AI`,`h10` AS `AJ`,`h11` AS `AK`,`h12` AS `AL`,`i1` AS `FA`,`i2` AS `FB`,`i3` AS `FC`,`i4` AS `FD`,`i5` AS `FE`,`i6` AS `FF`,`m0` AS `GA`,`m1` AS `GB`,`m2` AS `GC`,`m3` AS `GD`,`m4` AS `GE`,`m5` AS `GF`,`m6` AS `GG` FROM `clases`');
				$clase = 'A';
				
				while( $res = mysql_fetch_assoc($query) ){
					$clase=$clases_h[intval($res['ID'])];
					foreach ($res as $field=>$value) {
						if($field === 'ID'){
							$clase=$clases_h[intval($value)];
						} else $buf.='|'.$clase.'F'.$field.'0'.$value;
					}
				}
				$query = $database->query('SELECT `raza` AS `raza`,`clase` AS `clase`,`max_hit` AS `DA`,`min_hit` AS `EA` ,`mana` AS `BA` ,`vida` AS `CA` FROM `razas`');
				while( $res = mysql_fetch_assoc($query) ){
					$clase 	= $clases_h[intval($res['clase'])];
					$raza 	= $razas_h[intval($res['raza'])];
					foreach ($res as $field=>$value) {
						if( $field === 'clase' ){
							$clase 	= $clases_h[intval($value)];
						}elseif( $field === 'raza' ){
							$raza 	= $razas_h[intval($value)];
						} else $buf.='|'.$clase.$raza.$field.'0'.$value;
					}
				}
				$fch = fopen('balance.ini', "w"); // Abres el archivo para escribir en él
				fwrite($fch, $buf); // Grabas
				fclose($fch); // Cierras el archivo.
				$database->uquery("UPDATE `configuracion` SET `balancemd5`='".md5($buf)."',ultimobalancecreado=ultimobalance LIMIT 1");
				echo $buf;
				unset($buf);
			//} else {*/
				readfile('../dataserver/balance.ini');
			//}
		}
	}	

//<! FIN DE LAS FUNCIONES !>
	get_balance();
	/*if( $_REQUEST['a']==='getint' ){
		//get_int();
		
	} elseif ( $_REQUEST['a']==='getmod' ){
		//get_mod();
	}*/
	
/* FIN DE ARCHIVO */
