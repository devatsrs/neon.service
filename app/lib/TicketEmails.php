<?php 
namespace App\Lib;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Maatwebsite\Excel\Facades\Excel;
use App\Lib\User;
use App\Lib\Integration;
use App\Lib\AccountEmailLog;
use App\Lib\IntegrationConfiguration;
use App\Lib\Freshdesk;
use App\Lib\MandrilIntegration;
use App\Lib\TicketGroupAgents;
use App\Lib\CompanyConfiguration;
use Illuminate\Support\Facades\Log;

class TicketEmails{ 

	protected $TriggerTypes;
	protected $Agent;
	protected $Group;
	protected $EscalationAgent;
	protected $EmailFrom;
	protected $Client;
	protected $TicketID;
	protected $TicketData;
	protected $EmailTemplate;
	protected $CompanyID;
	protected $slug;
	protected $Error;
	protected $Comment;
	protected $NoteUser;
	protected $RespondTime;
	protected $ResolveTime;
	

	 public function __construct($data = array()){

		 if(!empty($data)) {

			 foreach ($data as $key => $value) {
				 $this->$key = $value;
			 }
			 $this->TriggerEmail();

		 }
	 }
	 
	 public function TriggerEmail(){
		try
		{
			$this->TicketData	  	=  		TicketsTable::find($this->TicketID);	 				
			if(is_array($this->TriggerType))
			{
				foreach($this->TriggerType as $TriggerType){
					if(method_exists($this,TicketEmails::$TriggerType())){						
						$this->$TriggerType();
					}
					
				}
			}else{
				if(method_exists($this,$this->TriggerType)){
					$method = $this->TriggerType;
					$this->$method();
				}
			}
			
		}
		catch(\Exception $ex)
		{
			Log::error("could not Trigger");
			Log::error($ex);		
			throw $ex;
		}
	 }	
	 
	protected function ReplaceArray($Ticketdata){
        $replace_array = array();
		if(isset($Ticketdata) && !empty($Ticketdata)){			
			$replace_array['Subject'] 			 = 		$Ticketdata->Subject;
			$replace_array['TicketID'] 			 = 		$Ticketdata->TicketID;
			$replace_array['Requester'] 		 = 		$Ticketdata->Requester;
			//$replace_array['RequesterName'] 	 = 		$Ticketdata->RequesterName;
			if($Ticketdata->AccountID){
				$replace_array['RequesterName'] 	 = 		Account::where(["AccountID"=>$Ticketdata->AccountID])->pluck("AccountName");
			}
			else if($Ticketdata->ContactID){
				$contactData						 =		Contact::where("ContactID",$Ticketdata->ContactID)->select(['FirstName','LastName'])->first();
				$replace_array['RequesterName'] 	 = 	    $contactData->FirstName." ".$contactData->LastName;
			}
			else if($Ticketdata->UserID){
				$UserData						 	 =		User::where("UserID",$Ticketdata->UserID)->select(['FirstName','LastName'])->first();
				$replace_array['RequesterName'] 	 = 	    $UserData->FirstName." ".$UserData->LastName;
			}else{
				$replace_array['RequesterName'] 	 = 		$Ticketdata->RequesterName;	
			}
			$replace_array['Status'] 			 = 		isset($Ticketdata->Status)?TicketsTable::getTicketStatusByID($Ticketdata->Status):TicketsTable::getDefaultStatus();
			$replace_array['Priority']	 		 = 		TicketPriority::getPriorityStatusByID($Ticketdata->Priority);
			$replace_array['Description'] 	 	 = 		$Ticketdata->Description;
			$replace_array['Group'] 			 = 		isset($Ticketdata->Group)?TicketGroups::where(['GroupID'=>$Ticketdata->Group])->pluck("GroupName"):'';
			$replace_array['Type'] 				 = 		isset($Ticketdata->Type)?TicketsTable::getTicketTypeByID($Ticketdata->Type):'';
			$replace_array['Date']				 = 		$Ticketdata->created_at;
			//$replace_array['helpdesk_name']		 = 		isset($Ticketdata->Group)?TicketGroups::where(['GroupID'=>$Ticketdata->Group])->pluck("GroupName"):'';
			if(isset($this->Comment)) {
				$replace_array['Comment']			 =		$this->Comment;
			}
			if(isset($this->NoteUser)) {
				$replace_array['NoteUser']			 =		$this->NoteUser;
			}
		}
        return $replace_array;
    }	
	
