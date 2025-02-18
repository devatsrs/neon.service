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
use App\Lib\TicketEmails;
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
		
		$joblogdata = array();
        $joblogdata['CronJobID'] = $CronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';
        try
		{
			$Ticketgroups 	=	TicketGroups::where(array("CompanyID"=>$CompanyID, "GroupEmailStatus"=>1))->get();
			foreach ($Ticketgroups as $TicketgroupData) { 
				if(!empty($TicketgroupData->GroupEmailAddress) && !empty($TicketgroupData->GroupEmailServer) && !empty($TicketgroupData->GroupEmailPassword) && $TicketgroupData->GroupEmailStatus==1 ){							
					
						/*$connection =  imap::CheckConnection($TicketgroupData->GroupEmailServer,$TicketgroupData->GroupEmailAddress,$TicketgroupData->GroupEmailPassword);
						if($connection['status']==0){
							throw new Exception($connection['error']);
						}*/
						$imap = new Imap(array('email'=>$TicketgroupData->GroupEmailAddress,"server"=>$TicketgroupData->GroupEmailServer,"password"=>$TicketgroupData->GroupEmailPassword));

					 	$imap->ReadTicketEmails($CompanyID,$TicketgroupData->GroupEmailServer,$TicketgroupData->GroupEmailPort,$TicketgroupData->GroupEmailIsSSL,$TicketgroupData->GroupEmailAddress,$TicketgroupData->GroupEmailPassword,$TicketgroupData->GroupID);
						$joblogdata['Message'] = 'Success';
						$this->CheckEscalationRule($TicketgroupData,$CompanyID);

				}    			
			}
			$this->TicketSlaPolicyViolationEmailSend($CompanyID);

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
	
	function CheckEscalationRule($GroupData,$CompanyID){
		
			$GroupAssignTime    =	 $GroupData->GroupAssignTime; 
			$GroupAssignEmail   = 	 $GroupData->GroupAssignEmail;	 
			$GroupID 			=	 $GroupData->GroupID;	
			$minutes			=	 $GroupAssignTime/60; 
			$datetime_from 		=    date("Y-m-d H:i:s", strtotime("-".$minutes." minutes"));	
			$closeStatus=TicketsTable::getClosedTicketStatus();
			if($GroupAssignEmail){		
				$Tickets 			= 	TicketsTable::select(['TicketID'])->where(["CompanyID"=>$CompanyID,"Group"=>$GroupID])->where("Status", "!=", $closeStatus)->where(["Agent"=>0])->where(['EscalationEmail'=>0])->WhereRaw('created_at <= "'.$datetime_from.'"')->get();
				 Log::error("**Escalation check for " .$GroupData->GroupName);
				 Log::error("**Escalation Tickets:".count($Tickets)."Found");
				foreach($Tickets as $TicketsData){
					
						new TicketEmails(array("TicketID"=>$TicketsData->TicketID,"TriggerType"=>"AgentEscalationRule","CompanyID"=>$CompanyID,"EscalationAgent"=>$GroupAssignEmail));
						TicketsTable::where(["TicketID"=>$TicketsData->TicketID])->update(array("EscalationEmail"=>1));						
				}
			}
	}
	
	function TicketSlaPolicyViolationEmailSend($CompanyID)
	{		
			
		$CurrentTime			=	 date('Y-m-d H:i');
		$query 					= 	 "call prc_CheckTicketsSlaVoilation ('".$CompanyID."','".$CurrentTime."')";  
		$tickets 				= 	 DB::select($query);
		foreach ($tickets as $ticket)
		{
			if($ticket->EscalationEmail==1 && $ticket->IsRespondedVoilation==1){

					new	TicketEmails(array("TicketID"=>$ticket->TicketID,"CompanyID"=>$CompanyID,"RespondTime"=>$ticket->RespondTime,"TriggerType"=>"AgentResponseSlaVoilation"));
			}
			
			if($ticket->EscalationEmail==1 && $ticket->IsResolvedVoilation==1){
				new	TicketEmails(array("TicketID"=>$ticket->TicketID,"CompanyID"=>$CompanyID,"ResolveTime"=>$ticket->ResolveTime,"TriggerType"=>"AgentResolveSlaVoilation"));
			}						
		}		
	}
}