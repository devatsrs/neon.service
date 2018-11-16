<?php
/**
 * Created by PhpStorm.
 * User: srs2
 * Date: 25/05/2015
 * Time: 06:58 
 */

namespace App\Console\Commands;


use App\Lib\Account;
use App\Lib\AmazonS3;
use App\Lib\Company;
use App\Lib\CompanyConfiguration;
use App\Lib\CompanySetting;
use App\Lib\CustomerTrunk;
use App\Lib\CronHelper;
use App\Lib\Helper;
use App\Lib\Job;
use App\Lib\NeonExcelIO;
use App\Lib\RateSheetDetails;
use App\Lib\Timezones;
use App\Lib\User;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;
use Webpatser\Uuid\Uuid;
use \Exception;

class CustomerRateSheetGenerator extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'customerratesheet';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Command description.';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }
    protected function getArguments()
    {
        return [
            ['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID '],
            ['JobID', InputArgument::REQUIRED, 'Argument JobID '],
        ];
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function handle()
    {

        CronHelper::before_cronrun($this->name, $this );

        $arguments = $this->argument();
        $getmypid = getmypid(); // get proccess id added by abubakar
        $JobID = $arguments["JobID"];
        $CompanyID = $arguments["CompanyID"];
        $job = Job::find($JobID);
        $accounts = '';
        $countuser = 0;
        $countcust = 0;
        $errorsuser = array();
        $errorscustomer = array();
        $errorslog = array();
        $emailstatus = array('status' => 0, 'message' => '');
        $UPLOADPATH = CompanyConfiguration::get($CompanyID,'UPLOAD_PATH');
        $userInfo = User::getUserInfo($job->JobLoggedUserID);
        $CustomerEmailSend=0;
        if (!empty($job)) {
            $ProcessID = Uuid::generate();
            $joboptions = json_decode($job->Options); 
            if (count($joboptions) > 0) {
                if(isset($joboptions->SelectedIDs)){
                    $ids = $joboptions->SelectedIDs;
                }else if($job->AccountID >0 ){
                    $ids = $job->AccountID;
                }

                if(isset($joboptions->SelectedIDs) && !empty($joboptions->sendMail)){
                    $CustomerEmailSend=1;
                }

                $criteria = '';
                if (!empty($joboptions->criteria)) {
                    $criteria = json_decode($joboptions->criteria);
                }

                $RateSheetTemplate = CompanySetting::getKeyVal($CompanyID,'RateSheetTemplate') != 'Invalid Key' ? json_decode(CompanySetting::getKeyVal($CompanyID,'RateSheetTemplate')) : '';
                $RateSheetTemplateFile = '';
                if($RateSheetTemplate != '') {
                    $RateSheetTemplateFile = $RateSheetTemplate->Excel;
                }
                if($RateSheetTemplateFile != '') {
                    $downloadtype = 'xlsx';
                } else {
                    if(!empty($joboptions->downloadtype)){
                        $downloadtype = $joboptions->downloadtype;
                    }else{
                        $downloadtype = 'xlsx';
                    }
                }
                $count = 0;
                Log::useFiles(storage_path() . '/logs/customerratesheet-' . $JobID . '-' . date('Y-m-d') . '.log');
                Log::info('job start ' . $JobID);
                $Company = Company::find($CompanyID);
                Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Change by abubakar
                Log::info('job transaction start ' . $JobID);
                if (!empty($ids)) {


                    $ids = explode(',', $ids);
                    if (count($ids) > 0) {
                        $accounts = Account::whereIn('AccountID', $ids)->get();
                    } else {
                        $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                        $jobdata['JobStatusMessage'] = 'ids is empty';
                    }
                } else {

                    if (!empty($criteria)) {

                        $account = Account::leftjoin('tblUser', 'tblAccount.Owner', '=', 'tblUser.UserID')->select('tblAccount.*');
                        $account->where(["tblAccount.CompanyID" => $CompanyID]);
                        $account->where(["tblAccount.AccountType" => 1]);
                        if (isset($criteria->account_name) && !empty($criteria->account_name)) {
                            $account->where('tblAccount.AccountName', 'like', '%' . $criteria->account_name . '%');
                        }
                        if (isset($criteria->account_number) && !empty($criteria->account_number)) {
                            $account->where('tblAccount.Number', 'like', '%' . $criteria->account_number . '%');
                        }
                        if (isset($criteria->contact_name) && !empty($criteria->contact_name)) {
                            $account->leftjoin('tblContact', 'tblContact.Owner', '=', 'tblAccount.AccountID');
                            $account->whereRaw(" CONCAT(tblContact.FirstName,' ',tblContact.LastName) like '%" . $criteria->contact_name . "%'");
                        }
                        if (isset($criteria->account_active)) {
                            if ($criteria->account_active == 'true') {
                                $account->where('tblAccount.Status', 1);
                            } else {
                                $account->where('tblAccount.Status', 0);
                            }
                        }
                        if (isset($criteria->vendor_on_off) && $criteria->vendor_on_off == 'true') {
                            $account->where('tblAccount.IsVendor', 1);
                        }
                        if (isset($criteria->customer_on_off) && $criteria->customer_on_off == 'true') {
                            $account->where('tblAccount.IsCustomer', 1);
                        }
                        if (isset($criteria->verification_status) && trim($criteria->verification_status) >= 0) {
                            $account->where('tblAccount.VerificationStatus', (int)$criteria->verification_status);
                        }

                        if (isset($criteria->tag) && trim($criteria->tag) != '') {
                            $account->where('tblAccount.tags', 'like', '%' . trim($criteria->tag) . '%');
                        }
                        if (isset($criteria->low_balance) && $criteria->low_balance == 'true') {
                            $account->leftjoin('tblAccountBalance', 'tblAccountBalance.AccountID', '=', 'tblAccount.AccountID');
                            $account->whereRaw("(CASE WHEN tblAccountBalance.BalanceThreshold LIKE '%p' THEN REPLACE(tblAccountBalance.BalanceThreshold, 'p', '')/ 100 * tblAccountBalance.PermanentCredit ELSE tblAccountBalance.BalanceThreshold END) < tblAccountBalance.BalanceAmount");
                        }

                        if (isset($criteria->account_owners) && trim($criteria->account_owners) > 0) {
                            $account->where('tblAccount.Owner', (int)$criteria->account_owners);
                        }
                        //DB::enableQueryLog();
                        $accounts = $account->get();
                    } else {
                        $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                        $jobdata['JobStatusMessage'] = 'id or criteria is not given';
                    }
                }
                if (!empty($accounts)) {
                    foreach ($accounts as $account) {
                        try {
                            DB::beginTransaction();

                            $Timezones = array();
                            if(is_array($joboptions->Timezones)) {
                                $Timezones = $joboptions->Timezones;
                            } else {
                                $Timezones[] = $joboptions->Timezones;
                            }

                            if($CustomerEmailSend==1 && is_array($joboptions->Trunks)){
                                if(count($joboptions->Trunks)==1){
                                    $jobtrunkname = DB::table('tblTrunk')->where(array('TrunkID'=>$joboptions->Trunks[0]))->pluck('Trunk');
                                    $file_name = $jobtrunkname.'-'.$account->AccountName.'-'.date('YmdHis');
                                }else{
                                    $jobtrunkname = DB::table('tblTrunk')->where(array('TrunkID'=>$joboptions->Trunks[0]))->pluck('Trunk');
                                    $file_name = $jobtrunkname.'-'.$account->AccountName.'-'.date('YmdHis');
                                }

                            }else{
                                $trunk = is_array($joboptions->Trunks) ? $joboptions->Trunks[0] : $joboptions->Trunks;
                                $jobtrunkname = DB::table('tblTrunk')->where(array('TrunkID'=>$trunk))->pluck('Trunk');
                                $file_name = $jobtrunkname.'-'.$account->AccountName.'-'.date('YmdHis');
                            }

                            log::info('file name '.$file_name);

                            //$file_name = Job::getfileName($account->AccountID, $joboptions->Trunks, 'customerdownload');
                            $amazonPath = AmazonS3::generate_upload_path(AmazonS3::$dir['CUSTOMER_DOWNLOAD'], $account->AccountID, $CompanyID);
                            $local_dir = $UPLOADPATH . '/' . $amazonPath;
                            $excel_data_all = array();
                            $data = array();
                            $data['Company'] = $Company;
                            $data['Account'] = $account;
                            //$replace_array = Helper::create_replace_array($account,array(),$userInfo);

                            $trunks = DB::table('tblCustomerTrunk')->join("tblTrunk","tblTrunk.TrunkID", "=","tblCustomerTrunk.TrunkID")->where(["tblCustomerTrunk.Status"=> 1])->where(["tblCustomerTrunk.AccountID"=>$account->AccountID])->where(["tblCustomerTrunk.CompanyID"=>$CompanyID])->select(array('tblCustomerTrunk.TrunkID'))->lists('TrunkID');

                            if (isset($joboptions->isMerge) && $joboptions->isMerge ==1 && isset($joboptions->Trunks) && is_array($joboptions->Trunks)) {

                                $trunk_prefix = '';
                                $trunk_name = '';
                                foreach ($joboptions->Trunks as $trunk) {
                                    foreach ($Timezones as $Timezone) {
                                        if (in_array($trunk, $trunks)) {
                                            $excel_data = array();
                                            $trunkname = DB::table('tblTrunk')->where(array('TrunkID' => $trunk))->pluck('Trunk');
                                            $timezonename = Timezones::find($Timezone)->Title;
                                            Log::info('job start prc_WSGenerateRateSheet for AccountName ' . $account->AccountName . ' job ' . $JobID);
                                            $excel_data = DB::select("CALL prc_WSGenerateRateSheet(" . $account->AccountID . ",'" . $trunk . "','" . $Timezone . "')");
                                            Log::info('job end prc_WSGenerateRateSheet for AccountName ' . $account->AccountName . ' job ' . $JobID);
                                            if (empty($excel_data)) {
                                                $msg = 'No rate sheet data found against account: ' . $account->AccountName . ' trunk: ' . $trunkname . ' timezone: ' . $timezonename;
                                                Log::info($msg);
                                                throw new Exception($msg);
                                            }
                                            $excel_data = json_decode(json_encode($excel_data), true);
                                            $RateSheetID = RateSheetDetails::SaveToDetail($account->AccountID, $trunkname, $Timezone, $file_name, $excel_data);
                                            RateSheetDetails::DeleteOldRateSheetDetails($RateSheetID, $account->AccountID, $trunkname, $Timezone);
                                            $data['excel_data'][$trunkname . ' - ' . $timezonename] = $excel_data;
                                            /*Customer trunk */
                                            $customertrunkprefix = CustomerTrunk::where(['AccountID' => $account->AccountID, 'TrunkID' => $trunk, 'Status' => 1])->pluck('Prefix');
                                            if (!empty($customertrunkprefix)) {
                                                $trunk_prefix .= $customertrunkprefix . '-';
                                            }
                                            $trunk_name .= $trunkname . '-';
                                        }
                                    }
                                }

                                $this->generatemultisheetexcel($file_name, $data, $local_dir,$downloadtype);
                                //$file_name .= '.'.$downloadtype;
                                $file_name .= '.xlsx';
                                Log::info('job is merge 1 ' . $JobID);
                                $trunk_prefix=rtrim($trunk_prefix,'-');
                                $trunk_name=rtrim($trunk_name,'-');
                                Log::info('trunk_prefix end ' . $trunk_prefix);
                                $account->trunkprefix = $trunk_prefix;
                                $account->trunk_name = $trunk_name;
                                $sheetstatusupdate = $this->sendRateSheet($JobID,$job,$ProcessID,$joboptions,$local_dir,$file_name,$account,$CompanyID,$userInfo,$Company,$countcust,$countuser,$errorscustomer,$errorslog,$errorsuser);
                                extract($sheetstatusupdate);
                                if (!AmazonS3::upload($local_dir . '/' . $file_name, $amazonPath,$CompanyID)) {
                                    throw new Exception('Error in Amazon upload');
                                }

                            } else if (isset($joboptions->isMerge) && $joboptions->isMerge ==0 &&  isset($joboptions->Trunks) && is_array($joboptions->Trunks)) {
//maybe this condition will never match


                                foreach ($joboptions->Trunks as $trunk) {
                                    foreach ($Timezones as $Timezone) {
                                        if (in_array($trunk, $trunks)) {
                                            $trunkname = DB::table('tblTrunk')->where(array('TrunkID' => $trunk))->pluck('Trunk');
                                            $timezonename = Timezones::find($Timezone)->Title;
                                            Log::info('job start prc_WSGenerateRateSheet for AccountName ' . $account->AccountName . ' job ' . $JobID);
                                            $excel_data = DB::select("CALL prc_WSGenerateRateSheet(" . $account->AccountID . ",'" . $trunk . "','" . $Timezone . "')");
                                            Log::info('job end prc_WSGenerateRateSheet for AccountName ' . $account->AccountName . ' job ' . $JobID);
                                            Log::info('job RateSheetDetails start for AccountName ' . $account->AccountName . ' job ' . $JobID);
                                            if (empty($excel_data)) {
                                                $msg = 'No rate sheet data found against account: ' . $account->AccountName . ' trunk: ' . $trunkname . ' timezone: ' . $timezonename;
                                                Log::info($msg);
                                                throw new Exception($msg);
                                            }
                                            $excel_data = json_decode(json_encode($excel_data), true);
                                            $RateSheetID = RateSheetDetails::SaveToDetail($account->AccountID, $trunkname, $Timezone, $file_name, $excel_data);
                                            $data['excel_data'] = $excel_data;
                                            /*Customer trunk */
                                            $customertrunkprefix = CustomerTrunk::where(['AccountID' => $account->AccountID, 'TrunkID' => $trunk, 'Status' => 1])->pluck('Prefix');
                                            $data['Account']->trunkprefix = $customertrunkprefix;
                                            $data['Account']->trunk_name = $trunkname;

                                            $this->generateexcel($file_name, $data, $local_dir, $downloadtype);
                                            $file_name .= '.' . $downloadtype;
                                            Log::info("job RateSheetDetails end for AccountName '" . $account->AccountName . "'" . $JobID);
                                            RateSheetDetails::DeleteOldRateSheetDetails($RateSheetID, $account->AccountID, $trunkname, $Timezone);
                                            Log::info("job RateSheetDetails old deleted for AccountName '" . $account->AccountName . "'" . $JobID);
                                            /*Customer trunk */
                                            //$customertrunkprefix = CustomerTrunk::where(['AccountID'=>$account->AccountID,'TrunkID'=>$trunk,'Status'=>1])->pluck('Prefix');
                                            $account->trunkprefix = $customertrunkprefix;
                                            $account->trunk_name = $trunkname;
                                            $sheetstatusupdate = $this->sendRateSheet($JobID, $job, $ProcessID, $joboptions, $local_dir, $file_name, $account, $CompanyID, $userInfo, $Company, $countcust, $countuser, $errorscustomer, $errorslog, $errorsuser);
                                            extract($sheetstatusupdate);
                                            if (!AmazonS3::upload($local_dir . '/' . $file_name, $amazonPath, $CompanyID)) {
                                                throw new Exception('Error in Amazon upload');
                                            }
                                            Log::info('job is merge 0 ' . $JobID);
                                        }
                                    }
                                }

                            }else if (isset($joboptions->Trunks) && !is_array($joboptions->Trunks)) {

                                //Log::info("Trunks" . $joboptions->Trunks );

                                if(in_array($joboptions->Trunks,$trunks)) {
                                    $trunkname = DB::table('tblTrunk')->where(array('TrunkID' => $joboptions->Trunks))->pluck('Trunk');
                                    foreach ($Timezones as $Timezone) {
                                        $timezonename = Timezones::find($Timezone)->Title;
                                        Log::info('job start prc_WSGenerateRateSheet for AccountName ' . $account->AccountName . ' job ' . $JobID);
                                        $excel_data = DB::select("CALL prc_WSGenerateRateSheet(" . $account->AccountID . ",'" . $joboptions->Trunks . "','" . $Timezone . "')");
                                        if (empty($excel_data)) {
                                            $msg = 'No rate sheet data found against account: ' . $account->AccountName . ' trunk: ' . $trunkname . ' timezone: ' . $timezonename;
                                            Log::info($msg);
                                            throw new Exception($msg);
                                        }
                                        Log::info('job end prc_WSGenerateRateSheet for AccountName ' . $account->AccountName . ' job ' . $JobID);
                                        Log::info('job RateSheetDetails start for AccountName ' . $account->AccountName . ' job ' . $JobID);
                                        $excel_data = json_decode(json_encode($excel_data), true);
                                        $RateSheetID = RateSheetDetails::SaveToDetail($account->AccountID, $trunkname, $Timezone, $file_name, $excel_data);
                                        $data['excel_data'] = $excel_data;
                                        /*Customer trunk */
                                        $customertrunkprefix = CustomerTrunk::where(['AccountID' => $account->AccountID, 'TrunkID' => $joboptions->Trunks, 'Status' => 1])->pluck('Prefix');
                                        $data['Account']->trunkprefix = $customertrunkprefix;
                                        $data['Account']->trunk_name = $trunkname;

                                        $this->generateexcel($file_name, $data, $local_dir, $downloadtype);
                                        $file_name .= '.' . $downloadtype;
                                        Log::info("job RateSheetDetails end for AccountName '" . $account->AccountName . "'" . $JobID);
                                        RateSheetDetails::DeleteOldRateSheetDetails($RateSheetID, $account->AccountID, $trunkname, $Timezone);
                                        Log::info("job RateSheetDetails old deleted for AccountName '" . $account->AccountName . "'" . $JobID);
                                        /*Customer trunk */
                                        //$customertrunkprefix = CustomerTrunk::where(['AccountID'=>$account->AccountID,'TrunkID'=>$joboptions->Trunks,'Status'=>1])->pluck('Prefix');
                                        $account->trunkprefix = $customertrunkprefix;
                                        $account->trunk_name = $trunkname;
                                        $sheetstatusupdate = $this->sendRateSheet($JobID, $job, $ProcessID, $joboptions, $local_dir, $file_name, $account, $CompanyID, $userInfo, $Company, $countcust, $countuser, $errorscustomer, $errorslog, $errorsuser);
                                        extract($sheetstatusupdate);
                                        if (!AmazonS3::upload($local_dir . '/' . $file_name, $amazonPath, $CompanyID)) {
                                            throw new Exception('Error in Amazon upload');
                                        }
                                        Log::info('job is merge 0 old logic' . $JobID);
                                    }
                                }
                            }else{
                                throw new Exception('Not option matched');
                            }
                            if ($joboptions->sendMail == 0) {
                                $fullPath = $amazonPath . $file_name; //$destinationPath . $file_name;
                                $jobdata['OutputFilePath'] = $fullPath;
                                $jobdata['updated_at'] = date('Y-m-d H:i:s');
                                $jobdata['ModifiedBy'] = 'RMScheduler';
                                Job::where(["JobID" => $JobID])->update($jobdata);
                            }
                            DB::commit();
                            Log::info('job transaction commit ' . $JobID);
                        } catch (Exception $e) {
                            try {
                                DB::rollback();
                            } catch (Exception $err) {
                                Log::error($err);
                            }
                            $errorslog[] = 'Account '.$account->AccountName.' exception '. $e->getMessage();
                            Log::error('Account'.$account->AccountName.' exception '.$e);
                        }
                    }

                    if (count($errorsuser)>0 || count($errorscustomer)>0 || count($errorslog)>0) {
                        $jobdata['JobStatusMessage'] = 'RateSheet Generated Successfully, ' ;
                        $jobdata['JobStatusMessage'] .= $countuser.' email sent to users, '.count($errorsuser).' Skipped users ,'.implode(',\n\r',$errorsuser);
                        $jobdata['JobStatusMessage'] .= $countcust.' email sent to account, '.count($errorscustomer).' Skipped Account ,'.implode(',\n\r',$errorscustomer);
                        $jobdata['JobStatusMessage'] .= count($errorslog).' accounts exception ,'.implode(',\n\r',$errorslog);

                        $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'PF')->pluck('JobStatusID');
                        $emaildata['Status'] = DB::table('tblJobStatus')->where('Code', 'PF')->pluck('Title');
                        $jobdata['updated_at'] = date('Y-m-d H:i:s');
                        $jobdata['ModifiedBy'] = 'RMScheduler';
                    } else {
                        $jobdata['JobStatusMessage'] = 'RateSheet Generated Successfully';
                        if ($joboptions->sendMail == 1) {
                            $jobdata['JobStatusMessage'] .= ' and send mail to customer';
                        }
                        $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'S')->pluck('JobStatusID');
                        $emaildata['Status'] = DB::table('tblJobStatus')->where('Code', 'S')->pluck('Title');
                        $jobdata['updated_at'] = date('Y-m-d H:i:s');
                        $jobdata['ModifiedBy'] = 'RMScheduler';
                    }

                } else {
                    $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                    $jobdata['JobStatusMessage'] = 'No Data Found';
                }
            } else {
                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                $jobdata['JobStatusMessage'] = 'No Data Found';
            }
        } else {
            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
            $jobdata['JobStatusMessage'] = 'No Data Found';
        }

        Job::where(["JobID" => $JobID])->update($jobdata);

        $emaildata['JobStatusMessage'] = $jobdata['JobStatusMessage'];
        $emaildata['Title'] = $job->Title;
        $emaildata['EmailTo'] = explode(',', $userInfo->EmailAddress);
        $emaildata['EmailToName'] = $userInfo->FirstName . ' ' . $userInfo->LastName;
        $emaildata['Subject'] = $job->Title;
        $emaildata['CompanyID'] = $CompanyID;


        if ($emailstatus['status'] == 0) {
//            Job::send_job_status_email($job,$CompanyID);
        }else {
            Job::where(["JobID" => $JobID])->update(array('EmailSentStatus' => $emailstatus['status'], 'EmailSentStatusMessage' => $emailstatus['message']));
            Log::info('job end ' . $JobID);
        }

        CronHelper::after_cronrun($this->name, $this);

    }
    protected function setSheetHeader($sheet,$data,$header_data){
        $count = 1;
        $sheet->row($count++, array());
        $sheet->mergeCells('A'.$count.':H'.$count);
        $sheet->getCell('A'.$count)->setValue('Company Name: '.$data['Company']->CompanyName);
        $sheet->cells('A'.$count, function($cells) {
            $cells->setFontWeight('bold');
        });
        $count++;
        $sheet->mergeCells('A'.$count.':H'.$count);
        $sheet->getCell('A'.$count)->setValue('Reference Number: '.date('Ymd'));
        $sheet->cells('A'.$count, function($cells) {
            $cells->setFontWeight('bold');
        });

        $count++;
        $sheet->row($count++, array());
        $sheet->row($count, $header_data);
        $sheet->row($count, function($row) {
            // call cell manipulation methods
            $row->setFontWeight('bold');
        });


        return $count;
    }
    protected function setSheetFooter($sheet,$count,$data){
        $sheet->row($count, array());
        $count++;
        $data['text'] = $data['Company']->RateSheetExcellNote;
        $notelist = explode(PHP_EOL, generic_replace($data));
        foreach($notelist as $line){
            $sheet->mergeCells('A'.$count.':H'.$count);
            $sheet->getCell('A'.$count)->setValue($line);
            $count++;
        }
        return $sheet;
    }
    public function generateexcel($file_name,$data,$local_dir,$downloadtype){

        if($downloadtype == 'xlsx'){
            $file_path = $local_dir.$file_name.'.xlsx';
        }else{
            $file_path = $local_dir.$file_name.'.csv';
        }


        $NeonExcel = new NeonExcelIO($file_path);
        $NeonExcel->write_ratessheet_excel_generate($data,$downloadtype);

        /*Excel::create($file_name, function ($excel) use ($excel_data_sheet,$header_data,$file_name,$data) {
            $excel->sheet('Sheet', function ($sheet) use ($excel_data_sheet,$header_data,$data) {
                $count = $this->setSheetHeader($sheet,$data,$header_data);
                $count++;
                $sheet->fromArray($excel_data_sheet,'','A'.$count,'',false);
                $count = count($excel_data_sheet)+$count;
                $this->setSheetFooter($sheet,$count,$data);
            });
        })->store('xlsx',$local_dir);*/
    }


    public function generatemultisheetexcel($file_name,$data,$local_dir,$downloadtype){

        if($downloadtype == 'xlsx'){
            $file_path = $local_dir.$file_name.'.xlsx';
        }else{
            $file_path = $local_dir.$file_name.'.csv';
        }

        $file_path = $local_dir.$file_name.'.xlsx';
        $NeonExcel = new NeonExcelIO($file_path);
        $NeonExcel->write_multi_ratessheet_excel_generate($data,$downloadtype);

        /*
        Excel::create($file_name, function ($excel) use ($data,$file_name) {
            $excel_data = isset($data['excel_data'])?$data['excel_data']:array();
            foreach($excel_data as $trunk => $excel_rows) {
                $excel_data_sheet = array();
                $header_data = array();
                foreach($excel_rows as $excel_data_rr){
                    array_shift($excel_data_rr);
                    array_shift($excel_data_rr);
                    array_shift($excel_data_rr);
                    $excel_data_sheet[] = $excel_data_rr;
                    $header_data = array_keys($excel_data_rr);
                }
                $header_data  = array_map('ucwords',$header_data);
                array_walk($header_data , 'custom_replace');
                if(count($header_data) == 0){
                    $header_data[] = 'Destination';
                    $header_data[] = 'Codes';
                    $header_data[] = 'Tech Prefix';
                    $header_data[] = 'Interval';
                    $header_data[] = 'Rate Per Minute (USD)';
                    $header_data[] = 'Level';
                    $header_data[] = 'Change';
                    $header_data[] = 'Effective Date';
                }
                $excel->sheet($trunk, function ($sheet) use ($excel_data_sheet, $header_data, $data) {
                    $count = $this->setSheetHeader($sheet, $data, $header_data);
                    $count++;
                    $sheet->fromArray($excel_data_sheet, '', 'A' . $count, '', false);
                    $count = count($excel_data_sheet) + $count;
                    $this->setSheetFooter($sheet, $count, $data);
                });
            }
        })->store('xlsx',$local_dir);*/

    }

    public function sendRateSheet($JobID,$job,$ProcessID,$joboptions,$local_dir,$file_name,$account,$CompanyID,$userInfo,$Company,$countcust,$countuser,$errorscustomer,$errorslog,$errorsuser){
        if ($joboptions->sendMail == 1) {
            $emaildata['Subject'] = $joboptions->subject;
            $emaildata['attach'] = $local_dir . basename($file_name);
            $EMAIL_TO_CUSTOMER = CompanyConfiguration::get($CompanyID,'EMAIL_TO_CUSTOMER');
            if ($joboptions->test == 1) {
                $emaildata['EmailTo'] = $joboptions->testEmail;
                $emaildata['EmailToName'] = 'test name';
            } else if($EMAIL_TO_CUSTOMER == 1){
                $emaildata['EmailTo'] = $account->Email;
                $emaildata['EmailToName'] = $account->FirstName . ' ' . $account->LastName;
            }

            if(!is_array($emaildata['EmailTo'])){
                $emaildata['EmailTo'] = explode(',',$emaildata['EmailTo']);
            }
            $emaildata['EmailTo'] = array_merge($emaildata['EmailTo'],explode(',', $userInfo->EmailAddress));
            $replace_array = Helper::create_replace_array($account,array(),$userInfo);
            $replace_array['TrunkPrefix'] = empty($account->trunkprefix)?'':$account->trunkprefix;
            $replace_array['TrunkName'] = empty($account->trunk_name)?'':$account->trunk_name;

         //   $joboptions->message = template_var_replace($joboptions->message,$replace_array);
			$message =  template_var_replace($joboptions->message,$replace_array);
            $emaildata['Subject'] =  template_var_replace($emaildata['Subject'],$replace_array);
            $emaildata['Message'] = $message;
            $emaildata['CompanyName'] = $Company->CompanyName;
            $emaildata['CompanyID'] = $CompanyID;
			if(isset($joboptions->email_from))
			{
				$emaildata['EmailFrom'] = $joboptions->email_from;
			}
            $emailstatus = $emailstatuscustomer = Helper::sendMail('emails.template', $emaildata);

            if (isset($emailstatuscustomer["status"]) && $emailstatuscustomer["status"] == 0) {
                $errorscustomer[] = $account->AccountName .' Email Exception'. $emailstatuscustomer["message"];
            } else {
                $countcust++;
                /** log emails against account */
                $statuslog = Helper::account_email_log($CompanyID,$account->AccountID,$emaildata,$emailstatuscustomer,$userInfo,$ProcessID,$JobID);
                if ($statuslog['status'] == 0) {
                    $errorslog[] = $account->AccountName . ' email log exception:' . $statuslog['message'];
                }
            }
        }else{
            $emaildata['attach'] = $local_dir . basename($file_name);
            $emaildata['EmailTo'] = explode(',', $userInfo->EmailAddress);
            $emaildata['EmailToName'] = $userInfo->FirstName . ' ' . $userInfo->LastName;
            $emaildata['Subject'] = $job->Title . ' ' . $account->RateEmail;
            $emaildata['CompanyName'] = $Company->CompanyName;
            $emaildata['CompanyID'] = $CompanyID;
			if(isset($joboptions->email_from))
			{
				$emaildata['EmailFrom'] = $joboptions->email_from;
			}
			
            $emailstatus = Helper::sendMail('emails.ratesheetgenerator', $emaildata);

            if($emailstatus['status']==0){
                $errorsuser[] = $userInfo->FirstName.' Email exception: '.$emailstatus['status'];
            }else{
                $countuser ++;
            }
        }
        $sheetstatusupdate['countcust'] = $countcust;
        $sheetstatusupdate['countuser'] = $countuser;
        $sheetstatusupdate['errorscustomer'] = $errorscustomer;
        $sheetstatusupdate['errorslog'] = $errorslog;
        $sheetstatusupdate['errorsuser'] = $errorsuser;
        $sheetstatusupdate['emailstatus'] =$emailstatus;
        return $sheetstatusupdate;
    }


}