<?php namespace App\Console\Commands;

use App\Lib\Account;
use App\Lib\CompanyGateway;
use App\Lib\CronHelper;
use App\Lib\GatewayAccount;
use App\Lib\Helper;
use App\Lib\TempUsageDetail;
use App\Lib\UsageDetail;
use App\Lib\UsageHeader;
use App\Lib\User;
use Illuminate\Console\Command;
use App\Lib\Job;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Config;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Finder\Iterator\RecursiveDirectoryIterator;
use Webpatser\Uuid\Uuid;

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

        CronHelper::before_cronrun($this);


        $arguments = $this->argument();
        $JobID = $arguments["JobID"];
        $CompanyID = $arguments["CompanyID"];
        $job = Job::find($JobID);
        $ProcessID = Uuid::generate();
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
                if(!empty($joboptions->StartDate)) {
                    $startdate = $joboptions->StartDate;
                }
                if(!empty($joboptions->EndDate)) {
                    $enddate = $joboptions->EndDate;
                }
                if(isset($joboptions->CDRType)) {
                    $CDRType = $joboptions->CDRType;
                }
                if(!empty($startdate) && !empty($enddate)){
                    DB::connection('sqlsrv2')->statement(" call  prc_InsertTempReRateCDR  ($CompanyID,$CompanyGatewayID,'".$startdate."','".$enddate."','".$AccountID."','" . $ProcessID . "','".$temptableName."','".$CDRType."')");
                    DB::connection('sqlsrv2')->statement("CALL  prc_updatePrefixTrunk ('" . $CompanyID . "','" . $CompanyGatewayID . "','" . $ProcessID . "' , '".$temptableName."')");
                    $skiped_account_data = TempUsageDetail::RateCDR($CompanyID,$ProcessID,$temptableName,$CompanyGatewayID);

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
                DB::connection('sqlsrv2')->statement(" call  prc_DeleteCDR  ($CompanyID,$CompanyGatewayID,'" . $startdate . "','" . $enddate . "','" . $AccountID . "','".$CDRType."')");
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

        CronHelper::after_cronrun($this);

    }
}

