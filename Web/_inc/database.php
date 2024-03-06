<?php

class MySQLDB
{
   var $connection;         //The MySQL database connection
   var $num_active_users;   //Number of active users viewing site
   var $num_active_guests;  //Number of active guests viewing site
   var $num_members	= 0;        //Number of signed-up users
   var $num_q		= 0;
   var $txt 		= '';
   var $udata 		= array();
   /* Note: call getNumMembers() to access $num_members! */

   /* Class constructor */
   function MySQLDB(){
		$this->num_members = -1;
		$this->connection = mysql_connect(DB_SERVER, DB_USER, DB_PASS) or die(mysql_error());
		mysql_select_db(DB_NAME, $this->connection) or die(mysql_error());
   }

   /**
    * confirmUserPass - Checks whether or not the given
    * username is in the database, if so it checks if the
    * given password is the same password in the database
    * for that user. If the user doesn't exist or if the
    * passwords don't match up, it returns an error code
    * (1 or 2). On success it returns 0.
    */
   function confirmUserPass($username, $password){
      /* Add slashes if necessary (for $this->query) */
	      $username = addslashes($username);

      /* Verify that user is in database */
      $q = "SELECT password FROM ".TBL_USERS." WHERE username = '$username'";
      $result = $this->query($q);
	  
      if(!$result || (mysql_numrows($result) < 1)){
         return 1; //Indicates username failure
      }

      /* Retrieve password from result, strip slashes */
      $dbarray = mysql_fetch_array($result);
      $dbarray['password'] = $dbarray['password'];
      $password = $password;

      /* Validate that password is correct */
      if($password === $dbarray['password']){
         return 0; //Success! Username and password confirmed
      }
      else{
         return 2; //Indicates password failure
      }
   }
   
   /**
    * confirmUserID - Checks whether or not the given
    * username is in the database, if so it checks if the
    * given userid is the same userid in the database
    * for that user. If the user doesn't exist or if the
    * userids don't match up, it returns an error code
    * (1 or 2). On success it returns 0.
    */
   function confirmUserID($username, $userid){
      /* Add slashes if necessary (for $this->query) */
	      $username = addslashes($username);

      /* Verify that user is in database */
      $q = "SELECT * FROM ".TBL_USERS." WHERE username = '$username' LIMIT 1";
      $result = $this->query($q);
	  
      if(!$result || (mysql_numrows($result) < 1)){
         return 1; //Indicates username failure
      }

      /* Retrieve userid from result, strip slashes */
      $dbarray = mysql_fetch_assoc($result);
      //$dbarray['userid'] = $dbarray['userid'];
      //$userid = $userid;

      /* Validate that userid is correct */
      if($userid === $dbarray['userid']){
		 $this->udata = $dbarray;
         return 0; //Success! Username and userid confirmed
      }
      else{
         return 2; //Indicates userid invalid
      }
   }
   /* est� registrado? */
   function usernameTaken($username){
      if(!get_magic_quotes_gpc()){
         $username = addslashes($username);
      }
      $q = "SELECT username FROM ".TBL_USERS." WHERE username = '$username'";
      $result = $this->query($q);
	  
      return (mysql_numrows($result) > 0);
   }
   
   function usernameBanned($username){
      if(!get_magic_quotes_gpc()){
         $username = addslashes($username);
      }
      $q = "SELECT * FROM users WHERE username = '$username' AND Ban='127'";
      $result = $this->query($q);
	  
      return (mysql_numrows($result) > 0);
   }
   
   function addNewUser($username, $password, $email, $pin){
      $time = time();
      $q = "INSERT INTO ".TBL_USERS." (`ID`,`username`,`password`,`userid`,`userlevel`,`email`,`timestamp`,`GM`,`PIN`)
	  VALUES (NULL,'$username', '$password', '0', '$ulevel', '$email', $time, '0', '$pin')";
	  $r = $this->query($q);
	  
      return $r;
   }
   
