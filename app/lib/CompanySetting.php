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

    public static function  setKeyVal($CompanyID,$key,$val){
        $CompanySetting = CompanySetting::where(["CompanyID"=> $CompanyID,'key'=>$key])->first();
        if(count($CompanySetting)>0){
            CompanySetting::where(["CompanyID"=> $CompanyID,'key'=>$key])->update(array('Value'=>$val));
        }else{
            CompanySetting::insert(array('CompanyID' => $CompanyID, 'key' => $key,'Value'=>$val));
        }
    }
}