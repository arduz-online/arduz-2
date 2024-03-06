CREATE TABLE `noticias` (
  `id` int(6) NOT NULL auto_increment,
  `name` varchar(200) NOT NULL default '',
  `msg` text NOT NULL,
  `date` int(15) NOT NULL default '0',
  `titulo` varchar(50) NOT NULL,
  `completa` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

INSERT INTO `noticias` (`id`, `name`, `msg`, `date`, `titulo`, `completa`) VALUES
(8, 'menduz', '¡Así es! Una vez más TDS supera un nuevo record de usuarios, ya superamos los 900, exactamente 905!. Un número realmente increible. ¡Ahora vamos por los 1.000!. Es [b]muy[/b] importante destacar que según testimonios de usuarios [u]NO[/u] había lag.\r\nAprovechamos tambíen para contarles que, como habran notado, en estos últimos días bajaron la cantidad de noticias posteadas por día. Esto se debe a que el sistema de noticias se encuentra offline debido a que por este sistema ingresaron los hackers el fin de semana pasado al servidor. Esto va a seguir así hasta que tengamos nuestro nuevo sistema de noticias 100% propio. Esperamos que sea en unos días.\r\nTambíen nos encontramos trabajando en un nuevo y mejorado sistema de soporte para usuarios, la nueva versión del MercadoAo con 2x1 (por ej) y un parche del juego entre otras cosas..', 1222890420, 'Y un día... ¡900 online!', '');
