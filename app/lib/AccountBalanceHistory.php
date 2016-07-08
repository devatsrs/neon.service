<?php

namespace App\Lib;

use Illuminate\Database\Eloquent\Model;

class AccountBalanceHistory extends Model
{
    //
    protected $guarded = array("AccountBalanceHistoryID");

    protected $table = 'tblAccountBalanceHistory';

    protected $primaryKey = "AccountBalanceHistoryID";

    public $timestamps = false; // no created_at and updated_at


}
