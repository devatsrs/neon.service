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
class ReadEmailsAutoRateImport extends Command
{

    protected $name = 'reademailsautorateimport';
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
						$AttachmentName = '';
						$aAttachmentCount = $oMessage->getAttachments()->count();
						$cc = $oMessage->getCc();
						$ccemail = $emailread->getCC($cc);

						if ($aAttachmentCount > 0) {
							$aAttachment = $oMessage->getAttachments();
							$AttachmentNamearr = [];
							$SheetAttachName_arr = [];
							foreach ($aAttachment as $oAttachment) {

								$AttachmentNamearr[] = $oAttachment->getName();
								$filename = $oAttachment->getName();
								$extension = \File::extension($filename);
                                if (in_array(strtolower($extension), array('xls','csv','xlsx') ))
                                {
                                    $SheetAttachName_arr[] = $oAttachment->getName();
                                }
								/*
								$uploadAttach = time().$oAttachment->getName();
								$amazonPath = $AttachmentPath = storage_path() . '/Vendorrate_fromEmail/';
                                $oAttachment->save($AttachmentPath, $uploadAttach); */


							}
							$CommaSeparate_Attachment = implode(", ", $AttachmentNamearr);
							$AttachmentName = !empty($CommaSeparate_Attachment) ? $CommaSeparate_Attachment : '';
							$Final_AttachmentName = !empty($SheetAttachName_arr) ? time().$SheetAttachName_arr[0] : '';

						} else {
							$AttachmentName = '';
						}

						if(!empty($MessageId)){
							$checkAlreadyExists = AutoImportRate::where('MessageId','=',$MessageId)->count();
						}else{
							$checkAlreadyExists = AutoImportRate::where('MailDateTime','=',$MailDateTime)->count();
						}

						$autoImportSetting = $emailread->GetMatchSubjectEmail($fromMail,$CompanyID);

						/* If "Sendor Email" And "From Email" Match Then We read the email and Save in table (tblAutoImport)  */
						if( $autoImportSetting > 0 && $checkAlreadyExists == 0 ){

								$SaveData = array(
									"AccountName" => $sender[0]->personal,
									"Subject" => $oMessage->getSubject(),
									"Description" => $oMessage->getTextBody(),
									"Attachment" => $AttachmentName,
									"To" => $to[0]->mail,
									"From" => $fromMail,
									"CC" => $ccemail,
									"MailDateTime" => $MailDateTime,
									"MessageId" => $MessageId,
									"created_at" => date('Y-m-d H:i:s'),
									"created_by" => "System"
								);
								AutoImportRate::insert($SaveData);



							
								$amazonPath = AmazonS3::generate_upload_path(AmazonS3::$dir['AUTOIMPORT_UPLOAD'],'',$CompanyID);
								Log::info($amazonPath);
								if(!AmazonS3::upload($Final_AttachmentName,$amazonPath,$CompanyID)){
									// Error code like email send for reason
								}


								$query = "call prc_ImportSettingMatch ( '".$from[0]->mail."','".$oMessage->getSubject()."','".$Final_AttachmentName."' )";
								Log::info($query);
								$results = DB::select($query);

								/* Job Log Start  ( IF Mail Match With Setting Then Job Log   )*/
								if( !empty($results) ) {
									//Log::info(print_r($results));
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
									Job::CreateAutoImportJob($CompanyID,$job_type,$data);
									DB::commit();

								}
								/* Job Block End */

						}

					}

				}



    }
	

}
