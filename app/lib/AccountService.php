<?php
namespace App\Lib;
class AccountService extends \Eloquent {
	protected $fillable = [];
    protected $connection = "sqlsrv";
    protected $table = "tblAccountService";
    protected $primaryKey = "AccountServiceID";
    protected $guarded = array('AccountServiceID');

}