<?php

if($session->logged_in){
$page['title']="Arduz Online - Perfil";
template_header();
echo '<div class="margen_">',get_header_title_cases('Perfil',22),'<!--
<a href="mpass.php">Modificar contraseña</a>-->En construcci&oacute;n.';
echo '</div><div class="clear"></div>';
template_divisor();
template_menu();
template_footer();
} else {
	go_login_page();
}
?>