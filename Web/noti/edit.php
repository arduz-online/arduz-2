<?php
require_once("seguro.php");
theme_header("EDITAR NOTICIA");
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
				$mensaje = $row['msg'];
				if (isset($row['completa'])) $com = $row['completa'];
			} else {
				$error = true;
			}
		} else {
			$error = true;
		}

		if(isset($_POST['btn_sub']) && $error == false) {
			$msg = trim($_POST['msg']);
			$completa = trim($_POST['completa']);
			$titulo = trim($_POST['tit']);
			$name = $_SESSION['nick'];
			if (isset($_POST['fecha'])){
				$date = mktime(date("H",$row['date']), date("i",$row['date']), 0, $_POST['mes'],$_POST['dia'],$_POST['ano']);
		    } else {
				$date = time();
			}
		    
		    if (empty($msg) || empty($titulo)) {
				$error = true;
		    }
			$nri=array("\\\r\\\n","\\\n","\\\r");
		    $nrr=array("\r\n","\n","\r");
			$completa = str_replace($nri,$nrr,$completa);
			$msg = str_replace($nri,$nrr,$msg);
			
		    if (!$error) {
				// insert data
				exec_sql('UPDATE `noticias` SET `msg` = \'' . $msg . '\', `titulo` = \''.$titulo.'\', `completa` = \''.$completa.'\', `date` = \''.$date.'\' WHERE `noticias`.`id` = '.$idx.' LIMIT 1;');
				echo '<b>LISTO, NOTICIA EDITADA!</b><br/><script>var t=setTimeout("window.location = \'ver.php\'",500);</script>';
				guardarnoticias();
		    }
		}
	}
	
	$comx = $com;
	$titox = $tito;
	$mensajex = $mensaje;
	
	if ($error && isset($_POST['btn_sub'])) {
		echo '
<b style="color:#ff1111;">Ha ocurrido un error</b><br/>
';
	} else {
		if (isset($_POST['btn_sub'])){
			$comx = $completa;
			$titox = $titulo;
			$mensajex = $msg;
		}
	}
	echo '<form style="margin:0;padding:0;" action="edit.php?idx='.$_REQUEST['idx'].'" method="post" name="form">
';
	formulario($titox,$idx,$mensajex,$comx,$row['date']);
	echo '
</form>';
}
footer();
?>