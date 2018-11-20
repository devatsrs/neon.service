<?php 
namespace App\Lib;
use App\Lib\TicketsTable;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use App\Lib\User;
use App\Lib\Lead;
use Carbon\Carbon;
use Illuminate\Support\Facades\Log;
use App\Lib\AccountEmailLog;
use App\Lib\Contact;
use Validator;
use App\Lib\EmailMessage;

class Imap{

protected $email;
protected $password;
protected $status;
protected $server;

	 public function __construct($data = array()){
		 foreach($data as $key => $value){
			 $this->$key = $value;
		 }
	 }
	 

	function ReadAttachments($emailMessage,$email_number,$CompanyID)
	{
		$attachmentsDB = array();

		$attachments = $emailMessage->attachments;

		if(count($attachments) > 0) {
			/* iterate through each attachment and save it */
			foreach ($attachments as $attachment) {
				// not inline image , only attachment
				if (!$attachment['inline']) {

					$filename = imap_mime_header_decode($attachment['filename'])[0]->text;

					$file_detail = $this->store_email_file($filename, $attachment['data'], $email_number, $CompanyID);

					$attachmentsDB[] = $file_detail;
				}
			}
		}
		/* attachments code end... */
		return $attachmentsDB;			
	}
	
	function GetEmailtxt($email)
	{
		$pos 	= 	strpos($email, "<");	
		if($pos){			
		  $first = explode("<",$email);
		  if(count($first)>0){
			 $second = explode(">",$first[1]);
			 return $second[0];
		   }		
		}else{
				return $email;
		}	
	}

    function GetNametxt($email)
    {
        $pos 	= 	strpos($email, "<");
        if($pos){
            $first = explode("<",$email);
            if(count($first)>0){
              return  $first[0];
            }
        }else{
            return $email;
        }
    }
	
	function GetCC($str){
		$cc = array();
		if(count($str)>0 && is_array($str)){
			foreach($str as $strData){
				$cc[] = $strData->mailbox.'@'.$strData->host;
			}
		}
		return implode(",",$cc);		
	}
	
	function GetMessageBody($msg){
		$doc = new \DOMDocument();
		$mock = new \DOMDocument;
		libxml_use_internal_errors(true);
		// load the HTML into the DomDocument object (this would be your source HTML)
		$doc->loadHTML(mb_convert_encoding($msg, 'HTML-ENTITIES', 'UTF-8'));
		$this->removeElementsByTagName('script', $doc);
		$this->removeElementsByTagName('style', $doc); 
		//removeElementsByTagName('link', $doc);
		$body = $doc->getElementsByTagName('body')->item(0);
		if(isset($body->childNodes)){
			foreach ($body->childNodes as $child){
				$mock->appendChild($mock->importNode($child, true));
			}	
		}
		// output cleaned html
		$msg = $mock->saveHtml();	
		return $msg;	
	}	
	
	static	function CheckConnection($server,$email,$password){
		try{
			imap_open("{".$server."}", $email, $password);
			//return true;
			return array("status"=>1,"error"=>0);
		} catch (\Exception $e) {
			Log::error("could not connect");
			Log::error($e);			
			return array("status"=>0,"error"=>$e);
			//return false;
		}   		
	}	
	
	function	SetEmailType($email,$CompanyID)
	{ 
		$final				  =	 	 array();
		$MatchArray  		  =      $this->findEmailAddress($email);
		
		if(count($MatchArray)>0){
			if($MatchArray['MatchType']=='Contact'){
				$final = array("ContactID"=>$MatchArray['MatchID'],"AccountID"=>0,"UserID"=>0);
			}
			
			if($MatchArray['MatchType']=='Account' || $MatchArray['MatchType']=='Lead'){
				$final = array("ContactID"=>0,"AccountID"=>$MatchArray['MatchID'],"UserID"=>0);
			}
			
			if($MatchArray['MatchType']=='User'){
				$final = array("ContactID"=>0,"AccountID"=>0,"UserID"=>$MatchArray['MatchID']);
			}
		}
		return $final;
	}
	
	function findEmailAddress($email)
	{
		$AccountTitle 	= 	'';
		$MatchID		=	0;
		$MatchType		=	'';
		$AccountID		=	0;

		//find in account(email,billing email), Email
		$AccountSearch1  =  DB::table('tblAccount')->whereRaw("find_in_set('".$email."',Email) OR find_in_set('".$email."',BillingEmail)")->get(array("AccountID","AccountName","AccountType"));
		$ContactSearch 	 =  DB::table('tblContact')->whereRaw("find_in_set('".$email."',Email)")->get(array("Owner","ContactID","FirstName","LastName"));		
		
		if(count($AccountSearch1)>0)													
		{
			if(count($AccountSearch1)>0)													
			{
				if($AccountSearch1[0]->AccountType==1)
				{
					$MatchType	 =   'Account';
				}else{
					$MatchType	 =   'Lead';
				}
				
				$MatchID	  =	 $AccountSearch1[0]->AccountID;
				$AccountTitle =  $AccountSearch1[0]->AccountName;
				$AccountID	  =  $AccountSearch1[0]->AccountID;							
			}		
		}
		
		if(count($ContactSearch)>0 || count($ContactSearch)>0)													
		{	 
				$MatchType	  =   'Contact';
				$MatchID	  =	 $ContactSearch[0]->ContactID;					
				$AccountID	  =  $ContactSearch[0]->Owner;
				//$Accountdata  =  
				$Accountdata  =   DB::table('tblAccount')->where(["AccountID" => $AccountID])->get(array("AccountName")); 
				$Accountname  =   isset($Accountdata[0]->AccountName)?' ('.($Accountdata[0]->AccountName).')':'';
				$AccountTitle =   $ContactSearch[0]->FirstName.' '.$ContactSearch[0]->LastName.$Accountname;							
		}				
		
		$UserSearch 	 =  DB::table('tblUser')->where(['EmailAddress'=>$email])->get(array("UserID","FirstName","LastName"));		
		
		if(count($UserSearch)>0 || count($UserSearch)>0)													
		{	 
				$MatchType	  =   'User';
				$MatchID	  =	 $UserSearch[0]->UserID;					
				$AccountTitle =  $UserSearch[0]->FirstName.' '.$UserSearch[0]->LastName;	
				$AccountID    =  0;
		}			 
        
		return array('MatchType'=>$MatchType,'MatchID'=>$MatchID,"AccountTitle"=>$AccountTitle,"AccountID"=>$AccountID);        
	}
	
