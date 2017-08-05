<?php
namespace App\Lib;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Maatwebsite\Excel\Facades\Excel;
use App\Lib\CompanySetting;

class AuditDetails extends \Eloquent {
    protected $guarded = array("AuditDetailID");
    protected $fillable = [];
    protected $table = "tblAuditDetails";
    protected $primaryKey = "AuditDetailID";
	public    $timestamps 	= 	false; // no created_at and updated_at


}