<?php

	define('DEBUG',true);
	define('ANTIHACK',true);
	
	$num=stripos($_SERVER['SERVER_NAME'],'noicoder.com');
	if( $num!==false ){
		header('HTTP/1.1 301 Moved Permanently');
		header('Location: http://www.arduz.com.ar/');
		exit();
	}

	$num=stripos($_SERVER['REQUEST_URI'],'/ao/');
	if( $num!==false ){
		header('HTTP/1.1 301 Moved Permanently');
		if(!empty($_REQUEST['a']))$aa=$_REQUEST['a'].'.php';
		header('Location: http://www.arduz.com.ar/'.$aa);
		exit();
	}
	gentime();
	
	require('_inc/cfg.php');	
	if( $_SERVER['REQUEST_URI']==='/index.php' ){
		header('Location: '.$urls[1]);
		exit();	
	}
	
	require('_inc/database.php');
	require('_inc/session.php');
	require('_inc/layout.theme.php');
	
	function mysql_escape($cadena) {
		if(get_magic_quotes_gpc() === 1) {
			$cadena = stripslashes($cadena);
		}
		return mysql_real_escape_string($cadena);
	}
	
	function go_login_page($url=''){
		if( $url === '' ) $url = substr($_SERVER['REQUEST_URI'],1);
		header('Location: mi_cuenta.php?url='.urlencode(base64_encode($url)));
		exit;
	}
	
	function IsGooglebot(){
		if(stripos('Googlebot',$_SERVER['HTTP_USER_AGENT'])!==false){
			$ip = $_SERVER['REMOTE_ADDR'];
			$name = gethostbyaddr($ip);
			if(eregi('Googlebot',$name)){
				$hosts = gethostbynamel($name);
				$key = array_keys($hosts);
				$size = sizeOf($key);
				for ($i=0; $i<$size; ++$i) if( $hosts[$key[$i]] === $ip ) return true;;
			}
		} return false;
	}
	
	function IsValidStr($Subject){
		if( preg_match('/^[a-zA-Z ]*$/',$Subject))
			return true;
		else
			return false;
	}
	
	function gentime() {
		static $a;
		if($a == 0) $a = microtime(true);
		else {
			$a=round((microtime(true)-$a)*1000,2);
			return (string)$a;
		}
	}
//*/
	
	$version	=	'0.2.04';
	$timenow 	=	time();
	$page		=	array();
	
	$actionArray = array(
		'noticia' =>				'_inc/pages/noticia.php',
		'acc' =>					'_inc/controlador.cuentas.php',
		'agregarpj' =>				'_inc/panel/addpj.php',
		'ranking' => 				'_inc/pages/rank.php',
		'reg' => 					'_inc/pages/register.php',
		'micuenta' => 				'_inc/pages/mi_r.php',
		'descargar' => 				'_inc/pages/dw.php',
		'estadisticas' =>			'_inc/pages/est.php',
		'equipo' =>					'_inc/pages/staff.php',
		'ayuda' =>					'_inc/pages/help.php',
		'firma' =>					'_inc/panel/sig.php',
		'mi' =>						'_inc/pages/mi.php',
		'version' =>				'_inc/pages/version.php',
		'parche'	=>				'_inc/pages/parche.php',
	/* PANEL PJ */
		'panel' => 					'_inc/panel/panel.php',
		'clan' =>					'_inc/panel/clan.php',
		'solicitud-clan' =>			'_inc/panel/solicitud-clan.php',
		'crear-clan' =>		 		'_inc/panel/clan_crear.php',
		'pj' =>						'_inc/panel/mi.pj.php',
		'trainer' =>				'_inc/panel/trainer.php',
		'borrarpj' =>				'_inc/panel/borra.pj.php',
		'inventario' =>				'_inc/panel/invent.php',
		'invajax' =>				'_inc/panel/invent_ajax.php',
		'mercado' =>				'_inc/panel/mercader.php',
		'ajaxmercader' =>			'_inc/panel/mercader_ajax.php',
		'perfil' =>					'_inc/panel/perfil.php',
		'mpass' =>					'_inc/panel/mpass.php',
		'personaje' =>				'_inc/panel/personaje.php',
		'ajax-clanes-chat' =>		'_inc/panel/chat_clanes.php',
		'recordar' =>				'_inc/pages/recordar.php',
	/* MANUAL / AUYUDA */
		'manual' =>					'_inc/pages/manual.php',
		'ayuda'	=>					'_inc/pages/ayuda.php',
	/* PANEL ADMIN */
		'007adminitems' =>			'_inc/panel/gm/items.php',
		'007adminbalance' =>		'_inc/panel/gm/balance.php',
		'007adminGMS' =>			'_inc/panel/gm/gms.php',
		'007admin' =>				'_inc/panel/gm/admin.php',
		'007adminbans' =>			'_inc/panel/gm/bans.php',
		'007updates2010' =>			'_inc/panel/gm/updates.php',
		'851updatestds0puto' =>		'_inc/panel/gm/updates_tds.php',
	);
	
	//TODO : Arreglar esta mierda que no deja pasar checkboxes en array por post!!!!
	
	// $key = array_keys($_POST);
	// $size = sizeOf($key);
	// for ($i=0; $i<$size; ++$i) $_POST[$key[$i]] = mysql_escape($_POST[$key[$i]]);
	// $key = array_keys($_GET);
	// $size = sizeOf($key);
	// for ($i=0; $i<$size; ++$i) $_GET[$key[$i]] = mysql_escape($_GET[$key[$i]]);
	// $key = array_keys($_REQUEST);
	// $size = sizeOf($key);
	// for ($i=0; $i<$size; ++$i) $_REQUEST[$key[$i]] = mysql_escape($_REQUEST[$key[$i]]);
	// unset($key);

	header('Content-type: text/html; charset=utf-8');
	ob_start();	
  
	if( empty($_GET['a']) || empty($actionArray[$_GET['a']]) ){
		if($_GET['a']==='' || $_GET['a']==='index' ){
			include '_inc/pages/index.php';
		} else {
			include '_inc/pages/404.php';
		}
	} else {
		include $actionArray[$_REQUEST['a']];
	}
	//echo utf8_encode(

	$buffer = ob_get_contents();
	ob_end_clean();
if(DEBUG===true){
	//flush();
	echo $_REQUEST['a'].'<br/><div class="clear"><br/></div><div><br/>'.$_GET['a'],'<pre>';var_dump($_REQUEST);echo '</pre>SQL:<br/><pre>'.$database->txt,'</pre><br/><br/>Memoria: '.(memory_get_usage()/1024).'KB<br/><br/>PAGESIZE:'.$tamanioo.'<br/>adz2009 '.dechex((3<<28));
	//$j=-1;//xFdf795e3;
	
	//echo '<br/></div>';
	/*for($i=31;$i>=0;$i--){
		echo((($j & (1 << $i))!==0)?'1':'0');
	}
	@set_calidad($j,1);
	echo '<br/>'.dechex($j).' C='.@get_calidad($j);
	echo '<br/>';
	for($i=31;$i>=0;$i--){
		echo((($j & (1 << $i))!==0)?'1':'0');
	}*/
	echo '<div class="clear"><br/></div>';
}	
	echo utf8_encode($buffer);
	flush();
	unset($buffer);
	//exit();

?>