	function getBody($imap,$uid) {
	$uid  =  imap_uid ($imap,$uid); //getting mail uid
    $body = $this->get_part($imap, $uid, "TEXT/HTML"); 
    // if HTML body is empty, try getting text body
    if ($body == "") {
        $body = nl2br($this->get_part($imap, $uid, "TEXT/PLAIN"));
    }
		return $body;
    }

    function get_part($imap, $uid, $mimetype, $structure = false, $partNumber = false){
    if (!$structure) {
			try{
				$structure = imap_fetchstructure($imap, $uid, FT_UID);
			} catch ( \Exception $ex ) {
				Log::error("Error in imap_fetchstructure");
				Log::error(print_r($ex,true));
			}
    }
    if ($structure) {
        if ($mimetype == $this->get_mime_type($structure)) {
            if (!$partNumber) {
                $partNumber = 1;
            }
            $text = imap_fetchbody($imap, $uid, $partNumber, FT_UID);
            switch ($structure->encoding) {
                case 3: return imap_base64($text);
                case 4: return imap_qprint($text);
                default: return $text;
           }
       }

        // multipart
        if ($structure->type == 1) {
            foreach ($structure->parts as $index => $subStruct) {
                $prefix = "";
                if ($partNumber) {
                    $prefix = $partNumber . ".";
                }
                $data = $this->get_part($imap, $uid, $mimetype, $subStruct, $prefix.($index + 1));
                if ($data) {
                    return $data;
                }
            }
        }
    }
    return false;
    }

    function get_mime_type($structure) {
        $primaryMimetype = array("TEXT", "MULTIPART", "MESSAGE", "APPLICATION",    "AUDIO", "IMAGE", "VIDEO", "OTHER");

        if ($structure->subtype) {
           return $primaryMimetype[(int)$structure->type] . "/" . $structure->subtype;
        }
        return "TEXT/PLAIN";
    }  
	function removeElementsByTagName($tagName, $document) {
	  $nodeList = $document->getElementsByTagName($tagName);
	  for ($nodeIdx = $nodeList->length; --$nodeIdx >= 0; ) {
		$node = $nodeList->item($nodeIdx);
		$node->parentNode->removeChild($node);
	  }
	}

	/**
	 * For Gmail
	 * IMAP Server : imap.gmail.com:993/imap/ssl
	 * Allow Less secure apps :  ON by following url
	 * https://myaccount.google.com/lesssecureapps?rfn=27&rfnc=1&eid=284774310474942540&et=0&asae=2&pli=1
	 * @param $CompanyID
	 * @param $server
	 * @param $email
	 * @param $password
	 * @param $GroupID
	 * @throws \Exception
	 */

