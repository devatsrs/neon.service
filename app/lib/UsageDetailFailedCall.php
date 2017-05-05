<?php
namespace App\Lib;

class UsageDetailFailedCall extends \Eloquent {
    protected $fillable = [];
    protected $connection = 'sqlsrvcdr';
    protected $guarded = array('UsageDetailFailedCallID');
    protected $table = 'tblUsageDetailFailedCall';
    protected  $primaryKey = "UsageDetailFailedCallID";
}