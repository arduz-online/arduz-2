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
 *		@start-date: 	17-5-09
 *		@desc: 			Logs.
 */
	require 'class.php';
	if( $_REQUEST['a']==='LOG' && !empty($_REQUEST['svid']) ){
		if(!empty($_POST['datos'])){
			list($svid,$svkey)=explode('_',$_REQUEST['svid']);
			$svid=intval($svid);
			$query=$database->query('SELECT keysec FROM servers WHERE ID = \''.$svid.'\' LIMIT 1');
			if( mysql_num_rows($query)>0 ){
				$keysec=mysql_fetch_assoc($query);
				if( $keysec['keysec'] === $svkey ){
					$nicka=explode('~',mysql_real_escape_string(mzdecode($_REQUEST['datos'])));
					$texta=$nicka[1];
					$id=base_convert($nicka[2],16,10);
					$nick=$nicka[0];
					$database->uquery("INSERT DELAYED INTO `cheat-log` (`ID` ,`nick` ,`pcid` ,`txt`) VALUES (NULL, '$nick', '$id', '$texta');");
					if( $id!='0' ){
						$database->uquery('UPDATE `sessions` SET `numcheats`=`numcheats`+1 WHERE `PCID`=\''.$id.'\' LIMIT 1;');
					}
					$query=$database->uquery("UPDATE `servers` SET `keysec`='$codigo',`ultima`='$timenow' WHERE `ID` = $svid");
					echo '&'.$codigo.DELIMITER.$id;
				} else {
					echo "'";
				}
			} else {
				echo ')';
			}
		}
	}
	elseif( $_REQUEST['a']==='error' ){
		if(!empty($_POST['error'])){
			$error=mysql_real_escape_string($_POST['error']);
			$database->uquery('INSERT DELAYED INTO `errores` (`ID`, `date`, `acc`, `text`) VALUES (NULL, \''.time().'\', \''.$pc_acc_id.'\', \''.$error.'\');'); 
			echo 'LOG@OK@ERR';
		}
	}
?>