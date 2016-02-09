<?php
namespace App\Lib;
class TempCodeDeck extends \Eloquent {
	protected $fillable = [];
    public $timestamps = false; // no created_at and updated_at

    protected $guarded = array('TempCodeDeckRateID');

    protected $table = 'tblTempCodeDeck';

    protected  $primaryKey = "TempCodeDeckRateID";

}