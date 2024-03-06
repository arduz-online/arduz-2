<?php
require_once("seguro.php");
theme_header("BORRAR NOTICIA");
if ($_SESSION["noti"]!="SI") {
	echo("Acceso denegado.");
	footer();
	exit();
} else {
	$error = false;
	if (isset($_REQUEST['idx']))
	{
	$idx = $_REQUEST['idx'];
		if (intval($idx)>0)
		{
			$res_id = exec_sql("SELECT * FROM `noticias` WHERE `id`='".$idx."' LIMIT 1");
			$numero = mysql_num_rows($res_id);
			if ($numero > 0)
			{
				$row = mysql_fetch_array($res_id);
				$tito = $row['titulo'];
			} else {
				$error = true;
			}
		} else {
			$error = true;
		}

		if(isset($_POST['btn_sub']) && $error == false && isset($_POST['borrar'])) {
				exec_sql('DELETE FROM `noticias` WHERE `noticias`.`id` = '.$idx.' LIMIT 1;');
				echo '<b style="color:green;"><big>NOTICIA BORRADA CORRECTAMENTE...</big></b><br/><script>var t=setTimeout("window.location = \'ver.php\'",1500);</script>';
				guardarnoticias();
				$error = true;
		}
	}
	if (!$error)
	echo '<form style="margin:0;padding:0;" action="borrar.php" method="post" name="form"><input type="checkbox" name="borrar" style="width:12px;"/>&iquest;Seguro querés borrar la noticia "'.$row['titulo'].'"?
<input value="'.$idx.'" type="hidden" name="idx"/><input type="submit" name="btn_sub" value="BORRAR" />
</form>';
}
footer();
?>