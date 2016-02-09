<?php
namespace App\Lib;
class CompanySetting extends \Eloquent {
	protected $fillable = [];
    protected $table = "tblCompanySetting";
    public $timestamps = false; // no created_at and updated_at

    public static function getKeyVal($CompanyID,$key){
        $CompanySetting = CompanySetting::where(["CompanyID"=> $CompanyID,'key'=>$key])->first();
        if(count($CompanySetting)>0){
            return $CompanySetting->Value;
        }else{
            return 'Invalid Key';
        }
    }
}