	protected function template_var_replace($EmailMessage,$replace_array){
		
		$replace_array 	=	$this->SetBasicFields($replace_array);
		
		$extra = [
			'{{Subject}}',
			'{{TicketID}}',
			'{{Requester}}',
			'{{RequesterName}}',
			'{{Status}}',
			'{{Priority}}',
			'{{Description}}',
			'{{Group}}',
			'{{Type}}',
			'{{Date}}',
			'{{Signature}}',
			'{{AgentName}}',
			'{{AgentEmail}}',
			'{{Notebody}}',
			'{{NoteUser}}',
			'{{Comment}}',
			'{{CompanyName}}',
			"{{CompanyVAT}}",
			"{{CompanyAddress1}}",
			"{{CompanyAddress2}}",
			"{{CompanyAddress3}}",
			"{{CompanyCity}}",
			"{{CompanyPostCode}}",
			"{{CompanyCountry}}",
			"{{TicketCustomerUrl}}",
			"{{TicketUrl}}",
			"{{helpdesk_name}}"
		];
	
		foreach($extra as $item){
			$item_name = str_replace(array('{','}'),array('',''),$item);
			if(array_key_exists($item_name,$replace_array)) {
				$EmailMessage = str_replace($item,$replace_array[$item_name],$EmailMessage);
			}
		}
		return $EmailMessage;
	} 
	
	protected function SetBasicFields($array){
			$array_data									=		array();
			$CompanyData								=		Company::find($this->CompanyID);
			$array_data['CompanyName']					=   	$CompanyData->CompanyName;
			$array_data['CompanyVAT']					=   	$CompanyData->VAT;			
			$array_data['CompanyAddress1']				=   	$CompanyData->Address1;
			$array_data['CompanyAddress2']				=   	$CompanyData->Address1;
			$array_data['CompanyAddress3']				=   	$CompanyData->Address1;
			$array_data['CompanyCity']					=   	$CompanyData->City;
			$array_data['CompanyPostCode']				=   	$CompanyData->PostCode;
			$array_data['CompanyCountry']				=   	$CompanyData->Country;
			$site_url 									= 		CompanyConfiguration::getValueConfigurationByKey($this->CompanyID,'WEB_URL');
			$array_data['TicketUrl']					=   	$site_url."/tickets/".$this->TicketID."/detail";	
			$array_data['TicketCustomerUrl']			=   	$site_url."/customer/tickets/".$this->TicketID."/detail";
			$array_data['Group']						=   	$this->Group->GroupName;
			$array_data['AgentName']					=   	isset($this->Agent->FirstName)?$this->Agent->FirstName.' '.$this->Agent->LastName:'';
			$array_data['AgentEmail']					=   	isset($this->Agent->EmailAddress)?$this->Agent->EmailAddress:'';	
			$array_data['helpdesk_name']				= 		$this->Group->GroupName;
						 		
			return array_merge($array_data,$array);
	}
	
	protected function  RequesterNewTicketCreated(){
		$this->slug					=		"RequesterNewTicketCreated";
		if(!$this->CheckBasicRequirments())
		{
			throw new \Exception($this->Error);
		}
		if(!$this->EmailTemplate->Status) {
			return;
		}
		$Requester = explode(",",$this->TicketData->Requester);
		$Requester = self::remove_group_emails_from_array($this->CompanyID,$Requester);

		$replace_array				= 		$this->ReplaceArray($this->TicketData); 
		$finalBody 					= 		$this->template_var_replace($this->EmailTemplate->TemplateBody,$replace_array);
		$finalSubject				= 		$this->template_var_replace($this->EmailTemplate->Subject,$replace_array);	
		$emailData['Subject']		=		$finalSubject;
		$emailData['Message'] 		= 		$finalBody;
		$emailData['CompanyID'] 	= 		$this->CompanyID;
		$emailData['EmailTo'] 		= 		$Requester;
		$emailData['EmailFrom'] 	= 		$this->Group->GroupReplyAddress;
		$emailData['CompanyName'] 	= 		$this->Group->GroupName;
		$emailData['In-Reply-To'] 	= 		AccountEmailLog::getLastMessageIDByTicketID($this->TicketID);
		$emailData['TicketID'] 		= 		$this->TicketID;
		$emailData['Auto-Submitted']= 		"auto-generated";
		$emailData['Message-ID']	= 		$this->TicketID;
		$status 					= 		Helper::sendMail($finalBody,$emailData,0);
	
		if($status['status']){
			Helper::email_log_data_Ticket($emailData,'',$status,$this->CompanyID);
		}else{
			$this->SetError($status['message']);
		}		
	}
	
