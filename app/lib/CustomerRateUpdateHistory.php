<?php

namespace App\Lib;

class CustomerRateUpdateHistory extends \Eloquent {

    protected $fillable = [];
    protected $guarded = array('CustomerRateUpdateHistoryID');

    protected $table = 'tblCustomerRateUpdateHistory';

    protected  $primaryKey = "CustomerRateUpdateHistoryID";


}
