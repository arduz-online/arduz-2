<?php
header('HTTP/1.1 301 Moved Permanently');
if(strlen($_REQUEST['a'])>0){
	header('Location: http://www.arduz.com.ar/'.$_REQUEST['a'].'.php');
} else {
	header('Location: http://www.arduz.com.ar/');
}
?>