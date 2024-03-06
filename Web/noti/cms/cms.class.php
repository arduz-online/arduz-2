<?php
/* MENDUZ */

$namespaces[0] = 'Ayuda';
$namespaces[1] = 'Manual';
//$namespaces[2] = 'FAQs';
require_once dirname(__FILE__).'/../../_inc/cfg.php'; 
require_once dirname(__FILE__).'/../../_inc/database.php'; 
define('DB_WEB',DB_NAME);
define('SUBSYSTEM_NAME','cms1');

if(get_magic_quotes_gpc()){
	foreach($_GET as $variable=>$valor)			
		$_GET[$variable] = @mysql_real_escape_string(stripslashes($valor));
	foreach($_POST as $variable=>$valor)	
		$_POST[$variable] = @mysql_real_escape_string(stripslashes($valor));
	foreach($_REQUEST as $variable=>$valor)
		$_REQUEST[$variable] = @mysql_real_escape_string(stripslashes($valor));
} else {
	foreach($_GET as $variable=>$valor) $_GET[$variable] 		= @mysql_real_escape_string($valor);
	foreach($_POST as $variable=>$valor) $_POST[$variable] 		= @mysql_real_escape_string($valor);
	foreach($_REQUEST as $variable=>$valor) $_REQUEST[$variable]	= @mysql_real_escape_string($valor);
}


// Categorias
function agregar_categoria($nombre,$namespace){
	mysql_query('INSERT INTO '.t('categorias')." 
		(`ID`	,`nombre`	,`namespace`) 
		VALUES
		(NULL	,'$nombre'	,'$namespace');"
	);
	return mysql_insert_id();
}
function editar_categoria($id,$nombre,$namespace){
	mysql_query('UPDATE '.t('categorias')." SET nombre = '$nombre',namespace = '$namespace' WHERE ID = '$id'");
	actualizar_cache($namespace);
}
function borrar_categoria($id){
	$namespace=obtener_idspace($id);
	mysql_query('DELETE FROM '.t('categorias')."	WHERE ID	= '$id'");
	actualizar_cache($namespace);	
}

function obtener_categorias($namespace){
	$r = mysql_query('SELECT * FROM '.t('categorias').' WHERE namespace=\''.$namespace.'\';');
	return ((mysql_num_rows($r)>0)?mysql_fetch_array($r):false);
}

function obtener_todas_categorias(){
	$r = mysql_query('SELECT * FROM '.t('categorias').' ORDER BY namespace');
	return $r;//((mysql_num_rows($r)>0)?mysql_fetch_array($r):false);
}	

function obtener_categoria($id){
	$r = mysql_query('SELECT * FROM '.t('categorias').' WHERE ID=\''.$id.'\';');
	return ((mysql_num_rows($r)>0)?mysql_fetch_array($r):false);
}

function obtener_idspace($idCategoria){
	$r = mysql_query('SELECT namespace FROM '.t('categorias').' WHERE ID=\''.$idCategoria.'\';');
	if (mysql_num_rows($r)==1) {
		$info=mysql_fetch_array($r);
		return intval($info['namespace']);
	} else {
		return -1;
	}
}
// obtiene el id de la categoria correspondiente a una entrada
function obtener_idcategoria($idEntrada){
	$r = mysql_query('SELECT cat FROM '.t('entradas').' WHERE ID=\''.$idEntrada.'\';');
	if (mysql_num_rows($r)==1) {
		$info=mysql_fetch_array($r);
		return intval($info['cat']);
	} else {
		return -1;
	}
}

// Entradas
function agregar_entrada($contenido,$titulo,$categoria){
	mysql_query('INSERT INTO '.t('entradas')." 
		(`ID`	,`titulo`	,`txt`			,`cat`) 
		VALUES
		(NULL	,'$titulo'	,'$contenido'	,'$categoria');"
	);
	actualizar_cache(obtener_idspace($categoria));
	return mysql_insert_id();
}
function editar_entrada($id,$contenido,$titulo,$categoria){
	mysql_query('UPDATE '.t('entradas')." SET txt = '$contenido',titulo = '$titulo', cat = '$categoria' WHERE ID = '$id'");
	actualizar_cache(obtener_idspace($categoria));
}
function borrar_entrada($id){
	$id_namespace=obtener_idspace(obtener_idcategoria($id));
	mysql_query('DELETE FROM '.t('entradas')." WHERE ID = '$id'");
	actualizar_cache($id_namespace);
}

