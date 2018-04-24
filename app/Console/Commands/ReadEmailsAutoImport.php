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
				$to = $oMessage->getTo();
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
							$MatchedAttachmentFileNames[] = $file_name;
						}

					}
					$Attachments = implode(", ", $AttachmentFileNames);
					$Final_AttachmentName = implode(", ", $MatchedAttachmentFileNames);

				} else {
					$Attachments = '';
				}



				$autoImportSetting = $emailread->GetMatchSubjectEmail($fromMail,$CompanyID);

				/* If "Sendor Email" And "From Email" Match Then We read the email and Save in table (tblAutoImport)  */
				if( $autoImportSetting > 0 ){



					$SaveData = array(
						"AccountName" => $sender[0]->personal,
						"Subject" => $Subject,
						"Description" => $oMessage->getTextBody(),
						"Attachment" => $Attachments,
						"To" => $to[0]->mail,
						"From" => $fromMail,
						"CC" => $ccemail,
						"MailDateTime" => $MailDateTime,
						"MessageId" => $MessageId,
						"created_at" => date('Y-m-d H:i:s'),
						"created_by" => "System"
					);
					AutoImportRate::insert($SaveData);


					$query = "call prc_ImportSettingMatch ( '".$from[0]->mail."','".$Subject."','".$Final_AttachmentName."' )";
					Log::info($query);
					$results = DB::select($query);

					/* Job Log Start  ( IF Mail Match With Setting Then Job Log   )*/
					if( !empty($results) ) {
						// Log::info(print_r($results));
						$mapping_option = $emailread->GetMappingArray();

						$data['Options'] = json_encode($mapping_option);
						if($results[0]->Type == 1){
							// For Vendor Rate
							$job_type = "VU" ;
							$data['Trunk'] = $results[0]->TrunkID;
							$data["AccountID"] = $results[0]->TypePKID;
							$data['codedeckid'] = VendorTrunk::where(["AccountID" => $results[0]->TypePKID,'TrunkID'=>$data['Trunk']])->pluck("CodeDeckId");
						}else{
							// For RateTable
							$job_type = "RTU" ;
							$ratetable = \DB::table("tblRateTable")->select("RateTableName")->where('RateTableId','=',$results[0]->TypePKID)->get();
							$data["ratetablename"] = $ratetable[0]->RateTableName;
							$data["RateTableID"] = $results[0]->TypePKID;

						}

						$data['checkbox_replace_all'] = "0";
						$data['checkbox_rates_with_effected_from'] = "1";
						$data['checkbox_add_new_codes_to_code_decks'] = "1";
						$data['radio_list_option'] = "1";

						$data['uploadtemplate'] = $results[0]->ImportFileTempleteID;
						$fullPath = $amazonPath . $Final_AttachmentName;
						$data['full_path'] = $fullPath;
						$data["CompanyID"] = $CompanyID;

						DB::beginTransaction();
						$jobId = Job::CreateAutoImportJob($CompanyID,$job_type,$data);
						DB::commit();

					}
					/* Job Block End */
					$jobID = !empty($jobId) ? $jobId : 0;
					$SaveData["JobID"] = $jobID;
					$SaveData["CompanyID"] = $CompanyID;
					AutoImportRate::insert($SaveData);

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