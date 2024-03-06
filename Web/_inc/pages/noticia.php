<?php 
	include 'noti/seguro.php';
	
	function getMetaDescription($text){//returns a text with a proper meta description
		$text = strip_tags($text);//erase possible html tags
		$text = str_replace (array('\r\n', '\n', '+','<br/>','<br />'), ' ', $text);//replace possible returns
		$text = str_replace ('"', '', $text);//replace possible returns
		$text = substr($text, 0, 220);//we need only 220 characters
		return $text."...";
	}
	
	$id=intval($_GET['cual']);
	if( $id>0 ){
		$res_id = $database->query("SELECT * FROM `noticias` WHERE `id`='".$id."' LIMIT 1");
		$numero = mysql_num_rows($res_id);
		if($numero > 0){
			$row = mysql_fetch_array($res_id);
			$tito = $row['titulo'];
			$mensaje = BBcode($row['msg']);
			if (strlen($row['completa'])>0) $mensaje .= "<hr/><p>" . BBcode($row['completa']);
			$buff = get_header_title_cases($tito,3,'h1').get_header_title_cases($mensaje{0},8).'<p class="lead">'.substr($mensaje, 1).'</p><br/><small style="color:#9A8972;font-size:8pt;"><em>'. date("d-m-Y",$row['date']) .' ' . ucfirst($name) . '</em></small>';
		} else {
			$buff = 'Error en la noticia.';
		}
		$page['header'] .= '<a href="noticia.php" title="Historial de noticias">Historial de noticias</a>';
		$page['title']='Arduz Online - '.$tito;
		$page['desc']=getMetaDescription($mensaje);
		template_header(2);
		echo '<div id="noticias">',$buff,'</div>';
	} else {
		$page['title']='Arduz Online - Historial de noticias.';
		template_header(2);
		echo '<div id="noticias">';
		readfile('_content/hist_news.html');
		echo '</div>';
	}
	template_footer();
?>