   function updateUserIDField($uid, $field, $value){
	  $q = "UPDATE ".TBL_USERS." SET ".$field." = '$value' WHERE ID = '$uid'";
	  
      return $this->uquery($q);
   }
   function updateUserField($uid, $field, $value){
	  $q = "UPDATE ".TBL_USERS." SET ".$field." = '$value' WHERE username = '$uid'";
	  
      return $this->uquery($q);
   }
   function CachedPjs($uid){
	  $q = "SELECT pjs_cache FROM pjs_cached WHERE UID = '$uid' LIMIT 1";
	  $result = $this->query($q);
	  
	  if( !$result || (mysql_numrows($result) === 0) ){
		return '';
	  }
	  $txt=mysql_fetch_assoc($result);
	  mysql_free_result($result);
      return $txt['pjs_cache'];
   }
   function CachePjs($uid,$pjs){
	  $this->uquery("INSERT INTO pjs_cached VALUES('$uid','$pjs') ON DUPLICATE KEY UPDATE pjs_cache='$pjs';");
   }
   function updatePJField($pjid, $field, $value){
	  $q = "UPDATE pjs SET $field = '$value' WHERE ID = '$pjid'";
      return $this->uquery($q);
   }
   
   function getUserInfo($username){
	  if( $this->udata['username'] === $username ) return $this->udata;
	  
      $q = "SELECT * FROM ".TBL_USERS." WHERE username = '$username'";
      $result = $this->query($q);

      if(!$result || (mysql_numrows($result) < 1)){
         return NULL;
      }

      $dbarray = mysql_fetch_array($result);
      return $dbarray;
   }

	public function quitarPersonaje($pj,$uid,$clan=false) {
		if($clan!=false){
			$this->query('UPDATE `pjs`,`clanes` SET `clanes`.`miembros`=`clanes`.`miembros`-1,`pjs`.`IDCuenta` = 0,`pjs`.`clan`=0,`nick`=CONCAT(`nick`,\'_\') WHERE `pjs`.`ID` = '.$pj.' AND `clanes`.`ID`=`pjs`.`clan`');
		} else {
			$this->query('UPDATE `pjs` SET `pjs`.`IDCuenta` = 0,`nick`=CONCAT(`nick`,\'_\') WHERE `pjs`.`ID` = '.$pj);
		}
		$this->query("DELETE FROM `solicitud-clan` WHERE userid = '".$pj."'");
		$this->ActualizarPjs($uid);
	}
	
	function ActualizarPjs($uid){
		$q 			= "SELECT ID,nick,clan,cuando_termina,armcao FROM `pjs` WHERE `IDCuenta` = '$uid' LIMIT 10";
        $result 	= $this->query($q);

		$pjs_ids	= array();
		$pjs_nicks	= array();
		$pjs_clanes	= array();
		$pjs_times	= array();
		$pjs_armcao	= array();
		$next_check = 0;

        if( !$result || (mysql_numrows($result) === 0) ){
			if( $this->udata['ID']==$uid && $this->udata['pjs']=='' ) return;
			$q = 'UPDATE users SET pjs = \'\' , pjs_nicks = \'\' , pjs_clanes = \'\' , pjs_times = \'\' WHERE ID = '.$uid.' LIMIT 1;';
			$result = $this->uquery($q);
			return;
		}
		
		while( $row=mysql_fetch_assoc($result) ){
			$pjs_ids[] 		= $row['ID'];
			$pjs_nicks[] 	= $row['nick'];
			$pjs_clanes[] 	= $row['clan'];
			$pjs_times[] 	= $row['cuando_termina'];
			$pjs_armcao[] 	= $row['armcao'];
		}

		$q = 'UPDATE users SET pjs = \''.implode('-',$pjs_ids).'\' , pjs_nicks = \''.implode('-',$pjs_nicks).'\' , pjs_clanes = \''.implode('-',$pjs_clanes).'\' , pjs_times = \''.implode('-',$pjs_times).'\' , pjs_armcao = \''.implode('-',$pjs_armcao).'\' , next_check=\''.$next_check.'\', last_mod='.(time()+60).' WHERE ID = '.$uid.' LIMIT 1;';
		$result = $this->uquery($q);
	}

