<?php
namespace App\Lib;
use Symfony\Component\Intl\Intl;
use App\Lib\CurrencyConversion;
use Illuminate\Support\Facades\DB;

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

    public static function getCurrencyId($CompanyID,$CurrencyCode){
        $CurrencyId='';
        if(isset($CurrencyCode)){
            $CurrencyId = Currency::where(["Code"=>$CurrencyCode,"CompanyId"=>$CompanyID])->pluck('CurrencyId');
            if(!empty($CurrencyId) && $CurrencyId>0){
                return $CurrencyId;
            }
        }
        return $CurrencyId;
    }

    public static function getCurrencyDropdownIDList($CompanyID,$includePrefix=0){
        if($includePrefix == 1)
            return Currency::select('Code', DB::raw('CONCAT("DBDATA-",CurrencyID) AS CurrencyID'))->where("CompanyId",$CompanyID)->lists('Code','CurrencyID');
        else
            return Currency::where("CompanyId",$CompanyID)->lists('Code','CurrencyID');
    }

    public static function convertCurrency($CompanyCurrency=0, $AccountCurrency=0, $FileCurrency=0, $Rate=0) {

        if($FileCurrency == $AccountCurrency) {
            $NewRate = $Rate;
        } else if($FileCurrency == $CompanyCurrency) {
            $ConversionRate = CurrencyConversion::where('CurrencyID',$AccountCurrency)->pluck('Value');
            if($ConversionRate)
                $NewRate = ($Rate *$ConversionRate);
            else
                $NewRate = 'failed';
        } else {
            $ACConversionRate = CurrencyConversion::where('CurrencyID',$AccountCurrency)->pluck('Value');
            $FCConversionRate = CurrencyConversion::where('CurrencyID',$FileCurrency)->pluck('Value');

            if($ACConversionRate && $FCConversionRate)
                $NewRate = ($ACConversionRate) * ($Rate/$FCConversionRate);
            else
                $NewRate = 'failed';
        }

        return $NewRate;

    }

    public function getRate(){
        return $this->hasOne(CurrencyConversion::class, 'CompanyID', 'CompanyId');
    }
}