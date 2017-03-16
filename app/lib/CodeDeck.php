<?php

namespace App\Lib;

class CodeDeck extends \Eloquent {

	// Add your validation rules here
	public static $rules = [
            'Code' =>      'required',
            'CompanyID' =>  'required',
            'Description' => 'required',
            'codedeckid' => 'required',
	];
    protected $table = 'tblRate';
    protected  $primaryKey = "RateID";
    protected $fillable = [];
    protected $guarded = ['RateID'];
}