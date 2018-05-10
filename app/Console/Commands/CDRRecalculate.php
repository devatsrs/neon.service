<?php namespace App\Console\Commands;

use App\Lib\Company;
use App\Lib\CompanyGateway;
use App\Lib\CronHelper;
use App\Lib\Job;
use App\Lib\TempUsageDetail;
use App\Lib\UsageDetail;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Finder\Iterator\RecursiveDirectoryIterator;

class CDRRecalculate extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'cdrrecal';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Command description.';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }
    /**
     * Get the console command arguments.
     *
     * @return array
     */
    protected function getArguments()
    {
        return [
            ['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID '],
            ['JobID', InputArgument::REQUIRED, 'Argument JobID '],
        ];
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function handle()
    {

        CronHelper::before_cronrun($this->name, $this );


        $arguments = $this->argument();
        $JobID = $arguments["JobID"];
        $CompanyID = $arguments["CompanyID"];
        $job = Job::find($JobID);
        $ProcessID = CompanyGateway::getProcessID();
        $getmypid = getmypid();
        $skiped_account_data = array();
        $jobdata['updated_at'] = date('Y-m-d H:i:s');
        $jobdata['ModifiedBy'] = 'RMScheduler';
        Job::JobStatusProcess($JobID,$ProcessID,$getmypid);
        $temptableName  = 'tblTempUsageDetail';
        Log::useFiles(storage_path().'/logs/cdrrecal-'.$JobID.'-'.date('Y-m-d').'.log');
        try {
            Log::error(' ========================== cdr transaction start =============================');

            $joboptions = json_decode($job->Options);
            if(!empty($job)) {
                $AccountID=0;
                $ResellerOwner=0;
                $CDRType = $startdate = $enddate= '';
                $CompanyGatewayID = $joboptions->CompanyGatewayID;
                $temptableName = CompanyGateway::CreateIfNotExistCDRTempUsageDetailTable($CompanyID,$CompanyGatewayID,'recal');
                if(!empty($joboptions->AccountID) && $joboptions->AccountID> 0){
                    $AccountID = (int)$joboptions->AccountID;
                }
                if(!empty($joboptions->ResellerOwner) && $joboptions->ResellerOwner> 0){
                    $ResellerOwner = (int)$joboptions->ResellerOwner;
                }

                $companysetting =   json_decode(CompanyGateway::getCompanyGatewayConfig($CompanyGatewayID));
                $RateCDR = 1;
                $RateFormat = Company::PREFIX;
                $CLI = $CLD =  $area_prefix = $Trunk = '';
                $RateMethod = 'CurrentRate';
                $zerovaluecost = $SpecifyRate =  0 ;
                $CurrencyID = 0;
                if(isset($companysetting->RateFormat) && $companysetting->RateFormat){
                    $RateFormat = $companysetting->RateFormat;
                }

                if(!empty($joboptions->StartDate)) {
                    $startdate = $joboptions->StartDate;
                }
                if(!empty($joboptions->EndDate)) {
                    $enddate = $joboptions->EndDate;
                }

                if(isset($joboptions->CDRType)) {
                    $CDRType = $joboptions->CDRType;
                }
                if(!empty($joboptions->CLD)) {
                    $CLD = $joboptions->CLD;
                }
                if(!empty($joboptions->CLI)) {
                    $CLI = $joboptions->CLI;
                }
                if(!empty($joboptions->zerovaluecost)) {
                    $zerovaluecost = $joboptions->zerovaluecost;
                }
                if(!empty($joboptions->CurrencyID)) {
                    $CurrencyID = $joboptions->CurrencyID;
                }
                if(!empty($joboptions->area_prefix)) {
                    $area_prefix = $joboptions->area_prefix;
                }
                if(!empty($joboptions->Trunk)) {
                    $Trunk = $joboptions->Trunk;
                }
                if(isset($joboptions->RateMethod)) {
                    $RateMethod = $joboptions->RateMethod;
                }
                if(isset($joboptions->SpecifyRate)) {
                    $SpecifyRate = $joboptions->SpecifyRate;
                }
                if(!empty($startdate) && !empty($enddate)){
                    Log::error("start  call  prc_InsertTempReRateCDR  ($CompanyID,$CompanyGatewayID,'".$startdate."','".$enddate."','".$AccountID."','" . $ProcessID . "','".$temptableName."','".$CDRType."','".$CLI."','".$CLD."',".intval($zerovaluecost).",'".intval($CurrencyID)."','".$area_prefix."','".$Trunk."','".$RateMethod."','".$ResellerOwner."')");
                    DB::connection('sqlsrv2')->statement(" call  prc_InsertTempReRateCDR  ($CompanyID,$CompanyGatewayID,'".$startdate."','".$enddate."','".$AccountID."','" . $ProcessID . "','".$temptableName."','".$CDRType."','".$CLI."','".$CLD."',".intval($zerovaluecost).",'".intval($CurrencyID)."','".$area_prefix."','".$Trunk."','".$RateMethod."','".$ResellerOwner."')");

                    if(TempUsageDetail::update_cost_with_margin($RateMethod,$SpecifyRate,$temptableName,$ProcessID)){
                        $RateCDR = 0;
                    }
                    Log::error("end  call  prc_InsertTempReRateCDR  ($CompanyID,$CompanyGatewayID,'".$startdate."','".$enddate."','".$AccountID."','" . $ProcessID . "','".$temptableName."','".$CDRType."','".$CLI."','".$CLD."',".intval($zerovaluecost).",'".intval($CurrencyID)."','".$area_prefix."','".$Trunk."','".$RateMethod."','".$ResellerOwner."')");
                    $skiped_account_data = TempUsageDetail::ProcessCDR($CompanyID,$ProcessID,$CompanyGatewayID,$RateCDR,$RateFormat,$temptableName,'',$RateMethod,$SpecifyRate,0,0,0);
                }
                if (count($skiped_account_data)) {
                    $jobdata['JobStatusMessage'] = implode(',\n\r',fix_jobstatus_meassage($skiped_account_data));
                    $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'PF')->pluck('JobStatusID');
                } else {
                    $jobdata['JobStatusMessage'] = 'Customer CDR ReRated Successfully';
                    $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'S')->pluck('JobStatusID');
                }
                //if(count($skiped_account_data) == 0) {
                DB::connection('sqlsrvcdr')->beginTransaction();
                DB::connection('sqlsrv2')->statement(" call  prc_DeleteCDR  ($CompanyID,$CompanyGatewayID,'" . $startdate . "','" . $enddate . "','" . $AccountID . "','".$CDRType."','".$CLI."','".$CLD."',".intval($zerovaluecost).",'".intval($CurrencyID)."','".$area_prefix."','".$Trunk."','".$ResellerOwner."')");
                DB::connection('sqlsrvcdr')->statement("call  prc_insertCDR ('" . $ProcessID . "','".$temptableName."')");
                DB::connection('sqlsrvcdr')->commit();
                //}
                DB::connection('sqlsrvcdr')->table($temptableName)->where(["processId" => $ProcessID])->delete();
                Log::error(' ========================== cdr transaction end =============================');
                $jobdata['updated_at'] = date('Y-m-d H:i:s');
                $jobdata['ModifiedBy'] = 'RMScheduler';

                Job::where(["JobID" => $JobID])->update($jobdata);
            }
        }catch (\Exception $e) {
            try {
                DB::rollback();
                DB::connection('sqlsrv2')->rollback();
                DB::connection('sqlsrvcdr')->rollback();

            } catch (\Exception $err) {
                Log::error($err);
            }
            try{
                DB::connection('sqlsrvcdr')->table($temptableName)->where(["processId" => $ProcessID])->delete();
            } catch (\Exception $err) {
                Log::error($err);
            }

            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','F')->pluck('JobStatusID');
            $jobdata['JobStatusMessage'] = 'Customer CDR ReRating Failed::'.$e->getMessage();
            $jobdata['updated_at'] = date('Y-m-d H:i:s');
            $jobdata['ModifiedBy'] = 'RMScheduler';
            Job::where(["JobID" => $JobID])->update($jobdata);
            Log::error($e);
            TempUsageDetail::where(["processId" => $ProcessID])->delete();
        }
        Job::send_job_status_email($job,$CompanyID);

        CronHelper::after_cronrun($this->name, $this);

    }
}

