<?php
namespace App\Console\Commands;

use App\Lib\Account;
use App\Lib\AmazonS3;
use App\Lib\AutoImportRate;
use App\Lib\AutoImportSetting;
use App\Lib\CompanyConfiguration;
use App\Lib\Job;
use App\Lib\Trunk;
use App\Lib\User;
use App\Lib\VendorTrunk;
use Symfony\Component\Console\Input\InputArgument;
use Carbon\Carbon;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Log;
use App\Lib\EmailServiceProvider;
use Illuminate\Support\Facades\DB;
use Webpatser\Uuid\Uuid;

class ReadEmailsAutoImport extends Command
{

	protected $name = 'reademailsautoimport';
	protected $description = 'AutoRate Import email read.';

	public function __construct()
	{
		parent::__construct();
	}

	protected function getArguments()
	{
		return [
			['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID'],
			['CronJobID', InputArgument::REQUIRED, 'Argument CronJobID'],
		];
	}
	public function fire()
	{
		$arguments = $this->argument();
		$CompanyID = $arguments["CompanyID"];
		$CronJobID = $arguments["CronJobID"];
		$emailread = new EmailServiceProvider();

		//Get all Mailboxes
		$aFolder = $emailread->connectEmail($CompanyID);
		$LastEmailReadDateTime = AutoImportRate::getLastEmailReadDateTime();

		$upload_path = CompanyConfiguration::get($CompanyID,'UPLOAD_PATH');


		//Loop through every Mailbox
		/** @var \Webklex\IMAP\Folder $oFolder */

		foreach($aFolder as $oFolder) {

			 if (!empty($LastEmailReadDateTime)) {
				 $LastEmailReadDateTime = date("Y-m-d H:i:s", strtotime("-1 Hour ", strtotime($LastEmailReadDateTime)));
				 $aMessage = $oFolder->searchMessages([['SINCE', Carbon::parse('' . $LastEmailReadDateTime . '')->format('d M y H:i:s')]]);
			 } else {
				 $aMessage = $oFolder->searchMessages([['UNSEEN']]);
			 }

			
			foreach ($aMessage as $oMessage) {


				$from = $oMessage->getFrom();
				$fromMail = $from[0]->mail;
				$MailDateTime = date('Y-m-d h:i:s', strtotime($oMessage->getDate()));
				$sender = $oMessage->getSender();
				$senderName = $sender[0]->personal;
				$to = $oMessage->getTo();
				$toMail=$to[0]->mail;
				$MessageId = $oMessage->getMessageId();
				$aAttachmentCount = $oMessage->getAttachments()->count();
				$cc = $oMessage->getCc();
				$ccemail = $emailread->getCC($cc);
				$Subject = $oMessage->getSubject();


				if(!empty($MessageId) && AutoImportRate::where( ["CompanyID" => $CompanyID, 'MessageId'=> $MessageId] )->count() > 0){
					Log::info("Already Imported. MessageId " . $MessageId);
					continue;
				} else if(empty($MessageId) && AutoImportRate::where( ["CompanyID" => $CompanyID, 'MailDateTime'=> $MailDateTime  , "Subject" => $Subject   ] )->count() > 0){
					Log::info("Already Imported. MailDateTime " . $MailDateTime);
					continue;
				}


				$query = "call prc_ImportSettingMatch ( '".$CompanyID."', '".$from[0]->mail."','".addslashes($Subject)."' )";
				Log::info($query);
				$results = DB::select($query);				
				/* If "Sendor Email" And "From Email" Match Then We read the email and Save in table (tblAutoImport)  */
				if( !empty($results) ){

					$results=array_shift($results);
					$Attachments="";
					$Final_AttachmentNameList="";
					if ($aAttachmentCount > 0) {

						$aAttachment = $oMessage->getAttachments();
						$AttachmentFileNames = [];
						$MatchedAttachmentFileNames = [];

						foreach ($aAttachment as $oAttachment) {

							$extension = \File::extension($oAttachment->getName());
							$file_name = Uuid::generate() . '.' . strtolower($extension);
							$AttachmentFileNames[] = $file_name;

							$amazonPath = AmazonS3::generate_upload_path(AmazonS3::$dir['AUTOIMPORT_UPLOAD'],'',$CompanyID);
							$fullPath = $upload_path . "/". $amazonPath;
							$oAttachment->save($fullPath, $file_name);

							if(!AmazonS3::upload($amazonPath.$file_name,$amazonPath,$CompanyID)){
								throw new Exception('Error in Amazon upload');
							}

							if (in_array(strtolower($extension), array('xls','csv','xlsx') )) {
								if(!empty($results->FileName) && $file_name==$results->FileName){
									$MatchedAttachmentFileNames[] = $file_name;
								}else{
									$MatchedAttachmentFileNames[] = $file_name;
								}
							}

						}
						$Attachments = implode(", ", $AttachmentFileNames);
						$Final_AttachmentNameList = implode(", ", $MatchedAttachmentFileNames);

					} else {
						$Attachments = '';
					}

					if(!empty($Final_AttachmentNameList)){
						/* Job Log Start  ( IF Mail Match With Setting Then Job Log   )*/
						// Log::info(print_r($results));
						foreach(explode(',', $Final_AttachmentNameList) as $Final_AttachmentName){
							$data=array();
							if($results->Type == 1){
								// For Vendor Rate
								$job_type = "VU" ;
								$data['Trunk'] = $results->TrunkID;
								$data["AccountID"] = $results->TypePKID;
								$data['codedeckid'] = VendorTrunk::where(["AccountID" => $results->TypePKID,'TrunkID'=>$data['Trunk']])->pluck("CodeDeckId");
								$AccountID = $results->TypePKID;
							}else{
								// For RateTable
								$job_type = "RTU" ;
								$ratetable = \DB::table("tblRateTable")->select("RateTableName")->where('RateTableId','=',$results->TypePKID)->get();
								$data["ratetablename"] = $ratetable[0]->RateTableName;
								$data["RateTableID"] = $results->TypePKID;
								$data['codedeckid']="";
								$AccountID = Account::where("Email", $fromMail)->pluck('AccountID');
							}

							$options=json_decode($results->Options);
							$arrOptions=array();
							$arrOptions["skipRows"]=$options->skipRows;
							$arrOptions["importratesheet"]=$options->importratesheet;
							$arrOptions["option"]=$options->option;
							$arrOptions["selection"]=$options->selection;
							$arrOptions["Trunk"]=$results->TrunkID;
							$arrOptions["codedeckid"]=$data['codedeckid'];
							$arrOptions["uploadtemplate"]=$results->ImportFileTempleteID;
							$arrOptions["checkbox_replace_all"]=$options->Settings->checkbox_replace_all;
							$arrOptions["checkbox_rates_with_effected_from"]=$options->Settings->checkbox_rates_with_effected_from;
							$arrOptions["checkbox_add_new_codes_to_code_decks"]=$options->Settings->checkbox_add_new_codes_to_code_decks;
							$arrOptions["checkbox_review_rates"]=$options->Settings->checkbox_review_rates;
							$arrOptions["radio_list_option"]=$options->Settings->radio_list_option;
							$data['Options'] = json_encode($arrOptions);

							$data['uploadtemplate'] = $results->ImportFileTempleteID;
							$fullPath = $amazonPath . $Final_AttachmentName;
							$data['full_path'] = $fullPath;
							$data["CompanyID"] = $CompanyID;
							$data['checkbox_replace_all'] = $arrOptions["checkbox_replace_all"];
							$data['checkbox_rates_with_effected_from'] = $arrOptions["checkbox_rates_with_effected_from"];
							$data['checkbox_add_new_codes_to_code_decks'] = $arrOptions["checkbox_add_new_codes_to_code_decks"];
							$data['radio_list_option'] = $arrOptions["checkbox_review_rates"];
							DB::beginTransaction();
							$jobId = Job::CreateAutoImportJob($CompanyID,$job_type,$data);
							DB::commit();

							/* Job Block End */
							$jobID = !empty($jobId) ? $jobId : 0;

							$SaveData = array(
								"AccountID" => $AccountID,
								"AccountName" => $senderName,
								"Subject" => $Subject,
								"Description" => $oMessage->getTextBody(),
								"Attachment" => $Attachments,
								"To" => $toMail,
								"From" => $fromMail,
								"CC" => $ccemail,
								"MailDateTime" => $MailDateTime,
								"MessageId" => $MessageId,
								"created_at" => date('Y-m-d H:i:s'),
								"created_by" => "System",
								"JobID" => $jobID,
								"CompanyID" => $CompanyID
							);
							AutoImportRate::insert($SaveData);
						}
					}else{
						$SaveData = array(
							"AccountName" => $senderName,
							"Subject" => $Subject,
							"Description" => $oMessage->getTextBody(),
							"Attachment" => $Attachments,
							"To" => $toMail,
							"From" => $fromMail,
							"CC" => $ccemail,
							"MailDateTime" => $MailDateTime,
							"MessageId" => $MessageId,
							"created_at" => date('Y-m-d H:i:s'),
							"created_by" => "System",
							"JobID" => 0,
							"CompanyID" => $CompanyID
						);
						AutoImportRate::insert($SaveData);
					}
				}

			}

		}



	}


}





/* Email Send by AUtoimport Start */
/*
$jobResult = DB::table('tblJob as j')
	->join('tblJobStatus as js','j.JobStatusID','=','js.JobStatusID')
	->where('j.JobID', $JobID)->select('js.Title','j.JobStatusMessage','j.CompanyID')->get();
Log::info($jobResult);
Log::info($jobResult[0]->Title);
$subject = $jobResult[0]->Title;
$body = $jobResult["JobStatusMessage"];
// $email = DB::table('tblAutoImportInboxSetting')->where('CompanyID', $jobResult["Title"])->select('emailNotificationOnSuccess','emailNotificationOnFail')->get();
$test123 = Helper::sendMail('emails.AccountActivityEmailSend', array(
	'EmailTo' => 'vinesh.srs@gmail.com',
	'EmailToName' => 'test',
	'Subject' => 'Account activity reminder',
	'CompanyID' => 'test',
	'data' => array("AccountTaskData" => 'sdfsdf')
));
Log::info($test123);
/* Email Send by AUtoimport End */