	// Microsoft shared office 365 fix
	//https://github.com/Webklex/laravel-imap/issues/100 version 		"webklex/laravel-imap": "1.1.2"
	//https://github.com/Webklex/laravel-imap/issues/78
	//https://stackoverflow.com/questions/28481028/access-office356-shared-mailbox-with-php
	function ReadTicketEmails($CompanyID,$server,$port,$IsSsl,$email,$password,$GroupID){
		$AllEmails  =   Messages::GetAllSystemEmails();
		$objEmailClient = new EmailClient(array('username'=>$email,"host"=>$server,"port"=>$port,"IsSSL"=>$IsSsl,"password"=>$password));
		$connected=$objEmailClient->connect();
		if($connected){
			Log::info("connectiong:".$email);
			$aFolder = $connected->getFolders(false,"INBOX");
			$group_email = $email;
			foreach($aFolder as $oFolder){
				if($oFolder->fullName!="INBOX"){
					continue;
				}
				$LastEmailReadDateTime = TicketGroups::getLatestTicketEmailReceivedDateTime($CompanyID,$GroupID);

				if(!empty($LastEmailReadDateTime)){
					$LastEmailReadDateTime = date("Y-m-d H:i:s", strtotime("-1 Hour ",strtotime($LastEmailReadDateTime)));
					Log::info("LastEmailReadDateTime - " . $LastEmailReadDateTime);

					$emails = $oFolder->searchMessages([['SINCE', Carbon::parse('' . $LastEmailReadDateTime . '')->format('d M y H:i:s')]]);

				} else {
					$emails = $oFolder->searchMessages([['UNSEEN']]);
				}
				try {

					foreach ($emails as $email) {
						Log::info("reading emails");

						$from = $email->getFrom();
						$priority	=  1;
						$FromName = $from[0]->personal;
						$fromMail = $from[0]->mail;
						$MailDateTime = date('Y-m-d H:i:s', strtotime($email->getDate()));
						$sender = Imap::dataDecode($email->getSender());
						$senderName = $sender[0]->personal;
						$to = $email->getTo();
						if(!empty($to) && isset($to[0]))
							$toMail=$to[0]->mail;
						else
							$toMail=$group_email;

						$MessageId = '<'.$email->getMessageId().'>';
						$aAttachmentCount = $email->getAttachments()->count();
						$cc = $email->getCc();
						$cc = EmailServiceProvider::getCC($cc);
						$cc_ = TicketEmails::remove_group_emails_from_array($CompanyID,explode(", ",$cc));
						$cc  = implode(",",$cc_);
						$bcc = $email->getBcc();
						$bcc = EmailServiceProvider::getCC($bcc);
						$bcc = TicketEmails::remove_group_emails_from_array($CompanyID,explode(", ",$bcc));
						$bcc = implode(",",$bcc);
						$in_reply_to = $email->getInReplyTo();
						if(!empty($in_reply_to)){
							$in_reply_to = '<'.$in_reply_to.'>';
						}
						$references   = explode(' ',$email->getReferences());						
						$Subject = $email->getSubject();
						$header = $email->getHeader();
						$message = 	$email->getHTMLBody(true);
						$message = trim($message);
						if(!$email->hasHTMLBody() || empty($message)){
							$message = 	"<pre>".$email->getTextBody()."</pre>";
						}
						$Extra = $message;

						Log::info("Subject -  " . $Subject);

						$Subject = Imap::dataDecode($Subject);
						Log::info("decode_Subject -  " . $Subject);

						Log::info("email_received_date - " . $MailDateTime);

						if(!empty($MessageId) && AccountEmailLogDeletedLog::where(["CompanyID"=>$CompanyID , "MessageID"=>$MessageId])->count() > 0){
							Log::info("Message id is exist in deleted tickets : ".$MessageId);
							continue;
						}else if(empty($MessageId) && AccountEmailLog::where(["CompanyID"=>$CompanyID, "EmailFrom"=>$fromMail, "Subject"=>trim($Subject) ])->count() > 0){
							Log::info("checking Subject Already Exists ");
							Log::info("Email Subject Already Exists.");
							continue;
						}else if(empty($MessageId)){
							$MessageId = $this->generate_random_message_id($fromMail);
							Log::info("New MessageID " . $MessageId);
						}

						// need to check for messageID already exists or not
						// if message id is blank , make sure to set random messageId before sending
						if ($msg_parent = AccountEmailLog::where(["CompanyID"=>$CompanyID, "MessageID"=>$MessageId])->count() > 0){
							Log::info("Email Already Exists");
							continue;
						}

						Log::info("NEW Subject -  " . $Subject);


						//-- check in reply to with previous email
						// if exists then don't check for auto reply
						if(!empty($in_reply_to)){
							$msg_parent   	=		AccountEmailLog::where("MessageID",$in_reply_to)->first();
							if(empty($msg_parent)){								
								$msg_parent   	=		AccountEmailLog::whereRaw("FIND_IN_SET('".$in_reply_to."', CcMessageID)")->first();
							}
							if(!empty($msg_parent) && isset($msg_parent->AccountEmailLogID)){
								$tblTicketCount = TicketsTable::where(["TicketID"=>$msg_parent->TicketID])->count();
								if($msg_parent->TicketID > 0 && $tblTicketCount == 0 ) {
									$msg_parent = '';
								}
							}
						}
						Log::info("in_reply_to");
						Log::info($in_reply_to);
						
						if(empty($msg_parent)){
							foreach($references as $references_id){
								if(!empty($references_id)){
									$msg_parent   	=		AccountEmailLog::where("MessageID",$references_id)->first();
									if(empty($msg_parent)){
										$msg_parent   	=		AccountEmailLog::whereRaw("FIND_IN_SET('".$references_id."', CcMessageID)")->first();
									}
									if(!empty($msg_parent) && isset($msg_parent->AccountEmailLogID)){
										$tblTicketCount = TicketsTable::where(["TicketID"=>$msg_parent->TicketID])->count();
										if($msg_parent->TicketID > 0 && $tblTicketCount > 0 ) {
											break;
										}
										if($msg_parent->TicketID > 0 && $tblTicketCount == 0 ) {
											$msg_parent = '';
											break;
										}
									}
								}
							}
						}
						Log::info("references");
						Log::info(print_r($references, true));
						Log::info("msg_parent");
						Log::info(print_r($msg_parent, true));

						//$msg_parentconversation   	=		  TicketsConversation::where("MessageID",$in_reply_to)->first();
						// Split on \n  for priority
						$h_array					=		  explode("\n",$header);						

						/*Log::info("h_array");
                        Log::info(print_r($h_array,true));

                        Log::info("body");
                        $message = 	($this->getBody($inbox,$email_number));  //get body from email
                        Log::info($message);

                        $message = imap_fetchbody($inbox,$email_number,1);
                        Log::info($message);*/
						foreach ( $h_array as $h ) {
							// Check if row start with a char
							if ( preg_match("/^[A-Z]/i", $h )) {
								$tmp 					= 	explode(":",$h);
								$header_name 		    = 	$tmp[0];
								$header_value 			= 	$tmp[1];
								$headers[$header_name] 	= 	$header_value;
							}

						}
						if(isset($headers['X-Priority']) && $headers['X-Priority']!=''){
							$prioritytxt  =  explode("X-Priority ",$headers['X-Priority']);
							$prioritytxt2 =  explode(" (",$prioritytxt[0]);
							$priority	  =	isset(Messages::$EmailPriority[trim($prioritytxt2[0])])?Messages::$EmailPriority[trim($prioritytxt2[0])]:1;
						}

						//If parent email is not found based on in_reply_to						
						if(empty($msg_parent)){

							// http://staging.neon-soft.com/tickets/19/detail
							//https://email09.godaddy.com/view_print_multi.php?uidArray=26391|INBOX&aEmlPart=0


							//Match the subject with all emails.
							$original_plain_subject = $this->get_original_plain_subject($Subject);							
							if(!empty($original_plain_subject)){
								$msg_parent = AccountEmailLog::whereRaw(" created_at >= DATE_ADD(now(), INTERVAL -1 Month )   ")->where(["CompanyID"=>$CompanyID, "EmailFrom"=>$fromMail,"EmailTo"=> $toMail,  "Subject"=>trim($original_plain_subject)])->first();
								if(!$msg_parent) {
									$msg_parent = AccountEmailLog::whereRaw(" created_at >= DATE_ADD(now(), INTERVAL -1 Month )   ")->where(["CompanyID"=>$CompanyID, "EmailFrom"=>$fromMail,"EmailTo"=> $toMail,  "Subject"=>trim($Subject)])->first();
								}
								if(isset($msg_parent->TicketID) && $msg_parent->TicketID > 0 && TicketsTable::where(["TicketID"=>$msg_parent->TicketID])->count() == 0 ) {
									$msg_parent = "";
								}
							}
						}


						if(!empty($msg_parent)){
							if($msg_parent->EmailParent==0){
								$parent = $msg_parent->AccountEmailLogID;
							}else{
								$parent = $msg_parent->EmailParent;
							}
							$parent_UserID  =  $msg_parent->UserID;
							$parentTicket 	=  $msg_parent->TicketID;

							/*else if(!empty($msg_parentconversation)){
                                $parent = $msg_parent->TicketID;
                            }*/
						}else{							    //new ticket
							$parent 			  = 	 0; // no parent by default
							$parent_UserID  	  =      0;
							$parentTicket		  =		 0;
						}
						
						if(!$parentTicket){
							$reply_array = explode("__",$in_reply_to);
							if(count($reply_array) == 3){
								$ticketnumber 	 = base64_decode($reply_array[1]);
								$ticketReq 		 = base64_decode($reply_array[2]);
								$replyTicketData = TicketsTable::where(["TicketID"=>$ticketnumber,"Requester"=>$ticketReq])->first();

								if($replyTicketData){
									$parentTicket = $replyTicketData->TicketID;
								}
							}
						}
						
						$upload_path = CompanyConfiguration::get($CompanyID,'UPLOAD_PATH');
						$attachmentsDB =  array();
						if($aAttachmentCount>0) {
							$aAttachment = $email->getAttachments();							
							foreach ($aAttachment as $oAttachment) {
								$path_parts = pathinfo(Imap::dataDecode($oAttachment->getName()));
								if(!array_key_exists("extension", $path_parts)){
									$path_parts["extension"]="";
								}
								$file_name = $path_parts["filename"] . '-'. date("YmdHis") . '.' . $path_parts["extension"];
								$amazonPath = AmazonS3::generate_upload_path(AmazonS3::$dir['EMAIL_ATTACHMENT'],'',$CompanyID);

								$fullPath = $upload_path . "/". $amazonPath;
								$filepath2  =  $amazonPath .'/'. $file_name;

								$oAttachment->save($fullPath, $file_name);
								if(is_amazon($CompanyID)) {
									if(!AmazonS3::upload($fullPath.$file_name,$amazonPath,$CompanyID)){
										throw new Exception('Error in Amazon upload');
									}
								}
								$attachmentsDB[] = array("filename"=>$file_name,"filepath"=>$filepath2);

							}
						}
						
						if(isset($attachmentsDB) && count($attachmentsDB)>0){
							$AttachmentPaths  =		serialize($attachmentsDB);
						}else{
							$AttachmentPaths  = 	serialize([]);
						}
						
						$checkRepeatedEmailsData = [
							"from" => $fromMail,
							"GroupID" => $GroupID,
						];
						
						if( TicketsTable::checkRepeatedEmails($CompanyID,$checkRepeatedEmailsData) ) {

							Log::info( "Repeated Emails skipped" );
							Log::info( "Repeated Emails skipped From " . $fromMail );
							Log::info( "Repeated Emails skipped Subject " . $Subject );
							Log::info( "Repeated Emails skipped MessageID " . $MessageId );
							//continue;
						}

						
						$check_auto = $this->check_auto_generated($header,$message);						
						if($check_auto && empty($msg_parent)){

							$AlreadyJunk  = JunkTicketEmail::where(["CompanyID"=>$CompanyID , "MessageID" => $MessageId])->count();
							if($AlreadyJunk > 0 ) {
								$logData = [
									'CompanyID' => $CompanyID,
									'From' => $fromMail,
									"FromName" => $FromName,
									"EmailTo" => $toMail,
									"Cc" => $cc,
									'Subject' => $Subject,
									'Message' => $message,
									"MessageID" => $MessageId,
									"EmailParent" => $parent,
									"AttachmentPaths" => $AttachmentPaths,
									"Extra" => json_encode($Extra),
									//"TicketID"=>$ticketID,
									"created_at" => date('Y-m-d H:i:s'),
									"created_by" => 'RMScheduler : AutoResponse Detected',
								];
								$JunkTicketEmailID = JunkTicketEmail::add($logData);
								Log::info("Junk Ticket Email " . $JunkTicketEmailID);

							} else {
								Log::info("Junk Ticket Email Already Exists with MessageID - " . $MessageId);
							}
							Log::info("Auto Responder Detected :");
							Log::info("header");
							Log::info($header);

							TicketGroups::where(["GroupID"=>$GroupID, "CompanyID" => $CompanyID])->update(["LastEmailReadDateTime"=> date("Y-m-d H:i:s",strtotime($MailDateTime))]);
							continue;
						}

						$logData = [
							'Requester'=> $fromMail,
							"RequesterName"=>$FromName,
							"RequesterCC"=>$cc,
							"RequesterBCC"=>$bcc,
							'Subject'=>$Subject,
							'Description'=>$message,
							'CompanyID'=>$CompanyID,
							"AttachmentPaths"=>$AttachmentPaths,
							"Group"=>$GroupID,
							"created_at"=>date('Y-m-d H:i:s'),
							"Priority"=>$priority,
							"Status"=> TicketsTable::getOpenTicketStatus(),
							"created_by"=> 'RMScheduler'
						];						
						$MatchArray  		  =     $this->SetEmailType($fromMail,$CompanyID);

						$skip_email_notification = false;
						if(!$parentTicket){
							// New ticket

							$logData 		 	  = 	array_merge($logData,$MatchArray);

							$ticketID 			  =  	TicketsTable::insertGetId($logData);

							// --------------- check for TicketImportRule ----------------
							//@TODO: add all the data which TicketImportRule::check function requires
							$ticketRuleData = array_merge($logData,["TicketID"=>$ticketID,"EmailTo"=>$toMail,"Group"=>$GroupID]);
							try{
								$TicketImportRuleResult = TicketImportRule::check($CompanyID,$ticketRuleData);
							} catch ( \Exception $ex){

								Log::error("Error in TicketImportRule::check on TicketID " . $ticketID);
								Log::error("TicketRuleData");
								Log::error(print_r($ticketRuleData,true));
								Log::error(print_r($ex,true));
							}

							if(is_array($TicketImportRuleResult)) {
								if (in_array(TicketImportRuleActionType::DELETE_TICKET,$TicketImportRuleResult)) {

									$logData = [
										'CompanyID'=>$CompanyID,
										'From'=> $fromMail,
										"FromName"=>$FromName,
										"EmailTo"=>$toMail,
										"Cc"=>$cc,
										'Subject'=>$Subject,
										'Message'=>$message,
										"MessageID"=>$MessageId,
										"EmailParent" => $parent,
										"AttachmentPaths"=>$AttachmentPaths,
										"Extra"=> json_encode($Extra),
										"TicketID"=>$ticketID,
										"created_at"=>date('Y-m-d H:i:s'),
										"created_by"=> 'RMScheduler : TicketImportRuleActionType::DELETE_TICKET',
									];
									$JunkTicketEmailID   =  JunkTicketEmail::add($logData);
									Log::info("Junk Ticket Email " . $JunkTicketEmailID);


									Log::info("TicketImportRuleAction TicketDeleted");

									TicketGroups::where(["GroupID"=>$GroupID, "CompanyID" => $CompanyID])->update(["LastEmailReadDateTime"=> date("Y-m-d H:i:s",strtotime($MailDateTime))]);
									continue;
								} else if (in_array(TicketImportRuleActionType::SKIP_NOTIFICATION, $TicketImportRuleResult)) {
									Log::info("TicketImportRuleAction SKIP_NOTIFICATION");
									$skip_email_notification = true;
								} else {
									Log::info("TicketImportRuleAction Result");
									Log::info($TicketImportRuleResult);
								}
							}
						}
						else //reopen ticket if ticket status closed
						{

							$ticketData  = TicketsTable::find($parentTicket);

							$ticketID = $ticketData->TicketID;
							// --------------- check for TicketImportRule ----------------
							$ticketRuleData = array_merge($logData,["TicketID"=>$ticketData->TicketID,"EmailTo"=>$toMail,"Group"=>$GroupID]);
							try{
								$TicketImportRuleResult = TicketImportRule::check($CompanyID,$ticketRuleData);
							} catch ( \Exception $ex){

								Log::error("Error in TicketImportRule::check on TicketID " . $ticketID);
								Log::error("TicketRuleData");
								Log::error(print_r($ticketRuleData,true));
								Log::error(print_r($ex,true));
							}

							if(is_array($TicketImportRuleResult)) {
								if (in_array(TicketImportRuleActionType::DELETE_TICKET,$TicketImportRuleResult)) {

									$logData = [
										'CompanyID'=>$CompanyID,
										'From'=> $fromMail,
										"FromName"=>$FromName,
										"EmailTo"=>$toMail,
										"Cc"=>$cc,
										'Subject'=>$Subject,
										'Message'=>$message,
										"MessageID"=>$MessageId,
										"EmailParent" => $parent,
										"AttachmentPaths"=>$AttachmentPaths,
										"Extra"=> json_encode($Extra),
										"TicketID"=>$ticketData->TicketID,
										"created_at"=>date('Y-m-d H:i:s'),
										"created_by"=> 'RMScheduler : TicketImportRule TicketImportRuleActionType::DELETE_TICKET',
									];
									$JunkTicketEmailID   =  JunkTicketEmail::add($logData);
									Log::info("Junk Ticket Email " . $JunkTicketEmailID);

									Log::info("TicketImportRuleAction TicketDeleted");
									TicketGroups::where(["GroupID"=>$GroupID, "CompanyID" => $CompanyID])->update(["LastEmailReadDateTime"=> date("Y-m-d H:i:s",strtotime($MailDateTime))]);
									continue;
								} else if (in_array(TicketImportRuleActionType::SKIP_NOTIFICATION, $TicketImportRuleResult)) {
									Log::info("TicketImportRuleAction SKIP_NOTIFICATION");
									$skip_email_notification = true;
								} else {
									Log::info("TicketImportRuleAction Result");
									Log::info($TicketImportRuleResult);
								}
							}
							$ticketID		=	$ticketData->TicketID;

							//update cc and bcc in ticket
							if(!empty($cc) || !empty($bcc)) {
								$ticketdatacc =	TicketsTable::find($ticketData->TicketID);

								$update_cc 	= explode(',',$cc);
								$update_bcc 	= explode(',',$bcc);

								$ticketcc  = explode(',',$ticketdatacc->RequesterCC);
								$ticketbcc = explode(',',$ticketdatacc->RequesterBCC);

								$ticketcc  = implode(',',array_unique(array_merge(array_filter($ticketcc),array_filter($update_cc))));
								$ticketbcc = implode(',',array_unique(array_merge(array_filter($ticketbcc),array_filter($update_bcc))));

								$ticketdatacc->update(['RequesterCC'=>$ticketcc,'RequesterBCC'=>$ticketbcc]);
							}
						}
						$logData = ['EmailFrom'=> $fromMail,
							"EmailfromName"=>$FromName,
							'Subject'=>$Subject,
							'Message'=>$message,
							'CompanyID'=>$CompanyID,
							"MessageID"=>$MessageId,
							"EmailParent" => $parent,
							"AttachmentPaths"=>$AttachmentPaths,
//							"EmailID"=>$email_number,
							"EmailCall"=>Messages::Received,
							"UserID" => $parent_UserID,
							"created_at"=>date('Y-m-d H:i:s'),
							"EmailTo"=>$toMail,
							"CreatedBy"=> 'RMScheduler',
							"Cc"=>$cc,
							"Bcc"=>$bcc,
							"TicketID"=>$ticketID,
							"EmailType"=>AccountEmailLog::TicketEmail
						];

						$EmailLog   =  AccountEmailLog::insertGetId($logData);
						// -- Not New
						if($parentTicket){
							if(!$parent){
								AccountEmailLog::find($EmailLog)->update(["EmailParent"=>$EmailLog]);
							}
						}

						// update duedate immediately after ticket created...
						try {
							if(isset($ticketID)){
								TicketSla::assignSlaToTicket($CompanyID,$ticketID);
							}
						} catch (Exception $ex) {
							Log::info("fail TicketSla::assignSlaToTicket");
							Log::info($ex);
						}

						// New Ticket
						if(!$parentTicket)
						{
							TicketsTable::find($ticketID)->update(array("AccountEmailLogID"=>$EmailLog));


							if(!in_array($fromMail,$AllEmails))
							{
								$FromNameArray	   =  explode(" ",$FromName);
								$ContactFirstName  =  $FromNameArray[0];

								if(count($FromNameArray)>1)
								{
									unset($FromNameArray[0]);
									$ContactLastName  = implode(" ",$FromNameArray);
								}else{
									$ContactLastName  = '';
								}

								$ContactData = array("FirstName"=>$ContactFirstName,"LastName"=>$ContactLastName,"Email"=>$fromMail,"CompanyId"=>$CompanyID);
								$contactID =  Contact::insertGetId($ContactData);
								TicketsTable::find($ticketID)->update(array("ContactID"=>$contactID));
								$EmailLogObj = AccountEmailLog::find($EmailLog);
								$EmailLogObj->update(array("UserType"=>Messages::UserTypeContact,"ContactID"=>$contactID));
								$AllEmails[] = $fromMail;
							}
							else
							{
								$accountIDSave  =	0;
								$accountID   	=  DB::table('tblAccount')->where(array("Email"=>$fromMail))->pluck("AccountID");
								$accountID2  	=  DB::table('tblAccount')->where(array("BillingEmail"=>$fromMail))->pluck("AccountID");
								if($accountID){
									$accountIDSave = $accountID;
								}
								if($accountID2){
									$accountIDSave = $accountID2;
								}
								$EmailLogObj = AccountEmailLog::find($EmailLog);
								$AccountData =	Account::select('FirstName','LastName')->where("AccountID", '=', $accountIDSave)->first();
								if($AccountData){
									$EmailLogObj->update(array("AccountID"=>$accountIDSave,"CreatedBy" => $AccountData->FirstName.' '.$AccountData->LastName));
								}else{
									$ContactID 	 =  DB::table('tblContact')->where(array("Email"=>$fromMail))->pluck("ContactID");
									if($ContactID){
										$ContactData =		Contact::select('FirstName','LastName')->where("ContactID", '=', $ContactID)->first();
										$EmailLogObj->update(array("UserType"=>Messages::UserTypeContact,"ContactID"=>$ContactID,"CreatedBy" => $ContactData->FirstName.' '.$ContactData->LastName));
									}else {

										// Add contact
										$FromNameArray	   =  explode(" ",$FromName);
										$ContactFirstName  =  $FromNameArray[0];

										if(count($FromNameArray)>1)
										{
											unset($FromNameArray[0]);
											$ContactLastName  = implode(" ",$FromNameArray);
										}else{
											$ContactLastName  = '';
										}

										$ContactData = array("FirstName"=>$ContactFirstName,"LastName"=>$ContactLastName,"Email"=>$fromMail,"CompanyId"=>$CompanyID);
										$contactID =  Contact::insertGetId($ContactData);
										TicketsTable::find($ticketID)->update(array("ContactID"=>$contactID));

									}
								}
							}
						}


						//create log

						// if new ticket
						$log_data = [
							"CompanyID" => $CompanyID ,
							"TicketID" => $ticketID ,
						];
						if (isset($MatchArray["AccountID"]) && $MatchArray["AccountID"] > 0) {
							$log_data["ParentID"] = $MatchArray["AccountID"];
							$log_data["ParentType"] = TicketLog::TICKET_USER_TYPE_ACCOUNT;
							$TicketUserName = Account::where(["AccountID"=>$MatchArray["AccountID"]])->pluck('AccountName');

						} else if (isset($MatchArray["UserID"])  && $MatchArray["UserID"] > 0) {
							$log_data["ParentID"] = $MatchArray["UserID"];
							$log_data["ParentType"] = TicketLog::TICKET_USER_TYPE_USER;
							$TicketUserName = User::get_user_full_name($MatchArray["UserID"]);
						} else if (isset($MatchArray["ContactID"])  && $MatchArray["ContactID"] > 0 ) {
							$log_data["ParentID"] = $MatchArray["ContactID"];
							$log_data["ParentType"] = TicketLog::TICKET_USER_TYPE_CONTACT;
							$TicketUserName = Contact::get_full_name($MatchArray["UserID"]);
						}

						if(isset($log_data["ParentType"]) && isset($log_data["ParentID"]) ) {
							if (!$parentTicket) {
								$log_data["Action"] = TicketLog::TICKET_ACTION_CREATED;
								$log_data["ActionText"] = "Ticket Created by " . TicketLog::$TicketUserTypes[$log_data["ParentType"]] . " " . $TicketUserName;

								TicketLog::insertTicketLog($log_data);
							} else {
								$log_data["Action"] = TicketLog::TICKET_ACTION_CUSTOMER_REPLIED;
								$log_data["ActionText"] = "Ticket Replied by " . TicketLog::$TicketUserTypes[$log_data["ParentType"]] . " " . $TicketUserName;
								TicketLog::insertTicketLog($log_data);
							}
						}

						//Send Notification Emails
						if(!$parentTicket){

							if(!$skip_email_notification) {
								if ($GroupID) {
									new TicketEmails(array("TicketID" => $ticketID, "CompanyID" => $CompanyID, "TriggerType" => array("AgentAssignedGroup")));
								}
								new TicketEmails(array("TicketID" => $ticketID, "CompanyID" => $CompanyID, "TriggerType" => array("RequesterNewTicketCreated")));
								new TicketEmails(array("TicketID" => $ticketID, "TriggerType" => "CCNewTicketCreated", "CompanyID" => $CompanyID));
							}
						}
						else //reopen ticket if ticket status closed
						{
							if ($ticketData->Status == TicketsTable::getClosedTicketStatus() || $ticketData->Status == TicketsTable::getResolvedTicketStatus()
								||	$ticketData->Status == TicketsTable::getWaitingOnCustomerTicketStatus() ||	$ticketData->Status == TicketsTable::getWaitingOnThirdPartyTicketStatus()) {
								TicketsTable::find($ticketData->TicketID)->update(["Status" => TicketsTable::getOpenTicketStatus()]);
								if(!$skip_email_notification) {
									new TicketEmails(array("TicketID" => $ticketData->TicketID, "CompanyID" => $CompanyID, "TriggerType" => array("AgentTicketReopened")));
								}
							}
							if(isset($ticketData->Requester)){
								if($fromMail==$ticketData->Requester){
									if(!$skip_email_notification) {
										new TicketEmails(array("TicketID" => $ticketData->TicketID, "TriggerType" => "RequesterRepliestoTicket", "CompanyID" => $CompanyID, "Comment" => $message));
									}
									TicketsTable::find($ticketData->TicketID)->update(array("CustomerRepliedDate" => date('Y-m-d H:i:s')));
								}
							}
							if(!$skip_email_notification) {
								//Email to all cc emails from main ticket.
								new TicketEmails(array("TicketID" => $ticketID, "TriggerType" => "CCNoteaddedtoticket", "Comment" => $message, "NoteUser" => $FromName, "CompanyID" => $CompanyID));
							}
						}
						///*-------------

						//$status = imap_setflag_full($inbox, $email_number, "\\Seen \\Flagged", ST_UID); //email staus seen
						Log::info("Updating last email_received_date "  . $MailDateTime);
						TicketGroups::where(["GroupID"=>$GroupID, "CompanyID" => $CompanyID])->update(["LastEmailReadDateTime"=> $MailDateTime ]);
					}

				} catch (Exception $e) {
					Log::error("Tracking email imap failed");
					Log::error($e);
				}
			}

		}else{
			Log::info("connectiong:".$email);
		}

		Log::info("reading emails completed");



	}
		
