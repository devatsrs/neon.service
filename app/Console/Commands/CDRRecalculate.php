<?php namespace App\Console\Commands;

use App\Lib\Company;
use App\Lib\CompanyGateway;
use App\Lib\Job;
use App\Lib\TempUsageDetail;
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
                $CDRType = $startdate = $enddate= '';
                $CompanyGatewayID = $joboptions->CompanyGatewayID;
                $temptableName = CompanyGateway::CreateIfNotExistCDRTempUsageDetailTable($CompanyID,$CompanyGatewayID,'recal');
                if(!empty($joboptions->AccountID) && $joboptions->AccountID> 0){
                    $AccountID = (int)$joboptions->AccountID;
                }
                $companysetting =   json_decode(CompanyGateway::getCompanyGatewayConfig($CompanyGatewayID));
                $RateCDR = 1;
                $RateFormat = Company::PREFIX;
                $CLI = $CLD = '';
                $zerovaluecost = 0;
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
                if(!empty($startdate) && !empty($enddate)){
                    DB::connection('sqlsrv2')->statement(" call  prc_InsertTempReRateCDR  ($CompanyID,$CompanyGatewayID,'".$startdate."','".$enddate."','".$AccountID."','" . $ProcessID . "','".$temptableName."','".$CDRType."','".$CLI."','".$CLD."',".intval($zerovaluecost).",'".intval($CurrencyID)."')");
                    $skiped_account_data = TempUsageDetail::ProcessCDR($CompanyID,$ProcessID,$CompanyGatewayID,$RateCDR,$RateFormat,$temptableName);
                }
                if (count($skiped_account_data)) {
                    $jobdata['JobStatusMessage'] = implode(',\n\r', $skiped_account_data);
                    $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'PF')->pluck('JobStatusID');
                } else {
                    $jobdata['JobStatusMessage'] = 'Customer CDR ReRated Successfully';
                    $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'S')->pluck('JobStatusID');
                }
                //if(count($skiped_account_data) == 0) {
                DB::connection('sqlsrvcdrazure')->beginTransaction();
                DB::connection('sqlsrv2')->statement(" call  prc_DeleteCDR  ($CompanyID,$CompanyGatewayID,'" . $startdate . "','" . $enddate . "','" . $AccountID . "','".$CDRType."','".$CLI."','".$CLD."',".intval($zerovaluecost).",'".intval($CurrencyID)."')");
                DB::connection('sqlsrvcdrazure')->statement("call  prc_insertCDR ('" . $ProcessID . "','".$temptableName."')");
                DB::connection('sqlsrvcdrazure')->commit();
                //}
                DB::connection('sqlsrvcdrazure')->table($temptableName)->where(["processId" => $ProcessID])->delete();
                Log::error(' ========================== cdr transaction end =============================');
                $jobdata['updated_at'] = date('Y-m-d H:i:s');
                $jobdata['ModifiedBy'] = 'RMScheduler';

                Job::where(["JobID" => $JobID])->update($jobdata);
            }
        }catch (\Exception $e) {
            try {
                DB::rollback();
                DB::connection('sqlsrv2')->rollback();
                DB::connection('sqlsrvcdrazure')->rollback();

            } catch (\Exception $err) {
                Log::error($err);
            }
            try{
                DB::connection('sqlsrvcdrazure')->table($temptableName)->where(["processId" => $ProcessID])->delete();
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

    }
}

