<?php
namespace App\Lib;
class TempDialString extends \Eloquent {
	protected $fillable = [];
    public $timestamps = false; // no created_at and updated_at

    protected $guarded = array('TempDialStringID');

    protected $table = 'tblTempDialString';

    protected  $primaryKey = "TempDialStringID";

}