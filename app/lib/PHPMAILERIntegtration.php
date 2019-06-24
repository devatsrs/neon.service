<?php 

namespace App\Lib;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Config;

class PHPMAILERIntegtration{ 

	public function __construct(){
	 } 


	public static function SetEmailConfiguration($config,$companyID,$data)
	{
		Config::set('mail.host',$config->SMTPServer);
		Config::set('mail.port',$config->Port);
		
		if(isset($data['EmailFrom'])){ 
			Config::set('mail.from.address',trim($data['EmailFrom']));
		}else{ 
			Config::set('mail.from.address',trim($config->EmailFrom));
		}
		
		if(isset($data['CompanyName'])){
			Config::set('mail.from.name',$data['CompanyName']);
		}else{
			Config::set('mail.from.name',$config->CompanyName);
		}
		Config::set('mail.encryption',($config->IsSSL==1?'ssl':'tls'));
		Config::set('mail.username',$config->SMTPUsername);
		Config::set('mail.password',  Crypt::decrypt($config->SMTPPassword));
		extract(Config::get('mail'));
	
		$mail = new \PHPMailer;
		//$mail->SMTPDebug = 1;
		//$mail->SMTPDebug = 3;                               // Enable verbose debug output
		$mail->isSMTP();                                      // Set mailer to use SMTP
		$mail->Host = $host;  // Specify main and backup SMTP servers
		$mail->SMTPAuth = true;                               // Enable SMTP authentication
		$mail->Username = $username;                 // SMTP username
		$mail->CharSet = 'UTF-8';
		$mail->Password = $password;                           // SMTP password
		$mail->SMTPSecure = $encryption;                            // Enable TLS encryption, `ssl` also accepted
	
		$mail->Port = $port;                                    // TCP port to connect to
		$mail->SetFrom(trim($from['address']), trim($from['name']));
		$mail->IsHTML(true);
		return $mail;		
	}	 
	
	public static function SendMail($view,$data,$config,$companyID='',$body)
	{
		if(empty($companyID)){
			 $companyID = User::get_companyID();
		}
		
		 $mail 		=   self::SetEmailConfiguration($config,$companyID,$data);
		 $status 	= 	array('status' => 0, 'message' => 'Something wrong with sending mail.');
	
		if(getenv('APP_ENV') != 'Production'){
			$data['Subject'] = 'Test Mail '.$data['Subject'];
		}
		$mail =  self::add_email_address($mail,$data,'EmailTo');
		$mail =  self::add_email_address($mail,$data,'cc');
		$mail =  self::add_email_address($mail,$data,'bcc');


		if(isset($data['In-Reply-To'])) {
			$mail->addCustomHeader('In-Reply-To', $data['In-Reply-To']);
		}

		if(isset($data["Auto-Submitted"])){
			$mail->addCustomHeader("Auto-Submitted","auto-generated");
		}
		//if(isset($data["Auto-Submitted"])){
			$mail->addCustomHeader("Auto-Submitted","auto-generated");
		//}

		$mail->MessageID = self::generate_email_message_id($data,$config);

		if(SiteIntegration::CheckIntegrationConfiguration(false,SiteIntegration::$imapSlug,$companyID))
		{
			$ImapData =  SiteIntegration::CheckIntegrationConfiguration(true,SiteIntegration::$imapSlug,$companyID);
			
			$mail->AddReplyTo($ImapData->EmailTrackingEmail, $config->CompanyName);
		}
			
		if(isset($data['attach'])){
			if(is_array($data['attach'])){
				foreach($data['attach'] as $attach){
					$mail->addAttachment($attach);
				}
			}else{
				$mail->addAttachment($data['attach']);
			}
        }

		$mail->Body = $mail->msgHTML($body);
		$mail->Subject = $data['Subject'];
		
		$emailto = is_array($data['EmailTo'])?implode(",",$data['EmailTo']):$data['EmailTo'];

		if (!$mail->send()) {
					$status['status'] = 0;
					$status['message'] .= $mail->ErrorInfo . ' ( Email Address: ' . $emailto . ')';					
		} else {
					$mail->clearAllRecipients();
					$status['status'] = 1;
					$status['message'] = 'Email has been sent';
					$status['body'] = $body;
					$status['message_id']	=	$mail->getLastMessageID(); 
		} 
		return $status;
	}
	
	static function add_email_address($mail,$data,$type='EmailTo') //type add,bcc,cc
	{
		if(isset($data[$type]))
		{
			if(!is_array($data[$type])){
				$email_addresses = explode(",",$data[$type]);
			}
			else{
				$email_addresses = $data[$type];
			}
	
			if(count($email_addresses)>0){
				foreach($email_addresses as $email_address){
					if($type=='EmailTo'){
						$mail->addAddress(trim($email_address));
					}
					if($type=='cc'){
						$mail->AddCC(trim($email_address));
					}
					if($type=='bcc'){
						$mail->AddBCC(trim($email_address));
					}
				}
			}
		}
		return $mail;
	}

	public static function generate_email_message_id($data,$config) {

		if (isset($data['EmailFrom'])) {
			$from = $data['EmailFrom'];
		} else {
			$from = $config->EmailFrom;
		}

		if(isset($data["Message-ID"]) && !empty($data["Message-ID"])) {
			$message_id		  = $data["Message-ID"] .'_'.  \Illuminate\Support\Str::random(32) . ''. $from;
		} else {
			$message_id		  =  md5(time().$config->EmailFrom) . ''. $from ;
		}

		return "<".$message_id .">";

	}

}
?>