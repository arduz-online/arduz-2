<?php
$page['title']='Arduz Online - Parches';
$page['desc']='Sitio de descarga de Arduz AO. Descargar cliente, Parches y solucionadores de problemas de el juego.';
$page['keys']='descargar ao, descargar arduz, descargar argentum, bajar arduz';
template_header(2);
?>
<div class="margen_">
<?php echo get_header_title_cases('Parches',24,'h1');?>
<div class="ma20">
<?php echo get_header_title_cases('Nuevo Updater',4,'h2');?>
<div style="clear:both;"></div>
<span class="ma20">
<form id="formulario" method="GET" action="http://ao.noicoder.com/updates/updater.zip">
<label style="padding-top:8px;">Mirror Noicoder.com</label><input type="submit" id="Submit" value="Descargar"/>
</form>
</span>
<?php /*echo get_header_title_cases('Parche 12-06-2009',4);?>
<div style="clear:both;"></div>
<span class="ma20">
<form id="formulario" method="GET" action="http://ao.noicoder.com/updates/12-06.zip">
<label style="padding-top:8px;">Mirror Noicoder.com</label><input type="submit" id="Submit" value="Descargar"/>
</form>
</span>
*/?>
</div>
<br/>
<div style="clear:both;"></div>
</div>
<?php template_footer(); ?>