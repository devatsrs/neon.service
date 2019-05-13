<?php
namespace App\Lib;

use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;


class VendorRate extends \Eloquent {

    protected $fillable   = [];
    protected $guarded    = array('VendorRateID');
    protected $table      = 'tblVendorRate';
    protected $primaryKey = "VendorRateID"; //Used in BasedController
}