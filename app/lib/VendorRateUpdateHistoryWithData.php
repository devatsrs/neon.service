<?php

namespace App\Lib;

class VendorRateUpdateHistoryWithData extends \Eloquent {

    protected $fillable = [];
    protected $guarded = array('VendorRateUpdateHistoryWithDataID');

    protected $table = 'tblVendorRateUpdateHistoryWithData';

    protected  $primaryKey = "VendorRateUpdateHistoryWithDataID";


}