	function DownloadInlineImages($emailMessage,$email_number,$CompanyID,$msgbody){

		// match inline images in html content
		preg_match_all('/src="cid:(.*)"/Uims', $msgbody, $matches);
		
		// if there are any matches, loop through them and save to filesystem, change the src property
		// of the image to an actual URL it can be viewed at
		if(count($matches)) {
			
			// search and replace arrays will be used in str_replace function below
			$search = array();
			$replace = array();
			
			foreach($matches[1] as $match) {

				if(isset($emailMessage->attachments[$match]['data'])) {

					// work out some unique filename for it and save to filesystem etc
					$str = explode("@", $match);
					$uniqueFilename = $str[0];
					// change /path/to/images to actual path

					$filename = $uniqueFilename;
					$file_detail = $this->store_email_file($filename , $emailMessage->attachments[$match]['data'] , $email_number , $CompanyID );

					$path = AmazonS3::unSignedUrl($file_detail["filepath"], $CompanyID);

					if (!is_numeric(strpos($path, "https://"))) {
						//$path = str_replace('/', '\\', $path);

						$path2 = CompanyConfiguration::getValueConfigurationByKey($CompanyID, 'WEB_URL') . "/download_file?file=";
						//if (copy($filepath, $path2.'/uploads/' . basename($filepath))) {
						//   $path = CompanyConfiguration::getValueConfigurationByKey($CompanyID,'WEB_URL') . '/uploads/' . basename($path);
						// }
						$path = $path2 . base64_encode($file_detail["filepath"]);
					}

					$search[] = "src=\"cid:$match\"";
					// change www.example.com etc to actual URL
					$replace[] = "src=\"$path\"";
				}
			}
			
			// now do the replacements
			$msgbody = str_replace($search, $replace, $msgbody);
			
		}
		return $msgbody;
	}

