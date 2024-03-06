<?php
$page['title']='Arduz Online - Mi cuenta';
$page['head']='<meta name="robots" content="noindex " />';
include('_inc/form.php');
$form = new Form;
template_header(2);
if($session->logged_in){
	header('Location: panel.php');
	exit();
}
else
{
?>
<div id="Ingresar" class="margen">
<?php 
echo get_header_title_cases('Ingresar a Arduz',24);

if($form->num_errors > 0){
   echo '<b id="err">'.$form->num_errors.' error(es)<br/>', $form->error("user"), '<br/>', $form->error("pass"),'</b>';
}

if( isset($_SESSION['regsuccess']) ){
   /* Registration was successful */
   if($_SESSION['regsuccess']){
	  echo '<b id="oka">Gracias <u>'.$_SESSION['reguname'].'</u>, tu cuenta fue registrada correctamente.</b>';
   }else{
	  echo '<b id="err">Por un error de sistema no se pudo registrar tu usuario, por favor intenta en otro momento.</b>'.$_SESSION['error'];
   }
   unset($_SESSION['regsuccess']);
   unset($_SESSION['reguname']);
}

if( !preg_match( '![^a-zA-Z0-9/+=]!', $_GET['url'] ) )
    $urlto = base64_decode( $_GET['url'] ); 
if(stripos($urlto,'acc.php')!==false)$urlto='';
$urlto = htmlentities($urlto, ENT_QUOTES);

?>
<form action="acc.php" method="POST" id="formulario">
<label for="user">Usuario:</label>
<span class="input">
<input type="text" name="user" id="user" value="<?php echo $form->value("user");?>" maxlength="27" class="t"></span>
<div style="clear:both;"></div>
<label for="pass">Contrase&ntilde;a:</label>
<span class="input"><input type="password" name="pass" id="pass" maxlength="27" value="<?php echo $form->value("pass"); ?>"></span>
<div style="clear:both;"></div>
<label for="remember">Recordar contrase&ntilde;a</label>
<input type="checkbox" id="remember" name="remember" <?php if($form->value("remember") != ""){ echo "checked"; } ?>>
<input type="hidden" name="sublogin" value="1"/>
<input type="hidden" name="url" value="<?php echo $urlto;?>"/><div style="clear:both;"></div>
<label></label><input id="Submit" type="submit" name="submit" value="Ingresar">
<div style="clear:both;"></div>
<br/><label for="regg">&iquest;No est&aacute;s registrado?</label><a href="reg.php" id="regg"><b>Registrar usuario!</b></a><div style="clear:both;"></div>
<br/><label></label><a href="recordar.php">Recuperar contrase&ntilde;a.</a><div style="clear:both;"></div>
</form>
</div>
<?php 
template_footer();
} ?>