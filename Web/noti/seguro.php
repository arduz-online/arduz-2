<?php
/* Modulo menduz  */
session_start();
conectar_db();
require_once("theme.php");
//BASE DE DATOS
function conectar_db() {
// conecta a el server db, y luego filtra la seguridad
//UM: 13/7/08
global $database;
if(!is_object($database)){
	$usr = "noicoder_root";
	$passwd = "";
	$sv = "localhost";
	$dbname = "noicoder_sake";
	$db = mysql_connect($sv, $usr, $passwd);
	mysql_select_db($dbname,$db);
	aplicar_seg_sql();
}
}

function aplicar_seg_sql() {
//UM: 13/7/08
	foreach($_GET as $variable=>$valor){
	// Modifica las variables pasadas por URL
		$_GET[$variable] = @mysql_real_escape_string($valor);
	}
	foreach($_POST as $variable=>$valor){
	// Modifica las variables de formularios 
		$_POST[$variable] = @mysql_real_escape_string($valor);
	}
	foreach($_REQUEST as $variable=>$valor){
	// Modifica las variables de formularios 
		$_REQUEST[$variable] = @mysql_real_escape_string($valor);
}
}
function sec_simple($string) { //inyeccion sql.
//seguridad simple para sql
//UM: 11/7/08
	$result = str_replace ( "'" , "'" , $string);
}
function dec($string) {
//Decodifica una cadena con base 64 bit
//UM: 11/7/08
    /*$string = base64_decode($string);
    $control = "132mz"; //super secreto
    $string = str_replace($control, "", "$string");*/
    return $string;
} 
function enc($string) {
//Codifica una cadena con base 64 bit
//UM: 11/7/08
    /*$control = "132mz";
    $tmp_string = $string;
    $string = $control.$tmp_string.$control;
    $string = base64_encode($string);*/
    return($string);
}


function exec_sql($sql) {
//Ejecuta una llamada sql a la base conectada $db
//UM: 11/7/08
	$result = mysql_query($sql);
	return $result;
}
//Funciones varias
function bbcodex($texto) {
// aplica bbcode a la string $texto
//UM: 14/7/08
$texto = nl2br($texto); //Saltos de Linea
$texto = ereg_replace("&aacute;", "�", $texto);
$texto = ereg_replace("&eacute;", "�", $texto);
$texto = ereg_replace("&iacute;", "�", $texto);
$texto = ereg_replace("&oacute;", "�", $texto);
$texto = ereg_replace("&uacute;", "�", $texto);
$texto = ereg_replace("&ntilde;", "�", $texto);
$texto = ereg_replace("&uuml;", "�", $texto);
$texto = ereg_replace("&Aacute;", "�", $texto);
$texto = ereg_replace("&Eacute;", "�", $texto);
$texto = ereg_replace("&Iacute;", "�", $texto);
$texto = ereg_replace("&Oacute;", "�", $texto);
$texto = ereg_replace("&Uacute;", "�", $texto);
$texto = ereg_replace("&Ntilde;", "�", $texto);
$texto = ereg_replace("&Uuml;", "�", $texto);
return $texto;
}



