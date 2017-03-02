<?php
namespace App\Lib;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
class RecurringInvoiceLog extends \Eloquent {
    protected $connection = 'sqlsrv2';
    protected $fillable = [];
    protected $guarded = array('RecurringInvoicesLogID');
    protected $table = 'tblRecurringInvoiceLog';
    protected  $primaryKey = "RecurringInvoicesLogID";

    const CREATED = 1;
    const UPDATED = 2;
    const VIEWED = 3;
    const SENT = 4;
    const START=5;
    const STOP=6;
    const GENERATE = 7;
    const COMMENT  =8;

    public static $log_status = array(
                                    self::CREATED=>'Created',
                                    self::VIEWED=>'Viewed',
                                    self::SENT=>'Sent',
                                    self::UPDATED=>'Updated',
                                    self::START => 'Start',
                                    self::STOP => 'Stop',
                                    self::GENERATE => 'Generate',
                                    self::COMMENT => 'Comment'
                                );

}