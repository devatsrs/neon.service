<?php
namespace App\Lib;

use Illuminate\Support\Facades\Config;

class Company extends \Eloquent {
	protected $fillable = [];
    protected $guarded = array('CompanyID');
    protected $table = 'tblCompany';
    protected  $primaryKey = "CompanyID";

    const BILLING_STARTTIME = 1;
    const BILLING_ENDTIME = 2;
    const BILLING_SETUPTIME = 3;

    public static $billing_time = array(''=>'select a time',self::BILLING_STARTTIME=>'Start Time',self::BILLING_ENDTIME=>'End Time',self::BILLING_SETUPTIME=>'Setup Time');
    // CDR Rerate Based on Charge code or Prefix
    const CHARGECODE =1;
    const PREFIX =2;
    public static $rerate_format = array(''=>'select a Rerate Format',self::CHARGECODE=>'Charge Code',self::PREFIX=>'Prefix');

    public static function getName($CompanyID){

        if($CompanyID > 0){
            $CompanyName = Company::where("CompanyID",$CompanyID)->pluck("CompanyName");
            return $CompanyName;
        }
    }
	
    public static function getCompanyField($companyID,$field) {
        if(!empty($field) && $companyID > 0) {      
   	      return Company::where("CompanyID",$companyID)->pluck($field);
       }
    }

    public static function getCompanyAddress($companyID=0){
        if($companyID>0){
            $companyData = Company::find($companyID);
        }else{
            $companyData = Company::find(User::get_companyID());
        }
        $Address = "";
        $Address .= !empty($companyData->Address1) ? $companyData->Address1 . ',' . PHP_EOL : '';
        $Address .= !empty($companyData->Address2) ? $companyData->Address2 . ',' . PHP_EOL : '';
        $Address .= !empty($companyData->Address3) ? $companyData->Address3 . ',' . PHP_EOL : '';
        return $Address;
    }
	
	public static function getCompanyFullAddress($companyID){
		 if($companyID>0)
		 {
			 $companyData = Company::find($companyID);
			$Address = "";
			$Address .= !empty($companyData->Address1) ? $companyData->Address1 . ',' . PHP_EOL : '';
			$Address .= !empty($companyData->Address2) ? $companyData->Address2 . ',' . PHP_EOL : '';
			$Address .= !empty($companyData->Address3) ? $companyData->Address3 . ',' . PHP_EOL : '';
			$Address .= !empty($companyData->City) ? $companyData->City . ',' . PHP_EOL : '';
			$Address .= !empty($companyData->PostCode) ? $companyData->PostCode . ',' . PHP_EOL : '';
			$Address .= !empty($companyData->Country) ? $companyData->Country : '';
			return $Address;
		}
    }
	
    public static function getEmail($CompanyID){
        if($CompanyID > 0){
            $Email = Company::where("CompanyID",$CompanyID)->pluck("Email");
            return $Email;
        }
    }

    /** Setup Default Company Timezone
     * @param $CompanyID
     */
    public static function setup_timezone($CompanyID){
        $TimeZone = Company::where("CompanyID",$CompanyID)->pluck("TimeZone");
        if(!empty($TimeZone)){
            date_default_timezone_set($TimeZone);
            Config::set('app.timezone',$TimeZone);
        }

    }
}