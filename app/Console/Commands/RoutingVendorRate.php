<?php namespace App\Console\Commands;

use App\Lib\CronHelper;
use App\Lib\Summary;
use App\Lib\VendorRate;
use Illuminate\Console\Command;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\Retention;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use \Exception;
use Symfony\Component\Console\Input\InputArgument;
use App\Lib\CompanyGateway;

class RoutingVendorRate extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'routingvendorrate';

	/**
	 * The console command description.
	 *
	 * @var string
	 */
	protected $description = 'Routing Vendor Rate Command description.';

	protected function getArguments()
	{
		return [
			['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID '],
			['CronJobID', InputArgument::REQUIRED, 'Argument CronJobID'],
		];
	}

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
	 * Execute the console command.
	 *
	 * @return mixed
	 */
    public function handle() {
        
        CronHelper::before_cronrun($this->name, $this );

        $arguments = $this->argument();
        $CompanyID = $arguments["CompanyID"];
        $CronJobID = $arguments["CronJobID"];
        
        $CronJob =  CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings,true);
        CronJob::activateCronJob($CronJob);
        CronJob::createLog($CronJobID);
        
        Log::useFiles(storage_path() . '/logs/RoutingVendorRate-companyid:'.$CompanyID . '-cronjobid:'.$CronJobID.'-' . date('Y-m-d') . '.log');
        $joblogdata = array();
        $joblogdata['CronJobID'] = $CronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RoutingVendorRate';
        try{
            
            DB::connection('neon_routingengine')->beginTransaction();
            CronJob::createLog($CronJobID);
            
            DB::connection('neon_routingengine')->table('tblTempVendorRate')->truncate();
            $GetRoutingInfo = DB::connection('sqlsrv')->select('call prc_RoutingVendorRate(1)');
            
            //Put data into tables
            DB::connection('neon_routingengine')->table('tblVendorRate')->truncate();
            $GetRoutingInfo = DB::connection('sqlsrv')->select('call prc_RoutingVendorRate(2)');
            
            $result = CronJob::CronJobSuccessEmailSend($CronJobID);
            $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
            CronJobLog::insert($joblogdata);
            
            DB::connection('neon_routingengine')->commit(); 
            
        }catch (\Exception $e){
            Log::useFiles(storage_path() . '/logs/RoutingVendorRate-Error-' . date('Y-m-d') . '.log');
            
            Log::error($e);
            $this->info('Failed:' . $e->getMessage());
            $joblogdata['Message'] ='Error:'.$e->getMessage();
            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
            CronJobLog::insert($joblogdata);
            if(!empty($cronsetting['ErrorEmail'])) {

                    $result = CronJob::CronJobErrorEmailSend($CronJobID,$e);
                    Log::error("**Email Sent Status " . $result['status']);
                    Log::error("**Email Sent message " . $result['message']);
            }


    }
    
        CronJob::deactivateCronJob($CronJob);
        CronHelper::after_cronrun($this->name, $this);
    }

}
