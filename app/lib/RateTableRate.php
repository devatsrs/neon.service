<?php
namespace App\Lib;

class RateTableRate extends \Eloquent {
	protected $fillable = [];
    public $timestamps = false; // no created_at and updated_at

    protected $guarded = array('RateTableRateID');

    protected $table = 'tblRateTableRate';

    protected  $primaryKey = "RateTableRateID";

}