	protected function RequesterRepliestoTicket(){
		
			$this->slug					=		"RequesterRepliestoTicket";
			if(!$this->CheckBasicRequirments())
			{
				throw new \Exception($this->Error);
			}
			if(!isset($this->Agent->EmailAddress)){

				Log::info("RequesterRepliestoTicket: Agent Email is blank");
				return false;
				//throw new \Exception("Agent Email is blank");
			}
			if(!$this->EmailTemplate->Status) {
				return;
			}
			
			
		 	$replace_array				= 		$this->ReplaceArray($this->TicketData);
		    $finalBody 					= 		$this->template_var_replace($this->EmailTemplate->TemplateBody,$replace_array);
			$finalSubject				= 		$this->template_var_replace($this->EmailTemplate->Subject,$replace_array);	
            $emailData['Subject']		=		$finalSubject;
            $emailData['Message'] 		= 		$finalBody;
            $emailData['CompanyID'] 	= 		$this->CompanyID;
			$emailData['EmailTo'] 		= 		$this->Agent->EmailAddress;
            $emailData['EmailFrom'] 	= 		$this->Group->GroupReplyAddress;
            $emailData['CompanyName'] 	= 		$this->Group->GroupName;
			$emailData['In-Reply-To'] 	= 		AccountEmailLog::getLastMessageIDByTicketID($this->TicketID);
			$emailData['Comment']		=		$this->Comment;
			$emailData['TicketID'] 		= 		$this->TicketID;
			$emailData['Auto-Submitted']= 		"auto-generated";
			$emailData['Message-ID']	= 		$this->TicketID;
			$status 					= 		Helper::sendMail($finalBody,$emailData,0);
			$emailData['UserID']		=		User::getUserIDByUserName($this->CompanyID,$this->TicketData->created_by);
			if($status['status']){
			//	Helper::email_log_data_Ticket($emailData,'',$status,$this->CompanyID);						
			}else{
				$this->SetError($status['message']);
			}			
	}
	
	protected function AgentAssignedGroup(){
			$this->slug					=		"AgentAssignedGroup";
			if(!$this->CheckBasicRequirments())
			{
				throw new \Exception($this->Error);
			}
			if(!$this->EmailTemplate->Status) {
				return;
			}			
			$account 					= 		Account::find($this->TicketData->AccountID);
			$this->EmailTemplate  		=		EmailTemplate::getSystemEmailTemplate($this->CompanyID, $this->slug, $account->LanguageID);
		 	$replace_array				= 		$this->ReplaceArray($this->TicketData);
		    $finalBody 					= 		$this->template_var_replace($this->EmailTemplate->TemplateBody,$replace_array);
			$finalSubject				= 		$this->template_var_replace($this->EmailTemplate->Subject,$replace_array);				
			$Groupagents 				= 		TicketGroupAgents::get_group_agents($this->TicketData->Group,0,'EmailAddress');
			$emailData['Subject']		=		$finalSubject;
            $emailData['Message'] 		= 		$finalBody;
            $emailData['CompanyID'] 	= 		$this->CompanyID;
            $emailData['EmailTo'] 		= 		$Groupagents;
            $emailData['EmailFrom'] 	= 		$this->Group->GroupReplyAddress;
            $emailData['CompanyName'] 	= 		$this->Group->GroupName;
			$emailData['In-Reply-To'] 	= 		AccountEmailLog::getLastMessageIDByTicketID($this->TicketID);
			$emailData['Auto-Submitted']= 		"auto-generated";
			$emailData['Message-ID']	= 		$this->TicketID;
			$status 					= 		Helper::sendMail($finalBody,$emailData,0);
			$emailData['TicketID'] 		= 		$this->TicketID;
			
			if($status['status']){
			//	Helper::email_log_data_Ticket($emailData,'',$status,$this->CompanyID);						
			}else{
				$this->SetError($status['message']);
			}			
	}
	
