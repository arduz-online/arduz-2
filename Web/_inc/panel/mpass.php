<?php
if($session->logged_in){
include('_inc/form.php');
 template_header(1);
$_SESSION['url']='mpass.php';
if(isset($_SESSION['useredit'])){
   unset($_SESSION['useredit']);
   
   echo "<h1>Cuenta editada correctamente!</h1>";
   echo "<p><b>$session->username</b>, Tu cuenta fue actualizada correctamente.</p>";
} else {
?>
<div class="ma20">
<?php echo get_header_title_cases('Editar cuenta',4);?>
</div><div class="ma20">
<?php
if($form->num_errors > 0){
   echo "<td><font size=\"2\" color=\"#ff0000\">".$form->num_errors." error(s) found</font></td>";
}
?>
<form action="acc.php" method="POST" id="formulario">
<label>Contraseña actual:<?php echo $form->error("curpass"); ?></label><span class="input">
<input type="password" name="curpass" maxlength="30" value="<?php echo $form->value("curpass"); ?>"/></span>
<div class="clear"></div>
<label>Nueva contraseña:<?php echo $form->error("newpass"); ?></label><span class="input">
<td><input type="password" name="newpass" maxlength="30" value="<?php echo $form->value("newpass"); ?>"/></span>
<div class="clear"></div>

<label>Email:<?php echo $form->error("email"); ?></label><span class="input">
<input type="text" name="email" maxlength="50" value="<?php
if($form->value("email") == ""){
   echo $session->userinfo['email'];
}else{
   echo $form->value("email");
}
?>"></span>
<div class="clear"></div>
<input type="hidden" name="subedit" value="1">
<input type="submit" value="Guardar cambios" id="Submit">
</form>
</div>
<?php
}
template_divisor();
template_menu();
template_footer();
}
?>


