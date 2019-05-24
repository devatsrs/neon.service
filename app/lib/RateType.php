<?php
namespace App\Lib;

class RateType extends \Eloquent {

    protected $fillable = [];
    protected $guarded = array('RateTypeID');
    protected $table = 'tblRateType';
    public  $primaryKey = "RateTypeID"; //Used in BasedController
    CONST SLUG_DID = 'did';
    CONST SLUG_VOICECALL = 'voicecall';
    CONST SLUG_PACKAGE = 'package';


    public static function getRateTypeIDBySlug($Slug){
        return RateType::where(['Slug'=>$Slug,'Active'=>1])->pluck('RateTypeID');
    }

}