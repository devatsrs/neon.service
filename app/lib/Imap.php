<?php 
namespace App\Lib;
use App\Lib\TicketsTable;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use App\Lib\User;
use App\Lib\Lead;
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
	 
	 function ReadEmails($CompanyID) {
		 
		$email 		= 	$this->email;
		$password 	= 	$this->password;		
		$server		=	$this->server;
		try {
			$inbox  	= 	imap_open("{".$server."}", $email, $password);
		} catch (\Exception $e) {
			throw $e;
		}
		$emails 	= 	imap_search($inbox,'UNSEEN');

		if($emails){
			
			/* begin output var */
			$output = ''; 
			
			/* start from bottom */
		 	$emails =  array_reverse($emails);
		
			
			/* for every email... */
			foreach($emails as $key => $email_number){
				
				$MatchType	 =   ''; $MatchID = '';
				
				/* get information specific to this email */
				$overview 		= 		imap_fetch_overview($inbox,$email_number,0);    
				//$message		=		quoted_printable_decode(imap_fetchbody($inbox, $email_number, 1));
				//$header   	=  		imap_fetchheader($inbox,$email_number);
				$structure		= 		imap_fetchstructure($inbox, $email_number); 
				$message_id   	= 		isset($overview[0]->message_id)?$overview[0]->message_id:'';
				$references   	=  		isset($overview[0]->references)?$overview[0]->references:'';
				$in_reply_to  	= 		isset($overview[0]->in_reply_to)?$overview[0]->in_reply_to:$message_id;
				$overview_subject   =   isset($overview[0]->subject)?$overview[0]->subject:'';
				$msg_parent   	=		AccountEmailLog::where("MessageID",$in_reply_to)->first();

			
				if(!empty($msg_parent)){ // if email is reply of an email
					if($msg_parent->EmailParent==0){
						$parent = $msg_parent->AccountEmailLogID;                        
					}else{
						$parent = $msg_parent->EmailParent;
					}
					$parent_account =  $msg_parent->AccountID;
					$parent_UserID  =  $msg_parent->UserID;
					$AccountData    =   DB::table('tblAccount')->where(["AccountID" => $parent_account])->get(array("AccountName"));
					$Accountname    =  isset($AccountData[0]->AccountName)?' ('.($AccountData[0]->AccountName).')':'';
					$AccountTitle	=  $this->GetNametxt($overview[0]->from).$Accountname;
				}
				else
				{					
					// if email is not a reply of an email then search email in account,leads,contacts
					$parent_account 	= 	 0;
					$parent_UserID  	= 	 0;
					$parent 			= 	 0; // no parent by default		
					
					$MatchArray  		  =     $this->findEmailAddress($this->GetEmailtxt($overview[0]->from));
					$MatchType	 		  =     $MatchArray['MatchType'];
					$MatchID	 		  =	    $MatchArray['MatchID'];
					if($MatchArray['AccountID']){
						$parent_account = 	 $MatchArray['AccountID'];					
					}
					$AccountTitle		  =	    !empty($MatchArray['AccountTitle'])?$MatchArray['AccountTitle']:$this->GetNametxt($overview[0]->from);	
                }

				$attachmentsDB 		  =		$this->ReadAttachments($structure,$inbox,$email_number,$CompanyID); //saving attachments				
				
				if(isset($attachmentsDB) && count($attachmentsDB)>0){
					$AttachmentPaths  =		serialize($attachmentsDB);
					//$message		  =		$this->GetMessageBody(quoted_printable_decode(imap_fetchbody($inbox, $email_number, 1.2))); //if email has attachment then read 1.2 message part else read 1		
					
				}else{
					//$message		  =		quoted_printable_decode(imap_fetchbody($inbox, $email_number, 1.2));					
					$AttachmentPaths  = 	serialize([]);										
				}
			
				/*$message64		  = 	base64_decode($message);  //base 64 encoded msgs
				if((strlen($message64)>0) &&  (strpos($message64,"<html")>-1)){
						$message 	  = 	$message64;
						Log::info("msg64");
						Log::info($message64);	
				}*/
				
			 	$message = 	$this->getBody($inbox,$email_number);
				if(!empty($message)){
					$message =  $this->GetMessageBody($message);
				}
			
                $from   = $this->GetEmailtxt($overview[0]->from);
				$to 	= $this->GetEmailtxt($overview[0]->to);

				$message = html_entity_decode($message);

				$logData = ['EmailFrom'=> $from,
				"EmailfromName"=>!empty($AccountTitle)?$AccountTitle:$this->GetNametxt($overview[0]->from),
				'Subject'=>$overview_subject,
				'Message'=>$message,
				'CompanyID'=>$CompanyID,
				"MessageID"=>$message_id,
				"EmailParent" => $parent,
				"AccountID" => $parent_account,				
				"AttachmentPaths"=>$AttachmentPaths,
				"EmailID"=>$email_number,
				"EmailCall"=>Messages::Received,
                "UserID" => $parent_UserID,
                 "created_at"=>date('Y-m-d H:i:s'),
				 "EmailTo"=>$to
				];			
				$EmailLog   =  AccountEmailLog::insertGetId($logData);
				if($parent){ 					
          			AccountEmailLog::find($parent)->update(array("updated_at"=>date('Y-m-d H:i:s')));
				}
				
				$title = "Received from ".$AccountTitle." (".$from." )";
				
					 $data   = array(
						"CompanyID"=>$CompanyID,
						"AccountID"=> $parent_account,
						"Title"=>$title,
						"MsgLoggedUserID"=>$parent_UserID,
						"Description"=>$overview_subject,
						"MatchType"=>$MatchType,
						"MatchID"=>$MatchID,
						"EmailID"=>$EmailLog
					);  
                    Messages::logMsgRecord($data);
				
				//$status = imap_setflag_full($inbox, $email_number, "\\Seen \\Flagged", ST_UID); //email staus seen
				imap_setflag_full($inbox,imap_uid($inbox,$email_number),"\\SEEN",ST_UID);
			}			
		} 		
		/* close the connection */
		imap_close($inbox);
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

					$filename = $attachment['filename'];

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
		$doc->loadHTML($msg);		
		$this->removeElementsByTagName('script', $doc);
		$this->removeElementsByTagName('style', $doc); 
		//removeElementsByTagName('link', $doc);
		$body = $doc->getElementsByTagName('body')->item(0);
		foreach ($body->childNodes as $child){
			$mock->appendChild($mock->importNode($child, true));
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
           $structure = imap_fetchstructure($imap, $uid, FT_UID);
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
	
	
	function ReadTicketEmails($CompanyID,$server,$email,$password,$GroupID){ 
		$AllEmails  =   Messages::GetAllSystemEmails();
		$email 		= 	$email;
		$password 	= 	$password;		
		$server		=	$server;		
		try{
			$inbox  	= 	imap_open("{".$server."}INBOX", $email, $password);
		} catch (\Exception $ex) {
			throw $ex;
		}
		//$emails 	= 	imap_search($inbox,'UNSEEN');
		//$emails   = imap_search($inbox, 'SUBJECT "Fwd: Forwarded Agent email from client"');

		$LastEmailReadDateTime = TicketGroups::getLatestTicketEmailReceivedDateTime($CompanyID,$GroupID);
		$LastEmailReadDateTime = date("Y-m-d H:i:s", strtotime("-1 Hour ",strtotime($LastEmailReadDateTime))); // read 1 hour ahead to avoid skipping email.

		if(!empty($LastEmailReadDateTime)){

			$LastEmailReadDateTime = date("d F Y H:i:s", strtotime($LastEmailReadDateTime));	//$some   = imap_search($conn, 'SUBJECT "HOWTO be Awesome" SINCE "8 August 2008"', SE_UID);

			Log::info("LastEmailReadDateTime - " . $LastEmailReadDateTime);
			Log::info("LastEmailReadDateTime - " . date("d F Y H:i:s",strtotime($LastEmailReadDateTime)));

			$emails   = imap_search($inbox, 'SINCE "'.$LastEmailReadDateTime.'"');

		} else {

			$emails 	= 	imap_search($inbox,'UNSEEN');
		}
		//$emails   = imap_search($inbox, 'SUBJECT "Dev Test 3"');

		Log::info("connectiong:".$email);
		if($emails){
			
			/* begin output var */
			$output = ''; 
			
			/* start from bottom */
		 	$emails =  array_reverse($emails);
		
			try {
			/* for every email... */
			foreach($emails as $key => $email_number){
				Log::info("reading emails");
				/* get information specific to this email */
				$MatchType	 				= 		  ''; 
				$MatchID 					= 		  '';
				$priority					=		  1;				
				$headers 					=		  array();
				$message					=	      '';
				$overview = imap_fetch_overview($inbox, $email_number, 0);
				//$structure = imap_fetchstructure($inbox, $email_number);
				$header = imap_fetchheader($inbox, $email_number);
				$message_id   				= 		  isset($overview[0]->message_id)?$overview[0]->message_id:'';
				$references   				=  		  isset($overview[0]->references)?$overview[0]->references:'';
				$overview_subject  		    =		  isset($overview[0]->subject)?$overview[0]->subject:'(no subject)';
				$in_reply_to  				= 		  isset($overview[0]->in_reply_to)?$overview[0]->in_reply_to:$message_id;
				$msg_parent 				= 		  "";
				$email_received_date		= 		  isset($overview[0]->date)?$overview[0]->date:'';

				$headerdata					=		  imap_headerinfo($inbox, $email_number);

				$Extra = array_merge((array) $overview,(array) $headerdata);

				Log::info("Subject -  " . $overview_subject);
				Log::info("overview -  " . print_r($overview,true));
				Log::info("email_received_date - " . $email_received_date);
				Log::info("email_received_date DateTime - " . date("Y-m-d H:i:s",strtotime($email_received_date)));


				if(empty($overview)){
					Log::info("Blank overview found");
					continue;
				}


				// when there is no messageId found in email header.
				// just to add dummy random message id so as no to skip this email.

				if(empty($message_id)){

					if(isset($overview[0]->from)){
						$from_   	= 	$this->GetEmailtxt($overview[0]->from);
					}else{
						$from_		= 	"nofrom@email.com";
					}

					$whereArrray = ["CompanyID"=>$CompanyID, "Subject"=>trim($overview_subject) ];
					/*if(isset($overview[0]->to)) {
						$whereArrray["EmailTo"] = $overview[0]->to ;
					}*/
					if(!empty($from_)) {
						$whereArrray["EmailFrom"] = $from_ ;
					}
					Log::info("checking Subject Already Exists ");
					Log::info($whereArrray);
					if( AccountEmailLog::where($whereArrray)->count() > 0 ) {
						Log::info("Email Subject Already Exists.");
						continue ;
					}
					else {

						$message_id = $this->generate_random_message_id($from_);
						Log::info("New MessageID " . $message_id);

					}

				}

				/*if(strtotime($email_received_date) < strtotime($LastEmailReadDateTime)) {
					Log::info( "email_received_date ". date("Y-m-d H:i:s",strtotime($email_received_date)) . ' < ' .date("Y-m-d H:i:s",strtotime($LastEmailReadDateTime)));
					continue;
				} */

				// need to check for messageID already exists or not
				// if message id is blank , make sure to set random messageId before sending
				if ($msg_parent = AccountEmailLog::where(["CompanyID"=>$CompanyID, "MessageID"=>$message_id])->count() > 0){
					Log::info("Email Already Exists");
					continue;
				}

				Log::info("NEW Subject -  " . $overview_subject);


				//-- check in reply to with previous email
				// if exists then don't check for auto reply
				$in_reply_tos   = explode(' ',$in_reply_to);
				foreach($in_reply_tos as $in_reply_to_id){

					$msg_parent   	=		AccountEmailLog::where("MessageID",$in_reply_to_id)->first();
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
				Log::info("in_reply_tos");
				Log::info($in_reply_tos);

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
					$original_plain_subject = $this->get_original_plain_subject($overview_subject);
					if(!empty($original_plain_subject)){
						$EmailFrom = $EmailTo = "";
						if(isset($overview[0]->from)){
							$EmailFrom 	= 	$this->GetEmailtxt($overview[0]->from);
						}
						if(isset($overview[0]->to)) {
							$EmailTo = $this->GetEmailtxt($overview[0]->to);
						}else {
							$EmailTo = $email;
						}

						$msg_parent = AccountEmailLog::whereRaw(" created_at >= DATE_ADD(now(), INTERVAL -1 Month )   ")->where(["CompanyID"=>$CompanyID, "EmailFrom"=>$EmailFrom,"EmailTo"=> $EmailTo,  "Subject"=>trim($original_plain_subject)])->first();
						if(!$msg_parent) {
							$msg_parent = AccountEmailLog::whereRaw(" created_at >= DATE_ADD(now(), INTERVAL -1 Month )   ")->where(["CompanyID"=>$CompanyID, "EmailFrom"=>$EmailFrom,"EmailTo"=> $EmailTo,  "Subject"=>trim($overview_subject)])->first();
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

				$emailMessage = new EmailMessage($inbox, $email_number);
				$emailMessage->fetch();

				$attachmentsDB =  array();
				if(count($emailMessage->attachments)>0) {
					$attachmentsDB = $this->ReadAttachments($emailMessage, $email_number, $CompanyID); //saving attachments
				}

				if(isset($attachmentsDB) && count($attachmentsDB)>0){
					$AttachmentPaths  =		serialize($attachmentsDB);				
				}else{
					$AttachmentPaths  = 	serialize([]);										
				}
				
				$message = 	$this->getBody($inbox,$email_number);  //get body from email
				if(count($emailMessage->attachments)>0){
					$message =  $this->DownloadInlineImages($emailMessage, $email_number,$CompanyID,$message); // download inline images and added it places in body
				}

				if(!empty($message)){
					$message =  $this->GetMessageBody($message);
				}

				$message = $this->body_cleanup($message);


				$from   	= 	$this->GetEmailtxt($overview[0]->from);
				$FromName	=	$this->GetNametxt($overview[0]->from);
				$cc			=	isset($headerdata->ccaddress)?$headerdata->cc:array();
				$bcc		=	isset($headerdata->bccaddress)?$headerdata->bccaddress:'';
				$cc 		=	$this->GetCC($cc);
				if(isset($overview[0]->to)) {
					$to = $this->GetEmailtxt($overview[0]->to);
				}else {
					$to = $email; //when to  is blank
					$cc_ = TicketEmails::remove_group_emails_from_array($CompanyID,explode(",",$cc));
					$cc  = implode(",",$cc_);
				}
				$update_id  =	''; $insert_id  =	'';
				//Log::info("message :".$message);

				$checkRepeatedEmailsData = [
					"from" => $from,
					"GroupID" => $GroupID,
				];
				if( TicketsTable::checkRepeatedEmails($CompanyID,$checkRepeatedEmailsData) ) {

					Log::info( "Repeated Emails skipped" );
					Log::info( "Repeated Emails skipped From " . $from );
					Log::info( "Repeated Emails skipped Subject " . $overview_subject );
					Log::info( "Repeated Emails skipped MessageID " . $message_id );
					//continue;
				}

				$check_auto = $this->check_auto_generated($header,$message);
				if($check_auto && empty($msg_parent)){

					$AlreadyJunk  = JunkTicketEmail::where(["CompanyID"=>$CompanyID , "MessageID" => $message_id])->count();
					if($AlreadyJunk > 0 ) {
						$logData = [
							'CompanyID' => $CompanyID,
							'From' => $from,
							"FromName" => $FromName,
							"EmailTo" => $to,
							"Cc" => $cc,
							'Subject' => $overview_subject,
							'Message' => $message,
							"MessageID" => $message_id,
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
						Log::info("Junk Ticket Email Already Exists with MessageID - " . $message_id);
					}
					Log::info("Auto Responder Detected :");
					Log::info("header");
					Log::info($header);

					TicketGroups::where(["GroupID"=>$GroupID, "CompanyID" => $CompanyID])->update(["LastEmailReadDateTime"=> date("Y-m-d H:i:s",strtotime($email_received_date))]);
					continue;
				}
				
				/*
				 * Commeted Reason: GroupID will be group email we are reading in. no need to match with to
				 * $CheckInboxGroup 	=	TicketGroups::where(["CompanyID"=>$CompanyID,"GroupEmailAddress"=>$to])->first();
				if(count($CheckInboxGroup)>0){
					$GroupID = $CheckInboxGroup->GroupID;
				}*/

				///Check if agent forwarded email.
				//@TODO : not working with all types of email with different forwarded formats.
				/*$group_agents = 		array_values(TicketGroupAgents::get_group_agents($GroupID,0,'EmailAddress'));
				if(in_array($from,$group_agents)) {
					$_tmp_message = imap_fetchbody($inbox,$email_number,1);
					$from_array = $this->get_forwarded_email($_tmp_message);
					Log::info($from_array);
					if (!empty($from_array) && !empty($from_array["from"]) && filter_var($from_array["from"], FILTER_VALIDATE_EMAIL)) {
						$from = $from_array["from"];
						$FromName = $from_array["from_name"];
					}
				}*/

				$logData = [
					'Requester'=> $from,
					"RequesterName"=>$FromName,
					"RequesterCC"=>$cc,
					"RequesterBCC"=>$bcc,
					'Subject'=>$overview_subject,
					'Description'=>$message,
					'CompanyID'=>$CompanyID,
					"AttachmentPaths"=>$AttachmentPaths,
					"Group"=>$GroupID,
					"created_at"=>date('Y-m-d H:i:s'),
					"Priority"=>$priority,
					"Status"=> TicketsTable::getOpenTicketStatus(),
					"created_by"=> 'RMScheduler'
				];

				$MatchArray  		  =     $this->SetEmailType($from,$CompanyID);

				$skip_email_notification = false;
				if(!$parentTicket){
					// New ticket

					$logData 		 	  = 	array_merge($logData,$MatchArray);

					$ticketID 			  =  	TicketsTable::insertGetId($logData);

					// --------------- check for TicketImportRule ----------------
					$ticketRuleData = array_merge($logData,["TicketID"=>$ticketID,"EmailTo"=>$to,]);
					try{
						$TicketImportRuleResult = TicketImportRule::check($CompanyID,$ticketRuleData);
					} catch ( \Exception $ex){

						Log::error("Error in TicketImportRule::check on TicketID " . $ticketID);
						Log::error("TicketRuleData");
						Log::error($ticketRuleData);
						Log::error(print_r($ex,true));
					}

					if(is_array($TicketImportRuleResult)) {
						if (in_array(TicketImportRuleActionType::DELETE_TICKET,$TicketImportRuleResult)) {

							$logData = [
								'CompanyID'=>$CompanyID,
								'From'=> $from,
								"FromName"=>$FromName,
								"EmailTo"=>$to,
								"Cc"=>$cc,
								'Subject'=>$overview_subject,
								'Message'=>$message,
								"MessageID"=>$message_id,
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

							TicketGroups::where(["GroupID"=>$GroupID, "CompanyID" => $CompanyID])->update(["LastEmailReadDateTime"=> date("Y-m-d H:i:s",strtotime($email_received_date))]);
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


					// --------------- check for TicketImportRule ----------------
					$ticketRuleData = array_merge($logData,["TicketID"=>$ticketData->TicketID,"EmailTo"=>$to,]);
					try{
						$TicketImportRuleResult = TicketImportRule::check($CompanyID,$ticketRuleData);
					} catch ( \Exception $ex){

						Log::error("Error in TicketImportRule::check on TicketID " . $ticketID);
						Log::error("TicketRuleData");
						Log::error($ticketRuleData);
						Log::error(print_r($ex,true));
					}

					if(is_array($TicketImportRuleResult)) {
						if (in_array(TicketImportRuleActionType::DELETE_TICKET,$TicketImportRuleResult)) {


							$logData = [
								'CompanyID'=>$CompanyID,
								'From'=> $from,
								"FromName"=>$FromName,
								"EmailTo"=>$to,
								"Cc"=>$cc,
								'Subject'=>$overview_subject,
								'Message'=>$message,
								"MessageID"=>$message_id,
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
							TicketGroups::where(["GroupID"=>$GroupID, "CompanyID" => $CompanyID])->update(["LastEmailReadDateTime"=> date("Y-m-d H:i:s",strtotime($email_received_date))]);
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
				}
				$logData = ['EmailFrom'=> $from,
					"EmailfromName"=>$FromName,
					'Subject'=>$overview_subject,
					'Message'=>$message,
					'CompanyID'=>$CompanyID,
					"MessageID"=>$message_id,
					"EmailParent" => $parent,
					"AttachmentPaths"=>$AttachmentPaths,
					"EmailID"=>$email_number,
					"EmailCall"=>Messages::Received,
					"UserID" => $parent_UserID,
					"created_at"=>date('Y-m-d H:i:s'),
					"EmailTo"=>$to,
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
					 
					 
					if(!in_array($from,$AllEmails))
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
						
						$ContactData = array("FirstName"=>$ContactFirstName,"LastName"=>$ContactLastName,"Email"=>$from,"CompanyId"=>$CompanyID);
						$contactID =  Contact::insertGetId($ContactData);
						TicketsTable::find($ticketID)->update(array("ContactID"=>$contactID));
						$EmailLogObj = AccountEmailLog::find($EmailLog);
						$EmailLogObj->update(array("UserType"=>Messages::UserTypeContact,"ContactID"=>$contactID));		
						$AllEmails[] = $from;
					}
					else
					{
						$accountIDSave  =	0;
						$accountID   	=  DB::table('tblAccount')->where(array("Email"=>$from))->pluck("AccountID");
						$accountID2  	=  DB::table('tblAccount')->where(array("BillingEmail"=>$from))->pluck("AccountID");
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
							 $ContactID 	 =  DB::table('tblContact')->where(array("Email"=>$from))->pluck("ContactID");	
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

								 $ContactData = array("FirstName"=>$ContactFirstName,"LastName"=>$ContactLastName,"Email"=>$from,"CompanyId"=>$CompanyID);
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
					if ($ticketData->Status == TicketsTable::getClosedTicketStatus() || $ticketData->Status == TicketsTable::getResolvedTicketStatus()) {
						TicketsTable::find($ticketData->TicketID)->update(["Status" => TicketsTable::getOpenTicketStatus()]);
						if(!$skip_email_notification) {
							new TicketEmails(array("TicketID" => $ticketData->TicketID, "CompanyID" => $CompanyID, "TriggerType" => array("AgentTicketReopened")));
						}
					}
					if(isset($ticketData->Requester)){
						if($from==$ticketData->Requester){
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
				imap_setflag_full($inbox,imap_uid($inbox,$email_number),"\\SEEN",ST_UID);
				Log::info("Updating last email_received_date "  . date("Y-m-d H:i:s",strtotime($email_received_date)));
				TicketGroups::where(["GroupID"=>$GroupID, "CompanyID" => $CompanyID])->update(["LastEmailReadDateTime"=> date("Y-m-d H:i:s",strtotime($email_received_date)) ]);





			}
			} catch (Exception $e) {
				Log::error("Tracking email imap failed");
				Log::error($e);								
			}   			
		} 		
		/* close the connection */
		imap_close($inbox);
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

						$path2 = CompanyConfiguration::get($CompanyID, 'WEB_URL') . "/download_file?file=";
						//if (copy($filepath, $path2.'/uploads/' . basename($filepath))) {
						//   $path = CompanyConfiguration::get($CompanyID,'WEB_URL') . '/uploads/' . basename($path);
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

		$file_name = $email_number . "-" . $file_name;

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

}
?>