<?php
namespace App\Lib;

class RetailUsageDetail extends \Eloquent {

	protected $fillable = [];

    protected $connection = 'sqlsrvcdr';

    public $timestamps = false; // no created_at and updated_at

    protected $guarded = array('RetailUsageDetailID');

    protected $table = 'tblRetailUsageDetails';

    protected  $primaryKey = "RetailUsageDetailID";


    
}