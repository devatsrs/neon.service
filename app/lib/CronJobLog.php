<?php
namespace App\Lib;
use Illuminate\Support\Facades\DB;
class CronJobLog extends \Eloquent {
	protected $fillable = [];
    protected $guarded = array('CronJobLogID');

    protected $table = 'tblCronJobLog';

    protected  $primaryKey = "CronJobLogID";

    public static function createLog($CronJobID,$moredata=array()){
        $joblogdata = array();
        $joblogdata['CronJobID'] = $CronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';
        $joblogdatafinal = $moredata+$joblogdata;
        if(empty($joblogdatafinal['CronJobStatus'])){
            $joblogdatafinal['CronJobStatus'] = CronJob::CRON_SUCCESS;
        }
       // CronJobLog::insert($joblogdatafinal);

        if(empty($joblogdatafinal['Message'])){
            $joblogdatafinal['Message'] = '';
        }

        DB::select("CALL prc_CreateCronJobLog(".$CronJobID.",".$joblogdatafinal['CronJobStatus'].",'".$joblogdatafinal['created_at']."','RMScheduler','".$joblogdatafinal['Message']."')");



    }
}