	/**
	 *  Replace FWD: RE: kind of prefix from subject to be matched with orginal subject
	 * @param string $subject
	 * @return mixed
	 */
	public static function get_original_plain_subject($subject = '') {

		$find = [
			"/RE: Test Mail  RE:/", // to test in staging						
			"/^RE:/",
			"/^Re:/",
			"/^FWD:/",
			"/Test Mail/", // to test in staging
			"/Added as CC - [#[0-9]+]/",
		];

		$occurance = 1; // replace first occurrence

		return trim(preg_replace($find,"",$subject,$occurance));

	}

	/**
	 * http://stackoverflow.com/questions/9426801/detect-auto-reply-emails-programatically
	 * detect auto reply email to avoid creating tickets.
	 * Auto submited and email delivery failure emails will be ignored.
	 * @param string $header
	 */
	public static function check_auto_generated($header = '',$body) {

		$find_header = [
			"Auto-Submitted:",
		];
		$find_body = [
			"Delivery to the following recipient failed permanently:",
			"Delivery to the following recipients failed permanently:",
			"This message was created automatically by mail delivery software",
			"Delivery has failed to these recipients or groups",
			"Your mail message to the following address(es) could not be delivered.",
		];


		foreach($find_header as $f_header){

			if(strpos(strtolower($header),strtolower($f_header)) !== false){
 				return true;
			}
		}
		foreach($find_body as $f_body) {

			if(strpos(strtolower($body),strtolower($f_body)) !== false){
 				return true;
			}
		}



		return false;


	}

