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
	
	 public function __construct($data = array()){
		 foreach($data as $key => $value){
			 $this->$key = $value;
		 }		 		 
	}
	
	static function SendinvoiceSingle($InvoiceID,$type="body",$CompanyID,$singleemail){ 
		$message										=	 "";
		/*try{*/
				$InvoiceData   							=  	 Invoice::find($InvoiceID);
				$AccoutData 							=	 Account::find($InvoiceData->AccountID);
				$EmailTemplate 							= 	 EmailTemplate::where(["SystemType"=>Invoice::EMAILTEMPLATE,"CompanyID"=>$CompanyID])->first();
				if($type=="subject"){
					$EmailMessage							=	 $EmailTemplate->Subject;
				}else{
					$EmailMessage							=	 $EmailTemplate->TemplateBody;
				}
				$replace_array['CompanyName']			=	 Company::getName($CompanyID);
				$replace_array['InvoiceLink'] 			= 	 getenv("WEBURL") . '/invoice/' . $InvoiceData->AccountID . '-' . $InvoiceData->InvoiceID . '/cview?email='.$singleemail;
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
				
				
				 
			$extra = [
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
				'{{InvoiceNumber}}',
				'{{InvoiceGrandTotal}}',
				'{{InvoiceOutstanding}}',
				'{{OutstandingExcludeUnbilledAmount}}',
				'{{Signature}}',
				'{{OutstandingIncludeUnbilledAmount}}',
				'{{BalanceThreshold}}',
				'{{Currency}}',
				'{{CompanyName}}',
				"{{AccountName}}",
				"{{InvoiceLink}}"
			];
			
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
	
	static function GetEmailTemplateFrom($slug,$CompanyID){
		return EmailTemplate::where(["SystemType"=>$slug,"CompanyID"=>$CompanyID])->pluck("EmailFrom");
	}
}
?>