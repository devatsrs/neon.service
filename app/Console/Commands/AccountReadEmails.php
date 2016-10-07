<?php
namespace App\Console\Commands;

use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\Helper;
use App\Lib\User;
use App\Lib\Company;
use App\Lib\JobStatus;
use App\Lib\SiteIntegration;
use Symfony\Component\Console\Input\InputArgument;
use Carbon\Carbon;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Config;
use App\Lib\Job;
use App\Lib\JobType;
use Webpatser\Uuid\Uuid;
use \Exception;

class AccountReadEmails extends Command
{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'accountreademails';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'account email read .';

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
            ['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID'],
			['CronJobID', InputArgument::REQUIRED, 'Argument CronJobID'],           
        ];
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function fire()
    {
		/////////////////////////////
		
        CronHelper::before_cronrun($this->name, $this );

        $arguments 		= 	$this->argument();
        $CronJobID 		= 	$arguments["CronJobID"];
        $CompanyID 		= 	$arguments["CompanyID"];
        $CronJob 		= 	CronJob::find($CronJobID);
        $cronsetting 	= 	json_decode($CronJob->Settings,true);
		$today 	    	= 	date('Y-m-d');
        CronJob::activateCronJob($CronJob);
        CronJob::createLog($CronJobID);
        Log::useFiles(storage_path() . '/logs/accountemailalerts-' . $CronJobID . '-' . date('Y-m-d') . '.log');
        try
		{	Log::info('============== Account read email Start===========');
			if(SiteIntegration::CheckCategoryConfiguration(false,SiteIntegration::$emailtrackingSlug,$CompanyID)){
				Log::info('============== Integration find===========');
				$integration =  new SiteIntegration();
				$integration->ConnectActiveEmail($CompanyID);
				$integration->ReadEmails($CompanyID);
				$joblogdata['Message'] = 'Success';
				Log::info('============== Account read email End===========');
			}else{
				Log::error("No active Tracking email added");
				$joblogdata['Message'] = 'No active Tracking email added';
			}
        }
		catch (\Exception $e)
		{

            $this->info('Failed:' . $e->getMessage());
            $joblogdata['Message'] = 'Error:' . $e->getMessage();
            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
            Log::error($e);
            if(!empty($cronsetting['ErrorEmail'])) {
                $result = CronJob::CronJobErrorEmailSend($CronJobID,$e);
                Log::error("**Email Sent Status " . $result['status']);
                Log::error("**Email Sent message " . $result['message']);
            }
        }

        CronJob::deactivateCronJob($CronJob);
        CronJobLog::createLog($CronJobID,$joblogdata);
        if(!empty($cronsetting['SuccessEmail'])) {
            $result = CronJob::CronJobSuccessEmailSend($CronJobID);
            Log::error("**Email Sent Status ".$result['status']);
            Log::error("**Email Sent message ".$result['message']);
        }

        CronHelper::after_cronrun($this->name, $this);
    
		///////////////////////////////
    }
}