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



    
}