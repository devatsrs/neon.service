<?php
namespace App\Lib;

class ExactInvoiceLog extends \Eloquent {
    protected $connection = 'sqlsrv2';
    protected $fillable = [];
    protected $guarded = [];
    protected $table = 'tblExactInvoiceLog';
    protected $primaryKey = "ExactInvoiceLogId";

    public $timestamps = false;

    const PaymentStatusPending  = 0;
    const PaymentStatusPaid     = 1;
}