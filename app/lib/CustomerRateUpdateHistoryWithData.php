<?php

namespace App\Lib;

class  CustomerRateUpdateHistoryWithData extends \Eloquent {

    protected $fillable = [];
    protected $guarded = array('CustomerRateUpdateHistoryWithDataID');

    protected $table = 'tblCustomerRateUpdateHistoryWithData';

    protected  $primaryKey = "CustomerRateUpdateHistoryWithDataID";


}
