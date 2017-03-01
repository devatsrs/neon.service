<?php 
namespace App\Lib;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Maatwebsite\Excel\Facades\Excel;
use App\Lib\User;
use App\Lib\Integration;
use App\Lib\IntegrationConfiguration;
use App\Lib\Freshdesk;
use App\Lib\MandrilIntegration;
use Illuminate\Support\Facades\Log;

class SiteIntegration{ 

 protected $support;
 protected $companyID;
 protected $TrackingEmail;
 static    $SupportSlug			=	'support';
 protected $PaymentSlug			=	'payment';
 static    $EmailSlug			=	'email';
 static    $StorageSlug			=	'storage';
 static    $AccountingSlug		=	'accounting';
 static    $AmazoneSlug			=	'amazons3';
 static    $AuthorizeSlug		=	'authorizenet';
 static    $GatewaySlug			=	'billinggateway';
 static    $freshdeskSlug		=	'freshdesk';
 static    $mandrillSlug		=	'mandrill';
 static    $emailtrackingSlug   =   'emailtracking';
 static    $imapSlug      		=   'imap';
 static    $QuickBookSlug		=	'quickbook';
 
 	public function __construct(){
	
		//$this->companyID = 	User::get_companyID();
	 } 
	 
	 /*
	 * Get support settings return current active support
	 */

	public function SetSupportSettings($CompanyID){
		
		if(self::CheckIntegrationConfiguration(false,self::$freshdeskSlug,$CompanyID)){		
			$configuration 		=   self::CheckIntegrationConfiguration(true,self::$freshdeskSlug,$CompanyID);
			$data 				= 	array("domain"=>$configuration->FreshdeskDomain,"email"=>$configuration->FreshdeskEmail,"password"=>$configuration->FreshdeskPassword,"key"=>$configuration->Freshdeskkey);			
			$this->support = new Freshdesk($data);
		}		
	}
	
	/*
	 * Get support contacts from active support
	 */
	
	public function GetSupportContacts($options = array()){
        if($this->support){
            return $this->support->GetContacts($options);
        }
        return false;
    }
	
	/*
	 * Get support tickets from active support
	 */
	
	public function GetSupportTickets($options = array()){
        if($this->support){
            return $this->support->GetTickets($options);
        }
        return false;
    }
	
	/*
	 * Get support tickets conversation from active support
	 */	

	public function GetSupportTicketConversations($id){
        if($this->support){
            return $this->support->GetTicketConversations($id);
        }
        return false;
    }

	/*
	 * send mail . check active mail settings 
	 */
	
	public static function SendMail($view,$data,$companyID,$Body){
		$config = self::CheckCategoryConfiguration(true,self::$EmailSlug,$companyID);
		switch ($config->Slug){
			case SiteIntegration::$mandrillSlug:
       		return MandrilIntegration::SendMail($view,$data,$config,$companyID,$Body);
      	  break;
		}	
	}	
	
	/*
	 * check the connection of tracking mail . return true false
	 */
	
	public function ConnectActiveEmail($CompanyID){
		$config = self::CheckCategoryConfiguration(true,SiteIntegration::$emailtrackingSlug,$CompanyID);
		
		switch ($config->Slug){
			case  SiteIntegration::$imapSlug:
			 $config = SiteIntegration::CheckIntegrationConfiguration(true,SiteIntegration::$imapSlug,$CompanyID);			
       		 $status = Imap::CheckConnection($config->EmailTrackingServer,$config->EmailTrackingEmail,$config->EmailTrackingPassword);
			 
			 if($status['status']==1){
			 		$this->TrackingEmail = new Imap(array('email'=>$config->EmailTrackingEmail,"server"=>$config->EmailTrackingServer,"password"=>$config->EmailTrackingPassword)); 
					return true;
			}else{			
					Log::error("could not connect");
					Log::error($status['error']);	
			}
			 
      	  break;
		}	
	}
	
	/*
		connect to mail server and read its mails
	*/
	
	public function ReadEmails($CompanyID){
		if(isset($this->TrackingEmail)){
            return $this->TrackingEmail->ReadEmails($CompanyID);
        }
        return false;
	}
	
	/*
	 * check settings addded or not . return true,data or false
	 */ 
	
	public static function  CheckIntegrationConfiguration($data=false,$slug,$CompanyID){
		$Integration	 	 =	Integration::where(["CompanyID" => $CompanyID,"Slug"=>$slug])->first();	
		
		if(count($Integration)>0)
		{						
			$IntegrationSubcategory = Integration::select("*");
			$IntegrationSubcategory->join('tblIntegrationConfiguration', function($join)
			{
				$join->on('tblIntegrationConfiguration.IntegrationID', '=', 'tblIntegration.IntegrationID');
	
			})->where(["tblIntegration.CompanyID"=>$CompanyID])->where(["tblIntegration.IntegrationID"=>$Integration->IntegrationID])->where(["tblIntegrationConfiguration.Status"=>1]);
			 $result = $IntegrationSubcategory->first(); 
			
			 if(count($result)>0)
			 { 
				 $IntegrationData =  isset($result->Settings)?json_decode($result->Settings):array();
				 if(count($IntegrationData)>0){
					 if($data ==true){
						return $IntegrationData;
					 }else{
						return true;
					 }
				 }
			 }
		}
		return false;		
	}
	
		/*
	check main category have data or not
	*/
	public static function  CheckCategoryConfiguration($data=false,$slug,$companyID){
		$Integration	 =	Integration::where(["CompanyId" => $companyID,"Slug"=>$slug])->first();	
		if(count($Integration)>0)
		{						 
			$IntegrationSubcategory = Integration::select("*");
			$IntegrationSubcategory->join('tblIntegrationConfiguration', function($join)
			{
				$join->on('tblIntegrationConfiguration.IntegrationID', '=', 'tblIntegration.IntegrationID');
	
			})->where(["tblIntegration.CompanyID"=>$companyID])->where(["tblIntegrationConfiguration.ParentIntegrationID"=>$Integration->IntegrationID])->where(["tblIntegrationConfiguration.Status"=>1]);
			 $result = $IntegrationSubcategory->first();
			 if(count($result)>0)
			 {	
				 $IntegrationData =  isset($result->Settings)?json_decode($result->Settings):array();
				 if(count($IntegrationData)>0){
					 if($data ==true){
						return $result;
					 }else{
						return true;
					 }
				 }
			 }
		}
		return false;		
	}	
}
?>