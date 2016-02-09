<?php
namespace App\Lib;
use Illuminate\Support\Facades\Config;

class AccountEmailLog extends \Eloquent {
    protected $guarded = array("AccountEmailLogID");
    protected $fillable = [];
    protected $table = "AccountEmailLog";
    protected $primaryKey = "AccountEmailLogID";

}