<?php
$page['title']="Arduz Online - Panel - Mercado de items";
template_header();
if ($_SESSION['loggedE']=="1")
{
	$query = mysql_fetch_array(mysql_query("SELECT * FROM `pjs` WHERE `nick` = '".$_SESSION['Nick']."'"));
	if ($query['codigo']!=$_SESSION['passwd'])
	{
		$_SESSION['loggedE']="0";$_SESSION['GM']="0";$_SESSION['nick']="";$_SESSION['passwd']="";
		go_login_page();
		exit();
	}
?>
<div style="clear:both;">
</div>
<div class="caja">
	<div class="caja_b">
		<div id="Inicio">
			<?php include 'bin/toolbox.php';?><h1 id="misitems_img" class="himg">Mercado</h1>
				<table class="rank">
					<tr>
						<td style="width:30px;" class="rh"></td>
						<td style="width:200px;" class="rh">Item</td>
						<td class="rh"></td>
						<td class="rh">Vence</td>
						<td style="width:30px;" class="rh"></td>
					</tr>
<?php
echo '<b>Hora actual: '.date("d/m/Y H:i").'</b><br/>Puntos: '.$query['puntos'].'<br/>';
$libre=0;
$timenow=time();
$item=array();
									$items_sql=mysql_query("SELECT * FROM `mochila` WHERE `UID`='$query[ID]' LIMIT 1;");
									if(mysql_num_rows($items_sql)==1)
									{
										$items_db=mysql_fetch_array($items_sql);
										for ($o = 1; $o <= 8; $o++) {
											if($items_db['o'.$o]>0){
												if($items_db['t'.$o]==0 or $items_db['t'.$o]>$timenow)
												{
													if ($items_db['o'.$o]==$_REQUEST['item'] && $_REQUEST['a']=='panel-quitar-item') {
														++$ci;
														if($ci>1){$borraitems.=',';}
														$borraitems.="`o$o`='0',`t$o`='0'";
mysql_query("
INSERT INTO `LOGS` (
`ID` ,
`text` ,
`time`
)
VALUES (
NULL , '$query[nick]($query[ID]) BORRO ITEM $o ".$items_db['o'.$o]." le quedaban ".($items_db['o'.$o]-$timenow)."', '$timenow'
);");
													} else {
														$tmp=$items_db['o'.$o];											
														$item[$tmp]=mysql_fetch_array(mysql_query('SELECT * FROM items WHERE ID='.$tmp.' LIMIT 1;'));
														$item[$tmp]['Name']=utf8_encode($item[$tmp]['Name']);
														echo '<tr><td><img src="images/items/'.$item[$tmp]['ID'].'.gif" alt="IMG"/></td><td>'.$item[$tmp]['Name'].'</td><td>'.$item[$tmp]['desc'].'</td><td>'.date("d/m/Y H:i",$items_db['t'.$o]).'</td><td><a href="?a=panel-quitar-item&item='.$items_db['o'.$o].'" class="tooltip" title="CLICK AC&aacute; PARA QUITAR EL ITEM. <br/>OJO! no se puede recuperar el item una vez borrado!."><small>[X]</small></a></td></tr>';
														++$co;
														$item[$tmp]['si']='si';
													}
												} else {

													++$ci;
													if($ci>1){$borraitems.=',';}
													$borraitems.="`o$o`='0',`t$o`='0'";
												}
											} else {
											if($libre==0){$libre=$o;}
											}
										}
										if(strlen($borraitems)>0){
											mysql_query("UPDATE mochila SET $borraitems WHERE `UID`='$query[ID]' LIMIT 1;");
										//echo mysql_error().$borraitems;
										}
									} else {
										mysql_query("INSERT INTO `mochila` (
`UID` ,
`o1` ,
`t1` ,
`o2` ,
`t2` ,
`o3` ,
`t3` ,
`o4` ,
`t4` ,
`o5` ,
`t5` ,
`o6` ,
`t6` ,
`o7` ,
`t7` ,
`o8` ,
`t8`
)
VALUES (
'$query[ID]', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''
)");
										header("Location: panel.php-ver-items");
										exit;
									}
									echo '</table><h2>Mercado de items</h2>';
if ($co<8)
{
if($_REQUEST['a']=='panel-comprar-items' and isset($_REQUEST['item']))
{
	$sql=mysql_query('SELECT * FROM items WHERE ID='.intval($_REQUEST['item']).' LIMIT 1;');
	if(mysql_num_rows($sql)>0)
	{
		$itemx=mysql_fetch_array($sql);
		$itemx['Name']=utf8_encode($itemx['Name']);
		if($query['puntos']>= $itemx['Valor'] or $query['GM']>123)
		{
			if(isset($_POST['dias']))
			{//comprar
				if(intval($_POST['dias'])>=0)
				{
					if($item[$_REQUEST['item']]['si']!='si')
					{
						$precio=intval(($_POST['dias']+1)*7*0.9)*$itemx['Valor'];
						if($query['puntos']>=$precio or $query['GM']>123)
						{
							$tiempo=((intval($_POST['dias'])+1)*604800)+$timenow;
							if($query['GM']>123){$tiempo=0;$precio=0;}
							mysql_query('UPDATE mochila SET `o'.$libre.'`='.$itemx['ID'].',`t'.$libre.'`='.$tiempo.' WHERE UID='.$query['ID']);
							mysql_query("UPDATE pjs SET puntos=puntos-'$precio' WHERE ID='$query[ID]'");
							echo 'Item comprado correctamente!.<br/><a href="panel.php-ver-items">[Ir al mercado de items]</a>';
							mysql_query("
INSERT INTO `LOGS` (
`ID` ,
`text` ,
`time`
)
VALUES (
NULL , '$query[nick]($query[ID]) compro por $_POST[dias] $timenow to $tiempo precio:$precio item:$itemx[ID]', '$timenow'
);");
						} else { echo ' No tenés suficientes puntos.<br/><a href="panel.php-ver-items">[Ir al mercado de items]</a>'; }
					} else echo 'Ya ten&eacute;s este item!.<br/><a href="panel.php-ver-items">[Ir al mercado de items]</a>';
				} else { echo 'ERROR.'; }
			} else {
?>
<form method="POST">
<input type="hidden" name="a" value="panel-comprar-items"/>
<input type="hidden" name="item" value="<?php echo $itemx['ID'];?>"/>
<big><img src="images/items/<?php echo $itemx['ID'];?>.gif"/><b>&iquest;Quer&eacute;s comprar <q><?php echo $itemx['Name'];?></q>?</b></big><br/>
Duraci&oacute;n: <select name="dias">
<option value="0">7 d&iacute;as (<?php echo ($itemx['Valor']*(intval(1*7*0.9)));?>)</option>
<option value="1">14 d&iacute;as (<?php echo ($itemx['Valor']*(intval(2*7*0.9)));?>)</option>
<option value="3">28 d&iacute;as (<?php echo ($itemx['Valor']*(intval(4*7*0.9)));?>)</option>
</select><input type="submit" value="Comprar!"/></form>
<?php
			}
		} else {
			echo 'No ten&eacute;s los puntos necesarios para comprar el item.<br/><a href="panel.php-ver-items">[Ir al mercado de items]</a>';
		}
	} else {
		echo 'Error.<br/><a href="panel.php-ver-items">[Ir al mercado de items]</a>';
	}
} else {
?>

					<table class="rank">
					<tr>
					<td style="width:30px;" class="rh"></td>
					<td style="width:200px;" class="rh">Item</td>
					<td style="" class="rh"></td>
					<td style="width:30px;" class="rh"></td>
					</tr>
<?php
$items_db=mysql_query('SELECT * FROM items');
while($item_r = mysql_fetch_array($items_db))
{
if(!($item_r['Valor']=="9999999999" and $query['GM']<127))
echo '<tr><td><img src="images/items/'.$item_r['ID'].'.gif" alt="IMG"/></td><td>'.utf8_encode($item_r['Name']).'</td><td>'.utf8_encode($item_r['desc']).'</td><td><a href="?a=panel-comprar-items&item='.$item_r['ID'].'" class="tooltip" title="Precio: '.$item_r['Valor'].' puntos por d&iacute;a.">[Comprar]</a></td></tr>';
}
?>
</table>
<?php

?>

<?php
}
}else{
?>
No pod&eacute;s tener m&aacute;s items.
<?php
}
?>
		</div>
	</div>
</div>
<?php
template_footer();
} else {
go_login_page();
}
?>