<?php
namespace App\Lib;

class EmailTemplate extends \Eloquent {

    protected $guarded = array("TemplateID");
    protected $table = 'tblEmailTemplate';
    protected  $primaryKey = "TemplateID";
    const ACCOUNT_TEMPLATE =1;
    const INVOICE_TEMPLATE =2;

    public static function checkForeignKeyById($id){
        $companyID = User::get_companyID();
        $JobTypeID = JobType::where(["Code" => 'BLE'])->pluck('JobTypeID');
        $hasInCronLog = Job::where("TemplateID",$id)->where("CompanyID",$companyID)->where('JobTypeID',$JobTypeID)->count();
        if( intval($hasInCronLog) > 0 ){
            return true;
        }else{
            return false;
        }
    }
    public static function getTemplateArray($data=array()){
        $data['CompanyID']=User::get_companyID();
        $row = EmailTemplate::where($data)->select(array('TemplateID', 'TemplateName'))->orderBy('TemplateName')->lists('TemplateName','TemplateID');
        if(!empty($row)){
            $row = array(""=> "Select a Template")+$row;
        }
        return $row;
    }
}