function obtener_entradas($namespace,$limite=0){
	//Me re jugue con esta consulta eh!
	$limite = intval($limite);
	
	
	if($limite>0)
		$sql_add = 'LIMIT '.$limite;
	else
		$sql_add = '';
		
		
	$r = mysql_query('SELECT '.t('categorias').'.nombre AS `cat_nom`,'.t('categorias').'.namespace AS `namespace`, '.t('entradas').'.* FROM '.t('categorias').' INNER JOIN '.t('entradas').' ON '.t('categorias').'.ID = '.t('entradas').'.cat WHERE '.t('categorias').'.namespace=\''.(string)intval($namespace).'\' '.$sql_add.' ORDER BY '.t('entradas').'.cat;');
	return $r;//((mysql_num_rows($r)>0)?mysql_fetch_array($r):false);
}

function obtener_entrada($id){
	$r = mysql_query('SELECT * FROM '.t('entradas').' WHERE ID=\''.$id.'\';');
	return ((mysql_num_rows($r)>0)?mysql_fetch_array($r):false);
}

function obtener_todas_entradas(){
	$r = mysql_query('SELECT '.t('categorias').'.nombre AS `cat_nom`,'.t('categorias').'.namespace AS `namespace`, '.t('entradas').'.* FROM '.t('categorias').' INNER JOIN '.t('entradas').' ON '.t('categorias').'.ID = '.t('entradas').'.cat ORDER BY '.t('categorias').'.namespace, '.t('categorias').'.ID;');
	return $r;//((mysql_num_rows($r)>0)?mysql_fetch_array($r):false);
}

function t($name){
	// JA! mirá si voy a escribir todo eso en cada consulta :p
	// es para hacer consultas pone el nombre de la base de datos y prefijo de la tabla concatenados a la tabla
	return '`' . DB_WEB . '`.`' . SUBSYSTEM_NAME . '_' . $name . '`';
}	
function init_namespace($id){
	require_once dirname(__FILE__).'/templates/'.$id.'.php';
}

function actualizar_cache($idspace) {
	include(dirname(__FILE__).'/templates/'.$idspace.'.php');
	
	$contenido = ver_lista(); // Function del template
	
	$archivo=dirname(__FILE__).'/cache/'.$idspace.'.html';;

	$fch= fopen($archivo, 'w');
	fwrite($fch, $contenido); 
	fclose($fch); 
}

