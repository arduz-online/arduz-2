<?php
$errorstr = "
<div class='caja_margen'>

<div class='caja'>
<div class='caja_shadow_t'>
<div class='caja_shadow_b'>

<div class='caja_l'>
<div class='caja_r'>

 
<div class='caja_t'>
<div class='caja_b'>

<div class='caja_noticia'>
<h2>Error</h2>
<p>Noticia inexistente o invalida</p>

<div class='por_l'>
<div class='por_r'>

<div class='por_contenido'> <span class='dato'>Tierras del sur ".date('Y')."</span></div>

</div>
</div>


</div>
</div>
</div>

</div>

</div>

</div>
</div>

</div>

</div>
";
function theme_login($to="logear.php")
{
	echo '
<form name="form1" method="post" action="'.$to.'">
  Nick<br/>
  <input type="text" name="personaje"/><br/>
  Contrase&ntilde;a<br/>
  <input type="password" name="password"/><br/>
  <input type="submit" name="Submit" value="Logear">
</form>';
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
		.bb {border:1px solid #999;background:#eee;width:30px!important;font-family: verdana;font-size: 10pt;}
		.bb:hover {border:1px solid #119999;background-color:#ccfcff;width:30px!important;cursor:pointer;}
	</style>
</head>
<script type="text/javascript">
function bbc(tag) {
   	var txt = window.document.form.completa;
    if(document.selection) {
    	txt.focus();
    	sel = document.selection.createRange();
    	sel.text = \'[\' + tag + \']\' + sel.text + \'[/\' + tag + \']\';
    } else if(txt.selectionStart || txt.selectionStart == \'0\') {	
		txt.value = (txt.value).substring(0, txt.selectionStart) + "["+tag+"]" + (txt.value).substring(txt.selectionStart, txt.selectionEnd) + "[/"+tag+"]" + (txt.value).substring(txt.selectionEnd, txt.textLength);
    } else {
        txt.value = \'[\' + tag + \'][/\' + tag + \']\';
    }
    return;
}
function bbs(tag) {
   	var txt = window.document.form.msg;
    if(document.selection) {
    	txt.focus();
    	sel = document.selection.createRange();
    	sel.text = \'[\' + tag + \']\' + sel.text + \'[/\' + tag + \']\';
    } else if(txt.selectionStart || txt.selectionStart == \'0\') {	
		txt.value = (txt.value).substring(0, txt.selectionStart) + "["+tag+"]" + (txt.value).substring(txt.selectionStart, txt.selectionEnd) + "[/"+tag+"]" + (txt.value).substring(txt.selectionEnd, txt.textLength);
    } else {
        txt.value = \'[\' + tag + \'][/\' + tag + \']\';
    }
    return;
}
function urls() {
	var txt = window.document.form.msg;
	var link = prompt("Ingrese la dirección:", "http://");
	if(link.length == 0 || link == "http://") {
		return;
	} else {
		var link = "=" + link;
		var text;
		var sel2 = "";
		
		if(document.selection) {
			txt.focus();
			sel = document.selection.createRange();
			sel2 = sel.text;
		} else if(txt.selectionStart || txt.selectionStart == \'0\') {
			sel2 = (txt.value).substring(txt.selectionStart, txt.selectionEnd);
		}
		
		if(sel2.length > 0) {
			text = sel2;
		} else {
			text = prompt("Texto del link:", "");
		}
	}


	if(document.selection) {
		txt.focus();
		sel = document.selection.createRange();
		sel.text = "[url" + link + "]" + text + "[/url]";
	} else {
		txt.value = (txt.value).substring(0, txt.selectionStart) + "[url" + link + "]" + text + "[/url]" + (txt.value).substring(txt.selectionEnd, txt.textLength);
	}
	return;
}
function urlc() {
	var txt = window.document.form.completa;
	var link = prompt("Ingrese la dirección:", "http://");
	if(link.length == 0 || link == "http://") {
		return;
	} else {
		var link = "=" + link;
		var text;
		var sel2 = "";
		
		if(document.selection) {
			txt.focus();
			sel = document.selection.createRange();
			sel2 = sel.text;
		} else if(txt.selectionStart || txt.selectionStart == \'0\') {
			sel2 = (txt.value).substring(txt.selectionStart, txt.selectionEnd);
		}
		
		if(sel2.length > 0) {
			text = sel2;
		} else {
			text = prompt("Texto del link:", "");
		}
	}


	if(document.selection) {
		txt.focus();
		sel = document.selection.createRange();
		sel.text = "[url" + link + "]" + text + "[/url]";
	} else {
		txt.value = (txt.value).substring(0, txt.selectionStart) + "[url" + link + "]" + text + "[/url]" + (txt.value).substring(txt.selectionEnd, txt.textLength);
	}
	return;
}

</script>
<body>
<big><big><big><big>'.$title.'</big></big></big></big><br/>

';
}

function formulario($titox,$idx,$mensajex,$comx,$fecha)
{
if ($fecha<0) $actual=true;
	echo '
Logeado como: <b>'.$_SESSION['nick'].'</b></big> | <a href="ver.php?salir='.$_SESSION['nick'].'" title="Salir">Salir</a> | <a href="ver.php" title="Ver todas las noticias">Indice</a><br/><br/>
Titulo:<br/>
<input style="background:eee;" value="'.$titox.'" type="text" name="tit" />
<input value="'.$idx.'" type="hidden" name="idx"/><br/>
Noticia corta 
<input type="button" value="B" onclick="bbs(\'b\')" class="bb" style="width:30px; font-weight:bold;" />
<input type="button" value="I" onclick="bbs(\'i\')" class="bb" style="width:30px; font-style:italic;" />
<input type="button" value="U" onclick="bbs(\'u\')" class="bb" style="width:30px; text-decoration:underline;" />
<input type="button" value="URL" onclick="urls()" class="bb" />
<br/>
<textarea style="background:#fefefe;padding:5px;" cols="40" rows="15" name="msg">'. $mensajex.'</textarea><br/>
Noticia larga
<input type="button" value="B" onclick="bbc(\'b\')" style="width:30px; font-weight:bold;" class="bb" />
<input type="button" value="I" onclick="bbc(\'i\')" style="width:30px; font-style:italic;" class="bb" />
<input type="button" value="U" onclick="bbc(\'u\')" style="width:30px; text-decoration:underline;" class="bb" />
<input type="button" value="URL" onclick="urlc()" class="bb" />
<br/>
<textarea style="background:#fefefe;padding:5px;" cols="70" rows="15" name="completa">'.$comx.'</textarea><br/>
<br/><br/>
Usar fecha personalizada(De lo contrario, se usara la actual):<br/>';
if ($actual==true){
	$fecha=time();
	echo '<input type="checkbox" name="fecha" style="width:24px;"/>';
} else {
	echo '<input type="checkbox" name="fecha" style="width:24px;" checked=""/>';
}
echo '
<select name="ano">
';

for ($i=2004; $i <= date("Y");$i++)
{
if ($i == date("Y",$fecha)) $ad = '" selected="selected';
echo '<option value="'.$i.$ad.'">A&ntilde;o '.$i.'</option>
';
$ad="";
}

echo '</select><select name="mes">';
for ($i=1; $i<= 12;$i++)
{
if ($i == date("m",$fecha)) $ad = '" selected="selected';
echo '<option value="'.$i.$ad.'">Mes '.$i.'</option>
';
$ad="";
}

echo '</select><select name="dia">';
for ($i=1; $i<= 31;$i++)
{
if ($i == date("d",$fecha)) $ad = '" selected="selected';
echo '<option value="'.$i.$ad.'">Dia '.$i.'</option>
';
$ad="";
}
echo '</select>';
echo '
<br/><br/>
<input class="btn" type="submit" name="btn_sub" value="Enviar" />
';
}
function footer()
{
	echo '<strong>Sistema de noticias v1.1 - Tierras del sur &copy; </strong>
</body>
</html>';
}
?>