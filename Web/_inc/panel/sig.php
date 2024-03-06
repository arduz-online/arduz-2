<?php
$page['title']="Arduz Online - Panel - Firmas para foros";
$page['header'] .= '<h1 style="margin-top:10px;">Panel del personaje</h1><a href="?a=panel"><b>Volver al panel</b></a> | <a href="?a=salir"><b>Salir</b></a>';
template_header();
if ($_SESSION['loggedE']=="1")
{
?>
<div style="clear:both;">
</div>
<div class="caja">
	<div class="caja_b">
		<div id="Inicio">
		<h2>Firmas para foros</h2>
<?php
//print_r($_SESSION);
$query = mysql_fetch_array(mysql_query("SELECT * FROM `pjs` WHERE `nick` = '".$_SESSION['Nick']."'"));
if ($query['codigo']!=$_SESSION['passwd'])
{
	$_SESSION['loggedE']="0";$_SESSION['GM']="0";$_SESSION['nick']="";$_SESSION['passwd']="";
	go_login_page();
}
/*print_r ($query);
print_r ($clan);
print_r ($_SESSION);//*/
?>
<br/><br/><a href="http://www.arduz.com.ar/aofirma/<?=$query['ID'];?>.png"><img src="http://www.arduz.com.ar/aofirma/<?=$query['ID'];?>.png"/></a>
<br/>Para foros:<br/><input style="width:100%;" type="text" value="[url=http://www.arduz.com.ar/ao/][img]http://www.arduz.com.ar/aofirma/<?=$query['ID'];?>.png[/img][/url]"/>
		</div>
	</div>
</div>
<?php
	if ($query['GM']=="1" || $query['GM']=="1")
		include "bin/est.php";
template_footer();
} else {
go_login_page();
}
?>