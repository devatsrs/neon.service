<?php
namespace App\Lib;

class RateTable extends \Eloquent {

    protected $fillable = [];
    protected $guarded = [];
    protected $table = 'tblRateTable';
    protected $primaryKey = "RateTableId";

    const APPLIED_TO_CUSTOMER = 1;
    const APPLIED_TO_VENDOR = 2;
    const APPLIED_TO_RESELLER = 3;

    public static $AppliedTo = array( self::APPLIED_TO_CUSTOMER => 'Customer',self::APPLIED_TO_VENDOR=>'Vendor',self::APPLIED_TO_RESELLER=>'Partner');


    const RATE_STATUS_AWAITING  = 0;
    const RATE_STATUS_APPROVED  = 1;
    const RATE_STATUS_REJECTED  = 2;
    const RATE_STATUS_DELETE    = 3;

    
}