<?php
namespace App\Lib;
use Illuminate\Support\Facades\DB;

class LastPrefixNo extends \Eloquent {

	protected $fillable = [];

    public $timestamps = false; // no created_at and updated_at

	protected $table = "tblLastPrefixNo";

	protected  $primaryKey = "LastPrefixNoID";

	public static function getLastPrefix($CompanyID){


       //Get Last Prefix No. if Prefix is null.
        $LastPrefixNo2 = 0;
        $LastPrefixNo = LastPrefixNo::where(["CompanyID"=> $CompanyID])->first();
        if(count($LastPrefixNo) == 0){
            $company = Company::find($CompanyID);
            if($company->CustomerAccountPrefix == ''){
                $LastPrefixNo = DB::table('tblGlobalSetting')->where(["Key" => 'Default_Customer_Trunk_Prefix'])->first();
                $company->CustomerAccountPrefix = $LastPrefixNo->Value;
                $company->save();
            }else{
                LastPrefixNo::insert(array('CompanyID' => $CompanyID, 'LastPrefixNo' => $company->CustomerAccountPrefix));
                return $LastPrefixNo2 = $company->CustomerAccountPrefix;
            }
            if(count($LastPrefixNo)>0){
                LastPrefixNo::insert(array('CompanyID' => $CompanyID, 'LastPrefixNo' => $LastPrefixNo->Value));
                return $LastPrefixNo2 =  $LastPrefixNo->Value;
            }
        }
        if(count($LastPrefixNo) > 0 && isset($LastPrefixNo->LastPrefixNo)){
            $LastPrefixNo2 = $LastPrefixNo->LastPrefixNo;
            $LastPrefixNo2++;
        }
        while(CustomerTrunk::where(["CompanyID"=> $CompanyID,'Prefix'=>$LastPrefixNo2])->count() >=1){
            $LastPrefixNo2++;
        }
       	return $LastPrefixNo2;

	}

	//Increament Last PRefix No
	public static function incrementLastPrefix($CompanyID){

       //Get Last Prefix No. if Prefix is null.
       LastPrefixNo::where(["CompanyID"=> $CompanyID])->increment('LastPrefixNo');

	}

	//Update Last PRefix No
	public static function updateLastPrefixNo($value,$CompanyID){

       LastPrefixNo::where(["CompanyID"=> $CompanyID])->update(['LastPrefixNo'=>$value]);

	}
}