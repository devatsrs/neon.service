<?php
namespace App\Lib;

class AccountDetails extends \Eloquent
{
    protected $table = "tblAccountDetails";
    protected $primaryKey = "AccountDetailID";
    protected $guarded = array('AccountDetailID');

}