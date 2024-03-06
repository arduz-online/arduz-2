<?php
if($session->logged_in){
	if($session->numpjs > 0){
		if($session->userinfo['GM']<255) exit();
		
		include '_inc/game.logic.php';
		$page['title']='Arduz Online - Panel GM - BALANCE';	
		template_header();
		echo '<span class="pj">',get_header_title_cases('PANEL GM ARDUZ',22),'</span>';
		
		echo '
		<div class="ma20">
			<a href="007adminitems.php">Editar items.</a><br/>
			<a href="007adminbalance.php">Editar balance.</a><br/>
			<a href="007adminbans.php">Baneos.</a><br/>
		</div>';
		
		echo '<div class="clear"></div><br/>&nbsp;<div class="clear"></div>';
		template_divisor();
		template_menu();
		template_footer();
	} else header('Location: panel.php');
} else go_login_page();
?>