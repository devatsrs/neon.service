<?php 
namespace App\Lib;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use App\Lib\User;
use App\Lib\Lead;
use Illuminate\Support\Facades\Log;
use App\Lib\AccountEmailLog;
use Validator;

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
				
				$parent = 0; // no parent by default
				
				/* get information specific to this email */
				$overview 		= 		imap_fetch_overview($inbox,$email_number,0);   
				//$message		=		quoted_printable_decode(imap_fetchbody($inbox, $email_number, 1));
				//$header   	=  		imap_fetchheader($inbox,$email_number);
				$structure		= 		imap_fetchstructure($inbox, $email_number); 
				$message_id   	= 		isset($overview[0]->message_id)?$overview[0]->message_id:'';
				$references   	=  		isset($overview[0]->references)?$overview[0]->references:'';
				$in_reply_to  	= 		isset($overview[0]->in_reply_to)?$overview[0]->in_reply_to:$message_id;				
				$msg_parent   	=		AccountEmailLog::where("MessageID",$in_reply_to)->first();

				if(!empty($msg_parent)){
					if($msg_parent->EmailParent==0){
						$parent = $msg_parent->AccountEmailLogID;
					}else{
						$parent = $msg_parent->EmailParent;
					}
				}else{
                    $Lead['CompanyID']      =   $CompanyID;
                    $Lead['Email']          =   $this->GetEmailtxt($overview[0]->from);
                    $Lead['AccountType']    =   0;
                    $Lead['AccountName']    =   trim($this->GetNametxt($overview[0]->from));
				    Lead::$rules['AccountName'] = 'required|unique:tblAccount,AccountName,NULL,CompanyID,CompanyID,'.$Lead['CompanyID'].'';
			        $validator = Validator::make($Lead, Lead::$rules); 
					if ($validator->fails()) {                    	
						//Log::info(print_r($validator->messages()->all(),true));
					}else{
						Lead::create($Lead); 
					} 
					continue;
                }
								
				$attachmentsDB 	=	$this->ReadAttachments($structure,$inbox,$email_number,$CompanyID); //saving attachments
				
				if(isset($attachmentsDB) && count($attachmentsDB)>0){
					$AttachmentPaths = serialize($attachmentsDB);
					$message		=		$this->GetMessageBody(quoted_printable_decode(imap_fetchbody($inbox, $email_number, 1.2))); //add comment
				}else{
					$message		=		imap_fetchbody($inbox, $email_number, 1);
					$AttachmentPaths = serialize([]);
				}
					
				$logData = ['EmailFrom'=> $this->GetEmailtxt($overview[0]->from),
				'Subject'=>$overview[0]->subject,
				'Message'=>$message,
				'CompanyID'=>$CompanyID,
				"MessageID"=>$message_id,
				"EmailParent" => $parent,
				"AttachmentPaths"=>$AttachmentPaths,
				"EmailID"=>$email_number,
				"EmailCall"=>"Received",
				];			
				$data   =  AccountEmailLog::Create($logData);								
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
				
				if(!is_dir(getenv("UPLOAD_PATH").'/'.$amazonPath)){
					 mkdir(getenv("UPLOAD_PATH").'/'.$amazonPath, 0777, true);
				}
				
				$filepath   =  getenv("UPLOAD_PATH").'/'.$amazonPath . $email_number . "-" . $file_name;
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
	
	function GetMessageBody($msg){
		$pos = strpos($msg,"<html");
		if($pos !== false){ //html found		
			$d = new \DOMDocument;
			$mock = new \DOMDocument;
			libxml_use_internal_errors(true);
			$d->loadHTML($msg);
			$body = $d->getElementsByTagName('body')->item(0);
			foreach ($body->childNodes as $child){
				$mock->appendChild($mock->importNode($child, true));
			}			
			$msg =  $mock->saveHTML();		
		}
		return $msg;
	}	
	
	static	function CheckConnection($server,$email,$password){
		try{
			$mbox=imap_open("{".$server."}", $email, $password);
			return true;
		} catch (\Exception $e) {
			Log::error("could not connect");
			Log::error($e);			
			return false;
		}   		
	}	
}
?>