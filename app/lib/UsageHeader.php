<?php
namespace App\Lib;

class UsageHeader extends \Eloquent {
	protected $fillable = [];
    protected $connection = 'sqlsrvcdrazure';
    protected $guarded = array('UsageHeaderID');
    protected $table = 'tblUsageHeader';
    protected  $primaryKey = "UsageHeaderID";
}