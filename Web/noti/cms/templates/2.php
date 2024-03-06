<?php
// FAQs
function ver_lista(){
	$r = obtener_entradas(2);
	$cat = -1;
	$buffer = '';
	$buffer1 = '<a title="arriba"></a><div class="tit_faq">Preguntas frecuentes</div>';
	$num=0;
	while($entrada = mysql_fetch_array($r)){
		if($cat != $entrada['cat_nom']){
			$cat = $entrada['cat_nom'];
			if($num>0) $buffer1 .= '</ul>';
			$num++;
			$buffer1 .= '<div class="tit_cat">'.$cat.'</div><ul class="lista_faq">
		';
		}
		
		$buffer1 .= '<li><a href="#faq_'.$entrada['ID'].'">'.$entrada['titulo'].'</a></li>
		';
		
		$buffer .= '<div class="tit_resp"><a title="faq_'.$entrada['ID'].'"></a>
		'.$entrada['titulo'].'</div><div class="tit_resp1"><p>'.BBcode($entrada['txt']).'</p> <a href="#arriba" class="faqlink">Subir</a></div><br/>';
	}
	$buffer1 .= '</ul><div class="tit_faq">Respuestas</div>'.$buffer;
	return $buffer1;
}
//echo ver_lista();
?>