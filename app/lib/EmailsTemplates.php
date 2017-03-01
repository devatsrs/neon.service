<?php 
namespace App\Lib;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\View;

class EmailsTemplates{

	protected $EmailSubject;
	protected $EmailTemplate;
	protected $Error;
	protected $CompanyName;
	static $fields = array(
				"{{AccountName}}",
				'{{FirstName}}',
				'{{LastName}}',
				'{{Email}}',
				'{{Address1}}',
				'{{Address2}}',
				'{{Address3}}',
				'{{City}}',
				'{{State}}',
				'{{PostCode}}',
				'{{Country}}',
				'{{Signature}}',
				'{{Currency}}',
				'{{OutstandingExcludeUnbilledAmount}}',
				'{{OutstandingIncludeUnbilledAmount}}',
				'{{BalanceThreshold}}',
				'{{CompanyName}}',
				"{{CompanyVAT}}",
				"{{CompanyAddress1}}",
				"{{CompanyAddress2}}",
				"{{CompanyAddress3}}",
				"{{CompanyCity}}",
				"{{CompanyPostCode}}",
				"{{CompanyCountry}}",
				);
	
	 public function __construct($data = array()){
		 foreach($data as $key => $value){
			 $this->$key = $value;
		 }		 		 
	}
	
	static function SendinvoiceSingle($InvoiceID,$type="body",$CompanyID,$singleemail,$data = array()){ 
		$message										=	 "";
		$replace_array									=	$data;
		$userID											=	isset($data['UserID'])?$data['UserID']:0;
		/*try{*/
				$InvoiceData   							=  	 Invoice::find($InvoiceID);
				$AccoutData 							=	 Account::find($InvoiceData->AccountID);
				$EmailTemplate 							= 	 EmailTemplate::where(["SystemType"=>Invoice::EMAILTEMPLATE,"CompanyID"=>$CompanyID])->first();
				if($type=="subject"){
					$EmailMessage							=	 $EmailTemplate->Subject;
				}else{
					$EmailMessage							=	 $EmailTemplate->TemplateBody;
				}
				$replace_array							=	 EmailsTemplates::setCompanyFields($replace_array,$CompanyID);
				$replace_array							=	 EmailsTemplates::setAccountFields($replace_array,$InvoiceData->AccountID);
                $WEBURL                                 =    CompanyConfiguration::get($CompanyID,'WEB_URL');
                $replace_array['InvoiceLink'] 			= 	 $WEBURL . '/invoice/' . $InvoiceData->AccountID . '-' . $InvoiceData->InvoiceID . '/cview?email='.$singleemail;
				$replace_array['FirstName']				=	 $AccoutData->FirstName;
				$replace_array['LastName']				=	 $AccoutData->LastName;
				$replace_array['Email']					=	 $AccoutData->Email;
				$replace_array['Address1']				=	 $AccoutData->Address1;
				$replace_array['Address2']				=	 $AccoutData->Address2;
				$replace_array['Address3']				=	 $AccoutData->Address3;		
				$replace_array['City']					=	 $AccoutData->City;
				$replace_array['State']					=	 $AccoutData->State;
				$replace_array['PostCode']				=	 $AccoutData->PostCode;
				$replace_array['Country']				=	 $AccoutData->Country;
				$replace_array['Address3']				=	 $AccoutData->Address3;
				$replace_array['InvoiceNumber']			=	 $InvoiceData->FullInvoiceNumber;		
				$replace_array['Currency']				=	 Currency::where(["CurrencyId"=>$AccoutData->CurrencyId,"CompanyId"=>$CompanyID])->pluck("Code");
				$RoundChargesAmount 					= 	 Helper::get_round_decimal_places($CompanyID,$InvoiceData->AccountID);
				$replace_array['InvoiceGrandTotal']		=	 number_format($InvoiceData->GrandTotal,$RoundChargesAmount);
				$replace_array['AccountName']			=	 $AccoutData->AccountName;
				$replace_array['InvoiceOutstanding'] 	=	Account::getInvoiceOutstanding($CompanyID, $InvoiceData->AccountID, $InvoiceID,Helper::get_round_decimal_places($CompanyID,$InvoiceData->AccountID));
				
				
				 
			$extraSpecific = [
				'{{InvoiceNumber}}',
				'{{InvoiceGrandTotal}}',
				'{{InvoiceOutstanding}}',
				'{{OutstandingExcludeUnbilledAmount}}',
				'{{Signature}}',
				'{{OutstandingIncludeUnbilledAmount}}',
				'{{BalanceThreshold}}',				
				"{{InvoiceLink}}"
			];
			
			$extraDefault	=	EmailsTemplates::$fields;
			$extra 			= 	array_merge($extraDefault,$extraSpecific);
			
			foreach($extra as $item){
				$item_name = str_replace(array('{','}'),array('',''),$item);
				if(array_key_exists($item_name,$replace_array)) {
					$EmailMessage = str_replace($item,$replace_array[$item_name],$EmailMessage);
				}
			} 
			return $EmailMessage; 
			
			/*	return array("error"=>"","status"=>"success","data"=>$EmailMessage,"from"=>$EmailTemplate->EmailFrom);	
			}catch (Exception $ex){
				return array("error"=>$ex->getMessage(),"status"=>"failed","data"=>"","from"=>$EmailTemplate->EmailFrom);	
			}*/
}
	 
	
	protected function SetError($error){
		$this->Error = $error;
	}
	public function GetError(){
		return $this->Error;
	}
	