function BBcode($texto){
   $texto = preg_replace("/\\\"(.*?)\\\"/is","<q>$1</q>", $texto);
   $a = array(
      "/\[i\](.*?)\[\/i\]/is",
      "/\[b\](.*?)\[\/b\]/is",
      "/\[u\](.*?)\[\/u\]/is",
      "/\[img\](.*?)\[\/img\]/is",
      "/\[url=(.*?)\](.*?)\[\/url\]/is",
	  
   );
   $b = array(
      "<em>$1</em>",
      "<strong>$1</strong>",
      "<u>$1</u>",
      "<img src=\"$1\" alt=\"Im&aacute;n\" />",
      "<a href=\"$1\" target=\"_blank\" title=\"$2\">$2</a>",
	  
   );
  $c = array(".\n",".\n<br/>",".\n<br />",".<br/>\n",".<br/>",".<br>",".<br/>",".<br />",".\n<br>",".<br>\n","<br/>");

   $texto = preg_replace($a, $b, bbcodex($texto));
   $texto = ereg_replace(".</p> 
<p>",$c, $texto);
   
   return $texto;
}

function guardarnoticias($cuantas=3)
{
	require_once("../_inc/layout.theme.php");
	$res_id = exec_sql("SELECT * FROM `noticias` ORDER BY `date` DESC LIMIT ".$cuantas);
	$i = 0;
	$mensaje = "";
	while ($row = mysql_fetch_array($res_id)) {
		$name = $row['name'];
		$linx = utf8_encode(urls_amigables($row['titulo']));
		$tito = $row['titulo'];
		//if (strlen($row['completa'])>0){
		$eltit = get_header_title_cases($tito,3,'h2',true);

		//}
		
		$mensaje = BBcode($row['msg']);
		$mensaje = get_header_title_cases($mensaje{0},8,'div',true).'<p class="lead">'.substr($mensaje, 1).'<br /><small style="color:#9A8972;font-size:8pt;"><em>'. date("d-m-Y",$row['date']) .' ' . ucfirst($name) . '</em> - <a title="'.$tito.'" href="noticia_'.$linx.'_'.$row['id'].'.php">Enlace permanente</a></small></p>';
		$contenido .= $eltit.'<div class="clear"></div><div class="hr"></div>' . $mensaje . '<br/>
';

	}
	
	$contenido .= "<!--Noticias actualizadas el dia ". date("d-m-y") ." a las ". date("H:i:s") ." horas-->";
	if (strlen($contenido)>0)
	{
		$fch= fopen('../_content/news_estaticas.html', "w"); // Abres el archivo para escribir en �l
		fwrite($fch, $contenido); // Grabas
		fclose($fch); // Cierras el archivo.
		unset($contenido);
		//return true;
	} else return false;
	 $months = array (
	'1' => 'Enero',
	'2' => 'Febrero',
	'3' => 'Marzo',
	'4' => 'Abril',
	'5' => 'Mayo',
	'6' => 'Junio',
	'7' => 'Julio',
	'8' => 'Agosto',
	'9' => 'Septiembre',
	'10' => 'Octubre',
	'11' => 'Noviembre',
	'12' => 'Diciembre'
);
$dayss = array (
	'1' => 'L&uacute;nes',
	'2' => 'Martes',
	'3' => 'Miercoles',
	'4' => 'Jueves',
	'5' => 'Viernes',
	'6' => 'Sabado',
	'7' => 'Domingo'
);
	$res_id = exec_sql("SELECT * FROM `noticias` ORDER BY `date` DESC");
	$i = 0;
	while ($row = mysql_fetch_array($res_id)) {
		$date = $row['date'];
		$linx = urls_amigables($row['titulo']);
		$varx = date("Y",$row['date']);
		$anyos[$varx] = $varx;
		$vary = date("m",$row['date']);
		//$row['link']='<a title="'.$row['titulo'].' publicada el '.$dayss[intval(date("N",$row['date']))].' '.date("j",$row['date']).' de '.$months[intval(date("n",$row['date']))].' por '.$row['name'].'" href="noticia_'.$linx.'_'.$row['id'].'.php">'.$dayss[intval(date("N",$row['date']))].' '.date("j",$row['date']).' - '.BBcode($row['titulo']).'</a>';
		$row['link']='<a title="'.$row['titulo'].' publicada el '.$dayss[intval(date("N",$row['date']))].' '.date("j",$row['date']).' de '.$months[intval(date("n",$row['date']))].' por '.$row['name'].'" href="noticia_'.$linx.'_'.$row['id'].'.php" class="tooltip">'.date('d-m-Y',$row['date']).' - '.BBcode($row['titulo']).'</a>';
		$row['linkr']='http://www.arduz.com.ar/noticia_'.$linx.'_'.$row['id'].'.php';
		$meses[$varx][$vary][$i]=$row;
		$meses[$varx][$vary]['dato']=intval(date("n",$row['date']));
		$i++;
	}
	$buff = get_header_title_cases('Historial de noticias',24,'h1',true);;
	$rssa = '<?xml version="1.0" encoding="ISO-8859-1" ?>
<rss version="0.91">
 <channel>
 <title>Arduz Online</title>
 <link>http://www.arduz.com.ar</link>
 <description>Arduz Online - MMORPG</description>
 <language>es-ar</language>';
	foreach ($anyos as $datox)
	{
		$buff.= get_header_title_cases('A�o '.$datox,1,'h1',true)."\n";
		foreach ($meses[$datox] as $datosmes)
		{
			$nombremes = $months[$datosmes['dato']];
			$buff.= get_header_title_cases($nombremes,9,'h2',true)."\n";
			foreach ($datosmes as $notix)
			{
				if (isset($notix['link'])){
					$buff.= '<h3 title="'.$dayss['titulo'].' posteada el '.$dayss[intval(date("N",$notix['date']))].' '.date("j",$notix['date']).' de '.$months[intval(date("n",$notix['date']))].' por '.$notix['name'].'">'.$notix['link'].'</h3>'."\n";
					if($rars < 11){
					$rssa.= '<item>
  <title>'.$notix['titulo'].'</title>
   <link>'.$notix['linkr'].'</link>
   <description>
	'.$notix['msg'].'
   </description>
  </item>';++$rars;}
				}
			}
		}
	}
	$buff.= 'Hay '.$i.' noticias.';

$rssa.= '
 </channel>
</rss>';
	$fch= fopen('../_content/hist_news.html', "w"); // Abres el archivo para escribir en �l
	fwrite($fch, $buff); // Grabas
	fclose($fch); // Cierras el archivo.
	$fch= fopen('../arduz.xml', "w"); // Abres el archivo para escribir en �l
	fwrite($fch, $rssa); // Grabas
	fclose($fch); // Cierras el archivo.		//return true;

	return false;
}
function urls_amigables($url) {
$url = utf8_encode(strtolower($url));
$find = array('�', '�', '�', '�', '�', '�');
$repl = array('a', 'e', 'i', 'o', 'u', 'n');
$url = utf8_encode(str_replace ($find, $repl, $url));
$find = array(' ', '&', '\r\n', '\n', '+');
$url = utf8_encode(str_replace ($find, '-', $url));
$find = array('/[^a-z0-9\-<>]/', '/[\-]+/', '/<[^>]*>/');
$repl = array('', '-', '');
$url = preg_replace ($find, $repl, $url);
return $url;
}
?>