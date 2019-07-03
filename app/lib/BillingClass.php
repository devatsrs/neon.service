<?php
namespace App\Lib;


use Illuminate\Support\Facades\DB;

class BillingClass extends \Eloquent {

    protected $table = 'tblBillingClass';
    public $primaryKey = "BillingClassID";
    protected $fillable = [];
    protected $guarded = ['BillingClassID'];


    public static function getBillingClass($BillingClassID){
        return BillingClass::where('BillingClassID',$BillingClassID)->first();
    }
    public static function getInvoiceTemplateID($BillingClassID){
        return BillingClass::where('BillingClassID',$BillingClassID)->pluck('InvoiceTemplateID');
    }
    public static function getPaymentDueInDays($BillingClassID){
        return BillingClass::where('BillingClassID',$BillingClassID)->pluck('PaymentDueInDays');
    }
    public static function getRoundChargesAmount($BillingClassID){
        return BillingClass::where('BillingClassID',$BillingClassID)->pluck('RoundChargesAmount');
    }
    public static function getRoundChargesCDR($BillingClassID){
        return BillingClass::where('BillingClassID',$BillingClassID)->pluck('RoundChargesCDR');
    }
    public static function getTaxRate($BillingClassID){
        return BillingClass::where('BillingClassID',$BillingClassID)->pluck('TaxRateID');
    }

    public static function getBillingClassByCompanyID($CompanyID){

        $Count = Reseller::IsResellerByCompanyID($CompanyID);
        if($Count==0){
            $BillingClasses = BillingClass::where(array("CompanyID"=>$CompanyID))->get();
        }else{
            $BillingClasses = DB::table('tblBillingClass as b1')->leftJoin('tblBillingClass as b2',function ($join) use($CompanyID){
                $join->on('b1.BillingClassID', '=', 'b2.ParentBillingClassID');
                $join->on('b1.IsGlobal','=', DB::raw('1'));
                $join->on('b2.CompanyID','=', DB::raw($CompanyID));
            })->select(['b1.Name','b1.BillingClassID'])
                ->where(function($q) use($CompanyID) {
                    $q->where('b1.CompanyID', $CompanyID)
                        ->orWhere('b1.IsGlobal', '1');
                })->whereNull('b2.BillingClassID')
                ->get();
        }
        return $BillingClasses;
    }
}