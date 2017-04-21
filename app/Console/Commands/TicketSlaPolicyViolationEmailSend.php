<?php namespace App\Console\Commands;

use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\Helper;
use App\Lib\User;
use App\Lib\TicketSla;
use App\Lib\TicketsTable;
use App\Lib\Company;
use App\Lib\JobStatus;
use App\Lib\SiteIntegration;
use App\Lib\Imap;
use App\Lib\TicketEmails;
use Symfony\Component\Console\Input\InputArgument;
use Carbon\Carbon;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Config;
use App\Lib\Job;
use App\Lib\TicketfieldsValues;
use App\Lib\JobType;
use Webpatser\Uuid\Uuid;
use \Exception;

class TicketSlaPolicyViolationEmailSend extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'ticketslapolicyviolationemailsend';

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
		CronHelper::beforecronrun($this->name, $this );

		$arguments 		= 	$this->argument();
		$CompanyID 		= 	$arguments["CompanyID"];
 		Company::setup_timezone($CompanyID);
		
        CronHelper::before_cronrun($this->name, $this );
	    $CronJob 		= 	CronJob::find($CronJobID);
        $cronsetting 	= 	json_decode($CronJob->Settings,true);
		$today 	    	= 	date('Y-m-d');
        CronJob::activateCronJob($CronJob);
        CronJob::createLog($CronJobID);
        Log::useFiles(storage_path() . '/logs/ticketslapolicyviolationemailsend-' . $CronJobID . '-' . date('Y-m-d') . '.log');
		
		$joblogdata = array();
        $joblogdata['CronJobID'] = $CronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';		
		try
		{	
			$CurrentTime			=	 date('Y-m-d H:i');
			$query 					= 	 "call prc_CheckTicketsSlaVoilation ('".$CompanyID."','".$CurrentTime."')";  
			$tickets 				= 	 DB::select($query);
			foreach ($tickets as $ticket)
			{
				if($ticket->EscalationEmail==1 && $ticket->IsRespondedVoilation==1){
				$send = new	TicketEmails(array("TicketID"=>$ticket->TicketID,"CompanyID"=>$CompanyID,"RespondTime"=>$ticket->RespondTime,"TriggerType"=>array("AgentResponseSlaVoilation")));					
				}
				
				if($ticket->EscalationEmail==1 && $ticket->IsResolvedVoilation==1){
			 	$send = new	TicketEmails(array("TicketID"=>$ticket->TicketID,"CompanyID"=>$CompanyID,"ResolveTime"=>$ticket->ResolveTime,"TriggerType"=>array("AgentResolveSlaVoilation")));					
				}
				
				// Call function check voilation reponse
				// resolved time with created_at of ticket time //ticket id,get creation date sla id, check voilation policy, compare apply to this,
				//return true or false if email sent or not- CheckTicketSlapolicyVoilation //template for resolve and responsed
				// if time is greate
				
				// then email to agent or selected user or email
				
				
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
