<?php
require_once("seguro.php");
theme_header("AGREGAR NOTICIA");

if ($_SESSION["noti"]!="SI") {
	echo("Acceso denegado.");
	footer();
	exit();
} else {
	$error = false;
  
	if(isset($_POST['btn_sub'])) {
		$msg = trim($_POST['msg']);
		$completa = trim($_POST['completa']);
		$titulo = trim($_POST['tit']);
		$name = $_SESSION['nick'];
		
		if (isset($_POST['fecha'])){
			$date = mktime(0, 0, 0, $_POST['mes'],$_POST['dia'],$_POST['ano']);
	    } else {
			$date = time();
		}
		
	    if (empty($msg) || empty($titulo)) {
			$error = true;
	    }
		
	    if (!$error) {
			// insert data
			exec_sql("INSERT INTO `noticias` (`name`,`msg`,`date`,`titulo`,`completa`) VALUES ('" . $name. "','" . $msg . "','".$date."','".$titulo."','".$completa."');");      
			echo 'LISTO, NOTICIA AGREGADA!<br /><script>var t=setTimeout("window.location = \'ver.php\'",500);</script>';
			guardarnoticias();
	    }
	}

	if ($error && isset($_POST['btn_sub'])) {
		echo '
<b style="color:#ff1111;">Por favor complete todos los campos</b><br />
';
	}
	$nrl=array("\r\n","\n","<br />","<br/>","<br>","\\r\\n","\\n","<br />","<br/>","<br>");
	$completa = str_replace($nrl,"
",$completa);
	$msg = str_replace($nrl,"
",$msg);
echo '<form style="margin:0;padding:0;" action="add.php" method="post" name="form">
';
formulario($titulo,"",$msg,$completa,-1);
echo '</form>';
}
footer();
?>