	protected function AgentTicketReopened(){		
			$this->slug					=		"AgentTicketReopened";
			if(!$this->CheckBasicRequirments())
			{
				throw new \Exception($this->Error);
			}
			if(!isset($this->Agent->EmailAddress)) {

				Log::info("AgentTicketReopened: Agent Email is blank");
				return false;
				//throw new \Exception("Agent Email is blank");
			}
			if(!$this->EmailTemplate->Status) {
				return;
			}

			$account 					= 		Account::find($this->TicketData->AccountID);
			$this->EmailTemplate  		=		EmailTemplate::getSystemEmailTemplate($this->CompanyID, $this->slug, $account->LanguageID);
		 	$replace_array				= 		$this->ReplaceArray($this->TicketData);
		    $finalBody 					= 		$this->template_var_replace($this->EmailTemplate->TemplateBody,$replace_array);
			$finalSubject				= 		$this->template_var_replace($this->EmailTemplate->Subject,$replace_array);				
			$emailData['Subject']		=		$finalSubject;
            $emailData['Message'] 		= 		$finalBody;
            $emailData['CompanyID'] 	= 		$this->CompanyID;
			$emailData['EmailTo'] 		= 		$this->Agent->EmailAddress;
            $emailData['EmailFrom'] 	= 		$this->Group->GroupReplyAddress;
            $emailData['CompanyName'] 	= 		$this->Group->GroupName;
			$emailData['In-Reply-To'] 	= 		AccountEmailLog::getLastMessageIDByTicketID($this->TicketID);
			$emailData['Message-ID']	= 		$this->TicketID;
			$status 					= 		Helper::sendMail($finalBody,$emailData,0);
			$emailData['TicketID'] 		= 		$this->TicketID;
			
			if($status['status']){
				//Helper::email_log_data_Ticket($emailData,'',$status,$this->CompanyID);						
			}else{
				$this->SetError($status['message']);
			}			
	}
	
