<?php
session_start() ; 
if ($_SESSION["noti"]!=="SI") {
	echo("Acceso denegado.");
	exit();
}
include "ver.php";

?>
