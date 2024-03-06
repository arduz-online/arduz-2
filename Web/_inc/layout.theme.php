<?php
$theme_type=1;
$Dida=0;
function template_header($type=1){
	global $page,$theme_type,$session,$urls;
	$theme_type=(int)$type;
	
	//<!DOCTYPE html SYSTEM "</?php echo $urls[2];/?/>xhtml1-strict-arduz.dtd">
?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html lang="es-AR" xmlns="http://www.w3.org/1999/xhtml" xml:lang="es-AR">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="Content-Language" content="es" />
<title><?php echo $page['title'];?></title>
<meta name="keywords" content="AO, Arduz, Online, Arduz AO, Arduz Online, AO, aotds, argentum, menduz, noicoder, agites, aocs, aostrike, clicknplay, click and play, Quest, Juego Online, Mi Cuenta, Inicio, Ranking, Ranking de personajes, Honor, Servidor Argentum Online, Servidor Argentum, Servidor AO, Server Argentum Online, Server Argentum, Server AO, mmorpg, rol"/>
<meta name="description" content="<?php echo ($page['desc']?$page['desc']:'Arduz AO es un juego online basado en Argentum Online que te da muchas posibilidades, como crear tu propio servidor. Es un click and play PvP del famoso MMORPG');?>"/>
<meta name="abstract" content="Arduz Online es un juego online del tipo MMORPG basado en Argentum Online."/>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<meta name="revisit-after" content="2 days" />
<meta name="robots" content="ALL,INDEX,FOLLOW" />
<meta name="distribution" content="global" />
<meta name="language" content="spanish" /> 
<link rel="index" href="<?php echo $urls[1];?>" title="Arduz Online" />
<link rel="alternate" type="application/rss+xml" title="Arduz Online - RSS" href="http://www.arduz.com.ar/arduz.xml" />
<link rel="sitemap" href="http://www.arduz.com.ar/sitemap.xml" />
<meta http-equiv="imagetoolbar" content="false" />
<link href="<?php echo $urls[2];?>style.css" type="text/css" rel="stylesheet" media="all"/>
<link href="<?php echo $urls[2];?>gh.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="<?php echo $urls[2];?>_js/jquery.js"></script>
<script type="text/javascript" src="<?php echo $urls[2];?>_js/ft.js"></script>
<script type="text/javascript">var mediactx = '<?php echo $urls[2]; ?>';var ctx = '<?php echo $urls[2]; ?>';var fontctx = '<?php echo $urls[2]; ?>_flash/';</script>
<script type="text/javascript" src="<?php echo $urls[2];?>_js/functions.js"></script>
<link rel="shortcut icon" href="<?php echo $urls[1];?>favicon.ico" type="image/x-icon" />
<link rel="icon" href="<?php echo $urls[1];?>favicon.ico" type="image/x-icon" />
<?php if($page['head']){ echo $page['head'],'
';}

//if($session->logged_in):

?>
<style type="text/css">#menul li a,#menul li a:hover,#menul li:hover a{color:#000!important;};</style>
<?php

//endif;

?>
</head>
<body>
<?php if(eregi('MSIE 6\.[0-9]+', $_SERVER['HTTP_USER_AGENT'])){?><div id="noIE6" style="background:#432; border: solid 1px #732;margin:3px 3px 0 3px; padding: 5px;color:#a98;font-family:arial,tahoma,verdana">
La versi&oacute;n de Internet Explorer que est&aacute;s utilizando es obsoleta y &eacute;ste(y muchos m&aacute;s) sitios no funcionan en esta, te recomendamos actualizar
a la <u><a href="http://www.microsoft.com/windows/products/winfamily/ie/default.mspx">&uacute;ltima
versi&oacute;n</a></u> o puedes utilizar otros navegadores como <u><strong><a href="http://www.mozilla.com">Firefox
</a></strong></u>, <u><a href="http://www.apple.com/safari/">Safari</a></u> o
<u><a href="http://www.google.com/chrome">Chrome</a></u>.
</div>
<?php } ?>
<noscript><div><b id="err">Este sitio necesita JavaScript para funcionar.</b></div></noscript>
<div id="Arduz_Online">
	<div id="header"><div id="menu_loader" style="display:none;"></div>
	<div id="menu">
		<ul id="menul">
			<li class="lkp">
				<a title="Inicio Arduz Online" href="<?php echo $urls[1];?>" rel="index" id="inicio">Inicio<span class="lkp mz"></span></a>
			</li>
			<li class="lkm">
				<a href="<?php echo ($session->logged_in?'panel.php':$urls[1].'mi_cuenta.php');?>" title="Mi cuenta" rel="account" id="mi_Cuenta">Mi cuenta<span class="lkm mz"></span></a>
			</li>
			<li class="lkd">
				<a href="<?php echo $urls[1];?>descargar.php" title="Descargar" id="descargar" rel="download">Descargar<span class="lkd mz"></span></a>
			</li>
			<li class="lkr">
				<a href="<?php echo $urls[1];?>ranking.php" title="Ranking" id="ranking">Ranking<span class="lkr mz"></span></a>
			</li>
		</ul>
	</div>
<?php if($page['header']){echo '<div class="clear"></div><div id="contenido_head">',$page['header'],'</div>';};?>
</div>
<?php if( $theme_type===1 ){?>
<div id="t1">
<div id="back_repeat">
<div id="container1">
<div id="content_ly2">
<div id="ly2r">
<?php } else { ?>
<div id="t2">
<div id="back_repeat">
<div id="container1">
<div id="content_ly2">
<div id="container2">
<?php }
}
function template_divisor(){
?></div><div id="ly2l"><?php
}
function template_menu(){
	global $session;
	echo get_header_title_cases( $session->username,23);
?>
<div id="toolbox">
<a href="panel.php">Panel principal</a><br/>
<a href="perfil.php">Perfil</a><br/>
<!--<a href="panel.php">Guerras</a><br/>
<a href="panel.php">Facciones</a><br/>-->
<?php if($session->userinfo['GM']>1) echo '<b><a href="007admin.php">Panel <b>GM</b></a></b><br/>'; ?>
<a href="crear-clan.php">Clan</a><br/>
<a href="acc.php"><b>Salir</b></a>
</div><div class="clear"></div>
<?php
}
function template_footer(){
global $theme_type,$database,$version;
?>
</div><div class="clear"></div></div><?php if($theme_type===2){ ?></div><?php } ?></div><div class="clear"></div><div id="pre_footer"></div></div>
<div id="footer_tela" role="contentinfo"><div id="copyright">Arduz Online 2009 &copy; | <a href="http://foro.arduz.com.ar" target="_blank" rel="nofollow">Foro</a> | <a href="equipo.php" rel="staff" title="Staff">El Equipo</a> | <a href="estadisticas.php" rel="servers" title="Servidores">Servidores</a> | <a href="http://www.arduz.com.ar/" title="Arduz Online" rel="index"><acronym title="Arduz Online" role="definition">AO</acronym></a> | <a href="ayuda.php" rel="help" title="Ayuda">Ayuda</a> | <a href="manual.php" title="Manual de Arduz AO">Manual</a><br/><small><?php echo gentime(),'ms ',$database->num_q,'c <a href="version.php" title="changelog">v',$version;?></a></small></div></div></div>
</div>
<p id="tooltip"></p>
<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src=\'" + gaJsHost + "google-analytics.com/ga.js\' type=\'text/javascript\'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
try {
var pageTracker = _gat._getTracker("UA-4202031-2");
pageTracker._trackPageview();
} catch(err) {}
</script>
</body>
</html>
<?php
}

function get_header_title_cases($text='menduz',$style=1,$tipo='div',$rnda=false)
{
global $urls,$Dida;
	$style=(int)$style;

	if($rnda!==false){
		$Dida = 1000+rand(1,999999);
		$Did=$Dida;
	} else {
		$Dida++;//=$Did.rand(1,123456);
		$Did=$Dida-1;
	}

	return '<'.$tipo.' id="flashtextdiv_'.$Did.'" class="flashtext" estilo="'.$style.'">'.$text.'</'.$tipo.'>';
}


/*
function get_header_title($text='menduz',$size='34',$color1="734800",$color2="ffe2b0",$opacity='100',$font='font_exocetlight.swf',$fontid='fntExocetLight',$Did="jo",$letter_spacing='-1',$angle='90',$blend='')
{global $urls;$dominio=$urls[2].'_flash';
$Did=$Did.rand(1,123456);
return '<div id="'.$Did.'" class="flashtext"><object id="flash_'.$Did.'" height="100%" width="100%" type="application/x-shockwave-flash" data="_flash/flashtext.swf"><param name="movie" value="'.$dominio.'/flashtext.swf"/><param name="base" value="'.$dominio.'/"/><param name="allowScriptAccess" value="always"/><param name="wmode" value="transparent"/><param name="bgcolor" value="#000000"/><param name="menu" value="false"/><param name="quality" value="best"/><param name="flashvars" value="varFlash=divid==='.$Did.'***fontpath==='.$dominio.'/***fontname==='.$font.'***fontid==='.$fontid.'***fontsize==='.$size.'***color1===0x'.$color1.'***color2===0x'.$color2.'***letterspacing==='.$letter_spacing.'***noflash==='.$text.'***flashtext==='.$text.'***gradientangle==='.$angle.'***blendmode==='.$blend.'***opacity==='.$opacity.'"/>'.$text.'</object></div>';}*/