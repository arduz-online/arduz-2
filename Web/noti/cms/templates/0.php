<?php
// SOPORTEEEES

class util {
    static private $sortfield = null;
    static private $sortorder = 1;
    static private function sort_callback(&$a, &$b) {
        if($a[self::$sortfield] == $b[self::$sortfield]) return 0;
        return ($a[self::$sortfield] > $b[self::$sortfield])? -self::$sortorder : self::$sortorder;
    }
    static function sort(&$v, $field, $asc=true) {
        self::$sortfield = $field;
        self::$sortorder = $asc? 1 : -1;
        usort($v, array('util', 'sort_callback'));
    }
}

function ver_lista(){
	$r = obtener_entradas(0);
	$cat = -1;
	$num = 0;
	$buf = array('','');
	$ln  = array(0,0);
	$categorias = array();
	
	while($entrada = mysql_fetch_array($r)){
		if(!array_key_exists($entrada['cat_nom'],$categorias)){
			$categorias[$entrada['cat_nom']]['texto'] = '';
			$categorias[$entrada['cat_nom']]['nombre'] = $entrada['cat_nom'];
			$categorias[$entrada['cat_nom']]['lineas'] = 2;
		}
		$categorias[$entrada['cat_nom']]['lineas']++;
		$categorias[$entrada['cat_nom']]['texto'] .=  '	- <a href="ayuda_'.urls_amigables($entrada['cat_nom'].'-'.$entrada['titulo']).'_'.$entrada['ID'].'.php">'.$entrada['titulo'].'</a><br/>';
	}
	
	util::sort($categorias,'lineas');
	
	foreach($categorias as $cat){
		$act_col = ($ln[0]>$ln[1]?1:0);
		$buf[$act_col] .= '<br/><b>'.$cat['nombre'].'</b><br/>'.$cat['texto'];
		$ln[$act_col] += $cat['lineas'];
	}
	
	$final= '<div id="col1" class="tablasoporte">'.$buf[0].'</div>'.'<div id="col2" class="tablasoporte">'.$buf[1].'</div>';
	
	return $final;
}


?>