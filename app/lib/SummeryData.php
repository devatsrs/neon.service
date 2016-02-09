<?php
namespace App\Lib;

class SummeryData extends \Eloquent {
    protected $connection = 'sqlsrv2';
    protected $fillable = [];
    protected $guarded = array('SummeryDataID');
    protected $table = 'tblSummeryData';
    public  $primaryKey = "SummeryDataID"; //Used in BasedController

}