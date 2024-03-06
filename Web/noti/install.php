<?php
require_once("seguro.php");
theme_header("Instalando");
exec_sql('DROP TABLE IF EXISTS `noticias`;');
exec_sql('CREATE TABLE `noticias` (
  `id` int(6) NOT NULL auto_increment,
  `name` varchar(200) NOT NULL default \'\',
  `msg` text NOT NULL,
  `date` int(15) NOT NULL default \'0\',
  `titulo` varchar(50) NOT NULL,
  `completa` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=12 ;
');
echo '<b style="color:green;"><big>Instalacion completa...</big></b><br/><script>var t=setTimeout("window.location = \'ver.php\'",1500);</script>';
footer();
?>