	protected function AgentResponseSlaVoilation(){
			$this->slug					=		"AgentResponseSlaVoilation";
			$send 						=		0;
			$sendemails					=		'';
			if(!$this->CheckBasicRequirments())
			{
				throw new \Exception($this->Error);
			}	
			
			$RespondedVoilation			=	TicketSlaPolicyViolation::where(['TicketSlaID'=>$this->TicketData->TicketSlaID,"VoilationType"=>TicketSlaPolicyViolation::$RespondedVoilationType])->select(['Time','Value'])->first();
			
			if(count($RespondedVoilation) == 0 ) {
				return 0;
			}
			if($RespondedVoilation->Time=='immediately')
			{
				$send = 1;
			}else{
				$DateSend  = new \DateTime($this->RespondTime);
				$DateSend->modify('+'.$RespondedVoilation->Time);
				$SendDate  =  $DateSend->format('Y-m-d H:i');   
				if($SendDate<=date('y-m-d H:i')){
					$send =1;
				}
			}
			
			if(!$send)	{
				return 0;
			}
			
			$sendto						=	   $RespondedVoilation->Value; 
			if($RespondedVoilation->Value =='0'){
					$sendemails 		=	isset($this->Agent->EmailAddress)?$this->Agent->EmailAddress:'';
			}else{ 
				$sendids = explode(',',$RespondedVoilation->Value); 
				
				foreach($sendids as $agentsID){ 
					if($agentsID==0){

						if(isset($this->Agent->EmailAddress)){
							$sendemails[] =	$this->Agent->EmailAddress;
						} else {
							Log::info("No Email Address found . this->Agent->EmailAddress - ");
						}
						continue;
					}
					$userdata = 	User::find($agentsID);
					if($userdata){							
						$sendemails[] =	$userdata->EmailAddress; 
					}			
				} 
			}
			if(is_array($sendemails)){
				$sendemails= array_unique($sendemails);
			}



			if(count($sendemails) > 0 && $this->EmailTemplate->Status) {

				$sendemails = self::remove_group_emails_from_array($this->CompanyID,$sendemails);

				$account 					= 		Account::find($this->TicketData->AccountID);
				$this->EmailTemplate  		=		EmailTemplate::getSystemEmailTemplate($this->CompanyID, $this->slug, $account->LanguageID);
				$replace_array = $this->ReplaceArray($this->TicketData);
				$finalBody = $this->template_var_replace($this->EmailTemplate->TemplateBody, $replace_array);
				$finalSubject = $this->template_var_replace($this->EmailTemplate->Subject, $replace_array);
				$emailData['Subject'] = $finalSubject;
				$emailData['Message'] = $finalBody;
				$emailData['CompanyID'] = $this->CompanyID;
				$emailData['EmailTo'] = $sendemails;
				$emailData['EmailFrom'] = $this->Group->GroupReplyAddress;
				$emailData['CompanyName'] = $this->Group->GroupName;
				$emailData['In-Reply-To'] 	= 		AccountEmailLog::getLastMessageIDByTicketID($this->TicketID);
				$emailData['Message-ID']	= 		$this->TicketID;
				$status = Helper::sendMail($finalBody, $emailData, 0);
				$emailData['TicketID'] = $this->TicketID;

				if ($status['status']) {
					//Helper::email_log_data_Ticket($emailData,'',$status,$this->CompanyID);
					TicketsTable::where(["TicketID" => $this->TicketData->TicketID])->update(array("RespondSlaPolicyVoilationEmailStatus" => 1));
					return 1;
				} else {
					$this->SetError($status['message']);
				}
			}
	}
	
	protected function AgentResolveSlaVoilation()
	{		
			$this->slug					=		"AgentResolveSlaVoilation";
			$send 						=		0;
			$sendemails					=		'';
			$sendarray					=		array();
			
			if(!$this->CheckBasicRequirments())
			{
				throw new \Exception($this->Error);
			}
			if(!$this->EmailTemplate->Status) {
				return;
			}
			$ResolveVoilation			=	TicketSlaPolicyViolation::where(['TicketSlaID'=>$this->TicketData->TicketSlaID,"VoilationType"=>TicketSlaPolicyViolation::$ResolvedVoilationType])->select(['Time','Value'])->get();	
			
			//Log::info(print_r($ResolveVoilation,true));
			if(count($ResolveVoilation)<1){return 0;}
			
			foreach($ResolveVoilation as $key => $SingleResolveVoilationData)
			{
				if($SingleResolveVoilationData->Time=='immediately')
				{
					$send = 1;
					$sendarray[$key]['send'] =  1;
				}
				else
				{
					$DateSend  = new \DateTime($this->ResolveTime);
					$DateSend->modify('+'.$SingleResolveVoilationData->Time);
					$SendDate  =  $DateSend->format('Y-m-d H:i');   
					if($SendDate<=date('y-m-d H:i')){
						$sendarray[$key]['send'] =  1;
					}
				}				
				
				if(isset($sendarray[$key]['send']) && $sendarray[$key]['send']==1)
				{
					$sendto		=	   $SingleResolveVoilationData->Value; 
					if($SingleResolveVoilationData->Value =='0')
					{
							$sendemails 		=	isset($this->Agent->EmailAddress)?$this->Agent->EmailAddress:'';
					}
					else
					{ 
						$sendids = explode(',',$SingleResolveVoilationData->Value); 
						
						foreach($sendids as $agentsID){ 
							if($agentsID==0){
								$sendemails[] =	isset($this->Agent->EmailAddress)?$this->Agent->EmailAddress:'';	
								continue;
							}
							$userdata = 	User::find($agentsID);
							if($userdata){							
								$sendemails[] =	$userdata->EmailAddress; 
							}			
						} 
					}
				}
			}
				if(is_array($sendemails)){
					$sendemails= array_unique($sendemails);
				}



			if(count($sendemails)<1){return 0;}

			$sendemails = self::remove_group_emails_from_array($this->CompanyID,$sendemails);

			$account 					= 		Account::find($this->TicketData->AccountID);
			$this->EmailTemplate  		=		EmailTemplate::getSystemEmailTemplate($this->CompanyID, $this->slug, $account->LanguageID);
		 	$replace_array				= 		$this->ReplaceArray($this->TicketData);
		    $finalBody 					= 		$this->template_var_replace($this->EmailTemplate->TemplateBody,$replace_array);
			$finalSubject				= 		$this->template_var_replace($this->EmailTemplate->Subject,$replace_array);				
			$emailData['Subject']		=		$finalSubject;
            $emailData['Message'] 		= 		$finalBody;
            $emailData['CompanyID'] 	= 		$this->CompanyID;
            $emailData['EmailTo'] 		= 		$sendemails;
            $emailData['EmailFrom'] 	= 		$this->Group->GroupReplyAddress;
            $emailData['CompanyName'] 	= 		$this->Group->GroupName;
			$emailData['In-Reply-To'] 	= 		AccountEmailLog::getLastMessageIDByTicketID($this->TicketID);
			$emailData['Message-ID']	= 		$this->TicketID;
			$status 					= 		Helper::sendMail($finalBody,$emailData,0);
			$emailData['TicketID'] 		= 		$this->TicketID;
			
			if($status['status']){ 
				TicketsTable::where(["TicketID"=>$this->TicketData->TicketID])->update(array("ResolveSlaPolicyVoilationEmailStatus"=>1));
				return 1;
				//Helper::email_log_data_Ticket($emailData,'',$status,$this->CompanyID);						
			}else{ 
				$this->SetError($status['message']);
			}			
	}
	
