<?php
$page['title']='Arduz Online - Descargar';
$page['desc']='Sitio de descarga de Arduz AO. Descargar cliente, Parches y solucionadores de problemas de el juego.';
$page['keys']='descargar ao, descargar arduz, descargar argentum, bajar arduz';
template_header(2);
?>
<div class="margen_">
<?php echo get_header_title_cases('Descargar Arduz Online',24,'h1');?>
<div style="clear:both;"></div>
<div class="ma20">
<?php echo get_header_title_cases('Cliente completo',4,'h2');?>
<div style="clear:both;"></div>

<div class="ma20">
<form id="formulario" method="GET" action="http://www.4shared.com/file/140460861/7c4bcbb7/Arduz_II.html">
<label style="padding-top:8px;">Mirror 4Shared</label><input type="submit" id="Submit" value="Descargar"/>
</form>
<small style="margin-left:181px"><em>Actualizado: 10-12-2009</em></small>
</div>
<br/>
<?php echo get_header_title_cases('Solucionador de runtimes experimental',4);?>
<div style="clear:both;"></div>
<div style="padding:5px;"><small><em><strong>Ejecutar y presionar omitir hasta que termine.</strong><br />Esto significa que algunos archivos estan instalados ya.</small></em></div>
<div class="ma20">
<form id="formulario" method="GET" action="http://www.4shared.com/file/166176432/f81c42b4/ArduzProblemas.html">
<label style="padding-top:8px;">Mirror 4Shared</label><input type="submit" id="Submit" value="Descargar"/>
</form>
</div>
<br/><br/>
<?php echo get_header_title_cases('Librerias necesarias para jugar (WINDOWS 2000)',4);?>
<div style="clear:both;"></div>
<div class="ma20">
<form id="formulario" method="GET" action="http://www.4shared.com/file/140472659/c44adc77/Redist.html">
<label style="padding-top:8px;">Mirror 4Shared</label><input type="submit" id="Submit" value="Descargar"/>
</form>
</div>
<br/><br/>
<?php echo get_header_title_cases('DirectX 9',4);?>
<div style="clear:both;"></div>
<div class="ma20">
<!--<em>Para solucionar errores A1.0, A1.1 y A1.2 en Windows 2000, XP, Vista y Windows 7</em>-->
<form id="formulario" method="GET" action="http://www.microsoft.com/downloads/details.aspx">
<input type="hidden" name="displaylang" value="en"/>
<input type="hidden" name="FamilyID" value="0CEF8180-E94A-4F56-B157-5AB8109CB4F5"/>
<label style="padding-top:8px;">Mirror Microsoft.com</label><input type="submit" id="Submit" value="Descargar"/>
</form>
</div>
<br/><br/><!--
<?php echo get_header_title_cases('Parches',4);?>
<div style="clear:both;"></div>
<div class="ma20">
<form id="formulario" method="GET" action="http://www.arduz.com.ar/parche.php">
<label style="padding-top:8px;"></label><input type="submit" id="Submit" value="Ver Parches"/>
</form>
</div>
</div>
<br/>-->
<div style="clear:both;"></div>
</div>
<?php template_footer(); ?>