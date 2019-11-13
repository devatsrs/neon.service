<?php
namespace App\Console\Commands;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\Helper;
use App\Lib\Job;
use App\Lib\JobStatus;
use App\Lib\JobType;
use App\Lib\RateTable;
use App\Lib\User;
use Illuminate\Console\Command;
use Symfony\Component\Console\Input\InputArgument;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Webpatser\Uuid\Uuid;

class RateTableGenerator extends Command {
    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'ratetablegenerator';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Generate rates against given rate table';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }
    /**
     * Get the console command arguments.
     *
     * @return array
     */
    protected function getArguments()
    {
        return [
            ['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID '],
            ['JobID', InputArgument::REQUIRED, 'Argument JobID'],
            ['CronJobID', InputArgument::OPTIONAL, 'Argument CronJobID']
        ];
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function fire()
    {

        CronHelper::before_cronrun($this->name, $this );


        $arguments = $this->argument();
        $getmypid = getmypid(); // get proccess id added by abubakar
        $JobID = $arguments["JobID"];
        $CronJobID = $arguments["CronJobID"];
        $CompanyID = $arguments["CompanyID"];
        $job = Job::find($JobID);

        $userInfo = User::getUserInfo($job->JobLoggedUserID);
        $username = User::get_user_full_name($job->JobLoggedUserID);
        $joboptions = json_decode($job->Options);
        Log::useFiles(storage_path().'/logs/ratetablegenerator-'.$JobID.'-'.date('Y-m-d').'.log');
        Log::info('job start '.$JobID);
        Log::info('job parameter '.$JobID . ' ' . $CronJobID . ' ' . $CompanyID);
        $emailstatus = array('status'=>0,'message'=>'');

        try {
            $ProcessID = Uuid::generate();
            Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Change by abubakar
            $data =array();
            $data['RateGeneratorId'] = $joboptions->RateGeneratorId;
            $data['RateTableID'] = -1;
            $data['rate_table_name'] = "";
            $data['EffectiveDate'] = date('Y-m-d',strtotime($joboptions->EffectiveDate));
            if(isset($joboptions->rate_table_name)){
                $data['rate_table_name'] = $joboptions->rate_table_name;
            }elseif(isset($joboptions->RateTableId)){
                $data['RateTableID'] = $joboptions->RateTableId;
            }
			
			if(isset($joboptions->replace_rate)){
					$data['replace_rate']= $joboptions->replace_rate;	
			}else{
				$data['replace_rate']= 0;
			}
			
			if(isset($joboptions->EffectiveRate)){
					$data['EffectiveRate']= $joboptions->EffectiveRate;	
			}else{
				$data['EffectiveRate']= 'now';
			}			

            $data['CompanyID'] = $CompanyID;

            $RateGenerator = \RateGenerator::find($data['RateGeneratorId']);

            $Policy = $RateGenerator->Policy;
            $GroupBy = $RateGenerator->GroupBy;
            $Timezones = $RateGenerator->Timezones;
            $IsMerge = $RateGenerator->IsMerge;

            $info = $error = array();
            if($RateGenerator->SelectType == \RateGenerator::Package) { // for DID

                $query = "CALL prc_WSGenerateRateTablePackage(".$JobID.","  .$data['RateGeneratorId']. "," . $data['RateTableID']. ",'".$data['rate_table_name']."','".$data['EffectiveDate']."',".$data['replace_rate'].",'".$data['EffectiveRate']."','".$username."')";
                Log::info($query);
                $JobStatusMessage = DB::select($query);
                $JobStatusMessage = array_reverse(json_decode(json_encode($JobStatusMessage),true));
                if(count($JobStatusMessage) > 0){
                    foreach ($JobStatusMessage as $JobStatusMessage1) {
                        if(is_numeric($JobStatusMessage1['Message'])) {
                            Log::info("Rate Generator Zone ." . $JobStatusMessage1['Message']);
                            $info[] = 'RateTable Created Successfully';
                        } else {
                            $error[] = $JobStatusMessage1['Message'];
                        }
                    }
                }

            }else if($RateGenerator->SelectType == \RateGenerator::DID) { // for DID

                $query = "CALL prc_WSGenerateRateTableDID(".$JobID.","  .$data['RateGeneratorId']. "," . $data['RateTableID']. ",'".$data['rate_table_name']."','".$data['EffectiveDate']."',".$data['replace_rate'].",'".$data['EffectiveRate']."','".$username."')";
                Log::info($query);
                $JobStatusMessage = DB::select($query);
                $JobStatusMessage = array_reverse(json_decode(json_encode($JobStatusMessage),true));
                if(count($JobStatusMessage) > 0){
                    foreach ($JobStatusMessage as $JobStatusMessage1) {
                        if(is_numeric($JobStatusMessage1['Message'])) {
                            $info[] = 'RateTable Created Successfully';
                        } else {
                            $error[] = $JobStatusMessage1['Message'];
                        }
                    }
                }

            }else if($IsMerge == 1) { // if merge by timezones
                $TakePrice = $RateGenerator->TakePrice;
                $MergeInto = $RateGenerator->MergeInto;

                if($Policy == \LCR::LCR_PREFIX){
                    $query = "CALL prc_WSGenerateRateTableWithPrefix(".$JobID.","  .$data['RateGeneratorId']. "," . $data['RateTableID']. ",'".$data['rate_table_name']."','".$data['EffectiveDate']."',".$data['replace_rate'].",'".$data['EffectiveRate']."','".$username."')";
                    Log::info($query);
                    $JobStatusMessage = DB::select($query);
                } else {
                    $query = "CALL prc_WSGenerateRateTable(".$JobID.","  .$data['RateGeneratorId']. "," . $data['RateTableID']. ",'".$data['rate_table_name']."','".$data['EffectiveDate']."',".$data['replace_rate'].",'".$data['EffectiveRate']."','".$username."')";
                    Log::info($query);
                    $JobStatusMessage = DB::select($query);
                }

                $JobStatusMessage = array_reverse(json_decode(json_encode($JobStatusMessage),true));
                if(count($JobStatusMessage) > 0){
                    foreach ($JobStatusMessage as $JobStatusMessage1) {
                        if(is_numeric($JobStatusMessage1['Message'])) {
                            $info[] = 'RateTable Created Successfully';
                        } else {
                            $error[] = $JobStatusMessage1['Message'];
                        }
                    }
                }
            } else {
                $Timezones = explode(',',$Timezones);
                $i=0;
                foreach ($Timezones as $Timezone) {
                    if($Policy == \LCR::LCR_PREFIX){
                        $query = "CALL prc_WSGenerateRateTableWithPrefix(".$JobID.","  .$data['RateGeneratorId']. "," . $data['RateTableID']. ",'".$data['rate_table_name']."','".$data['EffectiveDate']."',".$data['replace_rate'].",'".$data['EffectiveRate']."','".$username."')";
                        Log::info($query);
                        $JobStatusMessage = DB::select($query);
                    } else {
                        $query = "CALL prc_WSGenerateRateTable(".$JobID.","  .$data['RateGeneratorId']. "," . $data['RateTableID']. ",'".$data['rate_table_name']."','".$data['EffectiveDate']."',".$data['replace_rate'].",'".$data['EffectiveRate']."','".$username."')";
                        Log::info($query);
                        $JobStatusMessage = DB::select($query);
                    }

                    $JobStatusMessage = array_reverse(json_decode(json_encode($JobStatusMessage),true));
                    if(count($JobStatusMessage) > 0){
                        foreach ($JobStatusMessage as $JobStatusMessage1) {
                            if(is_numeric($JobStatusMessage1['Message'])) {
                                if($i == 0) {
                                    // if new rate table and multiple timezones then it will give rate table name exist error when it will run second time
                                    // so, we will send RateTableID (which is created for first timezone) to next all timezones
                                    // so, it will generate only one rate table for all timezones
                                    $data['RateTableID'] = $JobStatusMessage1['Message'];
                                    $data['rate_table_name'] = "";
                                }
                                $info[] = 'RateTable Created Successfully';
                            } else {
                                $error[] = $JobStatusMessage1['Message'];
                            }
                        }
                    }
                    $i++;
                }
            }

            $info   = array_unique($info);
            $error  = array_unique($error);
            $both   = array_unique(array_merge($error,$info));

            if(count($error) > 0 && count($info) > 0) {
                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','PF')->pluck('JobStatusID');
                $jobdata['JobStatusMessage'] = 'Rate Generation Partially Fail::'.implode(',',$both);
                $jobdata['updated_at'] = date('Y-m-d H:i:s');
                $jobdata['ModifiedBy'] = 'RMScheduler';
                Job::where(["JobID" => $JobID])->update($jobdata);
                Log::error($error);
            } else if(count($info) > 0) {

                if($RateGenerator->SelectType == \RateGenerator::VoiceCall) {
                    $RateTableName = RateTable::find($data['RateTableID'])->RateTableName;
                    $params['RateTableID']              = $data['RateTableID'];
                    $params['RateTableRateAAID']        = '';
                    $params['ProcessID']                = '';

                    $options['RateTableName']   = $RateTableName;
                    $options['params']          = $params;
                    $rules = array(
                        'CompanyID' => 'required',
                        'JobTypeID' => 'required',
                        'JobStatusID' => 'required',
                        'JobLoggedUserID' => 'required',
                        'Title' => 'required',
                        'CreatedBy' => 'required',
                    );

                    $JobType     = 'TRM';
                    $jobType     = JobType::where(["Code" => $JobType])->get(["JobTypeID", "Title"]);
                    $jobStatus   = JobStatus::where(["Code" => "P"])->get(["JobStatusID"]);

                    $options["CompanyID"]   = $CompanyID;
                    $data["CompanyID"]      = $CompanyID;
                    $data["JobTypeID"]      = isset($jobType[0]->JobTypeID) ? $jobType[0]->JobTypeID : '';
                    $data["JobStatusID"]    = isset($jobStatus[0]->JobStatusID) ? $jobStatus[0]->JobStatusID : '';
                    $data["JobLoggedUserID"]= $job->JobLoggedUserID;
                    $data["Title"]          = 'Termination Rate Difference ('.$options['RateTableName'].')';
                    $data["Description"]    = ' ' . isset($jobType[0]->Title) ? $jobType[0]->Title : '';
                    $data["CreatedBy"]      = $username;
                    $data["updated_at"]     = date('Y-m-d H:i:s');
                    $data["created_at"]     = date('Y-m-d H:i:s');
                    $data["Options"]        = json_encode($options);

                    $validator = \Validator::make($data, $rules);

                    if ($validator->fails()) {
                        return validator_response($validator);
                    }

                    $JobIDD = Job::insertGetId($data);
                }

                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','S')->pluck('JobStatusID');
                $jobdata['JobStatusMessage'] = implode(',',$info);
                $jobdata['updated_at'] = date('Y-m-d H:i:s');
                $jobdata['ModifiedBy'] = 'RMScheduler';
                Job::where(["JobID" => $JobID])->update($jobdata);
                Log::error($error);
            } else {
                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','F')->pluck('JobStatusID');
                $jobdata['JobStatusMessage'] = 'Rate Generation Fail::'.implode(',',$error);
                $jobdata['updated_at'] = date('Y-m-d H:i:s');
                $jobdata['ModifiedBy'] = 'RMScheduler';
                Job::where(["JobID" => $JobID])->update($jobdata);
                Log::error($error);
            }

            if($CronJobID > 0) {
                CronJob::sendRateGenerationEmail($CompanyID,$CronJobID,$JobID,$data['EffectiveDate']);
            }
            Log::info('job transaction commit '.$JobID);

        }catch (\Exception $e) {

            try{
                DB::rollback();
            }catch (\Exception $err) {
                Log::error($err);
            }
            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','F')->pluck('JobStatusID');
            $jobdata['JobStatusMessage'] = 'Rate Generation Fail::'.$e->getMessage();
            $jobdata['updated_at'] = date('Y-m-d H:i:s');
            $jobdata['ModifiedBy'] = 'RMScheduler';
            Job::where(["JobID" => $JobID])->update($jobdata);
            Log::error($e);
        }

        //Job::send_job_status_email($job,$CompanyID);
        if(intval($CronJobID) ==  0) {

            Job::send_job_status_email($job, $CompanyID);
        }


        Log::info('job end '.$JobID);

        CronHelper::after_cronrun($this->name, $this);


    }





} 