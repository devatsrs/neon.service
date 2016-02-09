<?php


namespace App\Lib;


class Payment extends \Eloquent{
    protected $fillable = [];
    protected $connection = 'sqlsrv2';
    protected $table = "tblPayment";
    protected $primaryKey = "PaymentID";

} 