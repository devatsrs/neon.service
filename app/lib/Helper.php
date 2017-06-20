<?php
namespace App\Lib;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\View;

class Helper{

    public static function sendMail($view,$data,$ViewType=1){
		$companyID = $data['CompanyID'];
		if($ViewType){
			$body 	=  html_entity_decode(View::make($view,compact('data'))->render()); 
		}
		else{
			$body  = $view;
		}

	
		if(SiteIntegration::CheckCategoryConfiguration(false,SiteIntegration::$EmailSlug,$companyID)){
			$status = 	 SiteIntegration::SendMail($view,$data,$companyID,$body);		
		}
		else
		{ 
			$config = Company::select('SMTPServer','SMTPUsername','CompanyName','SMTPPassword','Port','IsSSL','EmailFrom')->where("CompanyID", '=', $companyID)->first();
			$status = 	 PHPMAILERIntegtration::SendMail($view,$data,$config,$companyID,$body);
		}
		
       /* $status = array('status' => 0, 'message' => 'Something wrong with sending mail.');
        $mandrill =0;
        if(isset($data['mandrill']) && $data['mandrill'] ==1){
            $mandrill = 1;
        }
        $mail = Helper::setMailConfig($data['CompanyID'],$mandrill);
        $mail->isHTML(true);
        if(isset($data['isHTML']) && $data['isHTML'] == 'false'){
            $mail->isHTML(false);
        }
        $body = htmlspecialchars_decode(View::make($view,compact('data'))->render());

        if(!is_array($data['EmailTo']) && strpos($data['EmailTo'],',') !== false){
            $data['EmailTo']  = explode(',',$data['EmailTo']);
        }
        if(is_array($data['EmailTo'])){
            foreach((array)$data['EmailTo'] as $email_address){
                $mail->addAddress(trim($email_address));
            }
        }else{
            $mail->addAddress(trim($data['EmailTo']),$data['EmailToName']);
        }
        if(isset($data['attach'])){
            $mail->addAttachment($data['attach']);
        }
        if(isset($data['EmailFrom'])){
            $mail->From = $data['EmailFrom'];
            if(isset($data['EmailFromName'])){
                $mail->FromName = $data['EmailFromName'];
            }
        }
        if(env('APP_ENV') != 'Production'){
            $data['Subject'] = 'Test Mail '.env('RMArtisanFileLocation').' '.$data['Subject'];
        }
        $mail->Body = $body;
        $mail->Subject = $data['Subject'];
        if (!$mail->send()) {
            $status['status'] = 0;
            $status['message'] .= $mail->ErrorInfo;
            $status['body'] = '';
            return $status;
        } else {
            $status['status'] = 1;
            $status['message'] = 'Email has been sent';
            $status['body'] = $body;
            return $status;
        }*/
		return $status;
    }
/*    public static function setMailConfig_old($CompanyID,$mandrill){
        $result = Company::select('SMTPServer','SMTPUsername','CompanyName','SMTPPassword','Port','IsSSL','EmailFrom')->where("CompanyID", '=', $CompanyID)->first();
        if($mandrill == 1) {
            Config::set('mail.host', getenv("MANDRILL_SMTP_SERVER"));
            Config::set('mail.port', getenv("MANDRILL_PORT"));
            Config::set('mail.from.address', $result->EmailFrom);
            Config::set('mail.from.name', $result->CompanyName);
            Config::set('mail.encryption', (getenv("MADRILL_SSL") == 1 ? 'SSL' : 'TLS'));
            Config::set('mail.username', getenv("MANDRILL_SMTP_USERNAME"));
            Config::set('mail.password', getenv("MANDRILL_SMTP_PASSWORD"));
        }else{
            Config::set('mail.host', $result->SMTPServer);
            Config::set('mail.port', $result->Port);
            Config::set('mail.from.address', $result->EmailFrom);
            Config::set('mail.from.name', $result->CompanyName);
            Config::set('mail.encryption', ($result->IsSSL == 1 ? 'SSL' : 'TLS'));
            Config::set('mail.username', $result->SMTPUsername);
            Config::set('mail.password', $result->SMTPPassword);
        }
        extract(Config::get('mail'));

        $mail = new \PHPMailer();
        //$mail->SMTPDebug = 3;                               // Enable verbose debug output
        $mail->isSMTP();                                      // Set mailer to use SMTP
        $mail->Host = $host;  // Specify main and backup SMTP servers
        $mail->SMTPAuth = true;                               // Enable SMTP authentication
        $mail->Username = $username;                 // SMTP username

        $mail->Password = $password;                           // SMTP password
        $mail->SMTPSecure = $encryption;                            // Enable TLS encryption, `ssl` also accepted

        $mail->Port = $port;                                    // TCP port to connect to

        $mail->From = $from['address'];
        $mail->FromName = $from['name'];
        return $mail;

    }*/

