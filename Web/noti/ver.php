<?php
require_once("seguro.php");
theme_header("NOTICIAS TDS");
if (isset($_REQUEST['salir']))
{
session_destroy();
echo '<script>var t=setTimeout("window.location = \'http://www.tierrasdelsur.cc/\'",500);</script><big>Espere por favor...</big>';
footer();
exit();
} 
if ($_SESSION["noti"]!="SI") {
	echo("Acceso denegado.");
	theme_header("LOGIN");
	theme_login();
	footer();
	exit();
} else {
if (isset($_POST['mostrar']) && isset($_POST['cuantas']))
{
guardarnoticias(intval($_POST['cuantas']));
echo '<b style="color:green;">Datos guardados correctamente.</b><br/>';
}
echo '<form action="ver.php" method="post"><select name="cuantas"><option value="5">Mostrar 5 en la página principal</option><option value="4">Mostrar 4 en la página principal</option><option value="3">Mostrar 3 en la página principal</option><option value="2">Mostrar 2 en la página principal</option><option value="1">Mostrar 1 en la página principal</option></select><input type="submit" value="Cambiar" name="mostrar" style="width:100px;"/></form>';

	echo '<br/><big>Logeado como: <b>'.$_SESSION['nick'].'</b></big> | <a href=\'add.php\'>NEW POST</a> | <a href="ver.php?salir='.$_SESSION['nick'].'" title="Salir">Salir</a><br/><br/><div style="width:400px;">';
	$res_id = exec_sql("SELECT * FROM `noticias` ORDER BY `date` DESC");
	$i = 0;
	while ($row = mysql_fetch_array($res_id)) {
		$name = $row['name'];
		/*$tito = $row['titulo'];
		if (strlen($row['completa'])>0){
			$tito = '<a title="Leer noticia completa" href="leernoticia.html?n='.$row['id'].'.LEER-POR-PANEL">'.$tito;
			$tito .=  '</a>';
		}
		$mensaje = BBcode($row['msg']);
		echo "<div>
<b><big>".$tito."</big></b>
<p>" . $mensaje . "</p>
<span>". date("d-m-y",$row['date']) ." Hora:". date("H:i",$row['date']) ."</span> -  Por: <span class='dato'>" . $name . "</span>
</div><a href=\"edit.php?idx=". $row['id'] ."\" title=\"Editar\">Editar</a><br/><br/><br/>
";*/
		$date = $row['date'];
		$linx = urls_amigables($row['titulo']);
		$tito = $row['titulo'];
		$tito = '<a title="Leer m&aacute;s, '.$row['titulo'].'" href="leernoticia.html?n='.$row['id'].'.'.$linx.'">'.date("d-m-Y",$row['date']).' '.$tito.'</a> - [<a href="edit.php?idx='. $row['id'] .'" title="Editar">E</a>] [<a href="borrar.php?idx='. $row['id'] .'" title="Borrar">B</a>]<br />
';
		echo $tito;
	}
}
echo "</div>";
footer();
?>
