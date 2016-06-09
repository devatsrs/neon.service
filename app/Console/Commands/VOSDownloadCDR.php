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
use App\Lib\UsageDownloadFiles;
use App\VOS;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;
use Webpatser\Uuid\Uuid;
use \Exception;

class VOSDownloadCDR extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'vosdownloadcdr';

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
        $cronsetting =   json_decode($CronJob->Settings);
        $dataactive['DownloadActive'] = 1;
        $CronJob->update($dataactive);
        $CompanyGatewayID =  $cronsetting->CompanyGatewayID;
        Log::useFiles(storage_path().'/logs/vosdownloadcdr-'.$CompanyGatewayID.'-'.date('Y-m-d').'.log');
        try {

            Log::info("Start");

            CronJob::createLog($CronJobID);

            $joblogdata = array();
            $joblogdata['CronJobID'] = $CronJobID;
            $joblogdata['created_at'] = date('Y-m-d H:i:s');
            $joblogdata['created_by'] = 'RMScheduler';
            $joblogdata['Message'] = '';

            $vos = new VOS($CompanyGatewayID);
            Log::info("VOS Connected");
            $filenames = $vos->getCDRs();
            if (!file_exists(Config::get('app.vos_location') .$CompanyGatewayID)) {
                mkdir(Config::get('app.vos_location') .$CompanyGatewayID, 0777, true);
            }
            //$filenames = UsageDownloadFiles::remove_downloaded_files($CompanyGatewayID,$filenames);
            Log::info('vos File download Count '.count($filenames));
            foreach($filenames as $filename) {

                if(!file_exists(Config::get('app.vos_location').$CompanyGatewayID.'/' . basename($filename))) {
                    $param = array();
                    $param['filename'] = $filename;
                    $param['download_path'] = Config::get('app.vos_location').$CompanyGatewayID.'/';
                    //$param['download_temppath'] = Config::get('app.temp_location').$CompanyGatewayID.'/';
                    $vos->downloadCDR($param);
                    UsageDownloadFiles::create(array("CompanyGatewayID"=> $CompanyGatewayID , "FileName" =>  basename($filename) ,"CreatedBy" => "NeonService" ));
                    Log::info("VOS download file".$filename);
                    //$vos->deleteCDR($param);
                }
            }
            $dataactive['DownloadActive'] = 0;
            $CronJob->update($dataactive);

            $joblogdata['Message'] = "Files Downloaded " . count($filenames);
            $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
            CronJobLog::insert($joblogdata);


        }catch (Exception $e) {
            Log::error($e);
            $dataactive['DownloadActive'] = 0;
            $CronJob->update($dataactive);

            $joblogdata['Message'] = 'Error:' . $e->getMessage();
            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
            CronJobLog::insert($joblogdata);

        }
        Log::info("VOS end");

        CronHelper::after_cronrun($this->name, $this);

    }

}