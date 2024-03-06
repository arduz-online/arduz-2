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
 *		@desc: 			SERVER FILE, mantiene los servidores y listas.
 */
	require 'class.php';
	
	$server_id 		= intval($_REQUEST['svid']);
	$server_id_str	= (string)$server_id;

	if( !empty($_POST['datos']) && $_REQUEST['a']==='crear' )
	{
		$database->uquery("DELETE FROM `servers` WHERE `ultima` < '".($timenow-900)."'");
		$temp1=mzdecode($_REQUEST['datos']);
		$serverdata=explode('~',$temp1);
		$query=$database->query("SELECT `ID`,`IP`,`PORT`,`keysec` FROM `servers` WHERE `IP` = '$IP' AND `PORT`='$serverdata[3]' AND `pcid`='$pc_acc_id' LIMIT 1");
		if( mysql_num_rows($query)===0 ){
			$hostname = gethostbyaddr($_SERVER['REMOTE_ADDR']);
			$query = $database->query("INSERT INTO `servers` SET `keysec`='$codigo',`ultima`='".$timenow."',`inicio`='".time()."', `IP` = '$IP',`Nombre`='$serverdata[0]',`Mapa`='$serverdata[1]',`Players`='$serverdata[2]',`PORT`='$serverdata[3]',`hamachi`='$serverdata[4]', `HOST`='$hostname', `maxusers`='$serverdata[6]', `passwd`='$serverdata[7]', `pcid`='$pc_acc_id', `RANK`='".(0-intval($pc_acc['privs']))."'");
			$server_id = (string)mysql_insert_id();
			$database->query("UPDATE sessions SET numservers=numservers+1 WHERE ID='$pc_acc_id'");
			echo '$'.$codigo.DELIMITER.$server_id.DELIMITER.intval($pc_acc['privs']);
		} else {
			//echo '%'.mysql_result($query,0,'ID').DELIMITER.mysql_result($query,0,'keysec');//YATA
			$codigo = mysql_result($query,0,'keysec');
			$svid 	= mysql_result($query,0,'ID');
			echo '$'.$codigo.DELIMITER.$svid.DELIMITER.intval($pc_acc['privs']);
			$database->query("UPDATE `servers` SET `keysec`='$codigo',`ultima`='".$timenow."',`inicio`='".$timenow."',`Nombre`='$serverdata[0]',`Mapa`='$serverdata[1]',`Players`='$serverdata[2]',`hamachi`='$serverdata[4]', `HOST`='$hostname', `maxusers`='$serverdata[6]', `passwd`='$serverdata[7]' WHERE `ID` = '$svid'");
		}
	}
	elseif( $_REQUEST['a']==='ping' )
	{
		
		if( $server_id > 0 ){
			$query=$database->query('SELECT * FROM `servers` WHERE ID = \''.$server_id_str.'\' LIMIT 1');
			if( mysql_num_rows($query)>0 ){
				$svdata		= mysql_fetch_array($query);
				if(!empty($_POST['datos'])){
					$temp1		= mzdecode($_POST['datos']);
					$serverdata	= explode('~',$temp1);
					foreach( $serverdata as $datos ){
						$cato = explode('=',$datos);
						if( $cato[0]=='N' ) {
							$sqladd .= " ,`Nombre`='$cato[1]'";
						} elseif( $cato[0]=='M' ) {
							$sqladd .= " ,`Mapa`='$cato[1]'";
						} elseif( $cato[0]=='U' ) {
							$cato[1]=intval($cato[1]);
							$sqladd .= " ,`players`='$cato[1]'";
							if( $cato[1]>0 ){
								$unica	= date('ymd');
								$total	= mysql_result($database->query('SELECT SUM(`players`) AS `total` FROM `servers`'),0,'total')+$cato[1];
								$rtotal	= mysql_fetch_assoc($database->query("SELECT * FROM `est-online` WHERE `unica` = '$unica' LIMIT 1"));
								if( $rtotal['num']<$total ){
									$database->uquery("INSERT INTO `est-online` (`unica`,`num`,`order`) VALUES ('$unica','$total','$timenow') ON DUPLICATE KEY UPDATE `num` = '$total'");
								}
							}
						} elseif ($cato[0]=='P') {
							$sqladd .= " ,`passwd`='$cato[1]'";
						}
					}
				}
				$query=$database->query("UPDATE `servers` SET `keysec`='$codigo',`ultima`='$timenow' $sqladd WHERE `ID`='$server_id_str'");
				if(intval($pc_acc['privs'])>0){
					$database->query("UPDATE `servers` SET `ultima`='$timenow' WHERE `IP` = '$IP'");
				}
				
				echo '&'.$codigo.DELIMITER;
			} else {
				echo ')';
			}
		} else {
			echo ')';
		}
		$database->uquery('DELETE FROM `servers` WHERE `ultima` < \''.($timenow-900).'\' AND `ID` != \''.$server_id_str.'\'');
	}
	elseif( $_REQUEST['a']==='borra' && $server_id > 0 )
	{
		$database->uquery("DELETE FROM `servers` WHERE `ultima` < '".($timenow-900)."'");
		$database->uquery("DELETE FROM `servers` WHERE `IP` = '$IP' AND `pcid` = '$pc_acc_id' AND `ID` = '$server_id_str'");
		echo '(';
	}
	elseif ( $_REQUEST['a']==='list' )
	{
		$agrega	= '';
		$total	= 0;
		$pcid	= intval($_REQUEST['session']);
		$query	= $database->query('SELECT * FROM `servers` ORDER BY `servers`.`RANK`, `servers`.`players` DESC');
		$database->uquery("DELETE FROM `servers` WHERE `ultima` < '".($timenow-900)."'");
		$total = mysql_num_rows($query);
		//$output->WriteLong($total);
		if( $total>0 ){
			while( $carlos=mysql_fetch_array($query) ){
				if( strlen($carlos['passwd'])>0 ){$agrega='y.si..';}
				echo '@|'.$carlos['IP'].'ç'.$carlos['PORT'].'ç'.$carlos['Nombre'].'ç'.$carlos['Mapa'].'ç'.$carlos['players'].'/'.$carlos['maxusers'].'ç'.$agrega;
				if( $server_id!==0 ){
					if (strlen($carlos['hamachi'])>7){
						echo '@|'.$carlos['hamachi'].'ç'.$carlos['PORT'].'ç'.$carlos['Nombre'].' - Via Hamachiç'.$carlos['Mapa'].' - Via Hamachiç'.$carlos['players'].'/'.$carlos['maxusers'].'ç'.$agrega;
					}
				}
				$agrega='';
			}
			//echo '@|';
		} else {
			//echo '@|localhostç7666çNo hay servidores online.çArduz Onlineç2009ç@|';
		}
	}

?>