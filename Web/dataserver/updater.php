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
 *		@start-date: 	02-07-09
 *		@desc: 			Updater.
 */
define('IGNORE_VER',true);
require 'class.php';
$last_act = intval($_REQUEST['svid']);
$v = $last_act;
$updater_version = '1.0';


/*$key = array_keys($aHash);
$size = sizeOf($key);

$i=0;

for ($i=0; $i<$size; $i++){
	$aHash[$key[$i]] .= "a";
}*/

$nl		= "\r\n";
$q 		= 'SELECT * FROM `updates` WHERE `num` > '.$last_act.' OR version > 0 ORDER BY `num` ASC';
$r 		= $database->query($q);
$ra 	= 'SELECT num FROM `updates` ORDER BY `num` DESC LIMIT 1';
$raa 	= mysql_fetch_assoc($database->query($ra));
$raa 	= intval($raa['num']);
$ra 	= 'SELECT num FROM `updates` WHERE `num` > '.$last_act.' LIMIT 1';
$rax 	= mysql_fetch_assoc($database->query($ra));
$rax 	= intval($rax['num']);
$num 	= mysql_num_rows($r);
if( $_REQUEST['a']==='list' ){
	$i 		= 0;
	if( $num > 0 ){
		echo '[OK]'.$nl.
		'[INIT]'.$nl.
		'NumPatches='.$num.$nl;
		
		while( $f = mysql_fetch_assoc($r) ){
			$i++;
			echo '[Patch'.$i.']'.$nl;
			echo 'Name='.$f['filename'].$nl;
			echo 'DownloadName='.$f['url'].$nl;
			echo 'Path='.$f['path'].$nl;
			echo 'Version='.$f['version'].$nl;
			echo 'MD5='.$f['MD5'].$nl;
			echo 'Num='.$f['num'].$nl.$nl;
			$v=$f['num'];
		}
		echo '[ARDUZ]'.$nl.'V='.($v+0).$nl.$nl;
	} else {
		echo '[NOMAS]'.$nl;//.mysql_error().$nl.$q;var_dump($_REQUEST);
		echo '[ARDUZ]'.$nl.'V='.($v+0).$nl.$nl;
	}
} elseif( $_REQUEST['a']==='lista' ){
	$i 		= 0;
	if( $num > 0 ){
		echo '$ArduzScript$'.$nl.
		'title: Arduz Update'.$nl.
		'files:'.$num.$nl;
		
		while( $f = mysql_fetch_assoc($r) ){
			$i++;
			$buff .=
			'file{'.$nl.
				'filename='.$f['filename'].$nl.
				'remote='.$f['url'].$nl.
				'local='.$f['path'].$nl.
				'md5='.$f['MD5'].$nl.
				'num='.$f['num'].$nl.
			'}'.$nl;
			$v=$f['num'];
		}
		echo 'version:'.($v+0).$nl.$nl.$buff;
	} else {
		echo '$ArduzScript$'.$nl;//.mysql_error().$nl.$q;var_dump($_REQUEST);
		
		echo 'files:0'.$nl.'versiona:'.($raa+0).$nl.$nl;
	}
} else {
	if( $rax > 0 ){echo '.';}//.$raa.'-'.$last_act;}
}
?>