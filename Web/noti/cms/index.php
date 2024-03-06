<?php
	define('ACTION_LOGIN'				,0);
	define('ACTION_AGREGAR_CATEGORIA'	,1);
	define('ACTION_AGREGAR_ENTRADA'		,2);
	define('ACTION_EDITAR_CATEGORIA'	,3);
	define('ACTION_EDITAR_ENTRADA'		,4);
	define('ACTION_BORRAR_CATEGORIA'	,5);
	define('ACTION_BORRAR_ENTRADA'		,6);
	define('ACTION_VER_CATEGORIAS'		,7);
	define('ACTION_VER_ENTRADAS'		,8);
	define('ACTION_LOGOUT'				,9);

	include "theme.php";
	require "cms.class.php";
	//CONTROLADOR {
	$action_cms = intval($_REQUEST['action_cms']);

	class session {
		// Ya sé, me vas a decir que este class es RE al pedo.
		// Pro no me importa, el class se queda y es util para otras cosas.
		public  $user 	= array();
		public  $logged	= false;

		function __construct(){
			@session_start();
			if($_SESSION[SUBSYSTEM_NAME]['logged'] == true){
				$this->logged 	= true;
				$this->user		= $_SESSION[SUBSYSTEM_NAME];
			}
		}
		
		public function login($user,$pass){
			require_once dirname(__FILE__).'/permisos.php';
			//global $usuarios;
			
			foreach( $usuarios as $tmp_user_db ){
				if ( strtoupper($tmp_user_db[0]) === strtoupper($user) && $tmp_user_db[1] === $pass ){
					$this->user = array(
						'nick'	=> $tmp_user_db[0],
					);
					$this->logged = true;
					$_SESSION[SUBSYSTEM_NAME] = $this->user;
					$_SESSION[SUBSYSTEM_NAME]['logged'] = (bool)( strlen($user)>0 ); //Comprobamos que no loguee con user "" y pass "", igual técnicamente no puede pasar.
					return true;
				} else {
					unset($_SESSION[SUBSYSTEM_NAME]);
					$this->logged = false;
					return false;
				}
			}
		}
		public function logout(){
			unset($_SESSION[SUBSYSTEM_NAME]);
			$this->logged = false;
		}
	} $session = &new session();
	
	if($action_cms == ACTION_LOGOUT) {
		$session->logout();
		$action_cms = ACTION_VER_ENTRADAS;
	}
	
	if( $action_cms>0 and $session->logged === true ){
		$id 		= intval($_REQUEST['ID']);
		$posting 	= !empty($_POST['Submit']);
		
		switch($action_cms){
		case ACTION_AGREGAR_CATEGORIA:
							theme_header('Agregar categor&iacute;a');
							if($posting){
								if(!empty($_POST['name'])){
									agregar_categoria($_POST['name'],intval($_POST['namespace']));
									timeout('CATEGORIA AGREGADA.');
								} else {
									echo '<b>NOMBRE INVALIDO</b><br/>';
									form_cat(ACTION_AGREGAR_CATEGORIA,$_POST['name'],$_POST['namespace']);
								}
							} else {
								form_cat(ACTION_AGREGAR_CATEGORIA);
							}
		break;



		case ACTION_AGREGAR_ENTRADA:
							theme_header('Agregar entrada');
							if($posting){
								if(!empty($_POST['name']) && !empty($_POST['txt'])){
									agregar_entrada($_POST['txt'],$_POST['name'],intval($_POST['cat']));
									timeout('ENTRADA AGREGADA.');
								} else {
									echo '<b>RELLENA TODOS LOS CAMPOS!!!!</b><br/>';
									form_ent(ACTION_AGREGAR_ENTRADA,$_POST['name'],$_POST['txt'],$_POST['cat']);
								}			
							} else {
								form_ent(ACTION_AGREGAR_ENTRADA);
							}
		break;



		case ACTION_EDITAR_CATEGORIA:
							theme_header('Editar categor&iacute;a');
							if( $id>0 ){
								$cat = obtener_categoria($id);
								if($cat !== false){
									if($posting){
										if(!empty($_POST['name'])){
											editar_categoria($id,$_POST['name'],intval($_POST['namespace']));
											timeout('CATEGORIA EDITADA.');
										} else {
											echo 'NOMBRE INVALIDO';
											form_cat(ACTION_EDITAR_CATEGORIA,$cat['nombre'],$_POST['namespace'],$id);
										}
									} else {
										form_cat(ACTION_EDITAR_CATEGORIA,$cat['nombre'],$cat['namespace'],$id);
									}
								} else echo 'ID INVALIDO';
							} else echo 'ID INVALIDO';
		break;



		case ACTION_EDITAR_ENTRADA:
							theme_header('Editar entrada');
							if( $id>0 ){
								$ent = obtener_entrada($id);
								if($ent !== false){
									if($posting){
										if(!empty($_POST['name']) && !empty($_POST['txt'])){
											editar_entrada($id,$_POST['txt'],$_POST['name'],intval($_POST['cat']));
											timeout('ENTRADA EDITADA.');
										} else {
											echo '<b>RELLENA TODOS LOS CAMPOS!!!!</b><br/>';
											form_ent(ACTION_EDITAR_ENTRADA,$id,$_POST['name'],$_POST['txt'],$_POST['cat']);
										}			
									} else {
										form_ent(ACTION_EDITAR_ENTRADA,$id,$ent['titulo'],$ent['txt'],$ent['cat']);
									}
								} else echo 'ID INVALIDO';
							} else echo 'ID INVALIDO';
		break;
		case ACTION_BORRAR_CATEGORIA:
							theme_header('Borrar categor&iacute;a');
							if( $id>0 ){
								if(obtener_categoria($id) != false){
									if($posting){
										if(isset($_POST['borrar'])){
											borrar_categoria($id);
											timeout('ENTRADA .');
										}
									} else {
										form_borr($id,ACTION_BORRAR_CATEGORIA);
									}
								} else {
									header('Location: index.php?action_cms='.ACTION_VER_ENTRADAS.'&err=No_existe_esa_categoria');
									exit();
								}
							} else header('Location: index.php?action_cms='.ACTION_VER_ENTRADAS.'&err=No_existe_esa_categoria');
			break;
		case ACTION_BORRAR_ENTRADA:
							theme_header('Borrar entrada');
							if( $id>0 ){
								if(obtener_entrada($id) != false){
									if($posting){
										if(isset($_POST['borrar'])){
											borrar_entrada($id);
											timeout('ENTRADA BORRADA.');
										}
									} else {
										form_borr($id,ACTION_BORRAR_ENTRADA);
									}
								} else {
									header('Location: index.php?action_cms='.ACTION_VER_ENTRADAS.'&err=No_existe_esa_entrada');
									exit();
								}
							} else header('Location: index.php?action_cms='.ACTION_VER_ENTRADAS.'&err=No_existe_esa_entrada');
		break;



		case ACTION_VER_CATEGORIAS:
							theme_header('Ver categor&iacute;as');
							echo '<br/><a href="index.php?action_cms='.ACTION_AGREGAR_CATEGORIA.'">Agregar categor&iacute;a.</a><br/>';
							$r = obtener_todas_categorias();
							$namespace = -1;
							while($cat = mysql_fetch_array($r)){
								if($namespace != $cat['namespace']){
									$namespace = $cat['namespace'];
									echo '<h2>'.$namespaces[$namespace].'</h2>';
								}
								echo $cat['nombre'].' - [<b><a href="index.php?action_cms='.ACTION_EDITAR_CATEGORIA.'&ID='.$cat['ID'].'">Editar</a></b>] | [<b><a href="index.php?action_cms='.ACTION_BORRAR_CATEGORIA.'&ID='.$cat['ID'].'">Borrar</a></b>]<br/>';
							}
		break;



		case ACTION_VER_ENTRADAS:
		default:
							theme_header('Ver entradas');
							echo '<br/><a href="index.php?action_cms='.ACTION_AGREGAR_ENTRADA.'">Agregar entrada.</a><br/>';
							$r = obtener_todas_entradas();
							$namespace = -1;
							$categoria = -1;
							while($ent = mysql_fetch_array($r)){
								if($namespace != $ent['namespace']){
									$namespace = $ent['namespace'];
									echo '<h2>'.$namespaces[$namespace].'</h2>';
								}
								if($categoria != $ent['cat_nom']){
									$categoria = $ent['cat_nom'];
									echo '<h3>-'.$categoria.'</h3>';
								}
								echo '--'.$ent['titulo'].' - [<b><a href="index.php?action_cms='.ACTION_EDITAR_ENTRADA.'&ID='.$ent['ID'].'">Editar</a></b>] | [<b><a href="index.php?action_cms='.ACTION_BORRAR_ENTRADA.'&ID='.$ent['ID'].'">Borrar</a></b>]<br/>';
							}
		break;
		}
		
	} else {
		if(strlen($_POST['user'])>0) $session->login($_POST['user'],$_POST['pass']);
		if($session->logged === true){
			if($_POST['action_cms']>0){
				header('Location: index.php?action_cms='.$_POST['action_cms']);
			} else {
				header('Location: index.php?action_cms='.ACTION_VER_ENTRADAS);
			}
			exit();
		} else {
			theme_header('Ingresar');
			theme_login($action_cms);
		}
	}
	footer();
//}/CONTROLADOR
?>