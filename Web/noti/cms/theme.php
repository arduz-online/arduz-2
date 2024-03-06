<?php
function theme_login($action_cms=0){
	echo '
<form name="form1" method="post" action="index.php">
  Nick<br/>
  <input type="text" name="user"/><br/>
  Contrase&ntilde;a<br/>
  <input type="password" name="pass"/><br/>
  <input type="hidden" name="action_cms" value="'.$action_cms.'"/><br/>
  <input type="submit" name="Submit" value="Logear">
</form>';
}

function form_cat($action_cms,$name='',$namespace=0,$id=0){
global $namespaces;
	echo '
	<form name="form1" method="post" action="index.php">
	  Nombre:<br/>
	  <input type="text" name="name" value="'.$name.'"/><br/>
	  Namespace<br/>
	<select name="namespace">';
	foreach($namespaces as $key=>$val){
		if ($key == $namespace) $ad = '" selected="selected';
		echo '<option value="'.$key.$ad.'">'.$val.'</option>';
		$ad='';
	}
	echo '</select>
	  <input type="hidden" name="action_cms" value="'.$action_cms.'"/><br/>
	  <input value="'.$id.'" type="hidden" name="ID"/><br/>
	  <input type="submit" name="Submit" value="Enviar">
	</form>';
}

function form_ent($action_cms,$id=0,$titulo='',$txt='',$cat=''){
global $namespaces;
	$txt = str_replace('\"','"',$txt);
	echo '<form name="form" method="post" action="index.php">
	Titulo:<br/>
		<input style="background:#fefefe;" value="'.$titulo.'" type="text" name="name" /><br/>
		Categor&iacute;a:<br/>
		<select name="cat">';
		$r = obtener_todas_categorias();
		while($tmp_cat = mysql_fetch_array($r)){
			echo '<option value="'.$tmp_cat['ID'].'"'.($tmp_cat['ID'] == $cat?' selected="selected"':'').'>'.$namespaces[$tmp_cat['namespace']].'::'.$tmp_cat['nombre'].'</option>';
		}
		echo '</select>
		<input value="'.$id.'" type="hidden" name="ID"/><br/>
		Contenido:<br/>
		<!--<input type="button" value="Negrita" onclick="bbc(\'b\',0)" class="bb" style="font-weight:bold;" />
		<input type="button" value="Italica" onclick="bbc(\'i\',0)" class="bb" style="font-style:italic;" />
		<input type="button" value="Subrr." onclick="bbc(\'u\',0)" class="bb" style="text-decoration:underline;" />
		<input type="button" value="URL" onclick="url(0)" class="bb" />
		<input type="button" value="IMG" onclick="img(0)" class="bb" />-->

		
		<br/>
		<textarea style="background:#fefefe;padding:5px;" cols="40" rows="15" name="txt" id="txt">'. $txt.'</textarea>
		<script type="text/javascript">
			SMarkUp.bind(
				\'txt\', //textarea id 
				\'bbcode\', //makup configuration name 
				300		//height of textarea
			);
		</script>		
		<br/>';
	echo '<br/><br/><input type="hidden" name="action_cms" value="'.$action_cms.'"/><input class="btn" type="submit" name="Submit" value="Enviar" /></form>';
}

function form_borr($id,$action_cms){
	echo '<form style="margin:0;padding:0;" action="index.php" method="post" name="form"><input type="checkbox" name="borrar" style="width:12px;"/>&iquest;Seguro lo querés borrar?<input value="'.$id.'" type="hidden" name="ID"/><input type="hidden" name="action_cms" value="'.$action_cms.'"/><input type="submit" name="Submit" value="BORRAR" /></form>';
}

function menu(){
global $session;
	echo 'Logeado como: <b>'.$session->user['nick'].'</b></big> | <a href="index.php?action_cms='.ACTION_LOGOUT.'" title="Salir">Salir</a> | <a href="index.php?action_cms='.ACTION_VER_ENTRADAS.'">Entradas</a> | <a href="index.php?action_cms='.ACTION_VER_CATEGORIAS.'">Categorias</a><br/><br/>';
}

function theme_header($title="Noticias")
{
	echo '
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="es" lang="es">
<head>
	<title>'.$title.'</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<style type="text/css">
		body {background-color: #ffffff;font-family:verdana;color: black;font-size:8pt;padding:40px;}
		input[type=text],input[type=password], textarea {border:1px solid #242424;font-family:Tahoma;font-size:8pt;width:500px;}
		.bb {border:1px solid #999;background:#eee;font-family:verdana;font-size: 10pt;}
		.bb:hover {border:1px solid #119999;background-color:#ccfcff;cursor:pointer;}
	</style>
	<script type="text/javascript" src="smarkup/smarkup.js"></script>
	<script type="text/javascript" src="smarkup/conf/bbcode/conf.js"></script>
	<link rel="stylesheet" type="text/css" href="smarkup/skins/style.css"/>
	<link href="smarkup/skins/default/style.css" type="text/css" rel="stylesheet" />
	<link rel="stylesheet" type="text/css" href="smarkup/skins/html/style.css"/>
	<link rel="stylesheet" type="text/css" href="smarkup/skins/bbcode/style.css"/>

</head>
<body>
<big><big><big><big>'.$title.'</big></big></big></big><br/>
';
menu();
}

function timeout($S=''){
	echo '<b>'.$S.'</b><br/><script>var t=setTimeout("window.location = \'index.php?action_cms='.ACTION_VER_ENTRADAS.'\'",500);</script>';
}

function footer()
{
	echo '<br/><br/><br/><strong>Manejador de contenido v0.1 - Tierras del sur &copy; </strong>
</body>
</html>';
}
?>