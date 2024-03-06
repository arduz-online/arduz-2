<?php
	$page['title']='Registrar usuario en Arduz';
	$page['head']='<link href="'.$urls[2].'recaptcha.css" type="text/css" rel="stylesheet" />';
	
	if($session->logged_in){
	   header('Location: panel.php');
	   exit;
	}
	
	template_header(2);
	echo '<div id="Regsitrarme-en-arduz" class="margen_">',get_header_title_cases('Registrar usuario en Arduz',24);
	require_once('_inc/form.php');

	if( isset($_SESSION['regsuccess']) ){
	   /* Registration was successful */
	   if($_SESSION['regsuccess']){
		  echo '<b id="oka">Gracias <u>'.$_SESSION['reguname'].'</u>, tu cuenta fue registrada correctamente. Ahora pod&eacute;s <a href="mi_cuenta.php"><em>ingresar.</em></a></b>';
	   }else{
		  echo '<b id="err">Por un error de sistema no se pudo registrar tu usuario, por favor intenta en otro momento.</b>'.$_SESSION['error'];
	   }
	   unset($_SESSION['regsuccess']);
	   unset($_SESSION['reguname']);
	} else {
		if($form->num_errors > 0){
		   echo '<b id="err">Ocurrieron '.$form->num_errors.' errores</b>';
		}
		require_once('_inc/recaptchalib.php');
?>
<form action="index.php?a=acc" method="POST" id="formulario">
<label for="name">Usuario:</label><span><span class="input"><input type="text" name="user" id="name" maxlength="28" value="<?php echo $form->value("user"); ?>"/></span><?php echo $form->error("user"); ?></span><div class="clear"></div>
<label for="pass">Contrase&ntilde;a:</label><span><span class="input"><input type="password" name="pass" id="pass" maxlength="28" value="<?php echo $form->value("pass"); ?>"/></span><?php echo $form->error("pass"); ?></span><div class="clear"></div>
<label for="email">EMail:</label><span><span class="input"><input type="text" name="email" id="email" maxlength="50" value="<?php echo $form->value("email"); ?>"/></span><?php echo $form->error("email"); ?></span><div class="clear"></div>
<label for="epin">Clave PIN:</label><span><span class="input"><input type="text" name="pin" id="pin" maxlength="28" value="<?php echo $form->value("pin"); ?>"/></span><?php echo $form->error("email"); ?></span><div class="clear"></div>
<input type="hidden" name="subjoin" value="1"/><label></label>
<span>
<?php
		$error = $form->error('captcha');
		echo recaptcha_get_html('6LeQcQYAAAAAANiWJn1fmEuGfhcJFPv1lk5_CyPL', $error);
?>
</span>
<input type="hidden" name="referer" value=""/>
<label></label><span><input type="submit" value="Continuar &gt;" id="Submit"/></span>
</form>
</div>
<?php 
	}
	template_footer();
?>