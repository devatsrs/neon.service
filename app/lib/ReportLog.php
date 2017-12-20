<?php
namespace App\Lib;

class ReportLog extends \Eloquent {
	protected $fillable = [];
    protected $guarded = array('ReportLogID');
    protected $connection = 'neon_report';
    protected $table = 'tblReportLog';
    protected  $primaryKey = "ReportLogID";

    public $timestamps = false; // no created_at and updated_at
}