	protected function AgentEscalationRule(){		
			
			$this->slug					=		"AgentEscalationRule";
			if(!$this->CheckBasicRequirments())
			{
				return $this->Error;
			}
			if(!$this->EmailTemplate->Status) {
				return;
			}
			$EscalationUser				=		User::find($this->EscalationAgent);
			$account 					= 		Account::find($this->TicketData->AccountID);
			$this->EmailTemplate  		=		EmailTemplate::getSystemEmailTemplate($this->CompanyID, $this->slug, $account->LanguageID);
		 	$replace_array				= 		$this->ReplaceArray($this->TicketData);
		    $finalBody 					= 		$this->template_var_replace($this->EmailTemplate->TemplateBody,$replace_array);
			$finalSubject				= 		$this->template_var_replace($this->EmailTemplate->Subject,$replace_array);				
			$emailData['Subject']		=		$finalSubject;
            $emailData['Message'] 		= 		$finalBody;
            $emailData['CompanyID'] 	= 		$this->CompanyID;
            $emailData['EmailTo'] 		= 		$EscalationUser->EmailAddress;
            $emailData['EmailFrom'] 	= 		$this->Group->GroupReplyAddress;
            $emailData['CompanyName'] 	= 		$this->Group->GroupName;
			$emailData['Message-ID']	= 		$this->TicketID;
			$status 					= 		Helper::sendMail($finalBody,$emailData,0);
			$emailData['TicketID'] 		= 		$this->TicketID;
			
			if($status['status']){
				//Helper::email_log_data_Ticket($emailData,'',$status,$this->CompanyID);						
			}else{
				$this->SetError($status['message']);
			}			
	}
	
	
	protected function SetError($error){
		$this->Error = $error;
	}
	public function GetError(){
		return $this->Error;
	}
	
