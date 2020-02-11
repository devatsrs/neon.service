<?php
namespace App\Lib;

class InvoicePeriodLog extends \Eloquent
{
    protected $connection = 'sqlsrv2';
    protected $table = "tblInvoicePeriodLog";
    protected $primaryKey = "InvoicePeriodLogID";
    protected $guarded = array('InvoicePeriodLogID');

}