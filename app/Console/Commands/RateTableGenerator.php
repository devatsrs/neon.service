<?php
namespace App\Console\Commands;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\Helper;
use App\Lib\Job;
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

        CronHelper::before_cronrun($this);


        $arguments = $this->argument();
        $getmypid = getmypid(); // get proccess id added by abubakar
        $JobID = $arguments["JobID"];
        $CronJobID = $arguments["CronJobID"];
        $CompanyID = $arguments["CompanyID"];
        $job = Job::find($JobID);
        $ProcessID = Uuid::generate();
        $userInfo = User::getUserInfo($job->JobLoggedUserID);
        $joboptions = json_decode($job->Options);
        Log::useFiles(storage_path().'/logs/ratetablegenerator-'.$JobID.'-'.date('Y-m-d').'.log');
        Log::info('job start '.$JobID);
        Log::info('job start '.$JobID);
        $emailstatus = array('status'=>0,'message'=>'');

        try {
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

            $data['CompanyID'] = $CompanyID;

            $Policy = \RateGenerator::where(["RateGeneratorId"=>$data['RateGeneratorId']])->pluck("Policy");

            if($Policy == \LCR::LCR_PREFIX){
                
                Log::info("CALL prc_WSGenerateRateTableWithPrefix(".$JobID.","  .$data['RateGeneratorId']. "," . $data['RateTableID']. ",'".$data['rate_table_name']."','".$data['EffectiveDate']."')");
                DB::statement("CALL prc_WSGenerateRateTableWithPrefix(".$JobID.","  .$data['RateGeneratorId']. "," . $data['RateTableID']. ",'".$data['rate_table_name']."','".$data['EffectiveDate']."')");

            }else {
                Log::info("CALL prc_WSGenerateRateTable(".$JobID.","  .$data['RateGeneratorId']. "," . $data['RateTableID']. ",'".$data['rate_table_name']."','".$data['EffectiveDate']."')");
                DB::statement("CALL prc_WSGenerateRateTable(".$JobID.","  .$data['RateGeneratorId']. "," . $data['RateTableID']. ",'".$data['rate_table_name']."','".$data['EffectiveDate']."')");

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
        if(isset($job->JobID) > 0) {

            Job::send_job_status_email($job, $CompanyID);
        }


        Log::info('job end '.$JobID);

        CronHelper::after_cronrun($this);


    }





} 