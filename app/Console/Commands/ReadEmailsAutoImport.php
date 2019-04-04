<?php
namespace App\Console\Commands;

use App\Lib\Account;
use App\Lib\AmazonS3;
use App\Lib\AutoImportRate;
use App\Lib\AutoImportSetting;
use App\Lib\CompanyConfiguration;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\Imap;
use App\Lib\Job;
use App\Lib\RateType;
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
		CronHelper::before_cronrun($this->name, $this );
		$arguments = $this->argument();
		$CompanyID = $arguments["CompanyID"];
		$CronJobID = $arguments["CronJobID"];
		$CronJob = CronJob::find($CronJobID);
		$cronsetting 	= 	json_decode($CronJob->Settings,true);

		CronJob::activateCronJob($CronJob);
		CronJob::createLog($CronJobID);

		Log::useFiles(storage_path() . '/logs/reademailsautoimport-' . $CronJobID . '-' . date('Y-m-d') . '.log');

		$joblogdata = array();
		$joblogdata['CronJobID'] = $CronJobID;
		$joblogdata['created_at'] = date('Y-m-d H:i:s');
		$joblogdata['created_by'] = 'RMScheduler';
		$countEmailMSG="";
		$errorEmailMSG="";
		$countEmails=0;
		try
		{
			$emailread = new EmailServiceProvider();

			//Get all Mailboxes
			$aFolder = $emailread->connectEmail($CompanyID);
			$LastEmailReadDateTime = AutoImportRate::getLastEmailReadDateTime($CompanyID);

			$upload_path = CompanyConfiguration::get($CompanyID,'UPLOAD_PATH');


			//Loop through every Mailbox
			/** @var \Webklex\IMAP\Folder $oFolder */

			foreach($aFolder as $oFolder) {
				  if($oFolder->fullName!="INBOX"){
					continue;
				  }
				  if (!empty($LastEmailReadDateTime)) {
				 	 $LastEmailReadDateTime = date("Y-m-d H:i:s", strtotime("-1 Hour ", strtotime($LastEmailReadDateTime)));
				 	 $aMessage = $oFolder->searchMessages([['SINCE', Carbon::parse('' . $LastEmailReadDateTime . '')->format('d M y H:i:s')]]);
				  } else {
				 	 $aMessage = $oFolder->searchMessages([['UNSEEN']]);
				  }
//				$aMessage = $oFolder->searchMessages([['UNSEEN']]);
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
					$MatchedAttachmentFileNames = [];
					$AttachmentFileNames = [];
					if ($aAttachmentCount > 0) {

						$aAttachment = $oMessage->getAttachments();

						foreach ($aAttachment as $oAttachment) {

							$path_parts = pathinfo($oAttachment->getName());
							if(!array_key_exists("extension", $path_parts)){
								$path_parts["extension"]="";
							}
							$file_name = Imap::dataDecode($path_parts["filename"]) . '-'. date("YmdHis") . '.' . $path_parts["extension"];
							$amazonPath = AmazonS3::generate_upload_path(AmazonS3::$dir['AUTOIMPORT_UPLOAD'],'',$CompanyID);

							$fullPath = $upload_path . "/". $amazonPath;
							$filepath2  =  $amazonPath .'/'. $file_name;
							$oAttachment->save($fullPath, $file_name);
							if(is_amazon($CompanyID)) {
								if(!AmazonS3::upload($fullPath.$file_name,$amazonPath,$CompanyID)){
									throw new Exception('Error in Amazon upload');
								}
							}
							$AttachmentFileNames[] = array("filename"=>$file_name,"filepath"=>$filepath2);

							if (in_array(strtolower($path_parts["extension"]), array('xls','csv','xlsx') )) {
								$MatchedAttachmentFileNames[strtolower($path_parts["filename"])] = $file_name;
							}
						}
					}
					$Attachments = json_encode($AttachmentFileNames);

					$query = "call prc_ImportSettingMatch ( '".$CompanyID."', '".$fromMail."','".addslashes($Subject)."', '".addslashes(implode(",", array_keys($MatchedAttachmentFileNames)))."' )";
					Log::info($query);
					Log::info($MatchedAttachmentFileNames);
					$results = DB::select($query);
					/* If "Sendor Email" And "From Email" Match Then We read the email and Save in table (tblAutoImport)  */
					if( !empty($results) ){
						foreach($results as $matchData){
								$data=array();
								if($matchData->Type == 1){
									// For Vendor Rate
									$job_type = "VU" ;
									$data['Trunk'] = $matchData->TrunkID;
									$data["AccountID"] = $matchData->TypePKID;
									$data['codedeckid'] = VendorTrunk::where(["AccountID" => $matchData->TypePKID,'TrunkID'=>$data['Trunk']])->pluck("CodeDeckId");
									$AccountID = $matchData->TypePKID;
								}else{
									// For RateTable
									$job_type = "RTU" ;
									$ratetable = \DB::table("tblRateTable")->select("RateTableName")->where('RateTableId','=',$matchData->TypePKID)->get();
									$data["ratetablename"] = $ratetable[0]->RateTableName;
									$data["RateTableID"] = $matchData->TypePKID;

									if($ratetable[0]->Type == RateType::getRateTypeIDBySlug(RateType::SLUG_DID)) { // did rate upload
										$job_type = 'DRTU';
									} else if($ratetable[0]->Type == RateType::getRateTypeIDBySlug(RateType::SLUG_PACKAGE)) { // package rate upload
										$job_type = 'PRTU';
									} else { // voicecall rate upload
										$job_type = 'RTU';
									}

									$data['codedeckid']="";
									$AccountID = 0;
								}

							try {
								$options=json_decode($matchData->options);
								$arrOptions=array();
								$arrOptions["skipRows"]=$options->skipRows;
								$arrOptions["importratesheet"]=$options->importratesheet;
								$arrOptions["option"]=$options->option;
								$arrOptions["selection"]=$options->selection;
								$arrOptions["Trunk"]=$matchData->TrunkID;
								$arrOptions["codedeckid"]=$data['codedeckid'];
								$arrOptions["uploadtemplate"]=$matchData->ImportFileTempleteID;
								$arrOptions["checkbox_replace_all"]=$options->Settings->checkbox_replace_all;
								$arrOptions["checkbox_rates_with_effected_from"]=$options->Settings->checkbox_rates_with_effected_from;
								$arrOptions["checkbox_add_new_codes_to_code_decks"]=$options->Settings->checkbox_add_new_codes_to_code_decks;
								$arrOptions["checkbox_review_rates"]=$options->Settings->checkbox_review_rates;
								$arrOptions["radio_list_option"]=$options->Settings->radio_list_option;
								$data['Options'] = json_encode($arrOptions);

								$data['uploadtemplate'] = $matchData->ImportFileTempleteID;
								$fullPath = $amazonPath . $MatchedAttachmentFileNames[trim($matchData->lognFileName)];

								$data['full_path'] = $fullPath;
								$data["CompanyID"] = $CompanyID;
								$data['checkbox_replace_all'] = $arrOptions["checkbox_replace_all"];
								$data['checkbox_rates_with_effected_from'] = $arrOptions["checkbox_rates_with_effected_from"];
								$data['checkbox_add_new_codes_to_code_decks'] = $arrOptions["checkbox_add_new_codes_to_code_decks"];
								$data['radio_list_option'] = $arrOptions["radio_list_option"];
								DB::beginTransaction();
								$jobId = Job::CreateAutoImportJob($CompanyID,$job_type,$data);
								DB::commit();

								/* Job Block End */
								$jobID = !empty($jobId) ? $jobId : 0;

								$SaveData = array(
									"AccountID" => $AccountID,
									"AccountName" => $senderName,
									"Subject" => $Subject,
									"Description" => $oMessage->getHTMLBody(),
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
								if(isset($MatchedAttachmentFileNames[$matchData->lognFileName])){
									unset($MatchedAttachmentFileNames[$matchData->lognFileName]);
								}
								$countEmails++;
								$countEmailMSG='Success Emails Read ' . $countEmails;

							}catch (\Exception $e){
								$errorEmailMSG .= "<br>E-Mail Subject - '".$Subject."' - Template Not Valid </br> Error:" . $e->getMessage();
							}
						}

					}else{
						$SaveData = array(
							"AccountName" => $senderName,
							"Subject" => $Subject,
							"Description" => $oMessage->getHTMLBody(),
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
			$joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
		}
		catch (\Exception $e)
		{

			$this->info('Failed:' . $e->getMessage());
			$errorEmailMSG .= '<br>Error:' . $e->getMessage();
			$joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
			Log::error($e);
			if(!empty($cronsetting['ErrorEmail'])) {
				$result = CronJob::CronJobErrorEmailSend($CronJobID,$e);
				Log::error("**Auto Import Email Read Status " . $result['status']);
				Log::error("**Auto Import Email Read message " . $result['message']);
			}
		}

		CronJob::deactivateCronJob($CronJob);
		$joblogdata['Message'] = $countEmailMSG.$errorEmailMSG;
		CronJobLog::createLog($CronJobID,$joblogdata);
		if(!empty($cronsetting['SuccessEmail'])) {
			$result = CronJob::CronJobSuccessEmailSend($CronJobID);
			Log::error("**Email Sent Status ".$result['status']);
			Log::error("**Email Sent message ".$result['message']);
		}

		CronHelper::after_cronrun($this->name, $this);


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