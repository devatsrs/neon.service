<?php 
namespace App\Lib;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use App\Lib\User;
use App\Lib\Lead;
use Illuminate\Support\Facades\Log;
use App\Lib\AccountEmailLog;
use App\Lib\TicketsTable;
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
	 
	 function ReadEmails($CompanyID){
		 
		$email 		= 	$this->email;
		$password 	= 	$this->password;		
		$server		=	$this->server;		
		$inbox  	= 	imap_open("{".$server."}", $email, $password)  or Log::info("can't connect: " . imap_last_error()); 
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
				
				$logData = ['EmailFrom'=> $from,
				"EmailfromName"=>!empty($AccountTitle)?$AccountTitle:$this->GetNametxt($overview[0]->from),
				'Subject'=>$overview[0]->subject,
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
						"Description"=>$overview[0]->subject,
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
	
	function ReadAttachments($structure,$inbox,$email_number,$CompanyID)
	{
		$attachments   = array();
		$attachmentsDB = array();
        $UPLOADPATH = CompanyConfiguration::get($CompanyID,'UPLOAD_PATH');
		
		/* if any attachments found code start... */
		if(isset($structure->parts) && count($structure->parts)) 
		{
			for($i = 0; $i < count($structure->parts); $i++) 
			{
				$attachments[$i] = array(
					'is_attachment' => false,
					'filename' => '',
					'name' => '',
					'attachment' => ''
				);
		
				if($structure->parts[$i]->ifdparameters) 
				{
					foreach($structure->parts[$i]->dparameters as $object) 
					{
						if(strtolower($object->attribute) == 'filename') 
						{
							$attachments[$i]['is_attachment'] = true;
							$attachments[$i]['filename'] = $object->value;
						}
					}
				}
		
				if($structure->parts[$i]->ifparameters) 
				{
					foreach($structure->parts[$i]->parameters as $object) 
					{
						if(strtolower($object->attribute) == 'name') 
						{
							$attachments[$i]['is_attachment'] = true;
							$attachments[$i]['name'] = $object->value;
						}
					}
				}
		
				if($attachments[$i]['is_attachment']) 
				{
					$attachments[$i]['attachment'] = imap_fetchbody($inbox, $email_number, $i+1);
		
					/* 3 = BASE64 encoding */
					if($structure->parts[$i]->encoding == 3) 
					{ 
						$attachments[$i]['attachment'] = base64_decode($attachments[$i]['attachment']);
					}
					/* 4 = QUOTED-PRINTABLE encoding */
					elseif($structure->parts[$i]->encoding == 4) 
					{ 
						$attachments[$i]['attachment'] = quoted_printable_decode($attachments[$i]['attachment']);
					}
				}
			}
		}
		
		/* iterate through each attachment and save it */
		foreach($attachments as $attachment)
		{
			if($attachment['is_attachment'] == 1)
			{
				$filename = $attachment['name'];
				if(empty($filename)) $filename = $attachment['filename'];		
				if(empty($filename)) $filename = time() . ".dat";
				
				$file_name 		=  \Webpatser\Uuid\Uuid::generate()."_".basename($filename);
				$amazonPath 	= 	AmazonS3::generate_upload_path(AmazonS3::$dir['EMAIL_ATTACHMENT'],'',$CompanyID);
				
				/*if(!is_dir($UPLOADPATH.'/'.$amazonPath)){
					 mkdir($UPLOADPATH.'/'.$amazonPath, 0777, true);
				}*/
				if (!file_exists($UPLOADPATH.'/'.$amazonPath)){
                    mkdir($UPLOADPATH.'/'.$amazonPath, 0777, true);
           	  }
				
				$filepath   =  $UPLOADPATH.'/'.$amazonPath . $email_number . "-" . $file_name;
				$filepath2  =  $amazonPath . $email_number . "-" . $file_name; 
				$fp = fopen($filepath, "w+");
				fwrite($fp, $attachment['attachment']);
				fclose($fp);
				
				if(is_amazon($CompanyID)){
					if (!AmazonS3::upload($filepath, $amazonPath,$CompanyID)) {
						throw new \Exception('Error in Amazon upload');	
					}					
				}
				$attachmentsDB[] = array("filename"=>$filename,"filepath"=>$filepath2); 
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
        $body = $this->get_part($imap, $uid, "TEXT/PLAIN");
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
		$inbox  	= 	imap_open("{".$server."}", $email, $password)  or Log::info("can't connect: " . imap_last_error()); 
		$emails 	= 	imap_search($inbox,'UNSEEN');
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
				$overview 					= 		  imap_fetch_overview($inbox,$email_number,0);    
				$structure					= 		  imap_fetchstructure($inbox, $email_number); 
				$header 					= 		  imap_fetchheader($inbox, $email_number);
				$message_id   				= 		  isset($overview[0]->message_id)?$overview[0]->message_id:'';
				$references   				=  		  isset($overview[0]->references)?$overview[0]->references:'';
				$in_reply_to  				= 		  isset($overview[0]->in_reply_to)?$overview[0]->in_reply_to:$message_id;		
					
				$msg_parent   				=		  AccountEmailLog::where(["MessageID"=>$in_reply_to])->first();				
				
				$headerdata					=		  imap_headerinfo($inbox, $email_number);		
				
				//$msg_parentconversation   	=		  TicketsConversation::where("MessageID",$in_reply_to)->first();
				// Split on \n  for priority 
				$h_array					=		  explode("\n",$header);
		
				foreach ( $h_array as $h ) {				
					// Check if row start with a char
						if ( preg_match("/^[A-Z]/i", $h )) {				
						$tmp 					= 	explode(":",$h);
						$header_name 		    = 	$tmp[0];
						$header_value 			= 	$tmp[1];								
						$headers[$header_name] 	= 	$header_value;						
					} else {
						// Append row to previous field
						$headers[$header_name]  = 	$header_value . $h;
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
					$original_plain_subject = $this->get_original_plain_subject($overview[0]->subject);
					if(!empty($original_plain_subject)){
						$EmailFrom 	= 	$this->GetEmailtxt($overview[0]->from);
						$EmailTo 		= 	$this->GetEmailtxt($overview[0]->to);

						$msg_parent = AccountEmailLog::whereRaw(" created_at >= DATE_ADD(now(), INTERVAL -1 Month )   ")->where(["CompanyID"=>$CompanyID, "EmailFrom"=>$EmailTo,"EmailTo"=> $EmailFrom,  "Subject"=>trim($original_plain_subject)])->first();
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
				
				$attachmentsDB 		  =		$this->ReadAttachments($structure,$inbox,$email_number,$CompanyID); //saving attachments	
				if(isset($attachmentsDB) && count($attachmentsDB)>0){
					$AttachmentPaths  =		serialize($attachmentsDB);				
				}else{
					$AttachmentPaths  = 	serialize([]);										
				}
				
				//$message =  $this->DownloadInlineImages($inbox, $email_number,$CompanyID); 
			 	//$message = 	$this->getBody($inbox,$email_number);
				//if(empty($message)){
				$message = 	$this->getBody($inbox,$email_number);  //get body from email
				//}
				if(count($attachmentsDB)>0){
					$message =  $this->DownloadInlineImages($inbox, $email_number,$CompanyID,$message); // download inline images and added it places in body
				}
				$message =  nl2br($this->GetMessageBody($message));  //get only body section from email. remove css and scripts
								
			
                $from   	= 	$this->GetEmailtxt($overview[0]->from);
				$to 		= 	$this->GetEmailtxt($overview[0]->to);
				$FromName	=	$this->GetNametxt($overview[0]->from);
				$cc			=	isset($headerdata->ccaddress)?$headerdata->cc:array();
				$bcc		=	isset($headerdata->bccaddress)?$headerdata->bccaddress:'';
								
				$cc 		=	$this->GetCC($cc);
				$update_id  =	''; $insert_id  =	'';
				
				//Log::info("message :".$message);
				$check_auto = $this->check_auto_generated($header,$message);
				if($check_auto){

					Log::info("Auto Responder Detected :");
					Log::info("header");
					Log::info($header);
					Log::info("overview");
					Log::info($overview);
					continue;
				}

				if(!$parentTicket){
				$logData = [
						'Requester'=> $from,
						"RequesterName"=>$FromName,
						"RequesterCC"=>$cc,
						'Subject'=>$overview[0]->subject,
						'Description'=>$message,
						'CompanyID'=>$CompanyID,
						"AttachmentPaths"=>$AttachmentPaths,
						"Group"=>$GroupID,
						"created_at"=>date('Y-m-d H:i:s'),
						"Priority"=>$priority,
						"Status"=>TicketsTable::getOpenTicketStatus(),
						"created_by"=> 'RMScheduler'
					];
					
					$MatchArray  		  =     $this->SetEmailType($from,$CompanyID);
					$logData 		 	  = 	array_merge($logData,$MatchArray);						
					$ticketID 			  =  	TicketsTable::insertGetId($logData); 
					TicketLog::AddLog($ticketID,$MatchArray,$CompanyID);
					if($GroupID){
						$TicketEmails 	=  new TicketEmails(array("TicketID"=>$ticketID,"CompanyID"=>$CompanyID,"TriggerType"=>array("AgentAssignedGroup")));
					}					
					$TicketEmails 	=  new TicketEmails(array("TicketID"=>$ticketID,"CompanyID"=>$CompanyID,"TriggerType"=>array("RequesterNewTicketCreated")));				$TicketEmails 	=  new TicketEmails(array("TicketID"=>$ticketID,"TriggerType"=>"CCNewTicketCreated","CompanyID"=>$CompanyID));
					
				}
				else //reopen ticket if ticket status closed 
				{
					
					$ticketData  = TicketsTable::find($parentTicket);
					
					if($ticketData->Status==TicketsTable::getClosedTicketStatus() || $ticketData->Status==TicketsTable::getResolvedTicketStatus()){
						TicketsTable::find($ticketData->TicketID)->update(["Status"=>TicketsTable::getOpenTicketStatus()]);	
					$TicketEmails 	=  new TicketEmails(array("TicketID"=>$ticketData->TicketID,"CompanyID"=>$CompanyID,"TriggerType"=>array("AgentTicketReopened")));		
					}	
				
					
					if(isset($ticketData->Requester)){
						if($from==$ticketData->Requester){		
						$TicketEmails 	=  new TicketEmails(array("TicketID"=>$ticketData->TicketID,"TriggerType"=>"RequesterRepliestoTicket","CompanyID"=>$CompanyID,"Comment"=>$message)); 
						TicketsTable::find($ticketData->TicketID)->update(array("CustomerRepliedDate"=>date('Y-m-d H:i:s'))); 
						}
					}
					$ticketID		=	$ticketData->TicketID;
					$TicketEmails 	=   new TicketEmails(array("TicketID"=>$ticketID,"TriggerType"=>"CCNoteaddedtoticket","Comment"=>$message,"NoteUser"=>$FromName,"CompanyID"=>$CompanyID));
				}
				$logData = ['EmailFrom'=> $from,
					"EmailfromName"=>$FromName,
					'Subject'=>$overview[0]->subject,
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
				if($parentTicket){
					if(!$parent){
						AccountEmailLog::find($EmailLog)->update(["EmailParent"=>$EmailLog]);
					}
				}
				
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
							  }
						}
					}
				}
				
				
				//$status = imap_setflag_full($inbox, $email_number, "\\Seen \\Flagged", ST_UID); //email staus seen
				imap_setflag_full($inbox,imap_uid($inbox,$email_number),"\\SEEN",ST_UID);

				try {
					if(isset($ticketID))
					{
						TicketSla::assignSlaToTicket($CompanyID,$ticketID);
					}
				} catch (Exception $ex) {
					Log::info("fail TicketSla::assignSlaToTicket");
					Log::info($ex);
				}

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
	
	
	function DownloadInlineImages($con,$msg,$CompanyID,$msgbody){ 
		$UPLOADPATH = CompanyConfiguration::get($CompanyID,'UPLOAD_PATH');
		// download email message #1 and fetch it
		$emailMessage = new EmailMessage($con, $msg);
		$emailMessage->fetch();
		
		// match inline images in html content
		preg_match_all('/src="cid:(.*)"/Uims', $msgbody, $matches);
		
		// if there are any matches, loop through them and save to filesystem, change the src property
		// of the image to an actual URL it can be viewed at
		if(count($matches)) {
			
			// search and replace arrays will be used in str_replace function below
			$search = array();
			$replace = array();
			
			foreach($matches[1] as $match) { 
				// work out some unique filename for it and save to filesystem etc
				$str = explode("@",$match); 
				$uniqueFilename = $str[0];
				// change /path/to/images to actual path
				
				///
				
				$filename 		=  $uniqueFilename;				
				$file_name 		=  \Webpatser\Uuid\Uuid::generate()."_".basename($filename);
				$amazonPath 	= 	AmazonS3::generate_upload_path(AmazonS3::$dir['EMAIL_ATTACHMENT'],'',$CompanyID);
				
				if(!is_dir($UPLOADPATH.'/'.$amazonPath)){
					 mkdir($UPLOADPATH.'/'.$amazonPath, 0777, true);
				}
				
				$filepath   =  $UPLOADPATH.'/'.$amazonPath . $msg . "-" . $file_name; 
				$filepath2  =  $amazonPath . $msg . "-" . $file_name;  
				$fp = fopen($filepath, "w+");
				fwrite($fp, $emailMessage->attachments[$match]['data']); 
				fclose($fp);
				
				$typeImage = pathinfo($filepath, PATHINFO_EXTENSION);
				$dataImage = file_get_contents($filepath);
				//@unlink($filepath);
				///				
				if(is_amazon($CompanyID)){
					if (!AmazonS3::upload($filepath, $amazonPath,$CompanyID)) {
						throw new \Exception('Error in Amazon upload');	
					}					
				}
				
				
				 $path = AmazonS3::unSignedUrl($filepath2,$CompanyID); 
				 
                if (!is_numeric(strpos($path, "https://"))) {
                    //$path = str_replace('/', '\\', $path);
					
					$path2 = CompanyConfiguration::get($CompanyID,'WEB_URL')."/download_file?file=";
                    //if (copy($filepath, $path2.'/uploads/' . basename($filepath))) {
                     //   $path = CompanyConfiguration::get($CompanyID,'WEB_URL') . '/uploads/' . basename($path);
                   // } 
				   $path = $path2.base64_encode($filepath2); 
                }
				
				$search[] = "src=\"cid:$match\"";
				// change www.example.com etc to actual URL
				$replace[] = "src=\"$path\"";
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
			"/^FWD:/",
			"/^Test Mail/", // to test in staging
		];

		$replace = 1; // replace first occurrence

		return trim(preg_replace($find,"",$subject,$replace));
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

}
?>