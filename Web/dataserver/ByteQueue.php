<?php
class clsByteQueue{
	private $buffer = array();
	public  $length = 0;
	
	function __construct( $data = '' ){
		$i = 0;
		$lenght = strlen( $data );
		if($lenght) {
			$this->buffer	= array();
			for($i = 0; $i < $lenght; $this->buffer[] = $data[$i++] );
			$this->length 	= count( $this->buffer );
		}
	}

	public function WriteFixedString( $data ){
		$i = 0;
		$lenght = strlen( $data );
		for($i = 0; $i < $lenght; $this->buffer[] = $data[$i++] );
		$this->length = count( $this->buffer );
	}

	public function WriteByte( $data ){
		$data = intval($data);
		if( intval($data)<256 && intval($data)>=0 ){
			$this->buffer[] = chr( $data );
		} else {
			$this->buffer[] = chr(0);
		}
		$this->length += 1;
	}

	public function WriteLong( $num ){
		$n				= explode('.',long2ip(intval($num)));
		$this->buffer[] 	= chr($n[3]);
		$this->buffer[] 	= chr($n[2]);
		$this->buffer[] 	= chr($n[1]);
		$this->buffer[] 	= chr($n[0]);
		$this->length  	+= 4;
	}

	public function WriteASCIIString($str){
		$data = strlen($str);
		$this->WriteFixedString(chr($data % 256).chr(floor($data / 256)).$str);
	}

	public function ReadBlock(/*$reverse*/){
		$res = $this->buffer;
		$this->buffer = array();
		$this->lenght = 0;
		/*if( $reverse ) {
			$res = array_reverse( $res );
		}*/
		return $res;
	}
	
	public function Flush(/*$reverse*/){	
		header('Content-type: arduz/binary');
		$res  = $this->buffer;
		$this->buffer = array();
		$this->lenght = 0;
		echo 'l', chr($this->lenght % 256), chr(floor($this->lenght / 256)), implode('',$this->ReadBlock(/*$reverse*/));
	}
}
?>