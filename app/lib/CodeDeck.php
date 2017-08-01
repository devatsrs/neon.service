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
    protected $table = 'tblCodeDeck';
    protected  $primaryKey = "CodeDeckID";
    protected $fillable = [];
    protected $guarded = ['CodeDeckID'];

    public static function getDefaultCodeDeckID()
    {
        return CodeDeck::where('DefaultCodedeck',1)->pluck('CodeDeckID');
    }
}