    public static function FileSizeConvert($bytes)
    {
        $bytes = floatval($bytes);
        $arBytes = array(
            0 => array(
                "UNIT" => "TB",
                "VALUE" => pow(1024, 4)
            ),
            1 => array(
                "UNIT" => "GB",
                "VALUE" => pow(1024, 3)
            ),
            2 => array(
                "UNIT" => "MB",
                "VALUE" => pow(1024, 2)
            ),
            3 => array(
                "UNIT" => "KB",
                "VALUE" => 1024
            ),
            4 => array(
                "UNIT" => "B",
                "VALUE" => 1
            ),
        );

        foreach($arBytes as $arItem)
        {
            if($bytes >= $arItem["VALUE"])
            {
                $result = $bytes / $arItem["VALUE"];
                $result = str_replace(".", "," , strval(round($result, 2)))." ".$arItem["UNIT"];
                break;
            }
        }
        return $result;
    }

    /**  Array to CSV conversion
    /*
    Array
    (
        [0] => Array
        (
            [AreaPrefix] => 1
            [Country] => USA
            [Description] => USA-Fixed-Others
            [NoOfCalls] => 6
            [Duration] => 12:34
            [BillDuration] => 12:34
            [TotalCharges] => .24650
            [Trunk] => Other
        )
     )
     */
    static function array_to_csv($array = array()){
        $output = "";
        if(count($array)) {
            $keys = array_keys($array[0]);
            $output .= implode(",", $keys) . PHP_EOL;
            foreach ($array as $key => $row) {
                $values = array_values($row);
                if (count($values)) {
                    $output .= implode(",", $values) . PHP_EOL;
                }

            }
        }
        return $output;




    }

