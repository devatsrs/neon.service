<?php
namespace App\Lib;

class RateSheet extends \Eloquent {
	protected $fillable = [];
    protected $guarded = array('RateSheetID');

    protected $table = 'tblRateSheet';

    protected  $primaryKey = "RateSheetID";
}