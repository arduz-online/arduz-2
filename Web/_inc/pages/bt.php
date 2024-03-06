<?php
class clsByte{
    protected $bitmask = 0;
    public function si ( $bit )		{$this->bitmask |= 1 << $bit;}
    public function no ( $bit )		{$this->bitmask &= ~ (1 << $bit);}
    public function tgl( $bit )		{$this->bitmask ^= 1 << $bit;}
    public function get( $bit )		{return (bool)(($this->bitmask & (1 << $bit))!==0);}
    public function in ( $int )		{$this->bitmask = intval($int);}
    public function out()			{return $this->bitmask;}
}


?>