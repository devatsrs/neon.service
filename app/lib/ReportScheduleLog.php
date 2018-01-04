<?php
namespace App\Lib;

class ReportScheduleLog extends \Eloquent {
	protected $fillable = [];
    protected $guarded = array('ReportScheduleLogID');
    protected $connection = 'neon_report';
    protected $table = 'tblReportScheduleLog';
    protected  $primaryKey = "ReportScheduleLogID";

    public $timestamps = false; // no created_at and updated_at
}