    static function email_log($data){
        $status = array('status' => 0, 'message' => 'Something wrong with Saving log.');
        if(!isset($data['User']) && empty($data['User'])){
            $status['message'] = 'User object not set in Account mail log';
            return $status;
        }
        if(!isset($data['EmailFrom']) && empty($data['EmailFrom'])){
            $status['message'] = 'Email From not set in Account mail log';
            return $status;
        }
        if(!isset($data['Subject']) && empty($data['Subject'])){
            $status['message'] = 'Subject not set in Account mail log';
            return $status;
        }
        if(!isset($data['Message']) && empty($data['Message'])){
            $status['message'] = 'Message not set in Account mail log';
            return $status;
        }
        if(!isset($data['ProcessID']) && empty($data['ProcessID'])){
            $status['message'] = 'ProcessID not set in Account mail log';
            return $status;
        }
        if(!isset($data['JobID']) && empty($data['JobID'])){
            $status['message'] = 'JobID not set in Account mail log';
            return $status;
        }
        $user = $data['User'];
        if(is_array($data['EmailTo'])){
            $data['EmailTo'] = implode(',',$data['EmailTo']);
        }
		
		if(!isset($data['message_id'])){
			$data['message_id'] = '';
		}
		
        $logData = ['EmailFrom'=>$data['EmailFrom'],
                    'EmailTo'=>$data['EmailTo'],
                    'Subject'=>$data['Subject'],
                    'Message'=>$data['Message'],
                    'AccountID'=>$data['AccountID'],
                    'CompanyID'=>$user->CompanyID,
                    'ProcessID'=>$data['ProcessID'],
                    'JobID'=>$data['JobID'],
                    'UserID'=>$user->UserID,
					"MessageID"=>$data['message_id'],
                    'CreatedBy'=>$user->FirstName.' '.$user->LastName];
        if(!empty($data['EmailType'])){
            $logData['EmailType'] = $data['EmailType'];
        }
        try {
            if ($AccountEmailLog = AccountEmailLog::Create($logData)) {
                $status['status'] = 1;
                $status['AccountEmailLog'] = $AccountEmailLog;
            }
        } catch (\Exception $e) {
            $status['status'] = 0;
        }
        return $status;
    }
    public static function EmailsendCDRFileReProcessed($CompanyID,$ErrorEmail,$JobTitle,$renamefilenames){
        $ComanyName = Company::getName($CompanyID);
        $emaildata['CompanyID'] = $CompanyID;
        $emaildata['CompanyName'] = $ComanyName;
        $emaildata['EmailTo'] = $ErrorEmail;
        $emaildata['EmailToName'] = '';
        $emaildata['Subject'] = 'CronJob has ReProcessed CDR Files';
        $emaildata['JobTitle'] = $JobTitle;
        $emaildata['Message'] = 'Please check this files are reprocess <br>'.implode('<br>',$renamefilenames);
        Log::info(' rename files');
        Log::info($renamefilenames);
        $result = Helper::sendMail('emails.cronjoberroremail', $emaildata);
    }
    public static function errorFiles($CompanyID,$ErrorEmail,$JobTitle,$errorfilenames){
        $ComanyName = Company::getName($CompanyID);
        $emaildata['CompanyID'] = $CompanyID;
        $emaildata['CompanyName'] = $ComanyName;
        $emaildata['EmailTo'] = $ErrorEmail;
        $emaildata['EmailToName'] = '';
        $emaildata['Subject'] = 'CronJob File Has Errors while Reading';
        $emaildata['JobTitle'] = $JobTitle;
        $emaildata['Message'] = 'Please check this file has error <br>'.$errorfilenames;
        Log::info(' error files');
        Log::info($errorfilenames);
        $result = Helper::sendMail('emails.cronjoberroremail', $emaildata);
    }

    public static function get_round_decimal_places($CompanyID = 0,$AccountID = 0,$ServiceID=0) {
        $RoundChargesAmount = 2;
        if($AccountID>0){
            $RoundChargesAmount = AccountBilling::getRoundChargesAmount($AccountID,$ServiceID);
        }

        if (empty($RoundChargesAmount)) {
            $value = CompanySetting::getKeyVal($CompanyID,'RoundChargesAmount');
            $RoundChargesAmount = ($value !='Invalid Key')?$value:2;
        }
        return $RoundChargesAmount;
    }

    public static function account_email_log($CompanyID,$AccountID,$emaildata,$status,$User='',$ProcessID='',$JobID=0,$EmailType=0){
        if(empty($User)) {
            $Company = Company::find($CompanyID);
            $User = User::getDummyUserInfo($CompanyID, $Company);
        }
		$status['message_id'] 	=  isset($status['message_id'])?$status['message_id']:"";
        $logData = ['AccountID' => $AccountID,
            'ProcessID' => $ProcessID,
            'JobID' => $JobID,
            'User' => $User,
            'EmailType' => $EmailType,
            'EmailFrom' => $User->EmailAddress,
            'EmailTo' => $emaildata['EmailTo'],
            'Subject' => $emaildata['Subject'],
            'Message' => $status['body'],
			"message_id"=>$status['message_id']
			];
        $statuslog = Helper::email_log($logData);
        return $statuslog;
    }

