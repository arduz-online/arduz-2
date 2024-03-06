SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `noicoder_sake`
--

-- --------------------------------------------------------

--
-- Table structure for table `active_guests`
--

CREATE TABLE `active_guests` (
  `ip` varchar(15) NOT NULL,
  `timestamp` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `active_users`
--

CREATE TABLE `active_users` (
  `username` varchar(30) NOT NULL,
  `timestamp` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `active_users`
--

INSERT INTO `active_users` (`username`, `timestamp`) VALUES
('menduz', 1241395650);

-- --------------------------------------------------------

--
-- Table structure for table `aportes_clanes`
--

CREATE TABLE `aportes_clanes` (
  `ID` int(10) UNSIGNED NOT NULL,
  `UID` int(10) UNSIGNED NOT NULL,
  `clan` mediumint(8) UNSIGNED NOT NULL,
  `cantidad` int(10) UNSIGNED NOT NULL,
  `fecha` int(10) UNSIGNED NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `balance_hits`
--

CREATE TABLE `balance_hits` (
  `clase` tinyint(3) UNSIGNED NOT NULL,
  `raza` tinyint(3) UNSIGNED NOT NULL,
  `max` smallint(5) UNSIGNED NOT NULL,
  `min` smallint(5) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `balance_int`
--

CREATE TABLE `balance_int` (
  `clase` smallint(6) UNSIGNED NOT NULL,
  `use_u` mediumint(9) NOT NULL,
  `use_dclick` mediumint(9) NOT NULL,
  `cast_attack` mediumint(9) NOT NULL,
  `cast_spell` mediumint(9) NOT NULL,
  `arrows` mediumint(9) NOT NULL,
  `attack` mediumint(9) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `balance_int`
--

INSERT INTO `balance_int` (`clase`, `use_u`, `use_dclick`, `cast_attack`, `cast_spell`, `arrows`, `attack`) VALUES
(1, 401, 255, 1151, 1051, 1151, 1301),
(2, 401, 241, 1151, 1051, 1151, 1301),
(3, 301, 205, 1151, 1051, 1051, 1350),
(4, 401, 241, 1151, 1051, 1151, 1301),
(6, 401, 241, 1151, 1051, 1151, 1301),
(7, 401, 241, 1151, 1051, 1151, 1301),
(9, 401, 241, 1151, 1051, 1151, 1301),
(10, 350, 205, 1151, 1051, 1151, 1301);

-- --------------------------------------------------------

--
-- Table structure for table `balance_mod`
--

CREATE TABLE `balance_mod` (
  `clase` smallint(5) UNSIGNED NOT NULL,
  `evasion` float NOT NULL DEFAULT 0.81,
  `ataquearmas` float NOT NULL DEFAULT 0.85,
  `ataqueproyectiles` float NOT NULL DEFAULT 0.7,
  `danioarmas` float NOT NULL DEFAULT 0.85,
  `danioproyectiles` float NOT NULL DEFAULT 0.7,
  `daniowrestling` float NOT NULL DEFAULT 0.1,
  `escudo` float NOT NULL DEFAULT 0.8
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `balance_mod`
--

INSERT INTO `balance_mod` (`clase`, `evasion`, `ataquearmas`, `ataqueproyectiles`, `danioarmas`, `danioproyectiles`, `daniowrestling`, `escudo`) VALUES
(10, 0.9, 0.8, 1.1, 0.9, 1.1, 0.1, 0.72),
(3, 1, 1, 0.65, 1.1, 0.8, 0.1, 0.8),
(2, 0.81, 0.85, 0.7, 0.85, 0.7, 0.1, 0.8),
(9, 0.85, 0.85, 0.75, 0.9, 0.8, 0.1, 1),
(4, 1.1, 0.85, 0.75, 0.9, 0.8, 0.1, 0.7),
(6, 1.1, 0.75, 0.7, 0.75, 0.7, 0.1, 0.65),
(1, 0.7, 0.5, 0.5, 0.6, 0.6, 0.1, 0.6),
(7, 0.85, 0.6, 0.7, 0.7, 0.7, 0.1, 0.6);

-- --------------------------------------------------------

--
-- Table structure for table `banned_users`
--

CREATE TABLE `banned_users` (
  `username` varchar(30) NOT NULL,
  `timestamp` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ban_log`
--

CREATE TABLE `ban_log` (
  `ID` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `gm` int(11) NOT NULL,
  `tiempo` int(11) NOT NULL,
  `razon` text NOT NULL,
  `time` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `boveda`
--

CREATE TABLE `boveda` (
  `CuentaID` int(11) UNSIGNED NOT NULL,
  `o1` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o2` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o3` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o4` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o5` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o6` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o7` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o8` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o9` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `o10` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `o11` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `o12` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `o13` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `o14` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `o15` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `o16` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `o17` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `o18` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `o19` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `o20` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `o21` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o22` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o23` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o24` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o25` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o26` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o27` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o28` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o29` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `o30` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t1` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t2` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t3` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t4` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t5` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t6` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t7` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t8` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t9` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t10` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t11` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t12` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t13` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t14` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t15` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t16` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t17` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t18` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t19` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t20` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t21` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t22` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t23` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t24` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t25` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t26` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t27` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t28` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t29` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t30` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `f1` int(11) NOT NULL DEFAULT 0,
  `f2` int(11) NOT NULL DEFAULT 0,
  `f3` int(11) NOT NULL DEFAULT 0,
  `f4` int(11) NOT NULL DEFAULT 0,
  `f5` int(11) NOT NULL DEFAULT 0,
  `f6` int(11) NOT NULL DEFAULT 0,
  `f7` int(11) NOT NULL DEFAULT 0,
  `f8` int(11) NOT NULL DEFAULT 0,
  `f9` int(11) NOT NULL DEFAULT 0,
  `f10` int(11) NOT NULL DEFAULT 0,
  `f11` int(11) NOT NULL DEFAULT 0,
  `f12` int(11) NOT NULL DEFAULT 0,
  `f13` int(11) NOT NULL DEFAULT 0,
  `f14` int(11) NOT NULL DEFAULT 0,
  `f15` int(11) NOT NULL DEFAULT 0,
  `f16` int(11) NOT NULL DEFAULT 0,
  `f17` int(11) NOT NULL DEFAULT 0,
  `f18` int(11) NOT NULL DEFAULT 0,
  `f19` int(11) NOT NULL DEFAULT 0,
  `f20` int(11) NOT NULL DEFAULT 0,
  `f21` int(11) NOT NULL DEFAULT 0,
  `f22` int(11) NOT NULL DEFAULT 0,
  `f23` int(11) NOT NULL DEFAULT 0,
  `f24` int(11) NOT NULL DEFAULT 0,
  `f25` int(11) NOT NULL DEFAULT 0,
  `f26` int(11) NOT NULL DEFAULT 0,
  `f27` int(11) NOT NULL DEFAULT 0,
  `f28` int(11) NOT NULL DEFAULT 0,
  `f29` int(11) NOT NULL DEFAULT 0,
  `f30` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=binary COMMENT='LaG';

-- --------------------------------------------------------

--
-- Table structure for table `chat_clanes`
--

CREATE TABLE `chat_clanes` (
  `ID` int(10) UNSIGNED NOT NULL,
  `nick` varchar(255) NOT NULL,
  `msg` varchar(255) NOT NULL,
  `time` int(11) NOT NULL,
  `clan` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cheat-log`
--

CREATE TABLE `cheat-log` (
  `ID` mediumint(9) NOT NULL,
  `nick` varchar(255) NOT NULL,
  `pcid` varchar(32) NOT NULL,
  `txt` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clanes`
--

CREATE TABLE `clanes` (
  `ID` int(11) NOT NULL,
  `Nombre` varchar(255) NOT NULL,
  `puntos` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `matados` int(11) NOT NULL DEFAULT 0,
  `muertos` int(11) NOT NULL DEFAULT 0,
  `honor` int(10) UNSIGNED NOT NULL,
  `rank_puntos` bigint(20) NOT NULL DEFAULT 0,
  `rank_puntos_old` bigint(20) NOT NULL DEFAULT 0,
  `rank_mm` bigint(20) NOT NULL DEFAULT 0,
  `rank_mm_old` bigint(20) NOT NULL DEFAULT 0,
  `fundador` int(11) NOT NULL,
  `miembros` int(11) NOT NULL,
  `lvl` mediumint(9) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clases`
--

CREATE TABLE `clases` (
  `ID` smallint(5) UNSIGNED NOT NULL,
  `name` varchar(32) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `h1` smallint(5) UNSIGNED NOT NULL,
  `h2` smallint(5) UNSIGNED NOT NULL,
  `h3` smallint(5) UNSIGNED NOT NULL,
  `h4` smallint(5) UNSIGNED NOT NULL,
  `h5` smallint(5) UNSIGNED NOT NULL,
  `h6` smallint(5) UNSIGNED NOT NULL,
  `h7` smallint(5) UNSIGNED NOT NULL,
  `h8` smallint(5) UNSIGNED NOT NULL,
  `h9` smallint(5) UNSIGNED NOT NULL,
  `h10` smallint(5) UNSIGNED NOT NULL,
  `h11` smallint(5) UNSIGNED NOT NULL,
  `h12` smallint(5) UNSIGNED NOT NULL,
  `i1` smallint(5) UNSIGNED NOT NULL,
  `i2` smallint(5) UNSIGNED NOT NULL,
  `i3` smallint(6) UNSIGNED NOT NULL,
  `i4` smallint(6) UNSIGNED NOT NULL,
  `i5` smallint(6) UNSIGNED NOT NULL,
  `i6` smallint(6) UNSIGNED NOT NULL,
  `m0` float UNSIGNED NOT NULL,
  `m1` float UNSIGNED NOT NULL,
  `m2` float UNSIGNED NOT NULL,
  `m3` float UNSIGNED NOT NULL,
  `m4` float UNSIGNED NOT NULL,
  `m5` float UNSIGNED NOT NULL,
  `m6` float UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `clases`
--

INSERT INTO `clases` (`ID`, `name`, `h1`, `h2`, `h3`, `h4`, `h5`, `h6`, `h7`, `h8`, `h9`, `h10`, `h11`, `h12`, `i1`, `i2`, `i3`, `i4`, `i5`, `i6`, `m0`, `m1`, `m2`, `m3`, `m4`, `m5`, `m6`) VALUES
(1, 'Mago', 1, 2, 11, 5, 41, 31, 14, 15, 23, 25, 24, 10, 250, 200, 1150, 1050, 1150, 1200, 0.65, 0.5, 0.5, 0.5, 0.6, 0.2, 0.61),
(2, 'Clérigo', 1, 2, 11, 5, 41, 31, 14, 15, 23, 25, 24, 10, 250, 200, 900, 1050, 1150, 950, 0.8, 0.85, 0.7, 0.85, 0.7, 0.1, 0.8),
(3, 'Guerrero', 1, 2, 11, 5, 41, 31, 14, 15, 23, 25, 24, 10, 275, 200, 1150, 1050, 1050, 1300, 1, 1, 0.9, 1.1, 1.1, 0.1, 0.8),
(4, 'Asesino', 1, 2, 11, 5, 41, 31, 14, 15, 23, 25, 24, 10, 250, 200, 900, 1050, 1150, 950, 1.1, 0.85, 0.75, 0.9, 0.8, 0.1, 0.7),
(5, 'Caballero Oscuro', 22, 34, 11, 42, 41, 22, 14, 15, 23, 32, 24, 10, 200, 100, 800, 950, 950, 850, 0.85, 1.1, 1.1, 1, 1, 1, 1),
(6, 'Bardo', 1, 2, 11, 5, 41, 31, 14, 15, 23, 25, 24, 10, 250, 200, 1050, 1050, 1150, 1200, 1.1, 0.75, 0.7, 0.75, 0.7, 0.1, 0.6),
(7, 'Druida', 1, 2, 11, 5, 41, 31, 14, 15, 23, 25, 24, 10, 250, 200, 1050, 1050, 1150, 1200, 0.75, 0.6, 0.7, 0.7, 0.7, 0.1, 0.6),
(8, 'Nigromante', 16, 2, 45, 46, 41, 22, 14, 15, 23, 25, 24, 10, 0, 0, 0, 0, 0, 0, 10, 10, 2, 10, 2, 1, 10),
(9, 'Paladín', 1, 2, 11, 5, 41, 31, 14, 15, 23, 25, 24, 10, 250, 200, 900, 1050, 1150, 950, 0.85, 0.85, 0.75, 0.9, 0.8, 0.1, 1),
(10, 'Arquero', 3, 2, 11, 5, 41, 31, 14, 15, 23, 25, 24, 10, 300, 200, 1150, 1050, 1100, 1200, 0.9, 0.8, 1, 0.9, 1.1, 0.1, 0.75);

-- --------------------------------------------------------

--
-- Table structure for table `cms1_categorias`
--

CREATE TABLE `cms1_categorias` (
  `ID` mediumint(9) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `namespace` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `cms1_categorias`
--

INSERT INTO `cms1_categorias` (`ID`, `nombre`, `namespace`) VALUES
(1, 'Errores del juego', 0),
(2, 'Cuentas y personajes', 0),
(3, 'Personaje', 1),
(4, 'Problemas Técnicos', 0),
(5, 'Otro', 1),
(6, 'Otro', 0);

-- --------------------------------------------------------

--
-- Table structure for table `cms1_entradas`
--

CREATE TABLE `cms1_entradas` (
  `ID` mediumint(9) NOT NULL,
  `titulo` varchar(255) NOT NULL,
  `txt` text NOT NULL,
  `cat` mediumint(9) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `cms1_entradas`
--

INSERT INTO `cms1_entradas` (`ID`, `titulo`, `txt`, `cat`) VALUES
(1, 'Runtime 0', 'adssdasdasda', 1),
(2, 'Runtine 1', 'asddsaasddsasad', 1),
(3, '¿Cómo crear una cuenta?', ' [h3]Primer Paso[/h3]\r\nEntramos a: [url=http://www.arduz.com.ar]Web de Arduz Online - http://www.arduz.com.ar[/url]\r\n\r\n[h3]Segundo paso[/h3]\r\nVamos a: \"Mi Cuenta\"\r\n\r\n[h3]Tercer Paso[/h3]\r\nClickeamos: \"Registrar usuario!\"\r\n\r\n[h3]Cuarto Paso[/h3]\r\n\r\nCompletamos este simple formulario que aparece en el cual se deben llenar los siguientes campos:\r\n\r\n[b]Usuario[/b]: (Poner nombre de usuario)\r\n\r\n[b]Contraseña[/b]: (Elegir una contraseña)\r\n\r\n[b]Email[/b]: (Ponen su email o uno en el que puedan entrar por si algo le pasa a su cuenta algún día)\r\n\r\n[b]Clave PIN[/b]: (La cual sirve para crear clanes y por seguridad si le pasa algo a la cuenta)\r\n\r\nY abajo ponen las letras que le aparecen en la figura que les aparece\r\n\r\n[h3]Quinto Paso[/h3]\r\n\r\nLuego de completar BIEN ese formulario les va a aparecer para que entren a su cuenta, una vez que entren ingresando el nombre de la cuenta y su correspondiente contraseña podrán ver que les aparece una opción que dice abajo de un texto, el cual da la bienvenida al juego aparece un boton que dice: \"Crear nuevo personaje\"\r\n\r\n[h3]Sexto Paso[/h3]\r\n\r\nLuego de presionar ese botón tiene que elegir la raza del personaje: (Humano (H), Elfo (E), Elfo Oscuro (Eo), Enano (E) o Gnomo (G))\r\n\r\nTambién eligen clase: Mago, Clérigo, Guerrero, Asesino, Bardo, Druida, Paladín, Arquero.\r\n\r\nY su género: Hombre o Mujer\r\n\r\n[h3]Séptimo Paso[/h3]\r\nLuego de elegir eso se ponen un nick a gusto y una cabeza que también les guste y presionan: \"Crear Personaje\"\r\n\r\n[h3]Octavo Paso[/h3]\r\n[b]¡¡Jugar y divertirse!![/b]\r\n\r\nGuia creada por ToMMyy\r\n', 5),
(4, 'Clases', 'C[b]LASES[/b]\r\n\r\n-Mago:\r\nEs la clase por excelencia preferida por muchos de los jugadores. Si te interesan mucho los hechizos y encantamientos, esta clase es la indicada, ya que posee mucha maná. Pero la desventaja de esta clase es el hecho de tener poca vida como también poca evasión, lo que significa que las clases de cuerpo a cuerpo le van a acertar mucho más facilmente los golpes.\r\nVentajas: Mucha maná y la mejor resistencia mágica.\r\nDesventajas: Poca evasión y pocos puntos de vida.\r\n\r\n-Druida:\r\nSacerdotes de la Naturaleza, aprendieron a entrar en armonía con esta y se volvieron poderosos luchadores. Tiene un hechizo especial que consiste en tomar la imagen de alguien y transformarse, esto sirve para confundir a los enemigos, ideal para despistar en una batalla. Aunque no tiene tanta maná como el Mago, está entre las clases que más poseen.\r\nVentajas: Mucho poder mágico y muy buena defensa mágica.\r\nDesventajas: Poca evasión.\r\n    \r\n-Clérigo:\r\nSabios y fuertes, es una clase que se especializa tanto en las artes mágicas como la lucha de cuerpo a cuerpo. Aunque sus golpes no sean tan fuertes puede combinar sus dos especialidades.\r\nAsí como el druida, el clérigo tiene mucho maná, pero no tanto como el Mago.\r\nVentajas: Buena defensa física y Mágica.\r\nDesventajas: No realiza muchos daños.\r\n\r\n-Bardo:\r\nUna clase muy práctica frente a las clases de cuerpo a cuerpo ya que posee una gran evasión lo que resulta difícil para enemigo cuando intente acertarle un golpe.\r\nSus ataques mágicos son muy poderosos aún más cuando usa un ítem especial que le da bonificación de poder mágico.\r\nVentajas: mucho poder mágico y mucha evasión contra golpes.\r\nDesventajas: Poca resistencia mágica.\r\n\r\n-Paladín:\r\nEl paladín es una clase con mucha vida y una gran fuerza, ideal para encuentro contra otra clase que lucha cuerpo a cuerpo ya que sus golpes son algo más débiles que los del guerrero. Una de las desventajas es que su maná que es muy limitada y eso dificulta sus peleas contra clases mágicas.\r\nVentajas: Buena Fuerza, buena defensa cuerpo a cuerpo y muchos puntos de vida.\r\nDesventajas: Poca resistencia mágica, poco mana.\r\n   \r\n-Asesino:\r\nSigiloso y sanguinario, la característica especial de esta clase es APUÑALAR, esto significa que de un golpe podrías dejar a tu enemigo prácticamente muerto, su evasión es la mejor y no conoce el miedo contra quienes intenten pegarle.\r\nVentajas: Mucha evasión, golpe asesino.\r\nDesventajas: Poco maná.\r\n\r\n-Guerrero:\r\nuna clase que no usa magias sino que directamente usa la fuerza y combate cuerpo a cuerpo, sus golpes resultan ser increíblemente devastadores cuando éste se encuentra en su punto más elevado, posee una gran vida pero su desventaja es que no puede usar magias, esto hace que sea una presa fácil si no está acompañado. Aunque siempre puede contar con su velocidad con el arco y la flecha.\r\nVentajas: Muchos puntos de vida, mucho ataque físico, mucha defensa física.\r\nDesventajas: No tiene mana.\r\n\r\n-Arquero:\r\nClase que no usa magia, pero que es muy hábil usando armas a distancias, tiene la habilidad de poder ocultarse entre las sombras cuando éste usa una armadura de cazador, tiene una bonificación de daño crítico para mejorar el rendimiento de su entrenamiento y esto hace que resulte fácil de entrenar. Sus fuertes ataques a distancia, hacen que cualquiera evite acercarse a él, aunque si está solo, el no tener magia le trae muchos problemas.\r\nVentajas: Ataque a distancia de gran poder, habilidad de ocultarse.\r\nDesventajas: No tiene mana. ', 3),
(5, 'Requisitos de sistema para jugar Arduz', ' \r\nEstos son los requisitos mínimos para correr el cliente del juego\r\n- Procesador Intel Pentium III 550 MHz O similar con MMX\r\n- 128 MB de memoria RAM\r\n- Placa de video aceleradora de 8 MB compatible con DirectX 8.1 o superior\r\n- Windows XP o superior\r\n- 500MB libres en el disco', 4),
(6, 'Guia para crear servidor con Hamachi', ' \r\n[h3]¿Por qué me combiene usar Hamachi?[/h3]\r\nHamachi es un programa que transforma una conexión de dos computadoras por internet en una conexión ficticia de LAN. En este caso lo vamos a usar para los que no pueden crear una partida de Arduz, o pueden pero no puede entrar gente.\r\n\r\n\r\n[h3]¿Dónde lo consigo?[/h3]\r\nAntes que nada, nos descargamos el Hamachi desde http://www.hamachi.cc/. Ahí vamos a encontrar, en la página principal, un botón que dice \"Descargar ahora\", que al pulsarlo nos lleva a una pantalla de registro opcional. En esta vamos a encontrar casi al pie las condiciones de uso, que vamos a tener que aceptar después de leerlas, y luego pulsar el botón \"Ir a Descargar\".\r\n\r\nSeguido a esto, nos van a aparecer en pantalla tres \"secciones\", cada una con un sistema operativo. Elegimos el nuestro(Windows en nuestro caso), y el idioma en el que queremos el programa(para el tutorial voy a usar Spanish, o Español), para luego clickear el botón \"Descargar\".\r\n\r\nGuardamos(o si prefieren solo ejecutenla, ya que es sólo el instalador) la descarga donde querramos.\r\n\r\n\r\n[h3]¿Cómo lo instalo?[/h3]\r\nCuando ejecutemos la instalación, nos va a aparecer una pantalla de introducción a la mísma. Clickeamos en el botón \"[u]S[/u]iguiente >\".\r\nSeguido a esto, nos va a dar el acuerdo de la licencia del programa que, después de aceptarla, se nos desbloquea el botón \"[u]S[/u]iguiente >\", que tendremos que clickear.\r\n[img:center]http://img187.imageshack.us/img187/6946/55348444hd4.bmp[/img]\r\n\r\nLa siguiente pantalla es clave. Acá vamos a definir la ubicación de dónde va a estar instalado el Hamachi, el nombre de la carpeta que se creará en el menú Inicio, si deseamos que Hamachi se ejecute siempre con el arranque de Windows, y si queremos un acceso directo a Hamachi en el Escritorio. Después de configurar todo esto, damos click a \"[u]S[/u]iguiente >\".\r\n\r\nAcá les da un texto que les explica los riesgos que se pueden correr al usar Hamachi, por lo que van a tener que marcar la opción que se les muestra, para mayor seguridad y disminución de riesgos.\r\n\r\n[img:center]http://img184.imageshack.us/img184/610/63197828yz9.bmp[/img]\r\n\r\nAhora van a tener que, si tienen un código de licencia, seleccionar la última opción e introducir el código. Si no tienen, pueden elegir usar la versión gratuita, o probar(cosa que no recomiendo ya que es sólo por un mes) la versión comercial. Después de seleccionar una opción, hagan click en \"[u]S[/u]iguiente >\", y luego en \"I[u]n[/u]stalar\".\r\n\r\nCuando termina la instalación, hacemos click en \"[u]S[/u]iguiente >\", y luego seleccionamos si deseamos ejecutar Hamachi para dar click en \"[u]F[/u]inalizar\".\r\n\r\n¡Listo! Ya tenemos Hamachi instalado en nuestra computadora.\r\n\r\n\r\n[h3]¿Cómo me inicio en Hamachi?[/h3]\r\n[img:center]http://img132.imageshack.us/img132/2356/73165160js1.bmp[/img]\r\n\r\nCuando lo ejecuten les van a aparecer dos nuevos íconos en la barra de herramientas, junto a los que se muestran al lado de la hora: El Hamachi y la conección que crea el mísmo.\r\n\r\nCuando desaparece el ícono de las dos computadoras y una red, significa que ya está funcionando y listo para usar. Ahora nos falta configurarlo.\r\n\r\n[img:center]http://img75.imageshack.us/img75/618/83356770um0.bmp[/img]\r\n\r\nHacemos doble click en el icono de Hamachi(las tres bolitas unidas por líneas entre sí). Se va a abrir la ventana del Hamachi.\r\n\r\nAntes que nada, tienen que clickear en el boton de encendido, ubicado en la parte inferior izquierda de la ventana para \"encender\" el Hamachi y nos va a pedir un Apodo de la cuenta, en el que van a poner su nombre o nick. ¡Listo! Tenemos nuestra red local simulada ya establecida. A los pocos segundos de conectarse, les va a preguntar si quieren establecer una Contraseña Maestra, lo que les recomiendo hacer por cuestiones de seguridad.\r\n\r\n\r\n[h3]¿Cómo creo una red?[/h3]\r\nDespues de seguir todos estos pasos vamos a tener que crear una red, para que los demás puedan conectarse con nosotros en nuestra red local simulada. Esto lo hacemos desde el botón con forma de triángulo que tenemos en la parte inferior derecha, que despliega un menú en el que tenemos que poner \"[u]C[/u]rear nueva red ..\".\r\n\r\n\r\n[img:center]http://img392.imageshack.us/img392/209/53108115dy6.bmp[/img]\r\n\r\nAcá tenemos que rellenar los campos: En \"Nombre de la red\" pongan el nombre de su servidor, o el nombre que deseen ponerle a la red, y en \"Contraseña de la red\", la contraseña con la que entrarán los demás a la red.\r\n\r\n\r\nYa con esto tenemos todo configurado y listo para unir gente a nuestra red.\r\n\r\n\r\n[h3]¿Cómo me uno a una red?[/h3]\r\nRepetimos todos los pasos hasta cuando clickeamos en el botón con forma de triángulo, en el que en vez de ir a \"[u]C[/u]rear nueva red ..\", tenemos que ir a \"[u]U[/u]nirse a red existente ..\", y ahí ponemos el nombre y la contraseña de la red.\r\n\r\n\r\n[h3]¿Cómo creo una partida de Arduz con Hamachi?[/h3]\r\nCuando ya tengamos la red funcionando, abrimos el \"Server.exe\", ubicado en la carpeta del Arduz, o bien ponemos \"CREAR PARTIDA\" ya en la interfase principal del juego.\r\n\r\n\r\n[img:center]http://img387.imageshack.us/img387/3176/44641047as9.bmp[/img]\r\n\r\nAhora que tenemos el Hamachi instalado, podemos ver que se agregó la opción tildable \"Hamachi\", para los que lo usen. Vamos a tildar esta opción, y creamos el servidor normalmente.\r\n\r\n¡Listo! Ahora para ingresar al servidor se va a usar la IP que crea el Hamachi(la pueden ver en la parte superior, en la ventana principal) y el puerto que pusimos al crear el servidor.\r\n[img:center]http://img361.imageshack.us/img361/769/14722577xs3.bmp[/img]\r\n\r\nAhora, para los que quieran entrar desde la lista de servidores, lo que van a tener que hacer es tildar la opción de abajo de la lista de servidores que dice \"Hamachi\", y van a encontrar el servidor así: \"Nombre del servidor - Vía Hamachi\"(Por ejemplo, \"Torneo de Labbel - Via Hamachi\").\r\n\r\nAhora, a no quejarse con el \"no puedo crear servidor\", \"no pueden entrar\", ¡¡Y a disfrutar!!\r\n\r\nLobby/Labbel - 28/12/2008', 5),
(7, '¿Cómo quito el límite de FPS?', 'Las [b]FPS[/b] (o cuadros por segundo) están limitados por defecto a 100 aproximadamente para evitar el consumo excesivo de procesador u otros recursos de la pc. Para quitar esta limitación sólo hay que apretar * (asterisco del pad numérico).\r\n\r\n', 6),
(8, 'Honor', 'El honor es el factor que tenemos el cuenta para la posición en el ranking. También es una medida para \"obligar\" a los usuarios a jugar correctamente según algunas directrices que te cito a continuación:\r\n\r\n[quote]\r\nEl hechizo inmovilizar ENTRE MAGOS es penado con [color=red]-5[/color] puntos de honor.\r\nEl hechizo inmovilizar A UN MAGO de parte de un DRUIDA o BARDO se pena con [color=red]-3[/color] puntos de honor.\r\nEl hechizo inmovilizar A UN DRUIDA o BARDO de parte de un MAGO, DRUIDA o BARDO es penado con [color=red]-3[/color] puntos de honor.\r\nEl hechizo inmovilizar a un usuario que recién respawnea (sin equipar, oculto) se pena con [color=red]-10[/color] puntos de honor.\r\nEl hechizo remover paralisis es premiado con [color=limegreen]1[/color] punto de honor, dependendo el caso(si está desnudo, si reciñen respawnea) puede variar entre [color=limegreen]1[/color] y [color=limegreen]3[/color].\r\nAtacar a un usuario que recién respawnea (sin equipar, oculto) se pena con [color=red]-10[/color] puntos de honor.\r\nSi un mago ataca a otro mago inmovilizado se pena con [color=red]-5[/color] puntos de honor.\r\nMatar a un usuario se premia con [color=limegreen]22[/color] puntos de honor.\r\n[/quote]\r\n', 5),
(9, 'Equipos por clase', 'Guia de objetos que usa cada clase de Arduz\r\n\r\n[b]Mago[/b]:\r\n- Túnica de druida (DEF:20/25; Requiere: Defensa 5 Resistencia 5)\r\n- Báculo engarzado (ATQ:1/1; Requiere: Magia 15)\r\n- Sombrero de mago (DEF:1/1; Requiere: Magia 5 Defensa 5 Resistencia 10)\r\n- Vestido de Bruja (DEF:15/20; Requiere: Defensa 5)\r\n- Dama blanca (DEF:15/20; Requiere: Defensa 5)\r\n- Túnica combinada (DEF:30/35 Requiere; Magia 10 Defensa 10)[E/G]\r\n\r\n[b]Druida[/b]:\r\n- Túnica de druida (DEF:20/25; Requiere: Defensa 5 Resistencia 5)\r\n- Daga +2 (ATQ:4/6; Requiere: Combate 8 )\r\n- Flauta magica (ATQ:1/1; Requiere: Magia 7)\r\n- Vestido de Bruja (DEF:15/20; Requiere: Defensa 5)\r\n- Dama blanca (DEF:15/20; Requiere: Defensa 5)\r\n- Túnica combinada (DEF:30/35 Requiere; Magia 10 Defensa 10)[E/G]\r\n\r\n[b]Clerigo[/b]:\r\n- Manto del dragón (DEF:30/35; Requiere: Defensa 7)\r\n- Hacha de guerra dos filos (ATQ:5/20; Requiere: Combate 10)\r\n- Escudo imperial (DEF:8/10; Requiere: Defensa 7)\r\n- Casco de hierro completo (DEF:10/20; Requiere: Defensa 12)\r\n- Manto de dragón (DEF:30/35; Requiere: Defensa 7)\r\n- Vestido de Bruja (DEF:15/20; Requiere: Defensa 5)\r\n- Dama blanca (DEF:15/20; Requiere: Defensa 5)\r\n- Túnica combinada (DEF:30/35 Requiere; Magia 10 Defensa 10)[E/G]\r\n- Casco de Hierro (DEF:3/8; Requiere: Defensa 5 Resistencia 5)\r\n- Anillas con manto verde (DEF:12/22; Requiere: Defensa 5)\r\n- Armadura de Placas Azules (DEF:40/40; Requiere: Combate 10 Defensa 15 Resistencia 5)\r\n- Armadura de Placas +2 (DEF:40/40; Requiere: Combate 10 Defensa 15 Resistencia 5)\r\n- Armadura de Placas de Gala (DEF:40/40; Requiere: Combate 10 Defensa 15 Resistencia 5)\r\n- Armadura de la Ciénaga (DEF:45/50; Requiere: Combate 10 Defensa 20 Resistencia 10)\r\n- Armadura liviana de hierro (DEF:8/15; Requiere: Defensa 5)\r\n\r\n[b]Bardo[/b]:\r\n- Túnica de druida (DEF:20/25; Requiere: Defensa 5 Resistencia 5)\r\n- Cimitarra (ATQ:6/14; Requiere: Magia 3 Combate 7)\r\n- Laúd mágico (DEF:1/1; Requiere: Magia 7)\r\n- Escudo de tortuga (DEF:1; Requiere: Defensa 1)\r\n- Vestido de Bruja (DEF:15/20; Requiere: Defensa 5)\r\n- Dama blanca (DEF:15/20; Requiere: Defensa 5)\r\n- Túnica combinada (DEF:30/35 Requiere; Magia 10 Defensa 10)[E/G]\r\n- Casco de Hierro (DEF:3/8; Requiere: Defensa 5 Resistencia 5)\r\n\r\n[b]Paladín[/b]:\r\n- Manto del dragón (DEF:30/35; Requiere: Defensa 7)\r\n- Hacha de guerra dos filos (ATQ:5/20; Requiere: Combate 10)\r\n- Escudo imperial (DEF:8/10; Requiere: Defensa 7)\r\n- Casco de hierro completo (DEF:10/20; Requiere: Defensa 12)\r\n- Casco de Hierro (DEF:3/8; Requiere: Defensa 5 Resistencia 5)\r\n- Anillas con manto verde (DEF:12/22; Requiere: Defensa 5)\r\n- Armadura de Placas Azules (DEF:40/40; Requiere: Combate 10 Defensa 15 Resistencia 5)\r\n- Armadura de Placas +2 (DEF:40/40; Requiere: Combate 10 Defensa 15 Resistencia 5)\r\n- Armadura de Placas de Gala (DEF:40/40; Requiere: Combate 10 Defensa 15 Resistencia 5)\r\n- Armadura de la Ciénaga (DEF:45/50; Requiere: Combate 10 Defensa 20 Resistencia 10)\r\n- Armadura liviana de hierro (DEF:8/15; Requiere: Defensa 5)\r\n\r\n[b]Asesino[/b]:\r\n- Armadura de las sombras (DEF:30/37; Requiere: Combate 3 Defensa 7 Resistencia 3)\r\n- Daga +4 (ATQ:6/8; Requiere: Combate 12)\r\n- Escudo de tortuga (DEF:1; Requiere: Defensa 1)\r\n- Casco de hierro completo (DEF:10/20; Requiere: Defensa 12)\r\n- Casco de Hierro (DEF:3/8; Requiere: Defensa 5 Resistencia 5)\r\n- Armadura de metal oscuro (DEF:30/37; Requiere: Combate 3 Defensa 7 Resistencia 3) [E/G]\r\n\r\n[b]Cazador[/b]:\r\n- Manto del dragon (DEF:30/35; Requiere: Defensa 7)\r\n- Arco de cazador (ATQ:6/12; Requiere: Combate 10 Defensa 5)\r\n- Flecha +3 (ATQ:2/5; Requiere: Combate 12)\r\n- Escudo imperial (DEF:8/10; Requiere: Defensa 7)\r\n- Capucha de cazador (DEF:8/12; Requiere Defensa 5)\r\n- Casco de Hierro (DEF:3/8; Requiere: Defensa 5 Resistencia 5)\r\n\r\n[b]Guerrero[/b]:\r\n- Manto del dragón (DEF:30/35; Requiere: Defensa 7)\r\n- Hacha de guerra dos filos (ATQ:5/20; Requiere: Combate 10)\r\n- Escudo imperial (DEF:8/10; Requiere: Defensa 7)\r\n- Casco de hierro completo (DEF:10/20; Requiere: Defensa 12)\r\n- Casco de Hierro (DEF:3/8; Requiere: Defensa 5 Resistencia 5)\r\n- Anillas con manto verde (DEF:12/22; Requiere: Defensa 5)\r\n', 3),
(10, 'Razas', 'R[b]RAZAS[/b]\r\n\r\n-Humanos:\r\nSuelen ser la raza predominante, comunmente de tez blanca o caucásica. Sus atributos principales son la fuerza, agilidad y constitución, pero no se destacan por ninguna de ella, sino más bien, mantienen un buen balance.\r\n\r\n-Elfos:\r\nSon seres de gran belleza. Largos cabellos y orejas puntiagudas los caracterizan. La agilidad, es el rasgo más sobresaliente de esta raza, aunque también, se destacan en menor medida por su inteligencia y su carisma.\r\n\r\n-Elfos Oscuros:\r\nDe largos cabellos, conservan las puntiagudas orejas de los elfos comunes, pero su tez puede tomar tonos del gris al negro.\r\nPoseen una inteligencia semejante a la de los elfos comunes, pero son más fuertes físicamente que éstos y que los humanos a su vez, aunque no tanto como los enanos. La agilidad, es otra de sus carácteristicas principales. Al ser seres poco agradables a la vista, tienen la peor bonificación de carisma entre las razas.\r\n\r\n-Enanos:\r\nSeres de poca altura, contextura robusta, largas barbas y cortos cabellos. En cuanto a su tez, es generalmente caucásica.\r\nDebido a su contextura física, es la raza más fuerte y resistente (es decir, de excelente constitución), pero esto los convierte también en la clase menos ágil y su carisma se ve seriamente afectado por su tosco aspecto. A su vez, la tosudez los convierte en la clase menos inteligente.\r\n\r\n-Gnomos:\r\nAl igual que los enanos, son seres de poca altura, aunque su contextura física es más pequeña y menos robusta. De tez caucásica y largos cabellos los gnomos suelen ser débiles, por lo que tienen el peor bonificador de constitución, pero de una notable agilidad, casi tan buena como la de los elfos. Esta clase es la más inteligente de las tierras.\r\n', 3),
(11, 'Habilidades', 'Existen 4 tipos de habilidades: Magia, Combate, Defensa y Resistencia.\r\n\r\nMagia: Esta habilidad nos permite utilizar objetos que potencian nuestro ataque mágico.\r\n\r\nCombate: Esta habilidad nos permite equipar armas con daño físico.\r\n\r\nDefensa: Con esta habilidad podremos utilizar distintos objetos para defendernos físicamente.\r\n\r\nResistencia: Sirve para poder portar items con resistencia mágica.\r\n\r\n\r\nLas distintas habilidades se mejoran yendo al Entrenador (en el panel de nuestro personaje) y seleccionando la Habilidad que deseamos entrenar. Mejorar cada habilidad tiene un costo (Dinero y Tiempo) que se irán incrementando gradualmente a medida que perfeccionamos nuestra habilidad.\r\n\r\nDurante el tiempo que mandamos a entrenar a nuestro personaje, no podremos utilizarlo. ', 1);

-- --------------------------------------------------------

--
-- Table structure for table `configuracion`
--

CREATE TABLE `configuracion` (
  `cfg` tinyint(1) NOT NULL,
  `num` int(11) NOT NULL,
  `numservers` int(11) NOT NULL,
  `numdownloads` int(11) NOT NULL,
  `ultimoupd1` int(11) NOT NULL,
  `ultimoupd2` int(11) NOT NULL,
  `ultimoupd3` int(11) NOT NULL,
  `maxsvr` mediumint(9) NOT NULL,
  `maxusr` mediumint(9) NOT NULL,
  `clanes` int(11) NOT NULL,
  `ultimorankeo` int(10) NOT NULL,
  `balancemd5` varchar(32) NOT NULL,
  `ultimobalance` int(10) UNSIGNED NOT NULL,
  `ultimobalancecreado` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `configuracion`
--

INSERT INTO `configuracion` (`cfg`, `num`, `numservers`, `numdownloads`, `ultimoupd1`, `ultimoupd2`, `ultimoupd3`, `maxsvr`, `maxusr`, `clanes`, `ultimorankeo`, `balancemd5`, `ultimobalance`, `ultimobalancecreado`) VALUES
(0, 0, 0, 0, 1318092400, 1318095125, 1318091684, 0, 13, 2, 1318035770, '567245eb052e8d3873f32d74857e7fae', 295, 295);

-- --------------------------------------------------------

--
-- Table structure for table `errores`
--

CREATE TABLE `errores` (
  `ID` int(11) NOT NULL,
  `date` int(11) NOT NULL,
  `acc` bigint(20) NOT NULL,
  `text` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `est-online`
--

CREATE TABLE `est-online` (
  `unica` int(10) UNSIGNED NOT NULL,
  `num` int(3) NOT NULL,
  `order` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `est-online`
--

INSERT INTO `est-online` (`unica`, `num`, `order`) VALUES
(91121, 21, 1258855030),
(91122, 27, 1258855362),
(91123, 25, 1258941622),
(91124, 25, 1259028004),
(91125, 24, 1259114578),
(91126, 30, 1259200825),
(91127, 26, 1259287204),
(91128, 31, 1259373603),
(91129, 32, 1259460009),
(91130, 33, 1259546412),
(91201, 31, 1259632811),
(91202, 44, 1259719218),
(91203, 37, 1259805660),
(91204, 31, 1259892024),
(91205, 45, 1259982050),
(91206, 43, 1260068411),
(91207, 38, 1260154807),
(91208, 46, 1260241212),
(91209, 42, 1260327647),
(91210, 57, 1260415056),
(91211, 64, 1260500406),
(91212, 66, 1260586800),
(91213, 66, 1260673203),
(91214, 80, 1260759604),
(91215, 75, 1260846000),
(91216, 88, 1260932430),
(91217, 82, 1261018829),
(91218, 79, 1261105207),
(91219, 88, 1261191612),
(91220, 63, 1261278001),
(91221, 67, 1261364403),
(91222, 70, 1261450801),
(91223, 93, 1261537208),
(91224, 92, 1261623600),
(91225, 90, 1261737604),
(91226, 74, 1261853783),
(91227, 58, 1261879239),
(91228, 78, 1261965603),
(91229, 68, 1262052004),
(91230, 64, 1262138401),
(91231, 62, 1262224806),
(100101, 35, 1262311200),
(100102, 59, 1262397618),
(100103, 57, 1262484004),
(100104, 66, 1262570408),
(100105, 82, 1262656807),
(100106, 79, 1262743200),
(100107, 87, 1262829600),
(100108, 91, 1262916016),
(100109, 87, 1263002443),
(100110, 101, 1263088803),
(100111, 113, 1263175204),
(100112, 79, 1263261637),
(100113, 89, 1263348026),
(100114, 89, 1263434400),
(100115, 71, 1263520804),
(100116, 91, 1263607215),
(100117, 73, 1263693629),
(100118, 63, 1263780001),
(100119, 60, 1263866402),
(100120, 61, 1263952809),
(100121, 58, 1264039209),
(100122, 73, 1264125607),
(100123, 70, 1264212040),
(100124, 51, 1264298414),
(100125, 88, 1264384805),
(100126, 95, 1264471204),
(100127, 66, 1264557606),
(100128, 70, 1264644000),
(100129, 76, 1264730406),
(100130, 85, 1264816800),
(100131, 78, 1264903205),
(100201, 90, 1264989610),
(100202, 85, 1265076006),
(100203, 69, 1265162403),
(100204, 69, 1265248802),
(100205, 83, 1265335213),
(100206, 70, 1265421610),
(100207, 87, 1265508001),
(100208, 93, 1265594400),
(100209, 75, 1265680800),
(100210, 85, 1265767209),
(100211, 89, 1265853614),
(100212, 80, 1265940002),
(100213, 75, 1266026416),
(100214, 100, 1266112806),
(100215, 77, 1266199204),
(100216, 77, 1266294999),
(100217, 114, 1266375600),
(100218, 77, 1266462008),
(100219, 93, 1266548410),
(100220, 98, 1266634802),
(100221, 89, 1266721204),
(100222, 99, 1266807606),
(100223, 74, 1266894001),
(100224, 89, 1266980438),
(100225, 101, 1267066819),
(100226, 85, 1267153201),
(100227, 78, 1267239604),
(100228, 62, 1267326008),
(100301, 75, 1267412413),
(100302, 72, 1267498804),
(100303, 77, 1267585300),
(100304, 93, 1267672655),
(100305, 89, 1267764544),
(100306, 84, 1267844403),
(100307, 91, 1267930800),
(100308, 93, 1268017262),
(100309, 87, 1268103612),
(100310, 88, 1268190048),
(100311, 86, 1268276414),
(100312, 86, 1268362808),
(100313, 87, 1268449203),
(100314, 80, 1268535602),
(100315, 75, 1268622025),
(100316, 85, 1268708407),
(100317, 97, 1268794804),
(100318, 84, 1268881214),
(100319, 99, 1268967602),
(100320, 78, 1269054004),
(100321, 108, 1269140400),
(100322, 91, 1269226823),
(100323, 84, 1269313206),
(100324, 93, 1269399603),
(100325, 73, 1269486004),
(100326, 89, 1269572406),
(100327, 78, 1269658814),
(100328, 93, 1269745201),
(100329, 66, 1269831600),
(100330, 76, 1269918028),
(100331, 82, 1270004406),
(100401, 79, 1270090859),
(100402, 81, 1270177206),
(100403, 80, 1270263601),
(100404, 79, 1270350014),
(100405, 84, 1270436430),
(100406, 90, 1270522816),
(100407, 86, 1270609201),
(100408, 97, 1270695609),
(100409, 81, 1270782044),
(100410, 69, 1270868406),
(100411, 59, 1270954800),
(100412, 66, 1271041243),
(100413, 79, 1271127602),
(100414, 66, 1271214011),
(100415, 104, 1271300427),
(100416, 63, 1271386800),
(100417, 61, 1271473200),
(100418, 59, 1271559602),
(100419, 66, 1271646015),
(100420, 77, 1271732439),
(100421, 80, 1271818802),
(100422, 67, 1271905217),
(100423, 84, 1271991609),
(100424, 81, 1272084635),
(100425, 71, 1272164400),
(100426, 75, 1272250827),
(100427, 64, 1272337236),
(100428, 84, 1272423626),
(100429, 66, 1272510035),
(100430, 88, 1272596461),
(100501, 71, 1272682801),
(100502, 71, 1272769216),
(100503, 58, 1272855613),
(100504, 33, 1272942000),
(100505, 65, 1273028402),
(100506, 62, 1273114800),
(100507, 61, 1273201203),
(100508, 66, 1273287642),
(100509, 51, 1273374019),
(100510, 50, 1273460440),
(100511, 53, 1273546967),
(100512, 43, 1273633221),
(100513, 52, 1273719600),
(100514, 62, 1273806067),
(100515, 52, 1273892414),
(100516, 47, 1273978814),
(100517, 44, 1274065355),
(100518, 58, 1274151603),
(100519, 58, 1274238055),
(100520, 56, 1274324406),
(100521, 65, 1274410848),
(100522, 67, 1274497205),
(100523, 70, 1274583603),
(100524, 58, 1274670005),
(100525, 63, 1274756408),
(100526, 72, 1274842858),
(100527, 69, 1274929206),
(100528, 85, 1275015602),
(100529, 80, 1275102003),
(100530, 70, 1275188401),
(100531, 66, 1275274803),
(100601, 56, 1275361209),
(100602, 57, 1275447610),
(100603, 68, 1275534032),
(100604, 70, 1275620570),
(100605, 103, 1275706803),
(100606, 69, 1275793210),
(100607, 60, 1275879601),
(100608, 63, 1275966126),
(100609, 67, 1276052449),
(100610, 58, 1276138839),
(100611, 66, 1276225239),
(100612, 66, 1276319097),
(100613, 84, 1276398001),
(100614, 64, 1276484407),
(100615, 73, 1276570804),
(100616, 64, 1276657206),
(100617, 81, 1276743610),
(100618, 86, 1276830009),
(100619, 78, 1276916410),
(100620, 67, 1277002815),
(100621, 69, 1277089207),
(100622, 76, 1277175601),
(100623, 65, 1277262020),
(100624, 66, 1277348400),
(100625, 77, 1277434903),
(100626, 80, 1277521223),
(100627, 56, 1277607601),
(100628, 53, 1277694054),
(100629, 55, 1277780400),
(100630, 54, 1277866808),
(100701, 54, 1277953242),
(100702, 73, 1278039603),
(100703, 65, 1278126007),
(100704, 51, 1278212404),
(100705, 52, 1278298820),
(100706, 56, 1278385296),
(100707, 60, 1278471607),
(100708, 70, 1278558017),
(100709, 53, 1278644410),
(100710, 71, 1278730805),
(100711, 64, 1278817200),
(100712, 50, 1278903611),
(100713, 60, 1278990000),
(100714, 62, 1279076404),
(100715, 57, 1279162815),
(100716, 71, 1279249201),
(100717, 62, 1279335606),
(100718, 62, 1279422002),
(100719, 65, 1279508402),
(100720, 59, 1279594814),
(100721, 78, 1279681210),
(100722, 67, 1279767600),
(100723, 71, 1279854000),
(100724, 108, 1279940400),
(100725, 86, 1280026807),
(100726, 79, 1280113215),
(100727, 77, 1280199605),
(100728, 86, 1280286000),
(100729, 79, 1280372409),
(100730, 89, 1280458814),
(100731, 86, 1280545200),
(100801, 65, 1280631604),
(100802, 61, 1280718007),
(100803, 68, 1280804408),
(100804, 53, 1280890816),
(100805, 58, 1280977215),
(100806, 54, 1281063629),
(100807, 82, 1281150015),
(100808, 71, 1281236409),
(100809, 52, 1281322809),
(100810, 67, 1281409241),
(100811, 63, 1281495605),
(100812, 62, 1281582012),
(100813, 64, 1281668401),
(100814, 74, 1281754800),
(100815, 72, 1281841236),
(100816, 75, 1281927600),
(100817, 72, 1282014001),
(100818, 72, 1282100416),
(100819, 72, 1282186811),
(100820, 87, 1282273202),
(100821, 63, 1282359607),
(100822, 64, 1282446020),
(100823, 65, 1282532415),
(100824, 67, 1282618802),
(100825, 65, 1282705200),
(100826, 68, 1282791607),
(100827, 73, 1282878003),
(100828, 78, 1282964407),
(100829, 88, 1283050809),
(100830, 88, 1283137212),
(100831, 77, 1283223615),
(100901, 82, 1283310004),
(100902, 86, 1283396407),
(100903, 84, 1283482802),
(100904, 84, 1283569208),
(100905, 83, 1283655604),
(100906, 68, 1283742034),
(100907, 77, 1283828402),
(100908, 65, 1283914802),
(100909, 77, 1284001207),
(100910, 116, 1284087603),
(100911, 87, 1284174006),
(100912, 71, 1284260402),
(100913, 72, 1284346815),
(100914, 64, 1284433206),
(100915, 69, 1284519619),
(100916, 69, 1284606009),
(100917, 72, 1284692402),
(100918, 63, 1284778806),
(100919, 72, 1284865206),
(100920, 67, 1284951614),
(100921, 61, 1285038001),
(100922, 74, 1285124408),
(100923, 72, 1285210817),
(100924, 70, 1285297210),
(100925, 107, 1285383601),
(100926, 88, 1285470008),
(100927, 79, 1285556466),
(100928, 110, 1285642803),
(100929, 105, 1285729220),
(100930, 118, 1285815611),
(101001, 101, 1285902012),
(101002, 89, 1285988410),
(101003, 109, 1286074804),
(101004, 87, 1286161211),
(101005, 75, 1286247602),
(101006, 85, 1286334003),
(101007, 82, 1286420403),
(101008, 101, 1286506802),
(101009, 96, 1286593202),
(101010, 78, 1286679614),
(101011, 73, 1286766006),
(101012, 76, 1286852403),
(101013, 90, 1286938800),
(101014, 76, 1287025201),
(101015, 72, 1287111607),
(101016, 77, 1287198000),
(101017, 80, 1287284413),
(101018, 79, 1287370816),
(101019, 74, 1287457205),
(101020, 68, 1287543615),
(101021, 83, 1287630006),
(101022, 83, 1287716407),
(101023, 71, 1287802809),
(101024, 71, 1287889201),
(101025, 70, 1287975610),
(101026, 83, 1288062020),
(101027, 78, 1288148403),
(101028, 79, 1288234805),
(101029, 72, 1288321215),
(101030, 92, 1288407621),
(101031, 88, 1288494005),
(101101, 92, 1288580419),
(101102, 68, 1288666801),
(101103, 81, 1288753211),
(101104, 62, 1288839621),
(101105, 78, 1288926085),
(101106, 75, 1289012425),
(101107, 78, 1289098811),
(101108, 69, 1289185202),
(101109, 91, 1289271623),
(101110, 100, 1289358002),
(101111, 87, 1289444429),
(101112, 87, 1289530802),
(101113, 77, 1289617202),
(101114, 62, 1289703601),
(101115, 63, 1289790022),
(101116, 62, 1289876401),
(101117, 85, 1289962808),
(101118, 80, 1290049207),
(101119, 79, 1290135601),
(101120, 65, 1290222011),
(101121, 66, 1290308406),
(101122, 75, 1290394800),
(101123, 59, 1290481211),
(101124, 59, 1290567600),
(101125, 84, 1290654029),
(101126, 74, 1290740405),
(101127, 76, 1290826804),
(101128, 64, 1290913225),
(101129, 71, 1290999681),
(101130, 81, 1291086003),
(101201, 78, 1291172443),
(101202, 75, 1291258809),
(101203, 86, 1291345206),
(101204, 71, 1291431609),
(101205, 73, 1291518015),
(101206, 75, 1291604408),
(101207, 95, 1291690837),
(101208, 80, 1291777200),
(101209, 94, 1291863611),
(101210, 77, 1291950013),
(101211, 85, 1292036402),
(101212, 89, 1292122806),
(101213, 79, 1292209268),
(101214, 77, 1292295622),
(101215, 85, 1292382004),
(101216, 79, 1292468408),
(101217, 88, 1292554813),
(101218, 86, 1292641223),
(101219, 81, 1292727609),
(101220, 86, 1292814009),
(101221, 77, 1292900561),
(101222, 70, 1292986800),
(101223, 85, 1293073200),
(101224, 75, 1293159612),
(101225, 58, 1293246748),
(101226, 64, 1293332404),
(101227, 77, 1293418800),
(101228, 73, 1293505212),
(101229, 81, 1293591600),
(101230, 79, 1293678015),
(101231, 77, 1293764404),
(110101, 61, 1293851655),
(110102, 71, 1293937203),
(110103, 73, 1294023610),
(110104, 71, 1294110000),
(110105, 76, 1294196413),
(110106, 68, 1294282808),
(110107, 70, 1294369199),
(110108, 76, 1294455614),
(110109, 73, 1294542011),
(110110, 79, 1294628402),
(110111, 81, 1294714800),
(110112, 77, 1294801298),
(110113, 68, 1294887605),
(110114, 82, 1294974001),
(110115, 70, 1295060400),
(110116, 69, 1295146809),
(110117, 78, 1295233208),
(110118, 83, 1295319606),
(110119, 74, 1295406012),
(110120, 78, 1295492404),
(110121, 90, 1295578803),
(110122, 76, 1295665212),
(110123, 78, 1295751600),
(110124, 67, 1295838012),
(110125, 99, 1295924418),
(110126, 76, 1296010807),
(110127, 76, 1296097201),
(110128, 69, 1296183609),
(110129, 68, 1296270006),
(110130, 66, 1296356404),
(110131, 83, 1296442817),
(110201, 81, 1296529203),
(110202, 84, 1296615620),
(110203, 76, 1296702004),
(110204, 79, 1296788403),
(110205, 84, 1296874801),
(110206, 71, 1296961205),
(110207, 77, 1297047607),
(110208, 83, 1297134009),
(110209, 87, 1297220415),
(110210, 83, 1297306818),
(110211, 78, 1297393201),
(110212, 72, 1297479601),
(110213, 82, 1297566000),
(110214, 81, 1297652413),
(110215, 81, 1297738807),
(110216, 86, 1297825256),
(110217, 85, 1297911610),
(110218, 81, 1297998015),
(110219, 74, 1298084413),
(110220, 78, 1298170801),
(110221, 81, 1298257255),
(110222, 78, 1298343602),
(110223, 89, 1298430006),
(110224, 92, 1298516404),
(110225, 89, 1298607683),
(110226, 80, 1298689201),
(110227, 79, 1298775599),
(110228, 85, 1298862001),
(110301, 110, 1298948409),
(110302, 93, 1299034802),
(110303, 93, 1299121226),
(110304, 81, 1299207604),
(110305, 110, 1299294005),
(110306, 71, 1299380410),
(110307, 78, 1299466804),
(110308, 79, 1299553202),
(110309, 70, 1299639600),
(110310, 79, 1299726020),
(110311, 97, 1299812412),
(110312, 101, 1299898803),
(110313, 89, 1299985216),
(110314, 73, 1300071605),
(110315, 90, 1300158043),
(110316, 104, 1300244402),
(110317, 83, 1300330806),
(110318, 88, 1300417222),
(110319, 76, 1300503609),
(110320, 91, 1300590016),
(110321, 83, 1300676407),
(110322, 94, 1300762801),
(110323, 110, 1300849267),
(110324, 103, 1300935600),
(110325, 120, 1301022009),
(110326, 84, 1301108401),
(110327, 87, 1301194806),
(110328, 87, 1301281212),
(110329, 78, 1301367608),
(110330, 78, 1301454006),
(110331, 70, 1301540422),
(110401, 84, 1301626800),
(110402, 100, 1301713219),
(110403, 83, 1301799606),
(110404, 79, 1301886051),
(110405, 77, 1301972408),
(110406, 74, 1302058814),
(110407, 66, 1302145200),
(110408, 79, 1302231604),
(110409, 90, 1302318020),
(110410, 83, 1302404400),
(110411, 71, 1302490813),
(110412, 67, 1302577208),
(110413, 66, 1302663641),
(110414, 68, 1302750032),
(110415, 70, 1302836404),
(110416, 75, 1302922802),
(110417, 68, 1303009203),
(110418, 70, 1303095608),
(110419, 75, 1303182013),
(110420, 92, 1303268487),
(110421, 89, 1303354803),
(110422, 75, 1303441204),
(110423, 74, 1303527602),
(110424, 67, 1303614001),
(110425, 65, 1303700422),
(110426, 69, 1303786830),
(110427, 74, 1303873201),
(110428, 59, 1303959601),
(110429, 101, 1304046000),
(110430, 97, 1304132408),
(110501, 93, 1304218804),
(110502, 71, 1304305222),
(110503, 85, 1304391620),
(110504, 105, 1304478000),
(110505, 83, 1304564406),
(110506, 91, 1304650802),
(110507, 69, 1304737204),
(110508, 69, 1304823601),
(110509, 92, 1304910007),
(110510, 70, 1304996401),
(110511, 76, 1305082809),
(110512, 77, 1305169245),
(110513, 74, 1305255635),
(110514, 81, 1305342004),
(110515, 94, 1305428401),
(110516, 68, 1305514810),
(110517, 71, 1305601207),
(110518, 77, 1305687604),
(110519, 94, 1305774063),
(110520, 85, 1305860403),
(110521, 78, 1305946827),
(110522, 83, 1306033209),
(110523, 91, 1306119613),
(110524, 94, 1306206000),
(110525, 78, 1306292400),
(110526, 92, 1306378813),
(110527, 77, 1306465210),
(110528, 87, 1306552770),
(110529, 90, 1306638003),
(110530, 80, 1306724411),
(110531, 82, 1306810800),
(110601, 88, 1306897200),
(110602, 96, 1306983605),
(110603, 110, 1307070006),
(110604, 85, 1307156406),
(110605, 90, 1307242812),
(110606, 80, 1307329215),
(110607, 82, 1307415605),
(110608, 86, 1307502002),
(110609, 71, 1307588409),
(110610, 72, 1307674814),
(110611, 125, 1307761200),
(110612, 89, 1307847600),
(110613, 89, 1307934125),
(110614, 73, 1308020400),
(110615, 115, 1308106806),
(110616, 125, 1308193201),
(110617, 168, 1308279609),
(110618, 104, 1308366001),
(110619, 106, 1308452401),
(110620, 108, 1308538800),
(110621, 103, 1308625210),
(110622, 91, 1308711603),
(110623, 115, 1308798014),
(110624, 92, 1308884406),
(110625, 96, 1308970805),
(110626, 67, 1309057208),
(110627, 70, 1309143613),
(110628, 75, 1309230003),
(110629, 81, 1309316403),
(110630, 83, 1309402836),
(110701, 82, 1309489208),
(110702, 77, 1309575604),
(110703, 82, 1309662000),
(110704, 81, 1309748425),
(110705, 82, 1309834845),
(110706, 83, 1309921200),
(110707, 72, 1310007608),
(110708, 84, 1310094053),
(110709, 79, 1310180400),
(110710, 82, 1310266804),
(110711, 77, 1310353200),
(110712, 85, 1310439627),
(110713, 89, 1310526005),
(110714, 85, 1310612401),
(110715, 89, 1310698819),
(110716, 83, 1310785204),
(110717, 101, 1310871600),
(110718, 108, 1310958001),
(110719, 76, 1311044405),
(110720, 91, 1311130799),
(110721, 78, 1311217202),
(110722, 91, 1311303609),
(110723, 82, 1311390000),
(110724, 83, 1311476407),
(110725, 80, 1311562829),
(110726, 69, 1311649200),
(110727, 60, 1311735600),
(110728, 57, 1311822009),
(110729, 78, 1311908492),
(110730, 64, 1311994801),
(110731, 64, 1312081209),
(110801, 73, 1312167799),
(110802, 80, 1312254011),
(110803, 73, 1312340404),
(110804, 70, 1312427558),
(110805, 75, 1312514004),
(110806, 83, 1312600866),
(110807, 77, 1312686000),
(110808, 83, 1312772441),
(110809, 68, 1312858804),
(110810, 74, 1312945205),
(110811, 83, 1313031618),
(110812, 85, 1313119047),
(110813, 72, 1313204402),
(110814, 88, 1313291636),
(110815, 100, 1313377206),
(110816, 97, 1313464334),
(110817, 91, 1313550010),
(110818, 91, 1313636413),
(110819, 71, 1313723966),
(110820, 65, 1313809201),
(110821, 68, 1313895603),
(110822, 60, 1313982394),
(110823, 61, 1314070427),
(110824, 73, 1314156518),
(110825, 65, 1314241203),
(110826, 77, 1314327601),
(110827, 96, 1314414656),
(110828, 76, 1314501954),
(110829, 79, 1314586808),
(110830, 80, 1314673200),
(110831, 75, 1314759613),
(110901, 69, 1314846000),
(110902, 78, 1314932420),
(110903, 82, 1315018810),
(110904, 79, 1315105208),
(110905, 76, 1315192383),
(110906, 98, 1315278013),
(110907, 100, 1315364463),
(110908, 79, 1315450809),
(110909, 85, 1315537204),
(110910, 89, 1315623614),
(110911, 76, 1315710004),
(110912, 90, 1315796403),
(110913, 77, 1315882802),
(110914, 86, 1315969207),
(110915, 81, 1316055616),
(110916, 91, 1316142012),
(110917, 96, 1316228690),
(110918, 80, 1316316446),
(110919, 82, 1316401797),
(110920, 89, 1316487602),
(110921, 76, 1316575725),
(110922, 75, 1316660407),
(110923, 78, 1316747187),
(110924, 76, 1316833234),
(110925, 74, 1316920207),
(110926, 76, 1317006000),
(110927, 72, 1317095034),
(110928, 73, 1317178806),
(110929, 76, 1317265925),
(110930, 79, 1317351610),
(111001, 87, 1317438863),
(111002, 73, 1317524405),
(111003, 73, 1317610801),
(111004, 77, 1317697489),
(111005, 74, 1317783712),
(111006, 78, 1317871633),
(111007, 100, 1317956401),
(111008, 83, 1318042806);

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE `items` (
  `ID` int(10) UNSIGNED NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Valor` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `desc` varchar(255) NOT NULL,
  `clases` int(11) NOT NULL DEFAULT -1,
  `razas` int(11) NOT NULL DEFAULT -1,
  `genero` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `magia` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `combate` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `defenza` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `resistencia` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `habespecial` int(11) NOT NULL DEFAULT 0,
  `grh` smallint(6) NOT NULL,
  `posibilidad` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `NEWBIE` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `items`
--

INSERT INTO `items` (`ID`, `Name`, `Valor`, `desc`, `clases`, `razas`, `genero`, `magia`, `combate`, `defenza`, `resistencia`, `habespecial`, `grh`, `posibilidad`, `NEWBIE`) VALUES
(2, 'Hacha de guerra dos filos', 7000, 'ATQ: 5/20', -1, -1, 0, 0, 10, 0, 0, 268435456, 129, 90, 0),
(31, 'Túnica de los dioses', 4294967295, '', -1, -1, 0, 25, 25, 25, 25, 939524095, 31, 100, 0),
(32, 'Rastatúnica', 0, '0 / 0', -1, -1, 0, 0, 0, 0, 0, 268435455, 32, 0, 0),
(124, 'Katana', 6000, 'ATQ: 6/19 (Asesino)', -1, -1, 0, 0, 7, 0, 0, 268435456, 124, 90, 0),
(133, 'Escudo Imperial', 7000, 'DEF: 8/10', -1, -1, 0, 0, 0, 7, 0, 536870912, 133, 35, 0),
(195, 'Armadura de Placas', 10000, 'DEF: 35/40', -1, -1, 0, 0, 3, 10, 3, 536870912, 195, 90, 0),
(356, 'Armadura de las Sombras ', 8000, 'DEF: 30/37  (Asesino)', -1, -1, 0, 0, 3, 7, 3, 536870912, 356, 90, 0),
(360, 'Armadura de cazador', 10000, 'DEF: 10/20', -1, -1, 0, 0, 0, 10, 5, 1073741824, 360, 90, 0),
(370, 'Capucha de Cazador', 2500, 'DEF: 8/12 (Cazador)', -1, -1, 0, 0, 0, 5, 0, 1073741824, 370, 90, 0),
(390, 'Armadura de Placas +1', 12000, 'DEF: 35/40 ', -1, -1, 0, 0, 5, 12, 5, 536870912, 390, 90, 0),
(391, 'Armadura de Placas +2', 15000, 'DEF: 40/40', -1, -1, 0, 0, 10, 15, 5, 536870912, 391, 90, 0),
(481, 'Armadura de dragón', 20000, 'DEF: 60/65', -1, -1, 0, 0, 15, 25, 15, 536870912, 481, 10, 0),
(485, 'Armadura legendaria', 0, '', -1, -1, 0, 0, 0, 0, 0, 0, 485, 0, 0),
(489, 'Armadura de Placas Azules ', 20000, 'DEF: 40/40', -1, -1, 0, 0, 10, 15, 5, 536870912, 489, 90, 0),
(496, 'Armadura de la Ciénaga', 20000, 'DEF: 45/50', -1, -1, 0, 0, 10, 20, 10, 536870912, 496, 90, 0),
(497, 'Armadura de Placas de Gala', 20000, 'DEF: 40/40', -1, -1, 0, 0, 10, 15, 5, 536870912, 497, 90, 0),
(500, 'Armadura Bruñida', 20000, 'DEF: 40/40', -1, -1, 0, 0, 10, 12, 0, 536870912, 500, 90, 0),
(519, 'Túnica legendaria', 8000, 'DEF: 30/35', -1, -1, 0, 0, 0, 10, 10, 1073741824, 519, 100, 0),
(646, 'Túnica Real Pretoriana', 27500, '', -1, -1, 0, 20, 20, 20, 20, 0, 646, 15, 0),
(700, 'Anillo de los dioses', 0, '', -1, -1, 0, 0, 0, 0, 0, 0, 700, 0, 0),
(905, 'Suprema Armadura Dorada', 0, '', -1, -1, 0, 0, 0, 0, 0, 0, 905, 100, 0),
(906, 'Manto del Dragón', 9000, 'DEF: 30/35', -1, -1, 0, 0, 0, 7, 0, 1073741824, 906, 0, 0),
(987, 'Armadura de Klox ', 5000, 'DEF: 25/30', -1, -1, 0, 0, 2, 6, 2, 536870912, 987, 90, 0),
(988, 'Armadura de cazador (BAJOS)', 10000, 'DEF: 10/20', -1, -1, 0, 0, 0, 10, 5, 1073741824, 648, 90, 0),
(989, 'Armadura de metal oscuro', 8000, 'DEF: 30/37  (Asesino)', -1, -1, 0, 0, 3, 7, 3, 536870912, 971, 90, 0),
(990, 'Anillas con manto verde', 3000, 'DEF: 12/22', -1, -1, 0, 0, 0, 5, 0, 536870912, 889, 50, 0),
(991, 'Cota de Mallas Larga', 8000, 'DEF: 28/41', -1, -1, 0, 0, 10, 10, 0, 536870912, 975, 50, 0),
(992, 'Armadura Liviana de Hierro', 1000, 'DEF: 8/15', -1, -1, 0, 0, 0, 5, 0, 536870912, 885, 100, 0),
(993, 'Armadura de Placas de Thor', 4000, 'Def: 18/22', -1, -1, 0, 0, 0, 10, 0, 536870912, 970, 90, 0),
(995, 'Bracamante', 2500, 'ATQ: 5/15', -1, -1, 0, 0, 5, 0, 0, 268435456, 123, 100, 0),
(996, 'Sable', 2000, 'ATQ: 6/13', -1, -1, 0, 0, 5, 0, 0, 268435456, 125, 100, 0),
(997, 'Hacha Larga de Guerra', 6000, 'ATQ: 5/19', -1, -1, 0, 0, 12, 0, 0, 268435456, 126, 100, 0),
(998, 'Escudo de Hierro', 4000, 'DEF: 1/4', -1, -1, 0, 0, 0, 7, 0, 536870912, 128, 80, 0),
(999, 'Casco de hierro completo', 4000, 'DEF: 10/20', -1, -1, 0, 0, 0, 12, 0, 536870912, 131, 100, 0),
(1000, 'Casco de hierro', 0, 'DEF: 3/8', -1, -1, 0, 0, 0, 5, 5, 536870912, 132, 100, 1),
(1001, 'Hacha de Barbaro', 6000, 'ATQ: 5/16', -1, -1, 0, 0, 8, 0, 0, 268435456, 159, 100, 0),
(1002, 'Espada corta', 4000, 'ATQ: 1/4', -1, -1, 0, 0, 7, 0, 0, 268435456, 164, 100, 0),
(1003, 'Placas completas (E/G)', 7000, 'DEF: 30/35', -1, -1, 0, 0, 3, 7, 0, 536870912, 243, 100, 0),
(1004, 'Tunica de druidah', 1500, 'DEF: 20/25', -1, -1, 0, 0, 0, 5, 5, 1073741824, 986, 100, 0),
(1005, 'Daga +2', 2000, 'ATQ: 4/6', -1, -1, 0, 0, 8, 0, 0, 268435456, 365, 100, 0),
(1006, 'Daga +3', 3000, 'ATQ: 5/7', -1, -1, 0, 0, 10, 0, 0, 268435456, 366, 30, 0),
(1007, 'Daga +4', 5000, 'ATQ: 6/8', -1, -1, 0, 0, 12, 0, 0, 268435456, 367, 50, 0),
(1008, 'tunica antigua', 0, '', -1, -1, 0, 0, 0, 0, 0, 268435455, 381, 0, 0),
(1009, 'Armadura de Placas +1 (E/g)', 12000, 'DEF: 35/40', -1, -1, 0, 0, 5, 12, 5, 536870912, 392, 90, 0),
(1010, 'Armadura de Placas +2 (E/G)', 15000, 'DEF: 40/40', -1, -1, 0, 0, 10, 15, 5, 536870912, 393, 90, 0),
(1011, 'Cimitarra', 4500, 'ATQ: 6/14', -1, -1, 0, 3, 7, 0, 0, 268435456, 399, 90, 0),
(1012, 'Vara de mago', 30000, '', -1, -1, 0, 255, 0, 0, 0, 0, 400, 0, 0),
(1013, 'Martillo de Guerra', 0, '', -1, -1, 0, 0, 0, 0, 0, 0, 401, 100, 0),
(1014, 'espada de plata', 25000, 'ATQ: 10/20', -1, -1, 0, 0, 25, 0, 0, 268435456, 403, 15, 0),
(1015, 'Escudo de tortuga', 1000, 'DEF: 1/1', -1, -1, 0, 0, 0, 1, 0, 536870912, 404, 100, 0),
(1016, 'Casco de plata', 20000, 'DEF: 20/25', -1, -1, 0, 0, 0, 15, 0, 536870912, 405, 30, 0),
(1017, 'Arco compuesto', 1000, 'ATQ: 4/10', -1, -1, 0, 0, 5, 0, 0, 805306368, 479, 90, 0),
(1018, 'Flecha', 0, 'ATQ: 1/1', -1, -1, 0, 0, 0, 0, 0, 0, 480, 0, 1),
(1019, 'Dama blanca', 2000, 'DEF: 15/20', -1, -1, 0, 0, 0, 5, 0, 1073741824, 488, 100, 0),
(1020, 'Armadura de Placas rojas', 15000, 'DEF: 40/40', -1, -1, 0, 0, 10, 15, 5, 536870912, 493, 50, 0),
(1021, 'Armadura escarlata', 20000, 'DEF: 45/50', -1, -1, 0, 0, 10, 20, 0, 536870912, 495, 90, 0),
(1022, 'Vestido de Bruja', 20000, 'DEF: 15/20<br/>(H/E/EO-M)', -1, -1, 0, 0, 0, 5, 0, 1073741824, 513, 90, 0),
(1023, 'tunica combinada (e/g)', 7000, 'DEF: 30/35', -1, -1, 0, 10, 0, 10, 0, 1073741824, 525, 100, 0),
(1024, 'Túnica combinada (E/G) (M)', 7000, 'DEF: 30/35', -1, -1, 0, 10, 0, 15, 0, 1073741824, 526, 50, 0),
(1025, 'flecha +1', 6000, 'ATQ: 1/2', -1, -1, 0, 0, 5, 0, 0, 805306368, 551, 100, 0),
(1026, 'flecha +2', 7500, 'ATQ: 1/3', -1, -1, 0, 0, 7, 0, 0, 805306368, 552, 70, 0),
(1027, 'flecha +3', 10000, 'ATQ: 2/5', -1, -1, 0, 0, 12, 0, 0, 805306368, 553, 100, 0),
(1028, 'baston nudoso', 5000, 'ATQ: 1/1', -1, -1, 0, 7, 0, 0, 0, 805306368, 659, 100, 0),
(1029, 'baculo engarzado', 10000, 'ATQ: 1/1', -1, -1, 0, 15, 0, 0, 0, 805306368, 660, 100, 0),
(1030, 'sombrero de aprendiz', 2000, 'DEF: 1/1', -1, -1, 0, 0, 0, 5, 5, 1073741824, 661, 100, 0),
(1031, 'sombrero mágico', 9000, '', -1, -1, 0, 2, 0, 0, 5, 0, 383, 100, 0),
(1032, 'sombrero de mago', 6000, 'DEF: 1/1', -1, -1, 0, 5, 0, 5, 10, 1073741824, 662, 100, 0),
(1033, 'Arco compuesto reforzado', 6000, 'ATQ: 5/10', -1, -1, 0, 0, 8, 0, 0, 805306368, 664, 100, 0),
(1034, 'Arco de cazador', 9000, 'ATQ: 6/12', -1, -1, 0, 0, 10, 5, 0, 805306368, 665, 100, 0),
(1035, 'laúd mágico', 7000, 'DEF: 1/1', -1, -1, 0, 7, 0, 0, 0, 805306368, 696, 100, 0),
(1036, 'Anillo de Resistencia', 4000, 'DEF: 1/1', -1, -1, 0, 5, 0, 0, 5, 536870912, 697, 100, 0),
(1037, 'Anillo de Disolución', 15000, 'DEF: 1/1', -1, -1, 0, 15, 0, 0, 20, 536870912, 699, 1, 0),
(1038, 'cota de piquero', 0, '', -1, -1, 0, 0, 0, 0, 0, 0, 897, 100, 0),
(1039, 'flauta mágica', 7000, 'ATQ: 1/1', -1, -1, 0, 7, 0, 0, 0, 805306368, 208, 100, 0),
(1040, 'Daga', 0, 'NEWBIE', -1, -1, 0, 0, 0, 0, 0, 0, 15, 0, 1),
(1041, 'Daga', 1000, '', -1, -1, 0, 0, 0, 0, 0, 268435456, 15, 30, 0),
(1042, 'Daga +2', 0, 'NEWBIE', -1, -1, 0, 0, 0, 0, 0, 0, 365, 0, 1),
(1043, 'Hacha de bárbaro', 0, 'NEWBIE', -1, -1, 0, 0, 0, 0, 0, 0, 159, 0, 1),
(1044, 'Vara de fresno', 0, 'NEWBIE', -1, -1, 0, 0, 0, 0, 0, 0, 658, 0, 1),
(1045, 'Arco simple', 0, 'NEWBIE', -1, -1, 0, 0, 0, 0, 0, 0, 478, 0, 1),
(1046, 'Arco simple', 1000, 'ATQ: 1/4', -1, -1, 0, 0, 4, 0, 0, 0, 478, 0, 0),
(1047, 'Túnica de mago', 2500, 'DEF: 5/15', -1, -1, 0, 0, 0, 5, 0, 1073741824, 196, 50, 0),
(1048, 'Túnica azul', 0, 'NEWBIE', -1, -1, 0, 0, 0, 0, 0, 0, 238, 0, 1),
(1049, 'Túnica roja', 0, 'NEWBIE', -1, -1, 0, 0, 0, 0, 0, 0, 239, 0, 1),
(1050, 'Armadura de cuero', 2500, 'DEF: 5/15', -1, -1, 0, 0, 0, 5, 0, 0, 30, 0, 0),
(1051, 'Escudo de tortuga ', 0, 'NEWBIE', -1, -1, 0, 0, 0, 0, 0, 0, 404, 0, 1),
(1052, 'Gorro de aprendiz', 0, 'NEWBIE', -1, -1, 0, 0, 0, 0, 0, 0, 661, 0, 1),
(1053, 'Tunica de mago (E/G)', 0, '', -1, -1, 0, 0, 0, 0, 0, 0, 670, 0, 1),
(1054, 'Tunica de mago (E/G)', 2500, 'DEF: 5/15', -1, -1, 0, 0, 0, 5, 0, 1073741824, 670, 50, 0),
(1055, 'Tunica de monje (E/G)', 2500, 'DEF: 5/15', -1, -1, 0, 0, 0, 5, 0, 1073741824, 671, 50, 0),
(1056, 'Tunica de monje (E/G)', 0, 'NEWBIE', -1, -1, 0, 0, 0, 0, 0, 0, 671, 0, 1),
(1057, 'Túnica de ovispo (E/G)', 0, 'NEWBIE', -1, -1, 0, 0, 0, 0, 0, 0, 507, 0, 1),
(1058, 'Armadura de cuero (E/G)', 2500, 'DEF: 5/15', -1, -1, 0, 0, 0, 5, 0, 536870912, 668, 50, 0),
(1059, 'Armadura de cuero (E/G)', 0, 'NEWBIE', -1, -1, 0, 0, 0, 0, 0, 0, 668, 0, 1),
(1060, 'Armadura de cuero', 0, 'NEWBIE', -1, -1, 0, 0, 0, 0, 0, 0, 30, 0, 1),
(1061, 'Flecha Común', 4500, 'ATQ: 1/1', -1, -1, 0, 0, 4, 0, 0, 805306368, 480, 80, 0),
(1062, 'Armadura de Dragón (E/G)', 20000, 'DEF: 60/65', -1, -1, 0, 0, 30, 30, 30, 536870912, 482, 100, 0),
(1063, 'Túnica de Mago Oscuro', 30000, 'DEF: 5/8', -1, -1, 0, 25, 25, 25, 25, 1073741824, 518, 25, 0);

-- --------------------------------------------------------

--
-- Table structure for table `logs`
--

CREATE TABLE `logs` (
  `ID` mediumint(8) UNSIGNED NOT NULL,
  `text` varchar(255) NOT NULL,
  `time` int(10) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `mapas`
--

CREATE TABLE `mapas` (
  `ID` int(11) NOT NULL,
  `UID` int(11) NOT NULL,
  `Nombre` varchar(32) NOT NULL,
  `Desc` varchar(255) NOT NULL,
  `Tipo` int(11) NOT NULL,
  `MapaID` int(11) NOT NULL,
  `Version` int(11) NOT NULL,
  `size_sin_comprimir` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `mapas`
--

INSERT INTO `mapas` (`ID`, `UID`, `Nombre`, `Desc`, `Tipo`, `MapaID`, `Version`, `size_sin_comprimir`) VALUES
(1, 0, 'default', 'sin descripcion', 0, 1, 1, 1000218),
(2, 0, 'default', 'sin descripcion', 0, 2, 1, 1000218),
(3, 0, 'default', 'sin descripcion', 0, 1, 2, 1000218),
(4, 1, 'default', 'sin descripcion', 0, 4, 1, 1000218);

-- --------------------------------------------------------

--
-- Table structure for table `mercader`
--

CREATE TABLE `mercader` (
  `ID` int(11) UNSIGNED NOT NULL,
  `hash` varbinary(32) NOT NULL,
  `tiempo` int(11) NOT NULL DEFAULT 0,
  `items` smallint(6) NOT NULL DEFAULT 0,
  `o1` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o2` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o3` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o4` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o5` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o6` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o7` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o8` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o9` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `o10` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `o11` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `o12` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `o13` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `o14` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `o15` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `o16` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `o17` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `o18` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `o19` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `o20` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `o21` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o22` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o23` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o24` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o25` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o26` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o27` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o28` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o29` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `o30` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t1` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t2` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t3` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t4` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t5` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t6` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t7` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t8` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t9` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t10` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t11` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t12` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t13` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t14` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t15` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t16` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t17` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t18` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t19` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t20` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t21` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t22` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t23` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t24` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t25` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t26` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t27` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t28` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t29` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t30` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `f1` int(11) NOT NULL DEFAULT 0,
  `f2` int(11) NOT NULL DEFAULT 0,
  `f3` int(11) NOT NULL DEFAULT 0,
  `f4` int(11) NOT NULL DEFAULT 0,
  `f5` int(11) NOT NULL DEFAULT 0,
  `f6` int(11) NOT NULL DEFAULT 0,
  `f7` int(11) NOT NULL DEFAULT 0,
  `f8` int(11) NOT NULL DEFAULT 0,
  `f9` int(11) NOT NULL DEFAULT 0,
  `f10` int(11) NOT NULL DEFAULT 0,
  `f11` int(11) NOT NULL DEFAULT 0,
  `f12` int(11) NOT NULL DEFAULT 0,
  `f13` int(11) NOT NULL DEFAULT 0,
  `f14` int(11) NOT NULL DEFAULT 0,
  `f15` int(11) NOT NULL DEFAULT 0,
  `f16` int(11) NOT NULL DEFAULT 0,
  `f17` int(11) NOT NULL DEFAULT 0,
  `f18` int(11) NOT NULL DEFAULT 0,
  `f19` int(11) NOT NULL DEFAULT 0,
  `f20` int(11) NOT NULL DEFAULT 0,
  `f21` int(11) NOT NULL DEFAULT 0,
  `f22` int(11) NOT NULL DEFAULT 0,
  `f23` int(11) NOT NULL DEFAULT 0,
  `f24` int(11) NOT NULL DEFAULT 0,
  `f25` int(11) NOT NULL DEFAULT 0,
  `f26` int(11) NOT NULL DEFAULT 0,
  `f27` int(11) NOT NULL DEFAULT 0,
  `f28` int(11) NOT NULL DEFAULT 0,
  `f29` int(11) NOT NULL DEFAULT 0,
  `f30` int(11) NOT NULL DEFAULT 0,
  `p1` mediumint(8) UNSIGNED NOT NULL DEFAULT 1,
  `p2` mediumint(8) UNSIGNED NOT NULL DEFAULT 1,
  `p3` mediumint(8) UNSIGNED NOT NULL DEFAULT 1,
  `p4` mediumint(8) UNSIGNED NOT NULL DEFAULT 1,
  `p5` mediumint(8) UNSIGNED NOT NULL DEFAULT 1,
  `p6` mediumint(8) UNSIGNED NOT NULL DEFAULT 1,
  `p7` mediumint(8) UNSIGNED NOT NULL DEFAULT 1,
  `p8` mediumint(8) UNSIGNED NOT NULL DEFAULT 1,
  `p9` mediumint(8) UNSIGNED NOT NULL DEFAULT 1,
  `p10` mediumint(8) UNSIGNED NOT NULL DEFAULT 1,
  `p11` mediumint(8) UNSIGNED NOT NULL DEFAULT 1,
  `p12` mediumint(8) UNSIGNED NOT NULL DEFAULT 1,
  `p13` mediumint(8) UNSIGNED NOT NULL DEFAULT 1,
  `p14` mediumint(8) UNSIGNED NOT NULL DEFAULT 1,
  `p15` mediumint(8) UNSIGNED NOT NULL DEFAULT 1,
  `p16` mediumint(8) UNSIGNED NOT NULL DEFAULT 1,
  `p17` mediumint(8) UNSIGNED NOT NULL DEFAULT 1,
  `p18` mediumint(8) UNSIGNED NOT NULL DEFAULT 1,
  `p19` mediumint(8) UNSIGNED NOT NULL DEFAULT 1,
  `p20` mediumint(8) UNSIGNED NOT NULL DEFAULT 1,
  `p21` mediumint(8) UNSIGNED NOT NULL DEFAULT 1,
  `p22` mediumint(8) UNSIGNED NOT NULL DEFAULT 1,
  `p23` mediumint(8) UNSIGNED NOT NULL DEFAULT 1,
  `p24` mediumint(8) UNSIGNED NOT NULL DEFAULT 1,
  `p25` mediumint(8) UNSIGNED NOT NULL DEFAULT 1,
  `p26` mediumint(8) UNSIGNED NOT NULL DEFAULT 1,
  `p27` mediumint(8) UNSIGNED NOT NULL DEFAULT 1,
  `p28` mediumint(8) UNSIGNED NOT NULL DEFAULT 1,
  `p29` mediumint(8) UNSIGNED NOT NULL DEFAULT 1,
  `p30` mediumint(8) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=binary COMMENT='LaG';

--
-- Dumping data for table `mercader`
--

INSERT INTO `mercader` (`ID`, `hash`, `tiempo`, `items`, `o1`, `o2`, `o3`, `o4`, `o5`, `o6`, `o7`, `o8`, `o9`, `o10`, `o11`, `o12`, `o13`, `o14`, `o15`, `o16`, `o17`, `o18`, `o19`, `o20`, `o21`, `o22`, `o23`, `o24`, `o25`, `o26`, `o27`, `o28`, `o29`, `o30`, `t1`, `t2`, `t3`, `t4`, `t5`, `t6`, `t7`, `t8`, `t9`, `t10`, `t11`, `t12`, `t13`, `t14`, `t15`, `t16`, `t17`, `t18`, `t19`, `t20`, `t21`, `t22`, `t23`, `t24`, `t25`, `t26`, `t27`, `t28`, `t29`, `t30`, `f1`, `f2`, `f3`, `f4`, `f5`, `f6`, `f7`, `f8`, `f9`, `f10`, `f11`, `f12`, `f13`, `f14`, `f15`, `f16`, `f17`, `f18`, `f19`, `f20`, `f21`, `f22`, `f23`, `f24`, `f25`, `f26`, `f27`, `f28`, `f29`, `f30`, `p1`, `p2`, `p3`, `p4`, `p5`, `p6`, `p7`, `p8`, `p9`, `p10`, `p11`, `p12`, `p13`, `p14`, `p15`, `p16`, `p17`, `p18`, `p19`, `p20`, `p21`, `p22`, `p23`, `p24`, `p25`, `p26`, `p27`, `p28`, `p29`, `p30`) VALUES
(1, 0x3435313061373831643430616637396462313135356461306232616132626665, 1318096396, 29, 1002, 995, 996, 1002, 1001, 1006, 1007, 997, 1005, 996, 996, 1005, 124, 1001, 1001, 997, 1011, 2, 1002, 124, 1014, 1002, 997, 2, 995, 2, 1001, 995, 0, 2, 150, 500, 300, 500, 300, 300, 300, 150, 300, 750, 500, 500, 500, 150, 150, 300, 300, 750, 500, 500, 300, 750, 750, 750, 150, 300, 150, 500, 0, 150, 0, 536870912, 268435492, 536870916, 268435460, 268435456, 268435456, 4, 268435460, 805306368, 536870912, 536870944, 536870936, 36, 4, 268435488, 268435464, 805306376, 536870916, 536870920, 268435464, 805306368, 805306368, 805306376, 4, 268435456, 0, 536870912, 0, 10, 4001, 6252, 4667, 10802, 12962, 6002, 10002, 6481, 4322, 6003, 5002, 5402, 17498, 6999, 6481, 12962, 9722, 22683, 10802, 16202, 54002, 12003, 18003, 22683, 2701, 14002, 6001, 6252, 0, 8165),
(2, 0x6638326130613633613464346266393332303536363931626366363730396333, 1318099343, 29, 356, 497, 999, 497, 489, 993, 1015, 0, 989, 1010, 1062, 500, 1015, 1062, 987, 1009, 496, 1010, 1015, 1015, 993, 497, 989, 1010, 496, 496, 999, 991, 1036, 1062, 500, 300, 750, 150, 750, 500, 150, 0, 150, 750, 150, 500, 150, 300, 150, 300, 500, 150, 750, 300, 500, 150, 500, 500, 300, 150, 750, 500, 300, 750, 536870920, 268435472, 805306368, 8, 805306378, 536870938, 32, 0, 8, 805306378, 4, 536870928, 0, 268435456, 10, 268435480, 536870936, 8, 805306372, 268435456, 536870922, 26, 536870922, 536870920, 268435456, 8, 805306368, 536870928, 268435488, 805306400, 21602, 43202, 12003, 21601, 69987, 12600, 1081, 0, 8641, 52491, 21601, 54002, 1001, 40002, 5833, 27995, 58322, 16201, 3243, 2002, 11666, 25195, 23330, 40502, 40002, 21601, 12003, 21602, 8642, 64803),
(3, 0x3638643436396162663238356232663966653937306632336438383538396536, 1318096566, 29, 1033, 1061, 0, 1027, 1034, 1025, 31, 1034, 31, 1025, 1033, 1033, 1025, 1034, 1025, 1028, 1033, 1034, 1035, 1027, 31, 1035, 1025, 1017, 1039, 1028, 31, 31, 1039, 1027, 750, 300, 0, 150, 750, 150, 150, 300, 750, 750, 500, 500, 750, 150, 150, 500, 300, 750, 750, 300, 500, 500, 500, 750, 150, 500, 300, 300, 300, 300, 805306404, 268435472, 0, 0, 805306368, 0, 32, 268435488, 805306368, 805306400, 536870912, 536870916, 805306372, 32, 0, 536870912, 268435456, 805306368, 805306400, 268435492, 536870944, 536870944, 536870912, 805306376, 0, 536870944, 268435456, 268435456, 268435488, 268435492, 20998, 9722, 0, 10001, 27003, 6001, 16777215, 19442, 16777215, 19443, 15002, 16202, 19443, 9721, 6001, 12502, 12002, 27003, 22683, 23330, 16777215, 18902, 15002, 3243, 7001, 13502, 16777215, 16777215, 15122, 23330),
(4, 0x6236373162336362343232366566323836303866656230616335643830333738, 1318095817, 27, 1030, 1032, 1032, 1023, 988, 0, 1032, 1004, 988, 0, 1022, 1019, 1019, 1032, 1023, 0, 360, 1024, 360, 519, 360, 1023, 988, 988, 1030, 988, 1022, 1019, 1032, 1022, 500, 150, 150, 300, 750, 0, 750, 300, 150, 0, 750, 500, 150, 750, 500, 0, 150, 750, 500, 300, 500, 500, 750, 750, 150, 500, 150, 500, 500, 500, 536870944, 0, 32, 268435460, 805306394, 0, 805306404, 268435460, 24, 0, 805306368, 536870912, 4, 805306368, 536870912, 0, 16, 805306370, 536870920, 268435456, 536870914, 536870912, 805306376, 805306378, 0, 536870920, 8, 536870912, 536870916, 536870912, 5402, 6001, 6481, 15122, 37795, 0, 20998, 3242, 11665, 0, 60003, 5002, 2161, 18003, 17502, 0, 10801, 22683, 27002, 16002, 27002, 17502, 32403, 34995, 2001, 27002, 21601, 5002, 16202, 50002);

-- --------------------------------------------------------

--
-- Table structure for table `mochila`
--

CREATE TABLE `mochila` (
  `UID` mediumint(9) UNSIGNED NOT NULL,
  `CuentaID` int(11) UNSIGNED NOT NULL,
  `o1` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o2` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o3` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o4` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o5` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o6` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o7` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o8` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `o9` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `o10` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `o11` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `o12` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `o13` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `o14` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `o15` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `o16` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t1` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t2` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t3` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t4` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t5` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t6` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t7` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t8` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t9` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t10` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t11` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t12` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t13` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t14` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t15` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `t16` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `f1` int(11) NOT NULL DEFAULT 0,
  `f2` int(11) NOT NULL DEFAULT 0,
  `f3` int(11) NOT NULL DEFAULT 0,
  `f4` int(11) NOT NULL DEFAULT 0,
  `f5` int(11) NOT NULL DEFAULT 0,
  `f6` int(11) NOT NULL DEFAULT 0,
  `f7` int(11) NOT NULL DEFAULT 0,
  `f8` int(11) NOT NULL DEFAULT 0,
  `f9` int(11) NOT NULL DEFAULT 0,
  `f10` int(11) NOT NULL DEFAULT 0,
  `f11` int(11) NOT NULL DEFAULT 0,
  `f12` int(11) NOT NULL DEFAULT 0,
  `f13` int(11) NOT NULL DEFAULT 0,
  `f14` int(11) NOT NULL DEFAULT 0,
  `f15` int(11) NOT NULL DEFAULT 0,
  `f16` int(11) NOT NULL DEFAULT 0,
  `last_death` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='LaG';

-- --------------------------------------------------------

--
-- Table structure for table `noticias`
--

CREATE TABLE `noticias` (
  `id` int(6) NOT NULL,
  `name` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `msg` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `date` int(11) NOT NULL DEFAULT 0,
  `titulo` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `completa` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `noticias`
--

INSERT INTO `noticias` (`id`, `name`, `msg`, `date`, `titulo`, `completa`) VALUES
(29, 'Menduz', 'Para comprar items:\r\nIngresar a su cuenta de Arduz.\r\nEn el panel ir al último vínculo, que dice [i][Ir al mercado de items][/i] ó seguir este link: [url=http://www.arduz.com.ar/ao/index.php?a=items]Items[/url]\r\nSeleccionar el item que querés.\r\nElegir la cantidad de tiempo que lo querés tener.\r\nY comprar.^^\r\n\r\nEl máximo de items es de 8 por personaje, podés esperar a que se borren solos, cuando vence el plazo, ó borrarlos (Ojo que no se pueden recuperar).\r\nLos items se cambian por puntos igual que los clanes.\r\n\r\nSuerte\r\n', 1228973700, 'Mercado de items activado!', ''),
(30, 'Menduz', '[url=http://www.4shared.com/file/78113240/ebb1819a/Arduz_15.html ][b][u]Link de descarga[/u][/b][/url]\r\n\r\n\r\nPara saber las nuevas características de el nuevo cliente, y servidores, de Arduz hacé click [url=http://www.noicoder.com/foro/general/nuevo-parche-t359.0.html]ACÁ[/url]\r\n\r\nSaludos, El equipo de Arduz AO.', 1230593520, 'Nuevo Cliente!', ''),
(31, 'Menduz', 'Nuevo pache obligatorio, se solucionaron:\r\n[b]runtimes, problemas de resolución, bugs[/b] de la versión, etc, bug en el que cualquier personaje podia reiniciar la partida etc...\r\n[url=http://www.4shared.com/file/78273184/4bfb33d8/Parche_15_a_151_Arduz.html][b]Link al parche[/b][/url]\r\n\r\nSuerte', 1230686700, 'Nuevo parche con muchas soluciones!', ''),
(26, 'Menduz', 'Pociones arregladas.\r\nBots auto-balanceados para cada equipo.\r\nLetras con el hit que se desvanecen en el \\\"aire\\\".\r\nSe encriptaron los archivos de los servidores para que no hagan modificaciones de balances.\r\nEntre otras cosas..\r\n\r\nhttp://www.4shared.com/file/71822956/5a17f3a1/Parche.html\r\n\r\nSaludos.', 1227558600, 'Nuevo parche!', ''),
(27, 'Menduz', '[img]http://www.noicoder.com/aofirma/cache/1.png[/img]\r\n\r\nDesde el panel tienen su imágen, y el vínculo a ella para que puedan ponerla como firma de foros o donde quieran, esta les dá información básica sobre su personaje; posición en el ranking, cuantos puestos bajaron o subieron en el día, su clan, sus frags etc!\r\n\r\nEspero que les guste!\r\n\r\nSaludos', 1228771440, 'Firmas dinámicas de Arduz!', ''),
(22, 'Menduz', 'Ya terminamos el sistema de Clanes!\r\nPara tener tu Clan tenés que juntar 500.000 puntos en el ranking, identificarte en la seccion [b]Mi Cuenta[/b] con tu usuario y contraseña, ir a la opción [b][Crear Clan][/b], elegir un nombre para el clan y listo!.\r\n\r\nYa pueden mandarte solicitudes, podés administrar a los miembros de una forma facil desde el panel de clanes etc.\r\n\r\nLas solicitudes a los clanes se mandan desde el ranking de clanes, una vez identificados en sus cuentas.\r\n\r\nSuerte!\r\n\r\n[i][u][b]Felicidades a Gordo Cato por haber conseguido los 500k de puntos y haber creado el primer clan Real en arduz ^^[/b][/u][/i]', 1226928300, 'Clanes funcionando!', ''),
(18, 'Ares', 'Finalmente estamos viendo concretado [b]Arduz AO[/b], que empezamos junto a Menduz meses atrás.\r\n\r\nEste proyecto comenzó con una idea muy básica, aunque muy buena:\r\nCrear no solo un servidor de agite de fácil acceso, balanceado y que pueda sostener una gran cantidad de usuarios constantemente, sinó también que cada usuario pueda crear su propio servidor en casa.\r\n\r\nLuego de semanas de trabajo, los prototipos de Arduz fueron dando frutos y fueron resueltos los bugs y problemas que saltaban a simple vista, dando lugar después de cada reparación, un nuevo y mejorado Arduz.\r\n\r\nEncontrarán al comenzar el juego innovadoras opciones como el sistema de puntos y frags, que podrán chequear cada vez que lo deseen en la web.\r\n\r\nCada usuario va a ser capaz de abrir su propio servidor, con un máximo de 20 usuarios, para promover partidas rápidas y espontáneas. A la vez agregamos herramientas que facilitan el trabajo de cada host, cambio de mapa instantáneo, echar usuarios no queridos en la partida, etc.\r\n\r\nCambio de clase y de bando, [b]sistema de bots[/b] (aliados y enemigos, con su propio nivel de inteligencia artificial), son cosas que ofrecen los servidores Arduz AO.\r\n\r\nDesde ya, muchas gracias por todo y esperamos que les guste.\r\n\r\nAtte.\r\n\r\nAres, Staff de Arduz AO', 1233073680, '¡Bienvenidos a ARDUZ!', ''),
(25, 'Menduz', '[url=http://www.4shared.com/file/71822956/5a17f3a1/Parche.html]http://www.4shared.com/file/71822956/5a17f3a1/Parche.html[/url]\r\n\r\nArduz [b]se encuentra funcionando con un nuevo parche[/b].. consigo trae muchas mejoras.\r\nEntre ellas:\r\n\r\n> Clases prohibidas/permitidas\r\n> Contraseña de servers(para hacer [i]cerrados[/i])\r\n> Usuarios máximos por servidor, 4 a 20 usuarios.\r\n> Opción para jugar en [i]LAN[/i] de modo independiente, sin aparecer en la lista de servidores.\r\n> Soporte para pcs lentas (En la pantalla de opciones, elegir [i]Mayor velocidad[/i] para pcs rápidas ó [i]Mayor rendimiento[/i] para pcs más lentas)\r\n> Un mejorado protocolo WEB<>SERVIDOR entre otros..\r\n\r\nSi encuentran algún bug/error o como lo quieran llamar por favor publiquenlo en nuestro foro. \r\n\r\nSaludos\r\n\r\nMenduz.', 1227418500, 'Arduz funcionando.', ''),
(24, 'Menduz', 'Los [b]servidores de Arduz están deshabilitados por razones técnicas[/b], también el ranking, que fue el origen del problema. Este consumía demasiados recursos del servidor, lo cual probocó la suspención de la cuenta de hosting.\r\n\r\n[b]Estamos rediseñando los protocolos[/b] web>server server>web, para ahorrar recursos de sistema tanto en tu pc, como en el servidor web, esto nos lleva a deshabilitar temporalmente Arduz.\r\n\r\nEspero que sepan entender.\r\n\r\nCualquier avance va a ser publicado acá, en la página principal de Arduz.\r\n\r\nSaludos\r\n\r\nMenduz.', 1227368284, '¿Qué pasa con Arduz?', ''),
(33, 'Menduz', 'Beta cerrada: durante el comingo 11/10. Durante esta beta pretendemos que arduz 1 siga funcionando correctamente, la página de arduz 1 no va a funcionar, en cambio va a aparecer la de arduz2. Sin posibilidad de descargar, estamos analizando si permitir o no el registro de personajes durante la beta cerrada.\r\n\r\nLanzamiento publico previsto: domingo 11/10 a las 12pm\r\n\r\nCondiciones:\r\n-Se va a dar un período indeterminado \\\"fase de TESTEO\\\", esperemos que menos de 2 semanas.\r\n-El honor NO va a sumar en esta etapa.\r\n-Sí los puntos.\r\n-Va a haber parches periódicos solucionando bugs, no es problema gracias al updater.\r\n-Los items van a salir baratos.\r\n\r\n-Una vez finalizada la etapa de testeo, se borrarán los items, personajes, puntos y ranking. Las cuentas quedan.\r\n\r\nVale aclarar que todo esto es estimativo. Los plazos y fechas están sujetos a modificaciones.', 1255214820, 'Organización de Arduz 2', ''),
(36, 'Menduz', 'Bueno, perdimos la cuenta de la lista de bugs a solucionar. En esta semana vamos a ir arreglándolos de a poco. Sean pacientes, por favor a los que encuentren bugs o tengan sugerencias publiquen las en el foro, si nos ayuda los vamos a recompensar cuando termine el testeo y resetiemos.\r\n\r\n[url=http://www.noicoder.com/foro/arduz-ao/bugs-arduz-ii-t973.0.html]Publicquen los bugs acá.[/url]\r\n\r\n[b]Lo que hagan ahora NO VA A QUEDAR REGISTRADO EN EL RANKING, YA SEA PUNTOS, FRAGS, ITEMS. Todo se borra finalizado el testeo general.[/b]\r\n\r\nGracias por la paciencia..', 1255404720, 'Incontables bugs.', ''),
(37, 'Menduz', 'Para solucionar unos errores del juego tuvimos que reiniciar los inventarios y bóvedas a cero. Los objetos siguen saliendo 1 moneda, asi que no es problema. Sólo vuelvan a comprar los objetos que quieran.\r\n\r\nUn abrazo.', 1255909320, 'Reset de inventarios', ''),
(38, 'Menduz', 'Hoy hicimos una actualización en el juego, eta se descarga automáticamente. Si no se instala correctamente, o no se descarga, o el AutoUpdater no funciona(que es probable) pueden descargarla desde [url=http://www.4shared.com/file/142231379/56448704/_3__Parche.html]acá[/url]\r\n\r\nUn abrazo.', 1256063001, 'Actualización', ''),
(39, 'Menduz', 'Ya se movió completamente el servidor de datos y la web ya lo enlaza.\r\n\r\nPosiblemente los que se hayan creado cuenta después del 22 de octubre, tengan que volver a crearla, ya que la base de datos es la de ese dia. El ranking siguió funcionando con los usuarios creados, asi que los frags y puntos quedaron registrados siempre.\r\n\r\nUn abrazo.', 1256606281, 'Servidor funcionando', ''),
(40, 'Menduz', 'Estamos trabajando a full para terminar la version estable de Arduz 2.\r\nYa tenemos la web en un datacenter estable y muy bueno.\r\nTenemos la versión estable casi terminada.\r\nTenemos [u]muchos[/u] errores solucionados.\r\n\r\nEntre otras cosas\r\n\r\nPueden seguir el avance de la nueva versión en ésta dirección:\r\n [url=http://www.arduz.com.ar/version.php]Arduz Changelog[/url]\r\n\r\nUn abrazo', 1258054740, 'Próximos cambios', ''),
(41, 'Ares', 'Nueva versión de Arduz, solucionamos aproximadamente 80 errores que afectaban notablemente la jugabilidad, y agregamos un par de cosas nuevas.\r\n[url=http://www.noicoder.com/foro/arduz-ao/bugserroressujerencias-t1043.0.html]Click acá para informarnos errores/BUGS/sugerencias[/url]\r\n[url=http://www.arduz.com.ar/version.php#0.2.0]Click acá para ver los nuevos cambios[/url]\r\nPasos para poder jugar:\r\n[b]1.[/b] Prender el AutoUpdate.exe desde la carpeta del juego.\r\n[b]2.[/b] Volver a prender AutoUpdate.exe (tiene icono distinto ahora)\r\n[b]3.[/b] Jugar.\r\nSi no les funciona alguno de los pasos:\r\n[u][url=http://ao.noicoder.com/updates/updater.zip]Click acá para descargar el nuevo updater[/url][/u]\r\n[u][url=http://ao.noicoder.com/updates/11-15.zip]Click acá para bajar el parche del juego[/url][/u]\r\n\r\n[u][b]Aclaraciones importantes:[/b][/u]\r\n-[i]Ahora volvió a funcionar la web.[/i]\r\n-[i]Ya se pueden crear cuentas, personajes y comerciar normalmente.[/i]\r\n-[i]Los mercaderes siguen en 1 moneda de oro.[/i]\r\n\r\nUn abrazo\r\n', 1258320300, 'Arduz AO v0.2.01', ''),
(42, 'Ares', 'Hoy terminó la etapa de testeo, se solucionaron todos los bugs reportados. Y los que informó la base de datos, quedó uno (error 91) que todavía no sabemos porqué se produce.\r\n\r\nLos items van a tener precio más alto y se va a hacer un reset de personajes, NO DE USUARIOS, no van a tener que crear los usuarios nuevamente.\r\n\r\nEl ranking está arreglado.\r\n\r\nAnte cualquier cosnulta pasen por nuestro foro.\r\n\r\nUn abrazo.\r\n\r\n[b]Edit:[/b]\r\n[i]-Reducimos los intervalos de las pociones en todas las clases.[/i]\r\n', 1259534340, '¡Chau etapa de testeo!', ''),
(43, 'Ares', 'Para todos [b]los que presentan cualquiera de los siguientes errores[/b]:\r\n- Tarda en cargar la lista de servidores\r\n- No funciona el AutoUpdater\r\n- El servidor les dice -Balance desconfigurado...-\r\n- El servidor se borra de la lista de servidores\r\n- No se descargan las actualizaciones\r\n\r\nDescargue nuevamente el cliente completo haciendo [u][url=http://www.arduz.com.ar/descargar.php]click acá[/url][/u], este está con todas las actualizaciones instaladas, y librerías necesarias para jugar.\r\n\r\nUn abrazo.\r\n\r\n', 1260497940, 'Cliente optimizado', ''),
(44, 'Ares', 'Si se te jodió el updater, bajalo desde acá:\r\n\r\n[url=http://ao.noicoder.com/updates/AutoUpdate.exe]AutoUpdate.exe[/url]\r\n\r\nUn abrazo', 1260642180, 'Si se te jodió el updater', ''),
(45, 'Ares', 'Esperamos que con esta nueva actualización se solucione el problema que se cierra el juego cada 15 minutos.', 1260939720, 'Nueva actualización', ''),
(46, 'Menduz', 'PPronto vamos a activar los clanes en Arduz Online.\r\nLes dejo la lista de requerimientos para crear clan:\r\n- 250.000 puntos/oro (Se descuentan de la cuenta)\r\n- 150.000 puntos de honor ([i][u]NO[/u][/i] se descuentan)\r\n\r\nOtro tema, se soluciono el problema con las pociones en los servidores oficiales, ya se puede jugar normalmente.\r\n\r\nUn abrazo\r\n', 1104285600, 'Anuncio clanes.', ''),
(47, 'Ares', 'Les dejo la lista de requerimientos para crear clan:\r\n- 250.000 puntos/oro (Se descuentan de la cuenta)\r\n- 150.000 puntos de honor ([i][u]NO[/u][/i] se descuentan)\r\n\r\nPara crear clan, tienen que ingresar en \\\"Clanes\\\" en \\\"Mi Cuenta\\\"', 1263420273, 'Clanes Activados.', ''),
(48, 'Ares', 'Anunciamos que debido a problemas con noicoder.com, tuvimos que cambiar la ubicación del foro. Ahora se aloja en NRGGames.\r\n\r\n[url=http://foro.nrggames.com/forumdisplay.php?f=344]Foro Arduz Online[/url]', 1264563465, '¡Nuevo foro!', ''),
(49, 'Menduz', 'Después de unas vacaciones de 5 meses, voy a empezar a dedicarle un poco más de tiempo a Arduz a hacerle un par de modificaciones, para poder encargarle el proyecto a otra persona, ya que no tengo más tiempo extra como antes.\r\n\r\nPara recuperar contraseña/cambiar contraseña van a tener que ingresar a [url=http://www.arduz.com.ar/recordar.php]Recuperar contraseña[/url], y poner su nombre de usuario. Les va a llegar un mail con información para continuar con el cambio. En el mail van a encontrar un link que los va a llevar a la página de Arduz y les va a solicitar una nueva contraseña. Y eso es todo.', 1276295220, 'Recuperar contraseña', '');

-- --------------------------------------------------------

--
-- Table structure for table `pjs`
--

CREATE TABLE `pjs` (
  `ID` int(11) NOT NULL,
  `IDCuenta` int(11) NOT NULL,
  `nick` varchar(30) NOT NULL,
  `clan` int(11) NOT NULL DEFAULT 0,
  `magia` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `combate` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `defenza` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `resistencia` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `cuando_termina` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `cualskill` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `pagado` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `vidaup` mediumint(9) NOT NULL DEFAULT 0,
  `raza` tinyint(1) UNSIGNED NOT NULL DEFAULT 1,
  `clase` tinyint(1) UNSIGNED NOT NULL DEFAULT 1,
  `cabeza` mediumint(8) UNSIGNED NOT NULL DEFAULT 1,
  `genero` tinyint(1) NOT NULL DEFAULT 1,
  `armcao` tinyint(4) NOT NULL,
  `TieneItems` tinyint(1) NOT NULL DEFAULT 0,
  `items_act` int(11) NOT NULL,
  `items` varchar(255) NOT NULL,
  `order` int(11) NOT NULL,
  `muertes` int(11) NOT NULL,
  `frags` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pjs_cached`
--

CREATE TABLE `pjs_cached` (
  `UID` int(10) UNSIGNED NOT NULL,
  `pjs_cache` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `razas`
--

CREATE TABLE `razas` (
  `raza` smallint(5) UNSIGNED NOT NULL,
  `clase` smallint(5) UNSIGNED NOT NULL,
  `max_hit` mediumint(8) UNSIGNED NOT NULL,
  `min_hit` mediumint(8) UNSIGNED NOT NULL,
  `mana` mediumint(8) UNSIGNED NOT NULL,
  `vida` mediumint(8) UNSIGNED NOT NULL,
  `inicial` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `razas`
--

INSERT INTO `razas` (`raza`, `clase`, `max_hit`, `min_hit`, `mana`, `vida`, `inicial`) VALUES
(1, 1, 31, 30, 2206, 274, '1049-1044-1052'),
(1, 2, 70, 70, 1454, 332, '1048-1043-1051'),
(1, 3, 105, 105, 0, 410, '1060-1043-1000-1051'),
(1, 4, 100, 100, 752, 332, '1060-1042-1000'),
(1, 5, 1, 1, 5001, 6002, '1'),
(1, 6, 60, 60, 1454, 332, '1049-1040'),
(1, 7, 60, 60, 1454, 332, '1049-1040'),
(1, 8, 50, 50, 6001, 16000, ''),
(1, 9, 85, 80, 702, 390, '1060-1043-1000-1051'),
(1, 10, 100, 100, 0, 390, '1060-1045-1018'),
(2, 1, 31, 30, 2440, 254, '1049-1044-1052'),
(2, 2, 70, 70, 1610, 312, '1048-1043-1051'),
(2, 3, 105, 105, 0, 390, '1060-1043-1000-1051'),
(2, 4, 100, 100, 830, 312, '1060-1042-1000'),
(2, 5, 50, 50, 800, 200, ''),
(2, 6, 60, 60, 1610, 312, '1049-1040'),
(2, 7, 60, 60, 1610, 312, '1049-1040'),
(2, 8, 50, 50, 16000, 16000, '31-32'),
(2, 9, 85, 80, 780, 371, '1060-1043-1000-1051'),
(2, 10, 100, 100, 0, 371, '1060-1045-1018'),
(3, 1, 31, 30, 2440, 254, '1049-1044-1052'),
(3, 2, 70, 70, 1610, 312, '1048-1043-1051'),
(3, 3, 105, 105, 0, 390, '1060-1043-1000-1051'),
(3, 4, 100, 100, 830, 312, '1060-1042-1000'),
(3, 5, 50, 50, 800, 200, ''),
(3, 6, 60, 60, 1610, 312, '1049-1040'),
(3, 7, 60, 60, 1610, 312, '1049-1040'),
(3, 8, 50, 50, 800, 200, '31'),
(3, 9, 85, 80, 780, 371, '1060-1043-1000-1051'),
(3, 10, 100, 100, 0, 371, '1060-1045-1018'),
(4, 1, 31, 30, 2557, 234, '1056-1044-1052'),
(4, 2, 70, 70, 1688, 293, '1057-1043-1051'),
(4, 3, 105, 105, 0, 371, '1059-1043-1000-1051'),
(4, 4, 100, 100, 869, 293, '1059-1042-1000'),
(4, 5, 50, 50, 800, 200, ''),
(4, 6, 60, 60, 1688, 292, '1057-1040'),
(4, 7, 60, 60, 1688, 293, '1057-1040'),
(4, 8, 50, 50, 800, 9900, ''),
(4, 9, 85, 80, 819, 351, '1059-1043-1000-1051'),
(4, 10, 100, 100, 0, 351, '1059-1045-1018'),
(5, 1, 31, 29, 1621, 293, '1056-1044-1052'),
(5, 2, 70, 70, 986, 351, '1057-1043-1051'),
(5, 3, 90, 90, 0, 429, '1059-1043-1000-1051'),
(5, 4, 100, 100, 518, 351, '1059-1042-1000'),
(5, 5, 90, 90, 16000, 600, '483-403-625-403-559-699-639'),
(5, 6, 60, 60, 986, 352, '1057-1040'),
(5, 7, 60, 60, 986, 351, '1057-1040'),
(5, 8, 50, 50, 800, 200, ''),
(5, 9, 85, 80, 468, 410, '1059-1043-1000-1051'),
(5, 10, 100, 100, 0, 410, '1059-1045-1018');

-- --------------------------------------------------------

--
-- Table structure for table `recuperar_password`
--

CREATE TABLE `recuperar_password` (
  `UID` int(11) NOT NULL,
  `hash` varchar(32) NOT NULL,
  `vence` int(11) NOT NULL,
  `IP` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `servers`
--

CREATE TABLE `servers` (
  `ID` int(11) NOT NULL,
  `IP` varchar(255) NOT NULL,
  `PORT` int(11) NOT NULL,
  `ultima` bigint(20) NOT NULL,
  `inicio` int(11) NOT NULL,
  `players` int(11) NOT NULL,
  `HOST` varchar(255) NOT NULL,
  `keysec` varchar(10) NOT NULL,
  `Nombre` varchar(255) NOT NULL,
  `Mapa` varchar(255) NOT NULL,
  `hamachi` varchar(15) NOT NULL DEFAULT '0.0.0.0',
  `passwd` varchar(10) NOT NULL,
  `RANK` varchar(3) NOT NULL,
  `maxusers` varchar(2) NOT NULL,
  `pcid` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='SeRvErS BBMANDA';

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `ID` int(11) NOT NULL,
  `mac` varchar(12) NOT NULL,
  `code` smallint(6) NOT NULL,
  `server` mediumint(9) NOT NULL,
  `renew` int(11) NOT NULL,
  `numservers` mediumint(9) NOT NULL,
  `numcheats` mediumint(9) NOT NULL,
  `PCID` varchar(32) NOT NULL,
  `BAN` tinyint(4) NOT NULL,
  `IP` varchar(15) NOT NULL DEFAULT '0.0.0.0',
  `privs` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `solicitud-clan`
--

CREATE TABLE `solicitud-clan` (
  `ID` int(11) NOT NULL,
  `clan` int(3) NOT NULL,
  `userid` int(5) NOT NULL,
  `fecha` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `updates`
--

CREATE TABLE `updates` (
  `ID` int(10) UNSIGNED NOT NULL,
  `num` int(10) UNSIGNED NOT NULL,
  `url` varchar(255) NOT NULL,
  `MD5` varchar(32) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `version` int(11) NOT NULL,
  `path` varchar(255) NOT NULL DEFAULT '\\'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `ID` int(11) NOT NULL,
  `username` varchar(30) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(32) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `userid` varchar(32) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `userlevel` tinyint(1) UNSIGNED NOT NULL,
  `email` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `timestamp` int(11) UNSIGNED NOT NULL,
  `frags` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `muertes` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `partidos` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `puntos` bigint(11) UNSIGNED NOT NULL DEFAULT 0,
  `honor` int(20) NOT NULL DEFAULT 0,
  `clan_fundado` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `rank` int(11) NOT NULL DEFAULT 0,
  `rank_old` int(11) NOT NULL DEFAULT 0,
  `ultimologin` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `ultimosv` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `Ban` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `PIN` varchar(32) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `GM` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `last` mediumint(9) UNSIGNED NOT NULL DEFAULT 0,
  `last_r` mediumint(10) UNSIGNED NOT NULL DEFAULT 0,
  `clases_extra` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `pjs` varchar(128) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `pjs_nicks` varchar(512) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `pjs_clanes` varchar(128) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `pjs_times` varchar(256) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `pjs_armcao` varchar(64) NOT NULL,
  `last_cache` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `last_mod` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `next_check` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `last_check` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `PCID` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `clan` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `PJBAN` int(11) NOT NULL,
  `CDMSession` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `active_guests`
--
ALTER TABLE `active_guests`
  ADD PRIMARY KEY (`ip`);

--
-- Indexes for table `active_users`
--
ALTER TABLE `active_users`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `aportes_clanes`
--
ALTER TABLE `aportes_clanes`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `balance_int`
--
ALTER TABLE `balance_int`
  ADD PRIMARY KEY (`clase`);

--
-- Indexes for table `banned_users`
--
ALTER TABLE `banned_users`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `ban_log`
--
ALTER TABLE `ban_log`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `boveda`
--
ALTER TABLE `boveda`
  ADD PRIMARY KEY (`CuentaID`);

--
-- Indexes for table `chat_clanes`
--
ALTER TABLE `chat_clanes`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `cheat-log`
--
ALTER TABLE `cheat-log`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `clanes`
--
ALTER TABLE `clanes`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `clases`
--
ALTER TABLE `clases`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `cms1_categorias`
--
ALTER TABLE `cms1_categorias`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `cms1_entradas`
--
ALTER TABLE `cms1_entradas`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `configuracion`
--
ALTER TABLE `configuracion`
  ADD PRIMARY KEY (`cfg`);

--
-- Indexes for table `errores`
--
ALTER TABLE `errores`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `est-online`
--
ALTER TABLE `est-online`
  ADD PRIMARY KEY (`unica`);

--
-- Indexes for table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `mapas`
--
ALTER TABLE `mapas`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `mercader`
--
ALTER TABLE `mercader`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `mochila`
--
ALTER TABLE `mochila`
  ADD PRIMARY KEY (`UID`),
  ADD UNIQUE KEY `idx_UID_CuentaID` (`UID`,`CuentaID`);

--
-- Indexes for table `noticias`
--
ALTER TABLE `noticias`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pjs`
--
ALTER TABLE `pjs`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `pjs_cached`
--
ALTER TABLE `pjs_cached`
  ADD PRIMARY KEY (`UID`);

--
-- Indexes for table `recuperar_password`
--
ALTER TABLE `recuperar_password`
  ADD PRIMARY KEY (`UID`);

--
-- Indexes for table `servers`
--
ALTER TABLE `servers`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `PCID` (`PCID`);

--
-- Indexes for table `solicitud-clan`
--
ALTER TABLE `solicitud-clan`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `updates`
--
ALTER TABLE `updates`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `aportes_clanes`
--
ALTER TABLE `aportes_clanes`
  MODIFY `ID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ban_log`
--
ALTER TABLE `ban_log`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `chat_clanes`
--
ALTER TABLE `chat_clanes`
  MODIFY `ID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cheat-log`
--
ALTER TABLE `cheat-log`
  MODIFY `ID` mediumint(9) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `clanes`
--
ALTER TABLE `clanes`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cms1_categorias`
--
ALTER TABLE `cms1_categorias`
  MODIFY `ID` mediumint(9) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `cms1_entradas`
--
ALTER TABLE `cms1_entradas`
  MODIFY `ID` mediumint(9) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `errores`
--
ALTER TABLE `errores`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `items`
--
ALTER TABLE `items`
  MODIFY `ID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1064;

--
-- AUTO_INCREMENT for table `logs`
--
ALTER TABLE `logs`
  MODIFY `ID` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `mapas`
--
ALTER TABLE `mapas`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `noticias`
--
ALTER TABLE `noticias`
  MODIFY `id` int(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- AUTO_INCREMENT for table `pjs`
--
ALTER TABLE `pjs`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `servers`
--
ALTER TABLE `servers`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sessions`
--
ALTER TABLE `sessions`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `solicitud-clan`
--
ALTER TABLE `solicitud-clan`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `updates`
--
ALTER TABLE `updates`
  MODIFY `ID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
