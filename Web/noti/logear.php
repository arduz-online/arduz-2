<?php
session_start() ; 
include("permisos.php");
for ($i=1;$i<=count($gms);$i++) {
	if (strtoupper ($gms[$i])==strtoupper ($_POST['personaje']) && $passwords[$i]==md5($_POST['password'])) {
		session_register("noti");
		$_SESSION['noti']="SI";
	//	echo "el pj es ".$_POST['personaje'];
		$_SESSION['nick']=$_POST['personaje'];
		//Escribo en el log
		$contenido="</br>Se logueo".$_POST['personaje']." Fecha ".date('d')."/".date('m')."/".date('Y')."  ".date('g').":".date('j')." Desde la ip ".$_SERVER['REMOTE_ADDR'];
		$archivo="loguesopanel.html";
		$fch= fopen($archivo, "a"); // Abres el archivo para escribir en él
		fwrite($fch, $contenido); // Grabas
		fclose($fch); // Cierras el archivo.
		//dejo deescribir
		include("panela.php");	
		exit();
	}
}
//echo("HolitaaaaaaaaaaaaaaaaaaasS!!!!!!. Como estas bombon??? Todo bien precioso??? Te crees que soy idiota??? Por que no te venis a la reunion??? Si queers te pago el viaje todo de onda. Agregame haci hacemos una linda charlita queres???.");
echo ("No se pudo conectar con la base de datos...");
		//Escribo en el log
		$contenido="</br>NO PUDO LOGUEAR ERROR".$_POST['personaje']." Fecha ".date('d')."/".date('m')."/".date('Y')."  ".date('g').":".date('j')." Desde la ip ".$_SERVER['REMOTE_ADDR'];
		$archivo="loguesopanel.html";
		$fch= fopen($archivo, "a"); // Abres el archivo para escribir en él
		fwrite($fch, $contenido); // Grabas
		fclose($fch); // Cierras el archivo.
		
?>