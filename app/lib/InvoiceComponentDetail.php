<?php
namespace App\Lib;
class InvoiceComponentDetail extends \Eloquent
{
    //InvoiceComponentDetail
    protected $connection = 'sqlsrv2';
    protected $guarded = array("InvoiceComponentDetailID");

    protected $table = 'tblInvoiceComponentDetail';

    protected $primaryKey = "InvoiceComponentDetailID";

}