	protected function CheckBasicRequirments(){

		if(!isset($this->TicketData->Agent)) {
			Log::info("No Agent Found");

		} else if(isset($this->TicketData->Agent) && $this->TicketData->Agent > 0 ) {
			$agent =  User::find($this->TicketData->Agent);
			if(!$agent) {
				Log::info("Invalid Agent");
			}
			$this->Agent = $agent;
		} else {
			Log::info("Incorrect Agent2");
		}

		if(!isset($this->EmailFrom) || empty($this->EmailFrom))
		{
			if(!isset($this->TicketData->Group))
			{
				Log::info("No group Found");
			}
			else
			{
				$group =  TicketGroups::find($this->TicketData->Group);
				if(!$group)
				{
					Log::info("Invalid Group");
				}
				$this->Group = $group;
			}
		}
		else
		{
			$group  = 	TicketGroups::where(["GroupEmailAddress"=>$this->EmailFrom])->first();
			if(!$group) {
				Log::info("Invalid Group");
			}
			$this->Group = $group;
		}
		$account 					= 		Account::find($this->TicketData->AccountID);
		$this->EmailTemplate  		=		EmailTemplate::getSystemEmailTemplate($this->CompanyID, $this->slug, $account->LanguageID);
		if(!$this->EmailTemplate){
			$this->SetError("No email template found.");
		}

		if(!$this->EmailTemplate->Status){
			Log::error("Email template is disabled");
			return true;
		}

		$this->TicketEmailData = AccountEmailLog::where(['TicketID'=>$this->TicketID])->orderBy('AccountEmailLogID', 'DESC')->first();

		if($this->GetError()){
			throw new \Exception($this->Error);
		}
		return true;
	}
	
	protected function CCNewTicketCreated(){
			
		$emailto					=		array();
		$this->slug					=		"CCNewTicketCreated";
		
		if(!$this->CheckBasicRequirments())
		{
			throw new \Exception($this->Error);
		} 
		if(isset($this->TicketData->RequesterCC) && !empty($this->TicketData->RequesterCC)){
			$emailto = explode(",",$this->TicketData->RequesterCC);
		}else{
			return;
		}	
		
		if (($key = array_search($this->TicketData->Requester, $emailto)) !== false){			
			    unset($emailto[$key]);
		}	
	/*
		if (($key = array_search($this->Group->GroupEmailAddress, $emailto)) !== false){
			    unset($emailto[$key]);
	 	}*/



		if(count($emailto)>0 && $this->EmailTemplate->Status){

			$emailto = self::remove_group_emails_from_array($this->CompanyID,$emailto);

			$replace_array				= 		$this->ReplaceArray($this->TicketData);
			$finalBody 					= 		$this->template_var_replace($this->EmailTemplate->TemplateBody,$replace_array);
			$finalSubject				= 		$this->template_var_replace($this->EmailTemplate->Subject,$replace_array);	
			$emailData['Subject']		=		$finalSubject;
			$emailData['Message'] 		= 		$finalBody;
			$emailData['CompanyID'] 	= 		$this->CompanyID;
			$emailData['EmailTo'] 		= 		$emailto;
			$emailData['EmailFrom'] 	= 		$this->Group->GroupReplyAddress;
			$emailData['CompanyName'] 	= 		$this->Group->GroupName;
			$emailData['In-Reply-To'] 	= 		AccountEmailLog::getLastMessageIDByTicketID($this->TicketID);
			$emailData['TicketID'] 		= 		$this->TicketID;
			$emailData['Auto-Submitted']= 		"auto-generated";
			$emailData['Message-ID']	= 		$this->TicketID;
			$status 					= 		Helper::sendMail($finalBody,$emailData,0);

			if($status['status']){
				Helper::email_log_data_Ticket($emailData,'',$status,$this->CompanyID);
			}else{
				$this->SetError($status['message']);
			}
		}	
	}
	
