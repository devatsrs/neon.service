<?php
namespace App\Lib;
use Validator;
use Illuminate\Support\Facades\DB;

class Messages extends \Eloquent{

    protected $fillable 	= 	['PID'];
    protected $table 		= 	"tblMessages";
    protected $primaryKey 	= 	"MsgID";
    public 	  $timestamps 	= 	false; // no created_at and updated_at
	
	const  Sent 	= 	0;
    const  Received	=   1;
    const  Draft 	= 	2;	
	const  URGENT	=	4;
	const  LOW		=	1;
	const  MEDIUM	=	2;
	const  HIGH		=	3;
	
	const  UserTypeAccount	= 	0;
    const  UserTypeContact	=   1;
	
	public static $EmailPriority = [	   	
	   1 => Messages::URGENT,	    
	   5 => Messages::LOW,
   ];

    public static function logMsgRecord($options = "") {
		              
		$rules = array(
			'CompanyID' => 'required',                
			'Title' => 'required',
		);

		$CompanyID 					= 	$options["CompanyID"];
		$options["CompanyID"] 		= 	$CompanyID;
		$data["CompanyID"] 			= 	$CompanyID;
		$data["AccountID"] 			= 	$options["AccountID"];
		$data["MsgLoggedUserID"] 	= 	$options["MsgLoggedUserID"];
		$data["Title"] 				= 	$options["Title"] ;
		$data["Description"] 		= 	$options["Description"];
        $data["MatchType"] 		    = 	$options["MatchType"];
        $data["MatchID"] 		    = 	$options["MatchID"];
		$data["EmailID"] 		    = 	$options["EmailID"];		
		$data["updated_at"] 		= 	date('Y-m-d H:i:s');


		$validator 					= 	Validator::make($data, $rules);
		if ($validator->fails()) {
			return validator_response($validator);
		}

		if ($JobID = Messages::insertGetId($data)) {                   
				return array("status" => "success", "message" => "Job Logged Successfully");
		} else {
			   return array("status" => "failed", "message" => "Problem Inserting Job.");
		}
    }

    public static function getMsgDropDown($reset = 0){
        $companyID = User::get_companyID();
        $userID = User::get_userID();
        $isAdmin = (User::is_admin() || User::is('RateManager'))?1:0;
        $query = "Call prc_getMsgsDropdown (".$companyID.",".$userID.",".$isAdmin .",".$reset.")" ;
        $dropdownData = DataTableSql::of($query)->getProcResult(array('jobs','totalNonVisitedJobs'));
        return $dropdownData;

    }
	
	public static function GetAllSystemEmails($lead=1)
	{
		 $array 		 =  [];
		
		 if($lead==0)
		 {
			$AccountSearch   =  DB::table('tblAccount')->where(['AccountType'=>1])->whereRaw('Email !=""')->get(array("Email","BillingEmail"));
		 }
		 else
		 {
			$AccountSearch   =  DB::table('tblAccount')->whereRaw('Email !=""')->get(array("Email","BillingEmail"));
		 }
		 
		 $ContactSearch 	 =  DB::table('tblContact')->get(array("Email"));	
		
		if(count($AccountSearch)>0){
				foreach($AccountSearch as $AccountData){
					//if($AccountData->Email!='' && !in_array($AccountData->Email,$array))
					if($AccountData->Email!='')
					{
						if(!is_array($AccountData->Email))
						{				  
						  $email_addresses = explode(",",$AccountData->Email);				
						}
						else
						{
						  $email_addresses = $emails;
						}
						if(count($email_addresses)>0)
						{
							foreach($email_addresses as $email_addresses_data)
							{
								if(!in_array($email_addresses_data,$array))
								{
									$array[] =  $email_addresses_data;	
								}
							}
						}
						
					}			
					
					if($AccountData->BillingEmail!='')
					{
						if(!is_array($AccountData->BillingEmail))
						{				  
						  $email_addresses = explode(",",$AccountData->BillingEmail);				
						}
						else
						{
						  $email_addresses = $emails;
						}
						if(count($email_addresses)>0)
						{
							foreach($email_addresses as $email_addresses_data)
							{
								if(!in_array($email_addresses_data,$array))
								{
									$array[] =  $email_addresses_data;	
								}
							}
						}
						
					}
				}
		}
		
		if(count($ContactSearch)>0){
				foreach($ContactSearch as $ContactData){
					if($ContactData->Email!=''  && !in_array($ContactData->Email,$array))
					{
						$array[] =  $ContactData->Email;
					}
				}
		}
		
		//return  array_filter(array_unique($array));
		return $array;
    }
}