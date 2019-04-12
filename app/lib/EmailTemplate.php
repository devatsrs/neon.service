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
    
    
    public static function getSystemEmailTemplateID($companyID, $slug,$accountID,$languageID=""){
        if(empty($languageID)){
            $languageID=Translation::$default_lang_id;
        }
        $emailtemplate=EmailTemplate::where(["SystemType"=>$slug, "LanguageID"=>$languageID, "CompanyID"=>$companyID ])->first();
        if(empty($emailtemplate)){
            
            $ParentCompanyID = Reseller::where(["AccountID"=>$accountID, "ChildCompanyID"=>$companyID ])->pluck('CompanyID');
            
            if(!empty($ParentCompanyID)){
                $ChildAccountID = Reseller::where(["AccountID"=>$accountID, "ChildCompanyID"=>$companyID ])->pluck('AccountID');
                
                $ParentCompanyLanguageID = Account::where(["AccountID"=>$ChildAccountID])->pluck('LanguageID');
                
                $emailtemplate=EmailTemplate::where(["SystemType"=>$slug, "LanguageID"=>$ParentCompanyLanguageID, "CompanyID"=>$ParentCompanyID ])->first();
                if(empty($emailtemplate)){
                    $emailtemplate=EmailTemplate::where(["SystemType"=>$slug, "LanguageID"=>Translation::$default_lang_id, "CompanyID"=>$companyID ])->first();
                }            
            }else{
                if(empty($emailtemplate)){
                    $emailtemplate=EmailTemplate::where(["SystemType"=>$slug, "LanguageID"=>Translation::$default_lang_id, "CompanyID"=>$companyID ])->first();
                }
            }
        }
        return $emailtemplate;
    }
}