	static function SendRateSheetEmail($slug,$Ratesheet,$type="body",$data,$CompanyID){
		
			$replace_array					=	 $data;				
			$message						=	 "";		
			$EmailTemplate 					= 	 EmailTemplate::where(["SystemType"=>$slug,"CompanyID"=>$CompanyID])->first();
			if($type=="subject"){
				$EmailMessage				=	 $EmailTemplate->Subject;
			}else{
				$EmailMessage				=	 $EmailTemplate->TemplateBody;
			}
			
			$extra = [
				'{{FirstName}}',
				'{{LastName}}',
				'{{RateTableName}}',
				'{{EffectiveDate}}',
				'{{RateGeneratorName}}',					
				'{{CompanyName}}',
			];
		
		foreach($extra as $item){
			$item_name = str_replace(array('{','}'),array('',''),$item);
			if(array_key_exists($item_name,$replace_array)) {					
				$EmailMessage = str_replace($item,$replace_array[$item_name],$EmailMessage);					
			}
		} 
		return $EmailMessage; 	
	}
	
	static function GetEmailTemplateFrom($slug,$CompanyID){
		return EmailTemplate::where(["SystemType"=>$slug,"CompanyID"=>$CompanyID])->pluck("EmailFrom");
	}
	
		static function setCompanyFields($array,$CompanyID){
			$CompanyData							=	Company::find($CompanyID);
			$array['CompanyName']					=   $CompanyData->CompanyName;
			$array['CompanyVAT']					=   $CompanyData->VAT;			
			$array['CompanyAddress1']				=   $CompanyData->Address1;
			$array['CompanyAddress2']				=   $CompanyData->Address1;
			$array['CompanyAddress3']				=   $CompanyData->Address1;
			$array['CompanyCity']					=   $CompanyData->City;
			$array['CompanyPostCode']				=   $CompanyData->PostCode;
			$array['CompanyCountry']				=   $CompanyData->Country;			
			return $array;
	}
	
	static function CheckEmailTemplateStatus($slug,$CompanyID){
		return EmailTemplate::where(["SystemType"=>$slug,"CompanyID"=>$CompanyID])->pluck("Status");
	}
	
	static function setAccountFields($array,$AccountID,$CompanyID,$UserID=0){
			$AccoutData 					= 	 Account::find($AccountID);			
			$array['AccountName']			=	 $AccoutData->AccountName;
			$array['FirstName']				=	 $AccoutData->FirstName;
			$array['LastName']				=	 $AccoutData->LastName;
			$array['Email']					=	 $AccoutData->Email;
			$array['Address1']				=	 $AccoutData->Address1;
			$array['Address2']				=	 $AccoutData->Address2;
			$array['Address3']				=	 $AccoutData->Address3;		
			$array['City']					=	 $AccoutData->City;
			$array['State']					=	 $AccoutData->State;
			$array['PostCode']				=	 $AccoutData->PostCode;
			$array['Country']				=	 $AccoutData->Country;
			$array['Currency']				=	 Currency::where(["CurrencyId"=>$AccoutData->CurrencyId])->pluck("Code");		
			$array['OutstandingExcludeUnbilledAmount'] = Account::getOutstandingAmount($CompanyID, $AccountID,  Helper::get_round_decimal_places($CompanyID,$AccountID));
			$array['OutstandingIncludeUnbilledAmount'] = AccountBalance::getBalanceAmount($AccountID);
			$array['BalanceThreshold'] 				   = AccountBalance::getBalanceThreshold($AccountID);	
			  if(!empty($UserID)){
				   $UserData = user::find($UserID);
				  if(isset($UserData->EmailFooter) && trim($UserData->EmailFooter) != '')
					{
						$array['Signature']= $UserData->EmailFooter;	
					}
	        	}
			return $array;
	}
	
}
?>