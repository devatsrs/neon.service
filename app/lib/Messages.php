<?php
namespace App\Lib;
use Validator;

class Messages extends \Eloquent{

    protected $fillable 	= 	['PID'];
    protected $table 		= 	"tblMessages";
    protected $primaryKey 	= 	"MsgID";
    public 	  $timestamps 	= 	false; // no created_at and updated_at

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
}