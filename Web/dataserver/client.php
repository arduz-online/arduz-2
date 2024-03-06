<?php
/*                 ____________________________________________
 *                /_____/  http://www.arduz.com.ar/ao/   \_____\
 *               //            ____   ____   _    _ _____      \\
 *              //       /\   |  __ \|  __ \| |  | |___  /      \\
 *             //       /  \  | |__) | |  | | |  | |  / /        \\
 *            //       / /\ \ |  _  /| |  | | |  | | / /   II     \\
 *           //       / ____ \| | \ \| |__| | |__| |/ /__          \\
 *          / \_____ /_/    \_\_|  \_\_____/ \____//_____|_________/ \
 *          \________________________________________________________/  
 *
 *		@writer: 		Agustín Nicoás Méndez (aka Menduz)
 *		@contact: 		lord.yo.wo@gmail.com
 *		@start-date: 	16-12-09
 *		
 */

require 'class.php';

function get_init_config(){
	echo '31'.DELIMITER.'1';//PUEDO DESLIMITAR LAS FPS
}

	if( $_REQUEST['a']==='init' ){
		get_init_config();
		
	}/* elseif ( $_REQUEST['a']==='getmod' ){
		//get_mod();
	}*/
?>