	public function body_cleanup($message){
		$message = html_entity_decode($message);
		return $message ;

	}

	//@TODO: uncompleted , not working with various email forwarded messsages
	public function get_forwarded_email($message){

		return ["from" => "" , "from_name" => ""];
		/*$from_name = "";
		Log::info("message: " . $message);
		$start = strpos($message,"<") +1;
		$end = strpos($message,">")  ;
		$from = trim(substr($message, $start, $end-$start));

		if(!empty($from)){

			$start = strpos($message,"From: ") + 6;
			$end = strpos($message,"<");

			$from_name = trim(substr($message, $start, $end-$start));
		}*/
		return ["from" => $from , "from_name" => $from_name];
	}

	public function generate_random_message_id($from) {

		$data["Message-ID"] = "neon_random_id";
		$data["EmailFrom"] = $from;
		$MessageID = PHPMAILERIntegtration::generate_email_message_id($data,[]);

		return $MessageID;
	}

	public function store_email_file ($file_name , $filedata , $email_number , $CompanyID ) {

		$UPLOADPATH = CompanyConfiguration::get($CompanyID,'UPLOAD_PATH');

		$file_name = $email_number . "-" . str_replace("/","_",$file_name);

		$amazonPath = AmazonS3::generate_upload_path(AmazonS3::$dir['EMAIL_ATTACHMENT'], '', $CompanyID);

		$local_filepath   =  $UPLOADPATH.'/'.$amazonPath . $file_name;

		$filepath2  =  $amazonPath .'/'. $file_name;

		$fp = fopen($local_filepath, "w+");
		fwrite($fp, $filedata);
		fclose($fp);

		if(is_amazon($CompanyID)) {

			if (!AmazonS3::upload($local_filepath, $amazonPath,$CompanyID)) {
				throw new \Exception('Error in Amazon upload');
			}
		}

		return array("filename"=>$file_name,"filepath"=>$filepath2);

	}


	public static function dataDecode($emailHtml) {
		if(is_string($emailHtml)){

			$matches = null;

			/* Repair instances where two encodings are together and separated by a space (strip the spaces) */
			$emailHtml = preg_replace('/(=\?[^ ?]+\?[BQbq]\?[^ ?]+\?=)\s+(=\?[^ ?]+\?[BQbq]\?[^ ?]+\?=)/', "$1$2", $emailHtml);

			/* Now see if any encodings exist and match them */
			if (!preg_match_all('/=\?([^ ?]+)\?([BQbq])\?([^ ?]+)\?=/', $emailHtml, $matches, PREG_SET_ORDER)) {
				return $emailHtml;
			}
			foreach ($matches as $header_match) {
				list($match, $charset, $encoding, $data) = $header_match;
				$encoding = strtoupper($encoding);
				switch ($encoding) {
					case 'B':
						$data = base64_decode($data);
						break;
					case 'Q':
						$data = quoted_printable_decode(str_replace("_", " ", $data));
						break;
				}
				// This part needs to handle every charset
				switch (strtoupper($charset)) {
					case "UTF-8":
						break;
				}
				$emailHtml = str_replace($match, $data, $emailHtml);
			}
		}
		return $emailHtml;
	}

}
?>