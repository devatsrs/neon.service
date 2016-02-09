<?php
namespace App\Lib;

class Company extends \Eloquent {
	protected $fillable = [];
    protected $guarded = array('CompanyID');
    protected $table = 'tblCompany';
    protected  $primaryKey = "CompanyID";

    const BILLING_STARTTIME = 1;
    const BILLING_ENDTIME = 2;

    public static $billing_time = array(''=>'select a time',self::BILLING_STARTTIME=>'Start Time',self::BILLING_ENDTIME=>'End Time');
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
    public static function getEmail($CompanyID){
        if($CompanyID > 0){
            $Email = Company::where("CompanyID",$CompanyID)->pluck("Email");
            return $Email;
        }else{
            return  getenv("TEST_EMAIL");
        }
    }
}