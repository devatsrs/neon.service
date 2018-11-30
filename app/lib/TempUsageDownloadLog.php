<?php
namespace App\Lib;
class TempUsageDownloadLog extends \Eloquent {
	protected $fillable = [];
    protected $connection = 'sqlsrv2';
    protected $table = 'tblTempUsageDownloadLog';
    public $timestamps = false; // no created_at and updated_at

    public static function getStartDate($companyid,$CompanyGatewayID,$CronJobID){
        $endtime = TempUsageDownloadLog::where(array('CompanyID'=>$companyid,'CompanyGatewayID'=>$CompanyGatewayID))->max('end_time');
        if(empty($endtime)){
            $Settings =   CronJob::where(array('tblCronJob.CompanyID'=>$companyid,'CronJobID'=>$CronJobID))->pluck('tblCronJob.Settings');
            $cronsetting = json_decode($Settings);
            if(isset($cronsetting->StartDate)){
                $endtime = date('Y-m-d H:i:s',strtotime($cronsetting->StartDate));
            }else{
                $endtime = date('Y-m-01 00:00:00');
            }


        }
        return $endtime;
    }
    //@TODO: move this function in individual commands to make customization easy.
    public static function getLastDate($startdate,$companyid,$CronJobID){
        $Settings =   CronJob::where(array('CompanyID'=>$companyid,'CronJobID'=>$CronJobID))->pluck('Settings');
        $usageinterval = CompanyConfiguration::get($companyid,'USAGE_INTERVAL');
        $cronsetting = json_decode($Settings);

        $seconds = strtotime(date('Y-m-d 00:00:00')) - strtotime($startdate);
        $hours = round($seconds / 60 / 60  );

        if(isset($cronsetting->MaxInterval) && $hours > 24){
            $endtimefinal = date('Y-m-d H:i:s',strtotime($startdate)+$cronsetting->MaxInterval*60);
        }else {
            $endtimefinal = date('Y-m-d H:i:s',strtotime($startdate) + $usageinterval*60);
        }
        if($endtimefinal > date('Y-m-d H:i:s')){
            $endtimefinal = date('Y-m-d H:i:s');
        }
        return $endtimefinal;
    }

    // use for temp usage download files retention
    public static function getMinDateUsageDownloadFiles($CompanyID){
        $StartDate =  TempUsageDownloadLog::where(['CompanyID'=>$CompanyID])->min('start_time');
        return $StartDate;
    }


    /** Add TempUsageDownloadLog entry if New Gateway Setup
     * @param $CompanyID
     * @param $CompanyGatewayID
     * @param $StartDate
     */
    public static function addStartEntryForNewGateway($CompanyID,$CompanyGatewayID,$StartDate){

        if(TempUsageDownloadLog::where(array('CompanyID' => $CompanyID, 'CompanyGatewayID' => $CompanyGatewayID))->count() === 0 ){

            $TempUsageLogdata = array();

            $TempUsageLogdata['CompanyGatewayID'] = $CompanyGatewayID;
            $TempUsageLogdata['CompanyID'] = $CompanyID;
            $TempUsageLogdata['start_time'] = $StartDate;
            $TempUsageLogdata['end_time'] = $StartDate;
            $logdata['created_at'] = date('Y-m-d H:i:s');
            $TempUsageLogdata['ProcessID'] = "##START##";

            TempUsageDownloadLog::insert($TempUsageLogdata);

        }

    }

}
