<?php
/**
 * Created by PhpStorm.
 * User: srs2
 * Date: 25/05/2015
 * Time: 06:58
 */

namespace App\Console\Commands;


use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\Job;
use App\Lib\JobStatus;
use App\Lib\JobType;
use App\Sippy;
use Exception;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;

class SippyRateFileStatus  extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'sippyratefilestatus';

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
            ['CronJobID', InputArgument::REQUIRED, 'Argument CronJobID'],
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
        $CompanyID = $arguments["CompanyID"];
        $CronJobID = $arguments["CronJobID"];
        $CronJob =  CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings,true);
        CronJob::activateCronJob($CronJob);
        CronJob::createLog($CronJobID);
        $CompanyGatewayID = $cronsetting['CompanyGatewayID'];
        $response = array();
        Log::useFiles(storage_path() . '/logs/sippyratefilestatus-' . $CompanyGatewayID . '-' . date('Y-m-d') . '.log');

        try {
            $response['error']  = $response['message']  = array();
            $jobType        = JobType::where(["Code" => 'SCRP'])->orWhere(["Code" => 'SVRP'])->get(["JobTypeID", "Title"]);
            $jobStatus      = JobStatus::where(["Code" => "P"])->get(["JobStatusID"]);
            $JobTypeID      = isset($jobType[0]->JobTypeID) ? $jobType[0]->JobTypeID : '';
            $JobStatusID    = isset($jobStatus[0]->JobStatusID) ? $jobStatus[0]->JobStatusID : '';
            $PendingFiles   = Job::where(['CompanyID'=>$CompanyID,'JobTypeID'=>$JobTypeID,'JobStatusID'=>$JobStatusID])
                                ->where(DB::raw('JSON_EXTRACT(Options, "$.CompanyGatewayID")'),$CompanyGatewayID)
                                ->get();

            $SippySFTP = new Sippy($CompanyGatewayID);

            foreach ($PendingFiles as $PendingFile) {
                $Options = json_decode($PendingFile->Options);
                $token = isset($Options->token) ? $Options->token : '';
                $i_customer = isset($Options->i_customer) ? $Options->i_customer : '';
                $addparam['token'] = $token;
                $addparam['i_customer'] = $i_customer;
                $result = $SippySFTP->getUploadStatus($addparam);
                Log::info("result".print_r($result,true));
                if (!empty($result) && !isset($result['faultCode'])) {
                    if (!empty($result['result']) && strtoupper($result['result']) == 'OK') {
                        $Job = Job::find($PendingFile->JobID);
                        if ($result['status'] == 'DONE') {//will change this
                            $newJobStatus = JobStatus::where(["Code" => "S"])->get(["JobStatusID"]);
                            $NewJobStatusID = isset($newJobStatus[0]->JobStatusID) ? $newJobStatus[0]->JobStatusID : '';
                            $response['message'][] = 'File Upload Success for Job : '. $PendingFile->Title.', JobID : '.$PendingFile->JobID;
                        } else if ($result['status'] == 'FAIL') {//will change this
                            $newJobStatus = JobStatus::where(["Code" => "F"])->get(["JobStatusID"]);
                            $NewJobStatusID = isset($newJobStatus[0]->JobStatusID) ? $newJobStatus[0]->JobStatusID : '';
                            $response['message'][] = 'File Upload failed for Job : '. $PendingFile->Title.', JobID : '.$PendingFile->JobID;
                        } else {
                            $NewJobStatusID = $Job->JobStatusID;
                        }
                        $Options = json_decode($Job->Options,true);
                        $Status = !empty($Options['status']) ? $Options['status'] : '';
                        if($Status != $result['status']) {
                            $Options['status'] = $result['status'];
                            $JobStatusMessage = $result['status'];
                            $Options = json_encode($Options,true);
                            $Job->update(['JobStatusID' => $NewJobStatusID,'JobStatusMessage' => $JobStatusMessage,'Options'=>$Options]);
                        }
                    } else {
                        $response['error'][] = 'Error while getting status for Job : '. $PendingFile->Title.', JobID'.$PendingFile->JobID;
                    }
                } else {
                    $response['error'][] = 'Error : Job:'. $PendingFile->Title.', JobID:'.$PendingFile->JobID.', faultCode '.$result['faultCode'].', faultString '.$result['faultString'];
                }
            }

            $final_array = array_merge($response['error'],$response['message']);
            if(count($response['error'])){
                $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
                $joblogdata['Message'] = implode('<br>', fix_jobstatus_meassage($final_array));
            }else{
                $joblogdata['Message'] = !empty($final_array)?implode('<br>', fix_jobstatus_meassage($final_array)):'Success';
                $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
            }
        } catch (\Exception $e) {
            Log::error($e);
            $joblogdata['Message'] ='Error:'.$e->getMessage();
            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
            if(!empty($cronsetting['ErrorEmail'])) {

                $result = CronJob::CronJobErrorEmailSend($CronJobID,$e);
                Log::error("**Email Sent Status " . $result['status']);
                Log::error("**Email Sent message " . $result['message']);
            }
        }

        CronJobLog::createLog($CronJobID,$joblogdata);
        CronJob::deactivateCronJob($CronJob);
        Log::error(" CronJobId end" . $CronJobID);
        if(!empty($cronsetting['SuccessEmail'])) {
            $result = CronJob::CronJobSuccessEmailSend($CronJobID);
            Log::error("**Email Sent Status ".$result['status']);
            Log::error("**Email Sent message ".$result['message']);
        }

        CronHelper::after_cronrun($this->name, $this);

    }
}