<?php
$page['title']='Arduz Online - Juego de Rol PvP Online Multijugador Gratuito MMORPG';
template_header(2);
?><ul id="index_bar">
<li class="duel_list">
<?php
echo get_header_title_cases('Enlaces rápidos',10);
//echo get_header_title_cases('Últimos duelos entre usuarios',10);
?>
<div class="sumb">
<a href="estadisticas.php">Servidores <span style="color:#0f0;">Online</span></a><br/>
<a href="http://foro.arduz.com.ar" target="_blank" rel="nofollow">Foro</a><br/>
<a href="manual.php">Manual</a><br/>
<a href="ayuda.php">Ayuda</a><br/>
<a href="ranking_clanes.php">Ranking de clanes</a><br/>
<a href="equipo.php">Staff</a><br/>
<a href="noticia.php">Historial de noticias</a><br/>
<a href="ayuda_5.php">Requisitos de sistema</a><br/><!--
	<span class="acao5">Wacho</span> vs <s><span class="acao4">Wicha</span></s> 9 - 3<br/>
	<span class="acao5">ASDSD</span> vs <s><span class="acao25">Menduz</span></s> 4 - 1
</div>
<?php
//echo get_header_title_cases('Últimos duelos entre clanes',10);
?>
<div class="sumb">
	Arduz vs <s><span class="acao4">Wicha</span></s> 9 - 3<br/>
	ASDSD vs <s><span class="acao4">Menduz</span></s> 4 - 1
</div>
--></div></li><li class="armcao"></li></ul>

<div id="noticias"><?php
echo get_header_title_cases('Noticias en Arduz',24,'h1');
readfile('_content/news_estaticas.html');
?>
<h2 style="text-decoration:underline;">
<a href="noticia.php" title="Historial de noticias.">Historial de noticias.</a>
</h2>
</div><?php template_footer(); ?>