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
}