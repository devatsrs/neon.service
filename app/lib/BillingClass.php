<?php
namespace App\Lib;


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
    public static function getCDRType($BillingClassID){
        return BillingClass::where('BillingClassID',$BillingClassID)->pluck('CDRType');
    }
    public static function getRoundChargesAmount($BillingClassID){
        return BillingClass::where('BillingClassID',$BillingClassID)->pluck('RoundChargesAmount');
    }
}