<?php
namespace App\Lib;
use Symfony\Component\Intl\Intl;
use App\Lib\CurrencyConversion;

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

    public static function getCurrencyId($CurrencyCode){
        $CurrencyId='';
        if(isset($CurrencyCode)){
            $CurrencyId = Currency::where("Code",$CurrencyCode)->pluck('CurrencyId');
            if(!empty($CurrencyId) && $CurrencyId>0){
                return $CurrencyId;
            }
        }
        return $CurrencyId;
    }

    public static function getCurrencyDropdownIDList($CompanyID){
        return Currency::where("CompanyId",$CompanyID)->lists('Code','CurrencyID');
    }

    public static function convertCurrency($CompanyID=0, $FromCurrency=0, $ToCurrency=0, $Rate=0) {

        if($FromCurrency && $ToCurrency && $FromCurrency != $ToCurrency) {
            $FromCurrencyCode = Currency::find($FromCurrency)->pluck('Code');
            $ToCurrencyCode = Currency::find($ToCurrency)->pluck('Code');

            if($FromCurrencyCode == 'USD' || $ToCurrencyCode == 'USD') {
                $FromRate = CurrencyConversion::where(['CurrencyID' => $FromCurrency, 'CompanyID' => $CompanyID])->pluck('Value');
                $ToRate = CurrencyConversion::where(['CurrencyID' => $ToCurrency, 'CompanyID' => $CompanyID])->pluck('Value');

                $NewRate = (($ToRate / $FromRate) * $Rate);
            } else {
                $USDRateID = Currency::where(['Code' => 'USD', 'CompanyID' => $CompanyID])->pluck('CurrencyId');
                $USDRate = CurrencyConversion::where(['CurrencyID' => $USDRateID, 'CompanyID' => $CompanyID])->pluck('Value');
                $FromRate = CurrencyConversion::where(['CurrencyID' => $FromCurrency, 'CompanyID' => $CompanyID])->pluck('Value');
                $ToRate = CurrencyConversion::where(['CurrencyID' => $ToCurrency, 'CompanyID' => $CompanyID])->pluck('Value');

                $NewRate = (($USDRate / $FromRate) * $Rate);
                $NewRate = (($ToRate / $USDRate) * $NewRate);
            }

        } else {
            $NewRate = $Rate;
        }

        return $NewRate;

    }
}