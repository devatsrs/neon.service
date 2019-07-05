<?php
namespace App\Lib;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class UsageDetail extends \Eloquent {
	protected $fillable = [];
    protected $connection = 'sqlsrvcdr';
    public $timestamps = false; // no created_at and updated_at

    protected $guarded = array('UsageDetailID');

    protected $table = 'tblUsageDetails';

    protected  $primaryKey = "UsageDetailID";

    const RATE_METHOD_CURRENT_RATE = "CurrentRate";
    const RATE_METHOD_SPECIFYRATE = "SpecifyRate";
    const RATE_METHOD_VALUE_AGAINST_COST = "ValueAgainstCost";

    static $RateMethod = array(self::RATE_METHOD_CURRENT_RATE=>'Rate setup against account',self::RATE_METHOD_SPECIFYRATE=>'Specify Rate',self::RATE_METHOD_VALUE_AGAINST_COST=> "Add Margin on Cost" );

    public static function generatecsv($processID,$deletecdr=0,$IPbased = 0){
        Log::info("exec prc_getUsageDetail '".$processID."'");
        $UsageDetails = DB::connection('sqlsrvcdr')->select("CALL prc_getUsageDetail('".$processID."')");
        $count = 1;
        $excel_data = array();
        $prevacname = $prevfile = $get_current = $prevdate = $prevCompanyGatewayID='';
        $usedeatialids = array();
        foreach($UsageDetails as $UsageDetail){
            $cdrdate = date('Y-m-d',strtotime($UsageDetail->connect_time));
            $filename = $cdrdate.'.csv';
            if($IPbased == 1){
                $AccountName = trim($UsageDetail->remote_ip);
            }else{
                $AccountName = trim($UsageDetail->AccountName);
            }

            $fullpath = Config::get('app.cdr_location').$UsageDetail->CompanyGatewayID . '/' . $AccountName . '/';
            if (file_exists($fullpath) === false) {
                mkdir($fullpath, 0777, true);
            }
            $fullfilename = $fullpath.$filename;
            if($count == 1) {
                $prevacname = $AccountName;
                $prevfile = $filename;
                $prevCompanyGatewayID = $UsageDetail->CompanyGatewayID;
            }
            $prevfullpath = Config::get('app.cdr_location').$prevCompanyGatewayID . '/' . $prevacname . '/';
            $prevfullfilename = $prevfullpath.$prevfile;
            if($prevfullfilename != $fullfilename || $prevacname != $AccountName) {
                file_put_contents($prevfullfilename,$get_current,FILE_APPEND | LOCK_EX);
                $get_current='';
                $usedeatialids = array();
            }
            $excel_data = json_decode(json_encode($UsageDetail),true);
            unset($excel_data['CompanyGatewayID']);
            unset($excel_data['UsageDetailID']);
            $get_current .=implode(',',$excel_data)."\n";
            $usedeatialids[] = $UsageDetail->UsageDetailID;
            if(count($UsageDetails) == $count) {

                file_put_contents($prevfullfilename,$get_current, FILE_APPEND | LOCK_EX);
                $get_current='';
                $usedeatialids = array();

            }
            $prevacname = $AccountName;
            $prevfile = $filename;
            $prevdate = $cdrdate;
            $prevCompanyGatewayID = $UsageDetail->CompanyGatewayID;
            $count++;
        }
        if($deletecdr == 1){
            UsageDetail::where(["processId"=>$processID])->delete();
        }
    }


    /** Delete CDR from Given Date to Current Date
     * @param $cronsetting
     * @param $CompanyGatewayID
     * @param $CronJobID
     * @return array
     */
    public static function reImportCDRByStartDate($cronsetting,$CronJobID,$processID){

        $ReturnData=array();
        $CronJob = CronJob::find($CronJobID);
        $CompanyID = $CronJob->CompanyID;
        $StartDate = trim($cronsetting['CDRImportStartDate']);
        $CompanyGatewayID = $cronsetting['CompanyGatewayID'];

        //@TODO: Add transaction Start
        //@TODO: try catch

        try{

            Log::info("===== ReImport CDR By StartDate =========");

            DB::connection('sqlsrvcdr')->beginTransaction();

            $EndDate = date("Y-m-d");
            $prc="CALL prc_deleteCDRFromDate('".$StartDate."',".$CompanyGatewayID.",".$processID.",'".$EndDate."')";
            DB::connection('sqlsrvcdr')->select($prc);
            Log::info($prc);

            DB::connection('sqlsrvcdr')->commit();

            Log::info("===== End ReImport CDR By StartDate =========");

            //Remove start date when cdr deleted.
            $cronsetting['CDRImportStartDate'] = '';
            $cronsetting = json_encode($cronsetting);

            DB::connection('sqlsrv2')->beginTransaction();

            TempUsageDownloadLog::addStartEntryForNewGateway($CompanyID,$CompanyGatewayID,$StartDate);

            DB::connection('sqlsrv2')->commit();

            if($CronJob->update(['Settings'=>$cronsetting])){

                $ReturnData['CronJobStatus']=CronJob::CRON_SUCCESS;
                $ReturnData['Message'] = "Data deleted From ".$StartDate." to Current Date time.<br>";
                Log::info("==== Reimport CDR Success From ".$StartDate);

            }else{

                Log::info("=====ReimportCDR Fail to update======");
                $ReturnData['CronJobStatus'] = CronJob::CRON_FAIL;
                $ReturnData['Message'] = "Something Went Wrong";

            }

        }catch(\Exception $e){

            Log::info("===== Exception catch in CDR Reimport ======");
            Log::error($e);

            try {

                DB::connection('sqlsrv2')->rollback();
                DB::connection('sqlsrvcdr')->rollback();

            } catch (\Exception $err) {

                Log::error($err);

            }

            $ReturnData['CronJobStatus'] = CronJob::CRON_FAIL;
            $ReturnData['Message'] = 'Error:'.$e->getMessage();

        }


        //@TODO: Add transaction end

        return $ReturnData;

    }

    public static function getTotalUsageByStartDate($AccountID,$Date){
        $TotalCharges = 0;

        $UsageDetails = DB::connection('sqlsrvcdr')->select('SELECT SUM(ud.cost) as cost  FROM tblUsageDetails ud INNER JOIN tblUsageHeader h  ON ud.UsageHeaderID = h.UsageHeaderID WHERE h.AccountID = "' . $AccountID . '" AND h.StartDate = "' . $Date . '"');

        if (!empty($UsageDetails[0]->cost)) {
            $TotalCharges = $UsageDetails[0]->cost;
        }

        return $TotalCharges;
    }


}