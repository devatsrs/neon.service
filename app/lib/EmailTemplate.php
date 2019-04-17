<?php
namespace App\Lib;

class EmailTemplate extends \Eloquent {

    protected $guarded = array("TemplateID");
    protected $table = 'tblEmailTemplate';
    protected  $primaryKey = "TemplateID";
    const ACCOUNT_TEMPLATE =1;
    const INVOICE_TEMPLATE =2;

    //not using
    public static function checkForeignKeyById($id){
        $JobTypeID = JobType::where(["Code" => 'BLE'])->pluck('JobTypeID');
        $hasInCronLog = Job::where("TemplateID",$id)->where('JobTypeID',$JobTypeID)->count();
        if( intval($hasInCronLog) > 0 ){
            return true;
        }else{
            return false;
        }
    }

    //not using
    public static function getTemplateArray($data=array()){
        //$data['CompanyID']=User::get_companyID();
        $row = EmailTemplate::where($data)->select(array('TemplateID', 'TemplateName'))->orderBy('TemplateName')->lists('TemplateName','TemplateID');
        if(!empty($row)){
            $row = array(""=> "Select a Template")+$row;
        }
        return $row;
    }

    public static function getSystemEmailTemplate($companyID, $slug,$languageID=""){
        if(empty($languageID)){
            $languageID=Translation::$default_lang_id;
        }
        $emailtemplate=EmailTemplate::where(["SystemType"=>$slug, "LanguageID"=>$languageID, "CompanyID"=>$companyID ])->first();
        if(empty($emailtemplate)){
            $emailtemplate=EmailTemplate::where(["SystemType"=>$slug, "LanguageID"=>Translation::$default_lang_id, "CompanyID"=>$companyID ])->first();
        }
        return $emailtemplate;
    }
    
    public static function getSystemEmailTemplateID($companyID, $slug,$languageID=""){
        if(empty($languageID)){
            $languageID=Translation::$default_lang_id;
        }	
        $emailtemplate=EmailTemplate::where(["SystemType"=>$slug, "LanguageID"=>$languageID, "CompanyID"=>$companyID,"IsGlobal"=>0])->first();
        if(empty($emailtemplate)){     
			/** check same LanguageID in global*/
            $emailtemplate=EmailTemplate::where(["SystemType"=>$slug, "LanguageID"=>$languageID, "IsGlobal"=>1])->first();
            /** check same default LanguageID in company*/
            if(empty($emailtemplate)){
                $emailtemplate=EmailTemplate::where(["SystemType"=>$slug, "LanguageID"=>Translation::$default_lang_id, "CompanyID"=>$companyID,"IsGlobal"=>0])->first();
                /** check same default LanguageID in global*/
                if(empty($emailtemplate)){
                    $emailtemplate=EmailTemplate::where(["SystemType"=>$slug, "LanguageID"=>Translation::$default_lang_id, "IsGlobal"=>1])->first();
                }
            }
        }
        return $emailtemplate;
    }
         
}