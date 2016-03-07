<?php
namespace App\Lib;
use Symfony\Component\Intl\Intl;
class Currency extends \Eloquent {

    protected $fillable = [];
    protected $table = "tblCurrency";
    protected $primaryKey = "CurrencyId";
    public static function getCurrencyCode($CurrencyId){
        if($CurrencyId>0){
            return Currency::where("CurrencyId",$CurrencyId)->pluck('Code');
        }
    }

    public static function getCurrencySymbol($CurrencyID){
        if($CurrencyID>0){
            return Currency::where("CurrencyId",$CurrencyID)->pluck('Symbol');
        }
    }
}