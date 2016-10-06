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
            ['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID']           
        ];
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function fire()
    {
       // CronHelper::before_cronrun($this->name, $this );

        $arguments  = 	$this->argument();
        $getmypid   = 	getmypid(); // get proccess id
        $CompanyID  = 	$arguments["CompanyID"];
        $today 	    = 	date('Y-m-d');
        $Company    = 	Company::find($CompanyID);
		try {
			if(SiteIntegration::CheckCategoryConfiguration(false,SiteIntegration::$emailtrackingSlug,$CompanyID)){
				$integration =  new SiteIntegration();
				$integration->ConnectActiveEmail($CompanyID);
				$integration->ReadEmails($CompanyID);
			}else{
				Log::error("No active Tracking email added");
			}
        } catch (\Exception $e) {
			Log::error("Trackin email failed");
			Log::error($e);			
		}   

        //CronHelper::after_cronrun($this->name, $this);
    }
}