    function getCuentaForGame($username,$password){
      $q = "SELECT `users`.* FROM users WHERE `users`.`username` = '$username'";
      //$q = "SELECT `users`.*, `sessions`.`PCID` AS `PCIDb` FROM users,sessions WHERE `users`.`username` LIKE '$username' AND `sessions`.`ID` = `users`.`PCID`";
	  $result = $this->query($q);
	  
      if(!$result || (mysql_numrows($result) < 1)){
         return 1; //Indicates username failure
      }

      /* Retrieve password from result, strip slashes */
      $dbarray = mysql_fetch_array($result);

      /* Validate that password is correct */
      if($password == $dbarray['password']){
		  if($dbarray['PCID']>0){
			$q 		= "SELECT sessions.PCID AS `PCIDb` FROM sessions WHERE `ID` = '$dbarray[PCID]'";
			$result = mysql_fetch_array($this->query($q));
			$dbarray['PCIDb'] = $result['PCIDb'];
		  } else $dbarray['PCIDb'] = '0';

         return $dbarray; //Success! Username and password confirmed
      }
      else{//echo $password,'  ',$dbarray['password']."\n";
         return 2; //Indicates password failure
		 
      }
   }
   function getCuentaForDS($username,$password){
      $q = "SELECT * FROM ".TBL_USERS." WHERE username = '$username'";
      $result = $this->query($q);
	  
      if(!$result || (mysql_numrows($result) < 1)){
         return 1; //Indicates username failure
      }

      /* Retrieve password from result, strip slashes */
      $dbarray = mysql_fetch_array($result);

      /* Validate that password is correct */
      if($password === md5('dfc5101794ec1611a32be5d8206d6d6a5a765870'.$dbarray['password'].'dfc5101794ec1611a32be5d8206d6d6a5a765870')){
         return $dbarray; //Success! Username and password confirmed
      }
      else{//echo $password,'  ',$dbarray['password']."\n";
         return 2; //Indicates password failure
		 
      }
   }
   function getPJInfo($id){
      $q = "SELECT * FROM `pjs` WHERE ID = '$id' LIMIT 1";
      $result = $this->query($q);
	  

      if(!$result || (mysql_numrows($result) < 1)){
         return NULL;
      }

      $dbarray = mysql_fetch_array($result);
      return $dbarray;
   }
   
   function getPJsAcc($acc){
        $q = "SELECT ID FROM `pjs` WHERE `IDCuenta` = '$acc'";
        $result = $this->query($q);
		
		$dbarray=array();
        if(!$result || (mysql_numrows($result) == 0)){
			return NULL;
		}
		while($row=mysql_fetch_assoc($result)){
			$dbarray[] = $row['ID'];
		}
		return $dbarray;
   }
   
   function getClanArray(){
        $q = 'SELECT ID,Nombre FROM `clanes`';
        $result = $this->query($q);
		
		$dbarray=array();
        if(!$result || (mysql_numrows($result) == 0)){
			return NULL;
		}
		$dbarray[0] = '';
		while($row=mysql_fetch_assoc($result)){
			$dbarray[$row['ID']] = $row['Nombre'];
		}
		return $dbarray;
   }
   
   function getNumMembers(){
      if($this->num_members < 0){
         $q = "SELECT `ID` FROM ".TBL_USERS;
         $result = $this->query($q);
		 
         $this->num_members = mysql_numrows($result);
      }
      return $this->num_members;
   }
   	function query_false($query){
		$res = $this->query($query);
		if(mysql_num_rows($res) == 0){
			return false;
		} else return $res;
	}
	function query($query){
		$R=mysql_query($query, $this->connection);
		if(DEBUG===true){
			$this->txt .= 'Q>'.$query.'<br/>';
			$this->txt .= 'QE>'.mysql_error().'<br/>';
		}
		++$this->num_q;
		return $R;
	}
	function uquery($query){
		$R=mysql_unbuffered_query($query, $this->connection);
		if(DEBUG===true){
			$this->txt .= 'U>'.$query.'<br/>';
			$this->txt .= 'UE>'.mysql_error().'<br/>';
		}
		++$this->num_q;
		return $R;
	}
};

function mysql_update_array($table, $data, $id_field, $id_value) {
	foreach ($data as $field=>$value) {
		$fields[] = sprintf("`%s` = '%s'", $field, mysql_real_escape_string($value));
	}
	$field_list = join(',', $fields);
	
	$query = sprintf("UPDATE `%s` SET %s WHERE `%s` = %s", $table, $field_list, $id_field, intval($id_value));
	
	return $query;
}

$database = new MySQLDB;

?>
