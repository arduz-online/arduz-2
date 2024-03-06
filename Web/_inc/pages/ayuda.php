<?php 
	function getMetaDescription($text){//returns a text with a proper meta description
		$text = strip_tags($text);//erase possible html tags
		$text = str_replace (array('\r\n', '\n', '+','<br/>','<br />'), ' ', $text);//replace possible returns
		$text = str_replace ('"', '', $text);//replace possible returns
		$text = substr($text, 0, 220);//we need only 220 characters
		return $text."...";
	}
	
	$id=intval($_GET['cual']);
	
	if( $id>0 ){
		include('noti/cms/cms.class.php');
		init_namespace(0);
		$entrada	= obtener_entrada($id);
		if( $entrada !== false ){
			$tito = $entrada['titulo'];
			$mensaje = BBcode($entrada['txt']);
			$buff = get_header_title_cases($tito,3,'h1').get_header_title_cases($mensaje{0},8).'<p class="lead">'.substr($mensaje, 1).'</p><br/><br/><a href="ayuda.php">Volver a ayuda</a>';
		} else {
			$buff = 'Error en la entrada.';
		}

		$page['title']='Arduz Online - Ayuda - '.$tito;
		$page['desc']='Ayuda de Arduz Online:' . getMetaDescription($mensaje);
		template_header(2);

		echo '<div id="noticias" style="width:630px;">',get_header_title_cases('Ayuda de Arduz Online',24,'h1'),$buff,'</div>';
	} else {
		$page['title']='Arduz Online - Ayuda';
		$page['desc'] = 'P&aacute;gina de ayuda de Arduz Online';
		template_header(2);

		echo '<div id="noticias" style="width:630px;">',get_header_title_cases('Ayuda de Arduz Online',24,'h1');
		readfile('noti/cms/cache/0.html');
		echo '</div>';
	}	
	
	template_footer();
?>