   public static function create_replace_array($Account,$extra_settings,$JobLoggedUser=array()){
       $replace_array = array();
       $replace_array['FirstName'] = $Account->FirstName;
       $replace_array['LastName'] = $Account->LastName;
       $replace_array['Email'] = $Account->Email;
       $replace_array['Address1'] = $Account->Address1;
       $replace_array['Address2'] = $Account->Address2;
       $replace_array['Address3'] = $Account->Address3;
       $replace_array['City'] = $Account->City;
       $replace_array['State'] = $Account->State;
       $replace_array['PostCode'] = $Account->PostCode;
       $replace_array['Country'] = $Account->Country;
       $replace_array['OutstandingIncludeUnbilledAmount'] = AccountBalance::getBalanceAmount($Account->AccountID);
       $replace_array['BalanceThreshold'] = AccountBalance::getBalanceThreshold($Account->AccountID);
       $replace_array['Currency'] = Currency::getCurrencyCode($Account->CurrencyId);
       $replace_array['CurrencySign'] = Currency::getCurrencySymbol($Account->CurrencyId);
       $replace_array['CompanyName'] = Company::getName($Account->CompanyId);
	   $replace_array['CompanyVAT'] = Company::getCompanyField($Account->CompanyId,"VAT");
	   $replace_array['CompanyAddress'] = Company::getCompanyFullAddress($Account->CompanyId);
	   
	    $CompanyData						= Company::find($Account->CompanyId);	   
	    $replace_array['CompanyAddress1'] 	= $CompanyData->Address1;
		$replace_array['CompanyAddress2'] 	= $CompanyData->Address2;
		$replace_array['CompanyAddress3'] 	= $CompanyData->Address3;
		$replace_array['CompanyCity'] 		= $CompanyData->City;
		$replace_array['CompanyPostCode'] 	= $CompanyData->PostCode;
		$replace_array['CompanyCountry'] 	= $CompanyData->Country;
		$replace_array['Logo'] 				= combile_url_path(\App\Lib\CompanyConfiguration::get($Account->CompanyId,'WEB_URL'),'assets/images/logo@2x.png'); 		
		
        $domain_data  =     parse_url(\App\Lib\CompanyConfiguration::get($Account->CompanyId,'WEB_URL'));
		$Host		  = 	$domain_data['host'];
        $result       =    \Illuminate\Support\Facades\DB::table('tblCompanyThemes')->where(["DomainUrl" => $Host,'ThemeStatus'=>\App\Lib\Themes::ACTIVE])->first();

        if(!empty($result)){
            if(!empty($result->Logo)){           
				 $path = AmazonS3::unSignedUrl($result->Logo,$Account->CompanyId);  
                        if(strpos($path, "https://") !== false){
							$replace_array['Logo'] = $path;
                        }else{
                            $file = $result->Logo;           
                            $replace_array['Logo'] = MakeWebUrl($Account->CompanyId,$file); 
                        }
				
            }
        }
	    $replace_array['Logo'] = '<img src="'.$replace_array['Logo'].'" />';
	   
       $replace_array['OutstandingExcludeUnbilledAmount'] = AccountBalance::getOutstandingAmount($Account->CompanyId,$Account->AccountID);
       $Signature = '';
       if(!empty($JobLoggedUser)){
           $emaildata['EmailFrom'] = $JobLoggedUser->EmailAddress;
           $emaildata['EmailFromName'] = $JobLoggedUser->FirstName.' '.$JobLoggedUser->LastName;
           if(isset($JobLoggedUser->EmailFooter) && trim($JobLoggedUser->EmailFooter) != '')
           {
               $Signature = $JobLoggedUser->EmailFooter;
           }
       }
       $replace_array['Signature']= $Signature;
       $extra_var = array(
           'InvoiceNumber' => '',
           'InvoiceGrandTotal' => '',
           'InvoiceOutstanding' => '',
       );
       $replace_array = $replace_array + array_intersect_key($extra_settings, $extra_var);

       return $replace_array;
   }
    public static function alert_email_log($AlertID,$AccountEmailLogID){
        $logData = [
            'AlertID' => $AlertID,
            'AccountEmailLogID' => $AccountEmailLogID,
            'SendBy' => 'RMScheduler',
            'send_at'=>date('Y-m-d H:i:s')
        ];
        $statuslog = AlertLog::create($logData);
        return $statuslog;
    }

