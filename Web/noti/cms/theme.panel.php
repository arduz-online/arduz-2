<?php
function form_cat($action_cms,$name='',$namespace=0,$id=0){
global $namespaces;
	echo '
	<form name="form1" method="post" action="contenido_cms.php">
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
	echo '<form name="form" method="POST" action="contenido_cms.php">
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
	echo '<form style="margin:0;padding:0;" action="contenido_cms.php" method="POST" name="form"><input type="checkbox" name="borrar" style="width:12px;"/>&iquest;Seguro lo querés borrar?<input value="'.$id.'" type="hidden" name="ID"/><input type="hidden" name="action_cms" value="'.$action_cms.'"/><input type="submit" name="Submit" value="BORRAR" /></form>';
}

function menu(){
global $session;
	echo '<span><a href="contenido_cms.php?action_cms='.ACTION_VER_ENTRADAS.'" class="boton ui-state-default ui-corner-all"><span class="ui-icon ui-icon-star"></span>Entradas</a></span>
	<span><a href="contenido_cms.php?action_cms='.ACTION_VER_CATEGORIAS.'" class="boton ui-state-default ui-corner-all"><span class="ui-icon ui-icon-star"></span>Categorias</a></span><br/><br/>';
}

function theme_header($title="Noticias")
{
	echo '
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="/comun/css/'.JQUERY_UI_THEME.'/jquery-ui.css" />
		<link rel="stylesheet" type="text/css" href="/comun/css/'.JQUERY_UI_THEME.'/custom.css" />
		<link rel="stylesheet" type="text/css" href="/comun/css/estilos.css" />
		<script type="text/javascript" src="/comun/js/jquery-min.js"></script>

		<script type="text/javascript" src="/comun/js/jquery-ui-min.js"></script>
		
		<script>
			$(function(){
				$(".icon").hover(
					function() { $(this).addClass("ui-state-hover"); }, 
					function() { $(this).removeClass("ui-state-hover"); }
				);

				$(".boton").hover(
					function() { $(this).addClass("ui-state-hover"); }, 
					function() { $(this).removeClass("ui-state-hover"); }
				);
			});
		</script>
		<title>'.$title.'</title>
		<script type="text/javascript" src="http://'.$_SERVER['SERVER_NAME'].'/tds_cms/smarkup/jquery.smarkup.pack.js"></script>
		<script type="text/javascript" src="http://'.$_SERVER['SERVER_NAME'].'/tds_cms/smarkup/conf/bbcode/conf.js"></script>
		<link rel="stylesheet" type="text/css" href="http://'.$_SERVER['SERVER_NAME'].'/tds_cms/smarkup/skins/style.css"/>
		<link href="http://'.$_SERVER['SERVER_NAME'].'/tds_cms/smarkup/skins/default/style.css" type="text/css" rel="stylesheet" />
		<link rel="stylesheet" type="text/css" href="http://'.$_SERVER['SERVER_NAME'].'/tds_cms/smarkup/skins/html/style.css"/>
		<link rel="stylesheet" type="text/css" href="http://'.$_SERVER['SERVER_NAME'].'/tds_cms/smarkup/skins/bbcode/style.css"/>
		<link rel="stylesheet" type="text/css" href="http://'.$_SERVER['SERVER_NAME'].'/tds_cms/smarkup/conf/css/style.css"/>
	</head>
	<body>
		<div id="framecontent">';
			require_once($_SERVER['DOCUMENT_ROOT'] ."/admin_web/menu.php");
			echo '<div id="maincontent" style="padding-top:25px">';
menu();
}

function timeout($S=''){
	echo '<b>'.$S.'</b><br/><script>var t=setTimeout("window.location = \'contenido_cms.php?action_cms='.ACTION_VER_ENTRADAS.'\'",500);</script>';
}

function footer()
{
	echo '</div>
		</div>
	</body>
</html>';
}
?>