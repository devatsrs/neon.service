<?php

namespace App\Lib;

class VendorRateUpdateHistory extends \Eloquent {

    protected $fillable = [];
    protected $guarded = array('VendorRateUpdateHistoryID');

    protected $table = 'tblVendorRateUpdateHistory';

    protected  $primaryKey = "VendorRateUpdateHistoryID";


}
