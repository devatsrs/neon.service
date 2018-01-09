<?php
namespace App\Lib;


use Curl\Curl;
use Illuminate\Support\Facades\Log;

class Report extends \Eloquent{
    protected $guarded = array("ReportID");
    protected $connection = 'neon_report';
    protected $fillable = [];
    protected $table = "tblReport";
    protected $primaryKey = "ReportID";



}
