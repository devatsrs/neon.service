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
        $dataactive['DownloadActive'] = 1;
        $CronJob->update($dataactive);
        $CompanyGatewayID =  $cronsetting['CompanyGatewayID'];
        Log::useFiles(storage_path().'/logs/sippydownloadcdr-'.$CompanyGatewayID.'-'.date('Y-m-d').'.log');
        try {
            Log::info("Start");
            $sippy = new SippySSH($CompanyGatewayID);
            Log::info("SippySSH Connected");
            $filenames = $sippy->getCDRs();
            if (!file_exists(getenv("SIPPYFILE_LOCATION") .$CompanyGatewayID)) {
                mkdir(getenv("SIPPYFILE_LOCATION") .$CompanyGatewayID, 0777, true);
            }
            //$filenames = UsageDownloadFiles::remove_downloaded_files($CompanyGatewayID,$filenames);
            Log::info('sippy File download Count '.count($filenames));
            foreach($filenames as $filename) {

                if(!file_exists(getenv("SIPPYFILE_LOCATION").$CompanyGatewayID.'/' . basename($filename))) {
                    $param = array();
                    $param['filename'] = $filename;
                    $param['download_path'] = getenv("SIPPYFILE_LOCATION").$CompanyGatewayID.'/';
                    //$param['download_temppath'] = Config::get('app.temp_location').$CompanyGatewayID.'/';
                    $sippy->downloadCDR($param);
                    UsageDownloadFiles::create(array("CompanyGatewayID"=> $CompanyGatewayID , "FileName" =>  basename($filename) ,"CreatedBy" => "NeonService" ));
                    Log::info("SippySSH download file".$filename . ' - ' . $sippy->get_file_datetime($filename));
                    //$sippy->deleteCDR($param);
                }
            }
            $dataactive['DownloadActive'] = 0;
            $CronJob->update($dataactive);
        }catch (Exception $e) {
            Log::error($e);
            $dataactive['DownloadActive'] = 0;
            $CronJob->update($dataactive);

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