<?php
namespace App\Console\Commands;

use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\Helper;
use App\Lib\User;
use App\Lib\TicketGroups;
use App\Lib\TicketsTable;
use App\Lib\Company;
use App\Lib\JobStatus;
use App\Lib\SiteIntegration;
use App\Lib\Imap;
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

class ReadEmailsTickets extends Command
{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'reademailstickets';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Ticket email read.';

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
		 //////////////		
        CronHelper::before_cronrun($this->name, $this );

        $arguments 		= 	$this->argument();
        $CronJobID 		= 	$arguments["CronJobID"];
        $CompanyID 		= 	$arguments["CompanyID"];
        $CronJob 		= 	CronJob::find($CronJobID);
        $cronsetting 	= 	json_decode($CronJob->Settings,true);
		$today 	    	= 	date('Y-m-d');
        CronJob::activateCronJob($CronJob);
        CronJob::createLog($CronJobID);
        Log::useFiles(storage_path() . '/logs/reademailstickets-' . $CronJobID . '-' . date('Y-m-d') . '.log');
        try
		{
			$Ticketgroups 	=	TicketGroups::where(array("GroupEmailStatus"=>1))->get(); 
			foreach ($Ticketgroups as $TicketgroupData) { 
				if(!empty($TicketgroupData->GroupEmailAddress) && !empty($TicketgroupData->GroupEmailServer) && !empty($TicketgroupData->GroupEmailPassword) && $TicketgroupData->GroupEmailStatus==1 ){							
					
						$connection =  imap::CheckConnection($TicketgroupData->GroupEmailServer,$TicketgroupData->GroupEmailAddress,$TicketgroupData->GroupEmailPassword); 
						if($connection['status']==0){
							throw new Exception($connection['error']);
						}						
						$imap = new Imap(array('email'=>$TicketgroupData->GroupEmailAddress,"server"=>$TicketgroupData->GroupEmailServer,"password"=>$TicketgroupData->GroupEmailPassword));
						
					 	$imap->ReadTicketEmails($CompanyID,$TicketgroupData->GroupEmailServer,$TicketgroupData->GroupEmailAddress,$TicketgroupData->GroupEmailPassword,$TicketgroupData->GroupID);	 
						$joblogdata['Message'] = 'Success';
						
					
				}    			
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
	 /////////////
    }
}