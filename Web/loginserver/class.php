<?php
/*                 ____________________________________________
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
 *		
 */
	define('DELIMITER','~ç~');
	
	$pc_data 		= explode('/',$_SERVER['HTTP_USER_AGENT']);
	$versiones 		= '0.2.05';
	$apagar_arduz 	= false;
	$pcid 			= base_convert($_REQUEST['session'],16,10);
	$timenow 		= time();
	$codigo 		= '';
	$IP 			= getRealIP();
	$IP_Long		= ip2long($IP);
	$pc_acc_id 		= 0;
	
	if( $pcid==0 ){ exit; };
	
	if( $pc_data[0]!=='ADZSV' ){
		header('Location: ./../index.php');
		exit;
	}
	if(IGNORE_VER!==true){
		if( $pc_data[1]!==$versiones ){
			echo '"'.$pc_data[1].'@'.$versiones;
			exit;
		}
	}
	/*if( $pc_data[3]==='1' ){
		$inputData  =& new clsByteQueue(mzdecode($GLOBALS['HTTP_RAW_POST_DATA']));
		$es_binario = true;
	} else {
		$es_binario = false;
	}*/
	
	if( strlen($pc_data[2])!==12 ){
		exit;
	}

	if( $apagar_arduz===true ){
		echo '#'.$apagar_arduz_razon;
		exit;
	}
	
	require '../_inc/cfg.php';
	require '../_inc/database.php';
	//require 'ByteQueue.php';
	
	$account=$database->query('SELECT * FROM `sessions` WHERE `PCID` = \''.$pcid.'\' LIMIT 1');

	if( mysql_num_rows($account)===0 ){
		$pc_data[2] = mysql_real_escape_string($pc_data[2]);
		$database->uquery('INSERT INTO `sessions` (`ID` ,`mac` ,`code` ,`server` ,`renew` ,`numservers` ,`numcheats` ,`PCID`, `BAN`, `IP`)
			VALUES (NULL , \''.$pc_data[2].'\', \'0\', \'0\', \'0\', \'0\', \'0\', \''.$pcid.'\', \'0\', \''.$IP.'\');');
		$pc_acc_id = mysql_insert_id();
	} else {
		$pc_acc = mysql_fetch_assoc($account);
		if( $pc_acc['BAN']>=126 ){
			echo '!';
			exit;
		}
		if( $pc_acc['IP']!=$IP ){
			$database->uquery('UPDATE `sessions` SET `IP`=\''.$IP.'\' WHERE `ID`=\''.$pc_acc['ID'].'\' LIMIT 1;');
		}
		$pc_acc_id = intval($pc_acc['ID']);
	}
	
	header('Content-Type: text');
	header('X-Powered-By: Arduz_DSv'.$versiones);
	
	
	
/*	for ($i = 1; $i <= 6; ++$i) {
	   	$codigo= $codigo . chr(rand(65,90));
	}*/
	$codigo_dec = mt_rand();
	$codigo		= dechex($codigo_dec);
	function getRealIP(){
	   
	   if( $_SERVER['HTTP_X_FORWARDED_FOR'] != '' )
	   {
	      $client_ip =
	         ( !empty($_SERVER['REMOTE_ADDR']) ) ?
	            $_SERVER['REMOTE_ADDR']
	            :
	            ( ( !empty($_ENV['REMOTE_ADDR']) ) ?
	               $_ENV['REMOTE_ADDR']
	               :
	               "unknown" );
	   
	      $entries = split('[, ]', $_SERVER['HTTP_X_FORWARDED_FOR']);

	      reset($entries);
	      while (list(, $entry) = each($entries))
	      {
	         $entry = trim($entry);
	         if ( preg_match("/^([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)/", $entry, $ip_list) )
	         {
	            // http://www.faqs.org/rfcs/rfc1918.html
	            $private_ip = array(
	                  '/^0\./',
	                  '/^127\.0\.0\.1/',
	                  '/^192\.168\..*/',
	                  '/^172\.((1[6-9])|(2[0-9])|(3[0-1]))\..*/',
	                  '/^10\..*/');
	   
	            $found_ip = preg_replace($private_ip, $client_ip, $ip_list[1]);
	   
	            if ($client_ip != $found_ip)
	            {
	               $client_ip = $found_ip;
	               break;
	            }
	         }
	      }
	   }
	   else
	   {
	      $client_ip =
	         ( !empty($_SERVER['REMOTE_ADDR']) ) ?
	            $_SERVER['REMOTE_ADDR']
	            :
	            ( ( !empty($_ENV['REMOTE_ADDR']) ) ?
	               $_ENV['REMOTE_ADDR']
	               :
	               "unknown" );
	   }
	   
	   return $client_ip;
	}

	function mzdecode($str,$code = 'DELIMITER'){
		return mysql_real_escape_string(base64_decode(str_replace($code,'',$str)));
	}

	function exp_to_dec($float_stra){
		$float_str = (string)((float)($float_stra));
		if( ($pos = strpos(strtolower($float_str), 'e')) !== false ){
			$exp = substr($float_str, $pos+1);
			$num = substr($float_str, 0, $pos);
		   
			// strip off num sign, if there is one, and leave it off if its + (not required)
			if((($num_sign = $num[0]) === '+') || ($num_sign === '-')) $num = substr($num, 1);
			else $num_sign = '';
			if($num_sign === '+') $num_sign = '';
		   
			// strip off exponential sign ('+' or '-' as in 'E+6') if there is one, otherwise throw error, e.g. E+6 => '+'
			if((($exp_sign = $exp[0]) === '+') || ($exp_sign === '-')) $exp = substr($exp, 1);
			else trigger_error("Could not convert exponential notation to decimal notation: invalid float string '$float_str'", E_USER_ERROR);
		   
			// get the number of decimal places to the right of the decimal point (or 0 if there is no dec point), e.g., 1.6 => 1
			$right_dec_places = (($dec_pos = strpos($num, '.')) === false) ? 0 : strlen(substr($num, $dec_pos+1));
			// get the number of decimal places to the left of the decimal point (or the length of the entire num if there is no dec point), e.g. 1.6 => 1
			$left_dec_places = ($dec_pos === false) ? strlen($num) : strlen(substr($num, 0, $dec_pos));
		   
			// work out number of zeros from exp, exp sign and dec places, e.g. exp 6, exp sign +, dec places 1 => num zeros 5
			if($exp_sign === '+') $num_zeros = $exp - $right_dec_places;
			else $num_zeros = $exp - $left_dec_places;
		   
			// build a string with $num_zeros zeros, e.g. '0' 5 times => '00000'
			$zeros = str_pad('', $num_zeros, '0');
		   
			// strip decimal from num, e.g. 1.6 => 16
			if($dec_pos !== false) $num = str_replace('.', '', $num);
		   
			// if positive exponent, return like 1600000
			if($exp_sign === '+') return $num_sign.$num.$zeros;
			// if negative exponent, return like 0.0000016
			else return $num_sign.'0.'.$zeros.$num;
		}
		else return $float_stra;
	}
	
	
	
// Server
//var_dump($_REQUEST);
?>