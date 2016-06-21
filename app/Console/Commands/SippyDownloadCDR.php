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
use App\SippySSH;
use App\Lib\UsageDownloadFiles;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;
use \Exception;

class SippyDownloadCDR extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'sippydownloadcdr';

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

        $CronJobID = $arguments["CronJobID"];
        $CompanyID = $arguments["CompanyID"];
        $CronJob =  CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings, true);
        $getmypid = getmypid(); // get proccess id
        $dataactive['Active'] = 1;
        $dataactive['PID'] = $getmypid;
        $dataactive['LastRunTime'] = date('Y-m-d H:i:00');
        $CronJob->update($dataactive);

        $CompanyGatewayID   =  $cronsetting['CompanyGatewayID'];
        $FilesDownloadLimit =  $cronsetting['FilesDownloadLimit'];
        Log::useFiles(storage_path().'/logs/sippydownloadcdr-'.$CompanyGatewayID.'-'.date('Y-m-d').'.log');

        try {
            Log::info("Start");


            CronJob::createLog($CronJobID);

            $joblogdata = array();
            $joblogdata['CronJobID'] = $CronJobID;
            $joblogdata['created_at'] = date('Y-m-d H:i:s');
            $joblogdata['created_by'] = 'RMScheduler';
            $joblogdata['Message'] = '';


            $sippy = new SippySSH($CompanyGatewayID);
            Log::info("SippySSH Connected");
            $filenames = $sippy->getCDRs();
            $destination = getenv("SIPPYFILE_LOCATION") .$CompanyGatewayID;
            if (!file_exists($destination)) {
                mkdir($destination, 0777, true);
            }
            //$filenames = UsageDownloadFiles::remove_downloaded_files($CompanyGatewayID,$filenames);
            Log::info('sippy File download Count '.count($filenames));

            if(count($filenames) > 0) {

                /**
                 * GET array of files that are not exist in db
                 */
                $downloaded = array();
                foreach ($filenames as $filename) {
                    $isdownloaded = false;
                    if (!file_exists($destination . '/' . basename($filename))) {
                        $param = array();
                        $param['filename'] = $filename;
                        $param['download_path'] = $destination . '/';
                        //$param['download_temppath'] = Config::get('app.temp_location').$CompanyGatewayID.'/';
                        $sippy->downloadCDR($param);
                        Log::info("SippySSH download file" . $filename . ' - ' . $sippy->get_file_datetime($filename));
                        $downloaded[] = $filename;
                        //$sippy->deleteCDR($param);
                        $isdownloaded = true;

                    } else {

                        Log::info("SippySSH File was already exist  " . $filename . ' - ' . $sippy->get_file_datetime($filename));
                    }

                    if(UsageDownloadFiles::where(array("CompanyGatewayID" => $CompanyGatewayID, "FileName" => basename($filename)))->count() == 0) {
                        UsageDownloadFiles::create(array("CompanyGatewayID" => $CompanyGatewayID, "FileName" => basename($filename), "CreatedBy" => "NeonService"));
                        if($isdownloaded == false){
                            Log::info("Missing file inserted " . $filename . ' - ' . $sippy->get_file_datetime($filename));
                        }

                    }

                    if (count($downloaded) == $FilesDownloadLimit) {
                        break;
                    }

                }
                $dataactive['Active'] = 0;
                $CronJob->update($dataactive);

                $downloaded_files = count($downloaded);
                $joblogdata['Message'] = "Files Downloaded " . count($downloaded);

                if (count($downloaded) > 0) {
                    $joblogdata['Message'] .= "<br>Date  : " . $sippy->get_file_datetime($downloaded[$downloaded_files - 1]);
                    $joblogdata['Message'] .= " - " . $sippy->get_file_datetime($downloaded[0]);
                }

                $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
                CronJobLog::insert($joblogdata);
            }

            Log::info("SippySSH File Download Completed ");


        }catch (Exception $e) {
            Log::error($e);

            $dataactive['Active'] = 0;
            $CronJob->update($dataactive);

            $joblogdata['Message'] = 'Error:' . $e->getMessage();
            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
            CronJobLog::insert($joblogdata);


            if(!empty($cronsetting['ErrorEmail'])) {
                $result = CronJob::CronJobErrorEmailSend($CronJobID,$e);
                Log::info("**Email Sent Status " . $result['status']);
                Log::info("**Email Sent message " . $result['message']);
            }

        }
        Log::info("SippySSH end");

        CronHelper::after_cronrun($this->name, $this);

    }

}