	protected function CCNoteaddedtoticket()
	{	
		$emailtoCc					=		array();
		$emailtoBcc					=		array();
		$emailtoCc2					=		array();
		$emailtoBcc2					=		array();
		//$emailto					=		array();
		$this->slug					=		"CCNoteaddedtoticket";
		
		if(!$this->CheckBasicRequirments())
		{
			throw new \Exception($this->Error);
		} 
		if(isset($this->TicketEmailData->Cc) && !empty($this->TicketEmailData->Cc)){
			$emailtoCc = explode(",",$this->TicketEmailData->Cc);
		}
		if(isset($this->TicketEmailData->Bcc) && !empty($this->TicketEmailData->Bcc)){
			$emailtoBcc = explode(",",$this->TicketEmailData->Bcc);
		}

		if(isset($this->TicketData->RequesterCC) && !empty($this->TicketData->RequesterCC)){
			$emailtoCc2 = explode(",",$this->TicketData->RequesterCC);
		}
		if(isset($this->TicketData->Bcc) && !empty($this->TicketData->Bcc)){
			$emailtoBcc2 = explode(",",$this->TicketData->Bcc);
		}


		$emailto =   array_merge($emailtoCc,$emailtoBcc,$emailtoCc2,$emailtoBcc2);

		//exclude email address who commented on email.
		if(isset($this->TicketEmailData->Emailfrom) && !empty($this->TicketEmailData->Emailfrom)){
			$emailto =   array_diff($emailto,[$this->TicketEmailData->Emailfrom]);
		}



		if(count($emailto)>0 && $this->EmailTemplate->Status){

			$emailto = self::remove_group_emails_from_array($this->CompanyID,$emailto);

			$replace_array				= 		$this->ReplaceArray($this->TicketData);
			$finalBody 					= 		$this->template_var_replace($this->EmailTemplate->TemplateBody,$replace_array);
			$finalSubject				= 		$this->template_var_replace($this->EmailTemplate->Subject,$replace_array);	
			$emailData['Subject']		=		$finalSubject;
			$emailData['Message'] 		= 		$finalBody;
			$emailData['CompanyID'] 	= 		$this->CompanyID;
			$emailData['EmailTo'] 		= 		$emailto;
			$emailData['EmailFrom'] 	= 		$this->Group->GroupReplyAddress;
			$emailData['CompanyName'] 	= 		$this->Group->GroupName;
			$emailData['In-Reply-To'] 	= 		AccountEmailLog::getLastMessageIDByTicketID($this->TicketID);
			$emailData['TicketID'] 		= 		$this->TicketID;
			$emailData['Comment'] 		= 		$this->Comment;
			$emailData['NoteUser'] 		= 		$this->NoteUser;
			$emailData['Message-ID']	= 		$this->TicketID;
			$status 					= 		Helper::sendMail($finalBody,$emailData,0);

			if($status['status']){
				Helper::email_log_data_Ticket($emailData,'',$status,$this->CompanyID);
			}else{
				$this->SetError($status['message']);
			}
		}
	}

	public static function remove_group_emails_from_array($CompanyID,$email_array = array()) {


		$GroupEmailAddress 	=	TicketGroups::where(array("CompanyID"=>$CompanyID,"GroupEmailStatus"=>1))->get(["GroupReplyAddress", "GroupEmailAddress"])->toArray();

		$group_emails = [];
		foreach($GroupEmailAddress as $GEmailAddress){
			$group_emails[]  = $GEmailAddress["GroupEmailAddress"];
			$group_emails[]  = $GEmailAddress["GroupReplyAddress"];
		}


		//$GroupEmailAddress 	=	TicketGroups::get(["GroupEmailAddress"])->lists('GroupEmailAddress');

		return array_diff((array) $email_array,$group_emails);

	}

	/** This is system generated email.
	 * for repeated email block
	 * system will block repeated email address who is frequently sending email to group email address.
	 */
	protected function RepeatedEmailBlockEmail() {

		$this->slug						=		"RepeatedEmailBlockEmail";

		$EmailSubject 					= 		'System has block repeated email';

		$site_url 						= 		CompanyConfiguration::getValueConfigurationByKey($this->CompanyID,'WEB_URL');
		$ImportRuleUrl					=   	$site_url."/tickets/importrules/";


		$Group = TicketGroups::find($this->GroupID);

		$emailData['Subject']				=		$EmailSubject;
		$emailData['CompanyID'] 			= 		$this->CompanyID;
		$emailData['EmailTo'] 				= 		$Group->GroupReplyAddress;
		$emailData['EmailFrom'] 			= 		$Group->GroupReplyAddress;
		$emailData['CompanyName'] 			= 		$Group->GroupName;
		$emailData['BlockedEmailAddress'] 	= 		$this->EmailToBlock;
		$emailData['ImportRuleUrl'] 		= 		$ImportRuleUrl;
		//$emailData['Message-ID']			= 		$this->TicketID;
		$status 							= 		Helper::sendMail('emails.ticket_repeated_email_block_email',$emailData);

		if(!$status['status']) {
			Log::error("RepeatedEmailBlockEmail: Error sending email");
		}
	}
}
?>