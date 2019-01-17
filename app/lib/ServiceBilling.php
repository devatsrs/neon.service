<?php

namespace App\Lib;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class ServiceBilling extends Model
{
    //
    protected $guarded = array("ServiceBillingID");

    protected $table = 'tblServiceBilling';

    protected $primaryKey = "ServiceBillingID";

    public $timestamps = false; // no created_at and updated_at

}
