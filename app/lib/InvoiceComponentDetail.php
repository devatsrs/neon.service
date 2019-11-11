<?php
namespace App\Lib;
class InvoiceComponentDetail extends \Eloquent
{
    //InvoiceComponentDetail
    protected $guarded = array("InvoiceComponentDetailID");

    protected $table = 'tblInvoiceComponentDetail';

    protected $primaryKey = "InvoiceComponentDetailID";

}