    public static function ACD_ASR_CR($settings){

        if(!empty($settings['CompanyGatewayID'])) {
            foreach ($settings['CompanyGatewayID'] as $CompanyGatewayID) {
                $settings['GatewayNames'][] = CompanyGateway::where('CompanyGatewayID', $CompanyGatewayID)->pluck('Title');
            }
        }
        if(!empty($settings['CountryID'])) {
            foreach ($settings['CountryID'] as $CountryID) {
                $settings['CountryNames'][] = Country::getCountryName($CountryID);
            }
        }
        if(!empty($settings['TrunkID'])) {
            foreach ($settings['TrunkID'] as $TrunkID) {
                $settings['TrunkNames'][] = DB::table('tblTrunk')->where('TrunkID', $TrunkID)->pluck('Trunk');
            }
        }
        return $settings;
    }
	
	static function email_log_data_Ticket($data,$view = '',$status,$CompanyID){ 
	$EmailParent =	 0;
	if($data['TicketID']){
		//	$EmailParent =	TicketsTable::where(["TicketID"=>$data['TicketID']])->pluck('AccountEmailLogID');
	}

	
    $status_return = array('status' => 0, 'message' => 'Something wrong with Saving log.');
    if(!isset($data['EmailTo']) && empty($data['EmailTo'])){
        $status_return['message'] = 'Email To not set in Account mail log';
        return $status_return;
    }
    
    if(!isset($data['Subject']) && empty($data['Subject'])){
        $status_return['message'] = 'Subject not set in Account mail log';
        return $status_return;
    }
    if(!isset($data['Message']) && empty($data['Message'])){
        $status_return['message'] = 'Message not set in Account mail log';
        return $status_return;
    }

    if(is_array($data['EmailTo'])){
        $data['EmailTo'] = implode(',',$data['EmailTo']);
    }

    if(!isset($data['cc']))
    {
        $data['cc'] = '';
    }

    if(!isset($data['bcc']))
    {
        $data['bcc'] = '';
    }

    if(isset($data['AttachmentPaths']) && count($data['AttachmentPaths'])>0)
    {
        $data['AttachmentPaths'] = serialize($data['AttachmentPaths']);
    }
    else
    {
        $data['AttachmentPaths'] = serialize([]);
    }

    if($view!='')
    {
        $body = htmlspecialchars_decode(View::make($view, compact('data'))->render());
    }
    else
    {
        $body = $data['Message'];
    } 
	if(!isset($status['message_id']))
	{
		$status['message_id'] = '';
	} 
	if(!isset($data['EmailCall']))
	{
		$data['EmailCall'] = Messages::Sent;
	}

	if(isset($data['EmailFrom']))
	{
		$data['EmailFrom'] = $data['EmailFrom'];
	}else{
		$data['EmailFrom'] = User::get_user_email();
	}
	
    $logData = ['EmailFrom'=>$data['EmailFrom'],
        'EmailTo'=>$data['EmailTo'],
        'Subject'=>$data['Subject'],
        'Message'=>$body,
        'CompanyID'=>$CompanyID,
        'UserID'=>isset($data['UserID'])?$data['UserID']:0,
        'CreatedBy'=>"RMScheduler",
		"created_at"=>date("Y-m-d H:i:s"),
        'Cc'=>$data['cc'],
        'Bcc'=>$data['bcc'],
        "AttachmentPaths"=>$data['AttachmentPaths'],
		"MessageID"=>$status['message_id'],
		"EmailParent"=>isset($data['EmailParent'])?$data['EmailParent']:$EmailParent,
		"EmailCall"=>$data['EmailCall'],
    ];
    $data =  AccountEmailLog::insertGetId($logData);
    return $data;
}

}