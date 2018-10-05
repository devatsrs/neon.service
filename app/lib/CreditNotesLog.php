<?php

namespace App\Lib;

class CreditNotesLog extends \Eloquent {
    protected $connection = 'sqlsrv2';
    protected $fillable = [];
    protected $guarded = array('CreditNotesLogID');
    protected $table = 'tblCreditNotesLog';
    protected  $primaryKey = "InvoiceLogID";

    const CREATED = 1;
    const UPDATED = 2;
    const VIEWED = 3;
    const SENT =4;
    const CANCEL =5;
    const REGENERATED  =6;
    const POST  = 7;
    const COMMENT  =9;
    const PAID  =10;

    public static $log_status = array(self::CREATED=>'Created',self::VIEWED=>'Viewed',self::CANCEL=>'Cancel',self::SENT=>'Sent',self::UPDATED=>'Updated',self::REGENERATED => 'Regenerated',self::POST => 'Post',self::COMMENT => 'Comment',self::PAID => 'Paid');


}