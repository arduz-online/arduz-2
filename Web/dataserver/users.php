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
 *		@desc: 			SERVER FILE, comunica el servidor del juego con la web.
 */
	require 'class.php';
	require '../_inc/game.logic.php';
	
class Personajes{
	var $uid 			= 0;
	var $udata 			= array();
	
	var $pjs 			= array();
	var $pjs_times 		= array();
	var $pjs_nicks 		= array();
	var $pjs_armcao 	= array();
	var $pjs_clanes 	= array();
	
	var $numpjs 		= 0;
	var $active 		= false;
	var $GM;
	var $BAN;
	
	function Personajes()
	{
		
	}
	
	function Init($user,$pass){
		global $database;
		$result = $database->getCuentaForGame($user,$pass);
		if( !is_array($result) ){
			$this->active=false;
			return $result;
		} else {
			$this->udata 		= $result;
			$this->uid 			= $this->udata['ID'];
			$this->pjs 	  		= explode('-',$this->udata['pjs']);
			$this->numpjs 	  	= count($this->pjs);
			
			$this->GM 			= $this->udata['GM'];
			$this->BAN 			= $this->udata['BAN'];
			
			$this->pjs_times  	= explode('-',$this->udata['pjs_times']);
			$this->pjs_nicks  	= explode('-',$this->udata['pjs_nicks']);
			$this->pjs_armcao 	= explode('-',$this->udata['pjs_armcao']);
			$this->pjs_clanes 	= explode('-',$this->udata['pjs_clanes']);
			 
			$this->active=true;
			return true;
		}
	}
	public function get_pj($id){	
		global $database;
		if( in_array($id,$this->pjs) ){
			return $database->getPJInfo($id);
		} else {
			return NULL;
		}
	}
	public function get_pjs(){	//USABLES
		global $database;
		if( $this->numpjs>0 ){
			$res	=	$database->query('SELECT `ID`,`nick`,`clan`,`vidaup`,`raza`,`clase`,`cabeza`,`genero`,`armcao`,`items`,`cuando_termina` FROM `pjs` WHERE IDCuenta='.$this->uid.' LIMIT 10');
			
			if( mysql_num_rows($res)>0 ){
				return $res;
			} else {
				return NULL;
			}
		} else {
			return NULL;
		}
	}
	public function add_rankdata($pj,$frags,$muertes,$puntos,$honor,$PCID){
		global $database,$server_id_str;
		$puntos		= intval($puntos);
		$frags		= intval($frags);
		$muertes	= intval($muertes);
		$honor		= intval($honor);
		if( detect_cheat($puntos,$frags,$muertes)===true ){
			if($pj != 0){
				$info_pj=$this->get_pj($pj);
				if( $info_pj===NULL ){
					return '5'; //No puede usar este pj
				}
				if( $muertes>0 ){
					$database->uquery('UPDATE `pjs` SET `pjs`.`muertes`=`pjs`.`muertes`+\''.$muertes.'\',`pjs`.`order`=`pjs`.`order`+\''.intval(($puntos/(abs($frags*10-($muertes-1)*10)+1))*25).'\' WHERE `pjs`.`ID`=\''.$info_pj['ID'].'\';');
				}
			} else {
				$puntos	= intval($puntos/2);
				$honor 	= 0;//intval($honor/2);
			}
			
			if( $this->udata['ultimosv']!==$server_id_str || $this->udata['PCIDb'] != $PCID){
				return '7'; //Logueado en otro server
			}

			if( $info_pj['clan']>0 ){
				$database->uquery('UPDATE `clanes` SET `matados`=`matados` + \''.$frags.'\',`muertos` = `muertos` + \''.$muertes.'\',`puntos` = `puntos` + \''.$puntos.'\',`honor`=`honor`'.($honor<0?"-'".abs($honor)."'":"+'".$honor."'").' WHERE `clanes`.`ID`=\''.$info_pj['clan'].'\';');
			}		

			$sql = '`frags`=`frags`+\''.$frags.'\',`muertes`=`muertes`+\''.$muertes.'\',`puntos`=`puntos`+\''.$puntos.'\',`honor`=`honor`'.($honor<0?"-'".abs($honor)."'":"+'".$honor."'").',`ultimologin`=\''.time().'\'';
			$database->uquery('UPDATE `users` SET '.$sql.' WHERE `ID`=\''.$this->uid.'\';');
			//if( $this->udata['last_cache']<$this->udata['last_mod']){
			//	return '9';//PEDIR ACTUALIZACION
			//}else{
				return '1';//tutu bene
			//}
		} else {
			return '8';
		}
	}
}

	function detect_cheat($puntos,$frags,$muertes){
		global $Personajes,$pcid,$database;
		if( $pcid!=0 ){
			$sigue=true;
			if( $puntos > (($frags+3)*150) ){
				$sigue=false;
			}
			if( $puntos>24725 ){
				$sigue=false;
			}
			if( $puntos>44725 ){
				$database->uquery('UPDATE `sessions` SET `numcheats`=`numcheats`+1 WHERE `PCID`=\''.$Personajes->udata['PCID'].'\' LIMIT 1;');
			}
			if( $frags>20 && $muertes<4 ){
				$sigue=false;
			}
			if($sigue===false){
				$database->uquery("INSERT DELAYED INTO `cheat-log` (`ID` ,`nick` ,`pcid` ,`txt`) VALUES (NULL, '".$Personajes->udata['username']."', '".$Personajes->udata['PCID']."', 'Anticheat: P:$puntos F:$frags M:$muertes');");
			}
		}
		return (bool)$sigue;
	}

	function user_upd(){
		global $pc_acc_id,$server_id,$server_id_str,$timenow,$codigo,$database,$Personajes;
		$temp1		= mzdecode($_POST['datos']);
		$temp1 		= explode('/*/',$temp1);
		$serverdata = explode('~',$temp1[0]);
		$query		= $database->query("SELECT keysec FROM `servers` WHERE `ID` = '$server_id_str' LIMIT 1");
			if( mysql_num_rows($query)>0 ){
				$res = mysql_fetch_array($query);
				if( $serverdata[0]===$res['keysec'] ){
					$query 		= $database->uquery("UPDATE `servers` SET `keysec`='$codigo',`ultima`='$timenow' WHERE `ID`='$server_id_str'");
					$arraypen 	= explode('@',mzdecode($temp1[1],$serverdata[0]));
					$size 		= sizeOf($arraypen);
					unset($temp1);
					for( $i=0; $i<$size; ++$i ){
						list($UIDinSV, $usuario, $password, $pj, $puntos, $frags, $muertes, $honor, $user_pcid) = explode('~', $arraypen[$i]);
						if( $UIDinSV > 0 ){
							$user_pcid = base_convert($user_pcid,16,10);
							if( !empty($usuario) && !empty($password) ){
								$result=$Personajes->Init($usuario,$password);
								if($Personajes->udata['PJBAN']>time() && $Personajes->active==true){
									$add = '7';
								} else {
									if( $result===true ){
										$add = $Personajes->add_rankdata($pj,$frags,$muertes,$puntos,$honor,$user_pcid);
									} elseif( $result===1 ) {
										//usernot
										$add = '3';
									} elseif( $result===2 ) {
										//passnot
										$add = '2';
									} else {
										$add = $result;
									}
								}
							} else {
								$add = '0';
							}
							$str.=$UIDinSV.'-'.$add.'-'.mysql_error().DELIMITER;
						}
					}
					echo '*'.$codigo.DELIMITER.$size.DELIMITER.$str;
					unset($clan);
					unset($res);
					unset($add);
					unset($arraypen);
				} else {
					echo "'".$serverdata[0].DELIMITER.$res['keysec'];
				}
			} else {
				echo ')';
			}
	}

	function user_login(){
		global $pc_acc_id,$server_id,$server_id_str,$timenow,$codigo,$database,$Personajes,$gamelogic;
		$temp1			= mzdecode($_POST['datos']);
		$temp1 			= explode('/*/',$temp1);
		$serverdata 	= explode('~',$temp1[0]);
		$query			= $database->query("SELECT keysec FROM `servers` WHERE `ID` = '$server_id_str'");
		$clanes_car 	= false;
		$clanes_array 	= array( 0=>'' );
		$completar		= false;
		$num 			= 0;
		
		if( mysql_num_rows($query)>0 ){
			$res = mysql_fetch_assoc($query);
			if( $serverdata[0]===$res['keysec'] ){
				$arraypen = mzdecode($temp1[1],$serverdata[0]);
				list($UIDinSV, $usuario, $password, $user_pcid) = explode('~', $arraypen);
				
				unset($temp1);
				unset($arraypen);
				unset($serverdata);
				
				if( !empty($usuario) and !empty($password) ){
					$result=$Personajes->Init($usuario,$password);
					if( $result===true && $Personajes->udata['PJBAN']<time() && $Personajes->active==true){
						$info_pj = $Personajes->get_pjs($pj);
						$user_pcid = base_convert($user_pcid,16,10);
						$database->uquery("UPDATE users,sessions,servers SET users.ultimosv = '$server_id_str', users.ultimologin = '$timenow', users.PCID = sessions.ID, servers.players=servers.players+1 WHERE users.ID = '$Personajes->uid' AND sessions.PCID = '$user_pcid' AND servers.ID='$server_id_str'");
						
						/* USERS ONLINE */
						$unica	= date('ymd');
						$total	= mysql_result($database->query('SELECT SUM(`players`) AS `total` FROM `servers`'),0,'total')+1;
						$rtotal	= mysql_fetch_assoc($database->query("SELECT * FROM `est-online` WHERE `unica` = '$unica' LIMIT 1"));
						if( $rtotal['num']<$total ){
							$database->uquery("INSERT INTO `est-online` (`unica`,`num`,`order`) VALUES ('$unica','$total','$timenow') ON DUPLICATE KEY UPDATE `num` = '$total'");
						}
						/*/END USERS ONLINE */
						
						$add = '1' . DELIMITER . $Personajes->GM . 'r' . $Personajes->udata['rank'] . 'r' . $Personajes->udata['honor'];
						
						if( ($Personajes->udata['last_cache']<$Personajes->udata['last_mod']) || ($Personajes->udata['last_cache']=='0')){
							$info_pj = $Personajes->get_pjs($pj);
							if( $info_pj!==NULL ){
								//$cache = mysql_num_rows($info_pj).DELIMITER;
								while( $personaje = mysql_fetch_assoc($info_pj) ){
									if( $personaje['cuando_termina']<$timenow ){
									
										if( $personaje['cuando_termina']!=='0' ){
											$completar		= true;
										}
										
										if( $personaje['clan']>0 && $clanes_car===false ){
											$clanes_array	= $database->getClanArray();
											$clanes_car		= true;
										}
										
										$personaje['clan']	= $clanes_array[$personaje['clan']];
										unset($personaje['cuando_termina']);
										$cache.= 'PJ|'.implode('|',$personaje).DELIMITER;
										$num++;
									}
								}
								$cache=$num.DELIMITER.$cache;
								if( $completar === true ){
									$gamelogic->completar_tarea($Personajes->pjs,$Personajes->pjs_times,$Personajes->uid,false);
								}
								
								$database->uquery("UPDATE users SET last_cache = '$timenow' WHERE ID='$Personajes->uid'");
								$database->CachePjs($Personajes->uid,$cache);
								$add.=DELIMITER.$cache;
								unset($cache);
							} else {
								$add = '4' . DELIMITER . $Personajes->GM . 'r' . $Personajes->udata['rank'] . 'r' . $Personajes->udata['honor']; //NO TIENE PJS
							}
						} else {
							$add .= DELIMITER.$database->CachedPjs($Personajes->uid);//manda pjs cahceaqdos
						}
					} elseif( $result===1 ) {
						//usernot
						$add = '3';
					} elseif( $result===2 ) {
						//passnot
						$add = '2';
					}
				} else {
					$add = '0';
				}
				echo '+'.$UIDinSV.DELIMITER.$add;
				unset($add);
			} else {
				echo '\''.$serverdata[0].DELIMITER.$res['keysec'];
			}
		}
	}
	function char_select(){
		
	}
//<! FIN DE LAS FUNCIONES !>

	$server_id 		= intval($_REQUEST['svid']);
	$server_id_str	= (string)$server_id;
	
	if( !empty($_POST['datos']) && $server_id > 0 ){
		$Personajes = new Personajes;
		if( $_REQUEST['a']==='upd' ){
			user_upd();
		} elseif( $_REQUEST['a']==='login' ){
			user_login();
		}
	}
	
/* FIN DE ARCHIVO */