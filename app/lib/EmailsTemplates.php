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
				'{{CurrencySign}}',
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
				"{{Logo}}",
				"{{CreditnotesGrandTotal}}",
				"{{BillingAddress1}}",
				"{{BillingAddress2}}",
				"{{BillingAddress3}}",
				"{{BillingCity}}",
				"{{BillingPostCode}}",
				"{{BillingCountry}}",
				"{{BillingEmail}}",
				"{{CustomerID}}",
                "{{DirectDebit}}",
                "{{RegisterDutchFoundation}}",
                "{{COCNumber}}",
                "{{DutchProvider}}",	
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
				$InvoiceDetailPeriod 					= 	 InvoiceDetail::where(["InvoiceID" => $InvoiceID,'ProductType'=>Product::INVOICE_PERIOD])->first();
				$AccoutData 							=	 Account::find($InvoiceData->AccountID);
				$EmailTemplate 							= 	 EmailTemplate::getSystemEmailTemplate($CompanyID, Invoice::EMAILTEMPLATE, $AccoutData->LanguageID);
				if($type=="subject"){
					$EmailMessage							=	 $EmailTemplate->Subject;
				}else{
					$EmailMessage							=	 $EmailTemplate->TemplateBody;
				}
				$replace_array							=	 EmailsTemplates::setCompanyFields($replace_array,$CompanyID);
				$replace_array							=	 EmailsTemplates::setAccountFields($replace_array,$InvoiceData->AccountID,$CompanyID,$userID);
				$replace_array                          =    EmailsTemplates::DateTime($replace_array,$CompanyID);
                $WEBURL                                 =    CompanyConfiguration::getValueConfigurationByKey($CompanyID,'WEB_URL');
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
				$replace_array['CurrencySign']			=	 Currency::where(["CurrencyId"=>$AccoutData->CurrencyId,"CompanyId"=>$CompanyID])->pluck("Symbol");
				$RoundChargesAmount 					= 	 Helper::get_round_decimal_places($CompanyID,$InvoiceData->AccountID);
				$replace_array['InvoiceGrandTotal']		=	 number_format($InvoiceData->GrandTotal,$RoundChargesAmount);
				$replace_array['AccountName']			=	 $AccoutData->AccountName;
				$replace_array['InvoiceOutstanding'] 	=	Account::getInvoiceOutstanding($CompanyID, $InvoiceData->AccountID, $InvoiceID,Helper::get_round_decimal_places($CompanyID,$InvoiceData->AccountID));

			if(!empty($InvoiceDetailPeriod) && isset($InvoiceDetailPeriod->StartDate)) {
				$replace_array['PeriodFrom'] 			= 	 date('Y-m-d', strtotime($InvoiceDetailPeriod->StartDate));
			} else {
				$replace_array['PeriodFrom'] 			= 	 "";
			}
			if(!empty($InvoiceDetailPeriod) && isset($InvoiceDetailPeriod->EndDate)) {
				$replace_array['PeriodTo'] 				= 	 date('Y-m-d', strtotime($InvoiceDetailPeriod->EndDate));
			} else {
				$replace_array['PeriodTo'] 				= 	 "";
			}

			$extraSpecific = [
				'{{InvoiceNumber}}',
				'{{InvoiceGrandTotal}}',
				'{{InvoiceOutstanding}}',
				'{{OutstandingExcludeUnbilledAmount}}',
				'{{Signature}}',
				'{{OutstandingIncludeUnbilledAmount}}',
				'{{BalanceThreshold}}',				
				"{{InvoiceLink}}",
				"{{PeriodFrom}}",
				"{{PeriodTo}}",
				"{{Date}}",
				"{{Time}}"
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

	static function SendCreditNotesSingle($slug,$CreditNotesID,$type="body",$data = array(),$postdata = array()){

		//print_r($data);exit;
		$message								=	"";
		$AccoutData 							=	Account::find($CreditNotesData->AccountID);
		$CreditNotesData  							=  	CreditNotes::find($CreditNotesID);
		$replace_array							=	$data;
		$replace_array							=	EmailsTemplates::setCompanyFields($replace_array,$CreditNotesData->CompanyID);
		$replace_array 							=	EmailsTemplates::setAccountFields($replace_array,$CreditNotesData->AccountID,$CreditNotesData->CompanyID);
		$replace_array                          =   EmailsTemplates::DateTime($replace_array,$AccoutData->CompanyId);
		$EmailTemplate 							= 	EmailTemplate::getSystemEmailTemplate($AccoutData->CompanyId, $slug, $AccoutData->LanguageID);

		$CreditNotesNumber			=   $data['CreditNoteNumber'];

		if($type=="subject"){
			if(isset($postdata['Subject']) && !empty($postdata['Subject'])){
				$EmailMessage							=	 $postdata['Subject'];
			}else{
				$EmailMessage							=	 $EmailTemplate->Subject;
			}
		}else{
			if(isset($postdata['Message']) && !empty($postdata['Message'])){
				$EmailMessage							=	 $postdata['Message'];
			}else{
				$EmailMessage							=	 $EmailTemplate->TemplateBody;
			}
		}


		$replace_array['CompanyName']			=	 Company::getName($CreditNotesData->CompanyID);
		/*if(isset($data['CreditNotesURL'])){
			$replace_array['CreditNotesLink'] 		= 	 $data['CreditNotesURL'];
		}else{
			$replace_array['CreditNotesLink'] 		= 	 URL::to('/creditnotes/'.$CreditNotesID.'/creditnotes_preview');
		}*/

		$replace_array['CreditNotesNumber']		=	 isset($data['CreditNotesNumber'])?$data['CreditNotesNumber']:$CreditNotesNumber;
		$RoundChargesAmount 					= 	 Helper::get_round_decimal_places($CreditNotesData->CompanyID,$CreditNotesData->AccountID);
		$replace_array['CreditnotesGrandTotal']	=	 number_format($CreditNotesData->GrandTotal,$RoundChargesAmount);
		//$replace_array['Comment']				=	 isset($data['Comment'])?$data['Comment']:EmailsTemplates::GetCreditNotesComments($CreditNotesID);


		$extraSpecific = [
			'{{CreditNotesNumber}}',
			'{{CreditnotesGrandTotal}}',
			"{{CreditNotesLink}}",
			"{{Comment}}",
			"{{Message}}",
			"{{Date}}",
			"{{Time}}"
		];


		$extraDefault	=	EmailsTemplates::$fields;

		$extra = array_merge($extraDefault,$extraSpecific);


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
			$replace_array                  =   EmailsTemplates::DateTime($replace_array,$CompanyID);				
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
				"{{Date}}",
				"{{Time}}"
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
		$array['Logo'] 							= 	"<img src='".getCompanyLogo($CompanyID)."' />";
		return $array;
	}
	
	static function CheckEmailTemplateStatus($slug,$CompanyID){
		return EmailTemplate::where(["SystemType"=>$slug,"CompanyID"=>$CompanyID])->pluck("Status");
	}
	static function DateTime($array,$CompanyID){
		
		$CompanyData = Company::find($CompanyID);
 		date_default_timezone_set($CompanyData->TimeZone);
		
		$array['Date'] =  date("Y-m-d");
		$array['Time'] =  date("H:i:s");
		return $array;
	}
	
	static function setAccountFields($array,$AccountID,$CompanyID,$UserID=0){
			$RoundChargesAmount=Helper::get_round_decimal_places($CompanyID,$AccountID);
			$dynamicfields = Account::getDynamicfields('account',$AccountID,$CompanyID);
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
			$array['BillingAddress1']		=	 $AccoutData->BillingAddress1;
			$array['BillingAddress2']		=	 $AccoutData->BillingAddress2;
			$array['BillingAddress3']		=	 $AccoutData->BillingAddress3;
			$array['BillingCity']			=	 $AccoutData->BillingCity;
			$array['BillingPostCode']		=	 $AccoutData->BillingPostCode;
			$array['BillingCountry']		=	 $AccoutData->BillingCountry;
			$array['CustomerID']			=	 $dynamicfields['CustomerID'];
			$array['DirectDebit']			=	 $dynamicfields['Direct Debit'];
			$array['RegisterDutchFoundation']			=	 $dynamicfields['Register Dutch Foundation'];
			$array['COCNumber']			=	 $dynamicfields['COC Number'];
			$array['DutchProvider']			=	 $dynamicfields['Dutch Provider'];
			
				
			$array['Currency']				=	 Currency::where(["CurrencyId"=>$AccoutData->CurrencyId])->pluck("Code");		
			$array['CurrencySign']			=	 Currency::where(["CurrencyId"=>$AccoutData->CurrencyId])->pluck("Symbol");
			$array['OutstandingExcludeUnbilledAmount'] = Account::getOutstandingAmount($CompanyID, $AccountID,  $RoundChargesAmount);
			$array['OutstandingIncludeUnbilledAmount'] = number_format(AccountBalance::getBalanceAmount($AccountID), $RoundChargesAmount);
			$array['BalanceThreshold'] 				   = AccountBalance::getBalanceThreshold($AccountID);

					
			  if(!empty($UserID)){
				   $UserData = user::find($UserID);
				  if(isset($UserData->EmailFooter) && trim($UserData->EmailFooter) != '')
					{
						$array['Signature']= $UserData->EmailFooter;	
					}
	        	}else{
					$array['Signature']= '';	
				}
			return $array;
	}

	static function setAccountServiceFields($array,$AccountID,$UserID=0){
		$AccountServiceData 		= 	 AccountService::find($AccountID);
		$array['ServiceTitle']		=	 $AccountServiceData['ServiceTitle'];

		if(!empty($UserID)){
			$UserData = user::find($UserID);
			if(isset($UserData->EmailFooter) && trim($UserData->EmailFooter) != '')
			{
				$array['Signature']= $UserData->EmailFooter;
			}
		}else{
			$array['Signature']= '';
		}
		return $array;
	}

	static function SendAutoPayment($InvoiceID,$type="body",$CompanyID,$singleemail,$staticdata=array(),$data = array())
	{
		$message = "";
		$replace_array = $data;
		$userID = isset($data['UserID']) ? $data['UserID'] : 0;
		/*try{*/
		$InvoiceData = Invoice::find($InvoiceID);
		$AccoutData = Account::find($InvoiceData->AccountID);
		$InvoiceDetailPeriod = InvoiceDetail::where(["InvoiceID" => $InvoiceID,'ProductType'=>Product::INVOICE_PERIOD])->first();
		$EmailTemplate = EmailTemplate::getSystemEmailTemplate($CompanyID, Payment::AUTOINVOICETEMPLATE, $AccoutData->LanguageID);
		if ($type == "subject") {
			$EmailMessage = $EmailTemplate->Subject;
		} else {
			$EmailMessage = $EmailTemplate->TemplateBody;
		}
		$replace_array = EmailsTemplates::setCompanyFields($replace_array, $CompanyID);
		$replace_array = EmailsTemplates::setAccountFields($replace_array, $InvoiceData->AccountID,$CompanyID,$userID);
		$replace_array = EmailsTemplates::DateTime($replace_array,$CompanyID);
		$WEBURL = CompanyConfiguration::getValueConfigurationByKey($CompanyID, 'WEB_URL');
		$replace_array['InvoiceLink'] = $WEBURL . '/invoice/' . $InvoiceData->AccountID . '-' . $InvoiceData->InvoiceID . '/cview?email=' . $singleemail;
		$replace_array['InvoiceNumber'] = $InvoiceData->FullInvoiceNumber;
		$RoundChargesAmount = Helper::get_round_decimal_places($CompanyID, $InvoiceData->AccountID);
		$replace_array['InvoiceGrandTotal'] = number_format($InvoiceData->GrandTotal, $RoundChargesAmount);
		$replace_array['InvoiceOutstanding'] = Account::getInvoiceOutstanding($CompanyID, $InvoiceData->AccountID, $InvoiceID, Helper::get_round_decimal_places($CompanyID, $InvoiceData->AccountID));

		$replace_array['PaidAmount'] = empty($staticdata['PaidAmount'])?'':$staticdata['PaidAmount'];
		$replace_array['PaidAmount'] = number_format($replace_array['PaidAmount'], $RoundChargesAmount);
		$replace_array['PaidStatus'] = empty($staticdata['PaidStatus'])?'':$staticdata['PaidStatus'];
		$replace_array['PaymentMethod'] = empty($staticdata['PaymentMethod'])?'':$staticdata['PaymentMethod'];
		$replace_array['PaymentNotes'] = empty($staticdata['PaymentNotes'])?'':$staticdata['PaymentNotes'];

		if(!empty($InvoiceDetailPeriod) && isset($InvoiceDetailPeriod->StartDate)) {
			$replace_array['PeriodFrom'] 			= 	 date('Y-m-d', strtotime($InvoiceDetailPeriod->StartDate));
		} else {
			$replace_array['PeriodFrom'] 			= 	 "";
		}
		if(!empty($InvoiceDetailPeriod) && isset($InvoiceDetailPeriod->EndDate)) {
			$replace_array['PeriodTo'] 				= 	 date('Y-m-d', strtotime($InvoiceDetailPeriod->EndDate));
		} else {
			$replace_array['PeriodTo'] 				= 	 "";
		}

		$extraSpecific = [
			'{{InvoiceNumber}}',
			'{{InvoiceGrandTotal}}',
			'{{InvoiceOutstanding}}',
			'{{OutstandingExcludeUnbilledAmount}}',
			'{{Signature}}',
			'{{OutstandingIncludeUnbilledAmount}}',
			'{{BalanceThreshold}}',
			"{{InvoiceLink}}",
			"{{PaidAmount}}",
			"{{PaidStatus}}",
			"{{PaymentMethod}}",
			"{{PaymentNotes}}",
			"{{PeriodFrom}}",
			"{{PeriodTo}}",
			"{{Date}}",
			"{{Time}}"
		];

		$extraDefault = EmailsTemplates::$fields;
		$extra = array_merge($extraDefault, $extraSpecific);

		foreach ($extra as $item) {
			$item_name = str_replace(array('{', '}'), array('', ''), $item);
			if (array_key_exists($item_name, $replace_array)) {
				$EmailMessage = str_replace($item, $replace_array[$item_name], $EmailMessage);
			}
		}
		return $EmailMessage;

		/*	return array("error"=>"","status"=>"success","data"=>$EmailMessage,"from"=>$EmailTemplate->EmailFrom);
        }catch (Exception $ex){
            return array("error"=>$ex->getMessage(),"status"=>"failed","data"=>"","from"=>$EmailTemplate->EmailFrom);
        }*/
	}

	/**
	 * @param $Account
	 * @param string $type
	 * @param $CompanyID
	 * @param array $data
	 * @return mixed
	 */
	static function setContractManagePlaceholder($Account,$type="body",$CompanyID, $data = [])
	{
		$replace_array = $data;
		$EmailTemplate = EmailTemplate::getSystemEmailTemplate($CompanyID, Account::ContractManageEmailTemplate, $Account->LanguageID);
		if ($type == "subject") {
			$EmailMessage = $EmailTemplate->Subject;
		} else {
			$EmailMessage = $EmailTemplate->TemplateBody;
		}
		$replace_array = EmailsTemplates::setAccountServiceFields($replace_array, $Account->AccountID, 0);
		$replace_array = EmailsTemplates::setCompanyFields($replace_array, $CompanyID);
		$replace_array = EmailsTemplates::setAccountFields($replace_array, $Account->AccountID,$CompanyID, 0);
		$replace_array = EmailsTemplates::DateTime($replace_array,$CompanyID);
		$replace_array['ServiceTitle'] = $data['ServiceTitle'];
		$replace_array['ServiceName'] = $data['ServiceName'];
		$replace_array['ContractEndDate'] = $data['ContractEndDate'];
		$replace_array['ServiceTitle'] = $data['ServiceTitle'];

		$extraSpecific = ["{{ServiceName}}","{{ServiceTitle}}","{{ContractStartDate}}","{{ContractEndDate}}","{{Date}}","{{Time}}"];

		$extraDefault = EmailsTemplates::$fields;
		$extra = array_merge($extraDefault, $extraSpecific);

		foreach ($extra as $item) {
			$item_name = str_replace(array('{', '}'), array('', ''), $item);
			if (array_key_exists($item_name, $replace_array)) {
				$EmailMessage = str_replace($item, $replace_array[$item_name], $EmailMessage);
			}
		}

		return $EmailMessage;
	}
	static function setContractExpirePlaceholder($Account,$type="body",$CompanyID, $data = [])
	{
		$replace_array = $data;
		$EmailTemplate = EmailTemplate::getSystemEmailTemplate($CompanyID, Account::ContractExpireEmailTemplate, $Account->LanguageID);
		if ($type == "subject") {
			$EmailMessage = $EmailTemplate->Subject;
		} else {
			$EmailMessage = $EmailTemplate->TemplateBody;
		}
		$replace_array = EmailsTemplates::setAccountServiceFields($replace_array, $Account->AccountID, 0);
		$replace_array = EmailsTemplates::setCompanyFields($replace_array, $CompanyID);
		$replace_array = EmailsTemplates::setAccountFields($replace_array,$Account->AccountID,$CompanyID,0);
		$replace_array = EmailsTemplates::DateTime($replace_array,$CompanyID);

		
		$replace_array['ServiceName'] = $data['Services'];
		$replace_array['DaysOfExpiry'] = $data['Days'];
		$replace_array['ContractStartDate'] = $data['ContractStartDate'];
		$replace_array['ContractEndDate'] = $data['ContractEndDate'];
		$replace_array['ServiceTitle'] = $data['ServiceTitle'];

		$extraSpecific = ["{{DaysOfExpiry}}","{{ServiceName}}","{{ContractStartDate}}","{{ContractEndDate}}","{{ServiceTitle}}", "{{Date}}","{{Time}}"];
		$extraDefault = EmailsTemplates::$fields;
		$extra = array_merge($extraDefault, $extraSpecific);

		foreach ($extra as $item) {
			$item_name = str_replace(array('{', '}'), array('', ''), $item);
			if (array_key_exists($item_name, $replace_array)) {
				$EmailMessage = str_replace($item, $replace_array[$item_name], $EmailMessage);
			}
		}

		return $EmailMessage;
	}
	static function setOutPaymentPlaceholder($Account,$type="body",$CompanyID, $data = [])
	{
		$replace_array = $data;
		$EmailTemplate = EmailTemplate::getSystemEmailTemplate($CompanyID, Account::OutPaymentEmailTemplate, $Account->LanguageID);
		if ($type == "subject") {
			$EmailMessage = $EmailTemplate->Subject;
		} else {
			$EmailMessage = $EmailTemplate->TemplateBody;
		}
		$replace_array = EmailsTemplates::setCompanyFields($replace_array, $CompanyID);
		$replace_array = EmailsTemplates::setAccountFields($replace_array, $Account->AccountID,$CompanyID, 0);
		$replace_array['OutPaymentAmount'] = $data['OutPaymentAmount'];

		$extraSpecific = ["{{OutPaymentAmount}}"];

		$extraDefault = EmailsTemplates::$fields;
		$extra = array_merge($extraDefault, $extraSpecific);

		foreach ($extra as $item) {
			$item_name = str_replace(array('{', '}'), array('', ''), $item);
			if (array_key_exists($item_name, $replace_array)) {
				$EmailMessage = str_replace($item, $replace_array[$item_name], $EmailMessage);
			}
		}
		return $EmailMessage;
	}

	static function SendAutoPaymentFromProcessCallChare($AccountID,$type="body",$CompanyID,$singleemail,$staticdata=array(),$data = array())
	{
		$message = "";
		$replace_array = $data;
		$userID = isset($data['UserID']) ? $data['UserID'] : 0;
		/*try{*/

		$AccoutData = Account::find($AccountID);
		$EmailTemplate = EmailTemplate::getSystemEmailTemplate($CompanyID, Payment::AUTOINVOICETEMPLATE, $AccoutData->LanguageID);
		if ($type == "subject") {
			$EmailMessage = $EmailTemplate->Subject;
		} else {
			$EmailMessage = $EmailTemplate->TemplateBody;
		}
		$replace_array = EmailsTemplates::setCompanyFields($replace_array, $CompanyID);
		$replace_array = EmailsTemplates::setAccountFields($replace_array, $AccountID, $CompanyID, $userID);
		$RoundChargesAmount = Helper::get_round_decimal_places($CompanyID, $AccountID);

		$replace_array['PaidAmount'] = empty($staticdata['PaidAmount'])?'':$staticdata['PaidAmount'];
		$replace_array['PaidAmount'] = number_format($replace_array['PaidAmount'], $RoundChargesAmount);
		$replace_array['PaidStatus'] = empty($staticdata['PaidStatus'])?'':$staticdata['PaidStatus'];
		$replace_array['PaymentMethod'] = empty($staticdata['PaymentMethod'])?'':$staticdata['PaymentMethod'];
		$replace_array['PaymentNotes'] = empty($staticdata['PaymentNotes'])?'':$staticdata['PaymentNotes'];

		$extraSpecific = [
			'{{InvoiceNumber}}',
			'{{InvoiceGrandTotal}}',
			'{{InvoiceOutstanding}}',
			'{{OutstandingExcludeUnbilledAmount}}',
			'{{Signature}}',
			'{{OutstandingIncludeUnbilledAmount}}',
			'{{BalanceThreshold}}',
			"{{InvoiceLink}}",
			"{{PaidAmount}}",
			"{{PaidStatus}}",
			"{{PaymentMethod}}",
			"{{PaymentNotes}}",
			"{{PeriodFrom}}",
			"{{PeriodTo}}"
		];

		$extraDefault = EmailsTemplates::$fields;
		$extra = array_merge($extraDefault, $extraSpecific);

		foreach ($extra as $item) {
			$item_name = str_replace(array('{', '}'), array('', ''), $item);
			if (array_key_exists($item_name, $replace_array)) {
				$EmailMessage = str_replace($item, $replace_array[$item_name], $EmailMessage);
			}
		}
		return $EmailMessage;

		/*	return array("error"=>"","status"=>"success","data"=>$EmailMessage,"from"=>$EmailTemplate->EmailFrom);
        }catch (Exception $ex){
            return array("error"=>$ex->getMessage(),"status"=>"failed","data"=>"","from"=>$EmailTemplate->EmailFrom);
        }*/
	}

	static function SendDisputeSingle($DisputeID,$type="body",$CompanyID,$data = array()){
		$companyID								=	$CompanyID;
		$message								=	 "";
		$replace_array							=	$data;
		$DisputeData   							=  	Dispute::find($DisputeID);
		$userID											=	isset($data['UserID'])?$data['UserID']:0;
		//$InvoiceDetailPeriod 					= 	InvoiceDetail::where(["InvoiceID" => $DisputeID,'ProductType'=>Product::INVOICE_PERIOD])->first();

		$Account 								= 	Account::find($DisputeData->AccountID);
		$EmailTemplate 							= 	EmailTemplate::getSystemEmailTemplate($companyID, Dispute::EMAILTEMPLATE, $Account->LanguageID );

		$replace_array							=	EmailsTemplates::setCompanyFields($replace_array,$DisputeData->CompanyID);
		$replace_array 							=	EmailsTemplates::setAccountFields($replace_array,$DisputeData->AccountID,$DisputeData->CompanyID,$userID);

		if($type=="subject"){
			if(isset($postdata['Subject']) && !empty($postdata['Subject'])){
				$EmailMessage							=	 $postdata['Subject'];
			}else{
				$EmailMessage							=	 $EmailTemplate->Subject;
			}
		}else{
			if(isset($postdata['Message']) && !empty($postdata['Message'])){
				$EmailMessage							=	 $postdata['Message'];
			}else{
				$EmailMessage							=	 $EmailTemplate->TemplateBody;
			}
		}

		$replace_array['InvoiceNumber']			=	 $DisputeData->InvoiceNo;
		$replace_array['InvoiceType']			=	 ($DisputeData->InvoiceType == Invoice::INVOICE_IN?'Invoice Received':'Invoice Sent');
		$RoundChargesAmount 					= 	 Helper::get_round_decimal_places($CompanyID,$DisputeData->AccountID);
		$replace_array['DisputeAmount']			=	 number_format($DisputeData->DisputeAmount,$RoundChargesAmount);

		$extraSpecific = [
			'{{InvoiceNumber}}',
			"{{InvoiceType}}",
			'{{DisputeAmount}}'
		];

		$extraDefault	=	EmailsTemplates::$fields;

		$extra = array_merge($extraDefault,$extraSpecific);

		foreach($extra as $item){
			$item_name = str_replace(array('{','}'),array('',''),$item);
			if(array_key_exists($item_name,$replace_array)) {
				$EmailMessage = str_replace($item,$replace_array[$item_name],$EmailMessage);
			}
		}
		return $EmailMessage;

	}
	
}
?>