function bbcodex($texto) {
// aplica bbcode a la string $texto
//UM: 20/12/08
$texto = nl2br($texto); //Saltos de Linea
$texto = str_replace('<br />','<br />
',$texto); //Saltos de Linea
$texto = str_replace('\"','"',$texto); //Saltos de Linea
$texto = ereg_replace('&aacute;', 'á', $texto);
$texto = ereg_replace('&eacute;', 'é', $texto);
$texto = ereg_replace('&iacute;', 'í', $texto);
$texto = ereg_replace('&oacute;', 'ó', $texto);
$texto = ereg_replace('&uacute;', 'ú', $texto);
$texto = ereg_replace('&ntilde;', 'ñ', $texto);
$texto = ereg_replace('&uuml;', 'ü', $texto);
$texto = ereg_replace('&Aacute;', 'Á', $texto);
$texto = ereg_replace('&Eacute;', 'É', $texto);
$texto = ereg_replace('&Iacute;', 'Í', $texto);
$texto = ereg_replace('&Oacute;', 'Ó', $texto);
$texto = ereg_replace('&Uacute;', 'Ú', $texto);
$texto = ereg_replace('&Ntilde;', 'Ñ', $texto);
$texto = ereg_replace('&Uuml;', 'Ü', $texto);
return $texto;
}



function BBcode($texto){
   $a = array(
	    "/\[i\](.*?)\[\/i\]/is",
	    "/\[b\](.*?)\[\/b\]/is",
	    "/\[u\](.*?)\[\/u\]/is",
			"/\[img\](.*?)\[\/img\]/is",
			"/\[img:center\](.*?)\[\/img\]/is",
			"/\[img:(.*?)\](.*?)\[\/img\]/is",
			//"/\[img alt=\\\"(.*?)\\\"\](.*?)\[\/img\]/is",
	    "/\[url=(.*?)\](.*?)\[\/url\]/is",
		"/\[url\](.*?)\[\/url\]/is",
		"/\[list\](.*?)\[\/list\]/is",
		"/\[\*\](.*?)\n/is",
		"/\[quote\](.*?)\[\/quote\]/is",
		"/\[code\](.*?)\[\/code\]/is",
		"/\[form=(.*?);(.*?)\](.*?)\[\/form\]/is",
		"/\[campo=(.*?)\](.*?)\[\/campo\]/is",
		"/\[submit=(.*?)\](.*?)\[\/submit\]/is",
		"/\[h1\](.*?)\[\/h1\]/is",
		"/\[h2\](.*?)\[\/h2\]/is",
		"/\[h3\](.*?)\[\/h3\]/is",
		"/\[h4\](.*?)\[\/h4\]/is",
		"/\[h5\](.*?)\[\/h5\]/is",
		"/\[h6\](.*?)\[\/h6\]/is",
		"/\[color=(.*?)\](.*?)\[\/color\]/is",
   );
   
   $b = array(
	    "<em>$1</em>",
	    "<strong>$1</strong>",
	    "<u>$1</u>",
			"</p><div id=\"box_img\"><span class=\"noticias_img_box\"><img src=\"$1\" alt=\"Im&aacute;n\" onclick=\"verimagen_noticias('$1')\" /></span><div style='clear:both;'></div></div><p>",
			"<div style='text-align:center;'><img src=\"$1\" alt=\"Im&aacute;gen\" /></div><div style='clear:both;'></div>",
			"<img src=\"$2\" alt=\"Im&aacute;n\" style='float:$1' />",
			//"</p><div id=\"box_img\"><span class=\"noticias_img_box\"><img src=\"$2\" alt=\"$1\"  onclick=\"verimagen_noticias('$2')\" /></span><div style='clear:both;'></div></div><p>",
	    "<a href=\"$1\" target=\"_blank\" title=\"$2\">$2</a>",
		"<a href=\"$1\" target=\"_blank\" title=\"$1\">$1</a>",
		"<ul>$1</ul>",
		"<li>$1</li>",
		"<div class='quote'>$1</div><div class='clear'></div>",
		"<div class='code'>$1</div><div class='clear'></div>",
		"<form method='POST' name='$2' id='$2' action='$1' style='display:none;'>$3</form>",
		"<input type='hidden' id='$1' name='$1' value='$2' />",
		//"<textarea id='$1' name='$1'>$2</textarea>",
		"<a onclick='document.forms[\"$1\"].submit();' href='#'>$2</a>",
		"<h1>$1</h1>",
		"<h2>$1</h2>",
		"<h3>$1</h3>",
		"<h4>$1</h4>",
		"<h5>$1</h5>",
		"<h6>$1</h6>",
		"<span style='color:$1'>$2</span>",
   );
   
	$c = array(".\n\n\n\n",".\n",".\n<br/><br/>",".\n<br /><br />",".<br/><br/>\n",".<br/><br/>",".<br><br>",".<br /><br />",".\n<br>\n<br>",".<br>\n<br>\n");

   $texto = preg_replace($a, $b, bbcodex($texto));
   $texto = str_replace($c,".</p>
<p>", $texto);
   return $texto;
} 

function urls_amigables($url) {
$url = strtolower($url);
$find = array('á', 'é', 'í', 'ó', 'ú', 'ñ');
$repl = array('a', 'e', 'i', 'o', 'u', 'n');
$url = str_replace ($find, $repl, $url);
$find = array(' ', '&', '\r\n', '\n', '+');
$url = str_replace ($find, '-', $url);
$find = array('/[^a-z0-9\-<>]/', '/[\-]+/', '/<[^>]*>/');
$repl = array('', '-', '');
$url = preg_replace ($find, $repl, $url);
return $url;
}
/*
if($_GET['m']==='instalar'){
	mysql_query("DROP TABLE IF EXISTS ".t('categorias'));
	mysql_query("DROP TABLE IF EXISTS ".t('entradas'));
	mysql_query("CREATE TABLE ".t('categorias')." (
`ID` MEDIUMINT NULL AUTO_INCREMENT ,
`nombre` VARCHAR( 255 ) NOT NULL ,
`namespace` TINYINT NOT NULL DEFAULT '0',
PRIMARY KEY ( `ID` )
) ENGINE = InnoDB");
	mysql_query("CREATE TABLE ".t('entradas')." (
`ID` MEDIUMINT NULL AUTO_INCREMENT ,
`titulo` VARCHAR( 255 ) NOT NULL ,
`txt` TEXT NOT NULL ,
`cat` MEDIUMINT NOT NULL ,
PRIMARY KEY ( `ID` )
) ENGINE = InnoDB ");
}*/


?>