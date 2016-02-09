<?php
namespace App\Lib;

class Country extends \Eloquent {
	protected $fillable = [];
    protected $guarded = array('CountryID');
    protected $table = 'tblCountry';
    protected  $primaryKey = "CountryID";
}