<?php
/**
 * Created by PhpStorm.
 * User: srs2
 * Date: 25/05/2015
 * Time: 06:58 
 */

namespace App\Console\Commands;

use App\Lib\CronJob;
use App\SippySSH;
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
        $arguments = $this->argument();

        $CronJobID = $arguments["CronJobID"];
        $CompanyID = $arguments["CompanyID"];
        $CronJob =  CronJob::find($CronJobID);
        $cronsetting =   json_decode($CronJob->Settings);
        $dataactive['DownloadActive'] = 1;
        $CronJob->update($dataactive);
        $CompanyGatewayID =  $cronsetting->CompanyGatewayID;
        Log::useFiles(storage_pathg().'/logs/sippydownloadcdr-'.$CompanyGatewayID.'-'.date('Y-m-d').'.log');
        try {
            Log::info("Start");
            $sippy = new SippySSH($CompanyGatewayID);
            Log::info("SippySSH Connected");
            $filenames = $sippy->getCDRs();
            if (!file_exists(Config::get('app.sippy_location') .$CompanyGatewayID)) {
                mkdir(Config::get('app.sippy_location') .$CompanyGatewayID, 0777, true);
            }
            Log::info('sippy File download Count '.count($filenames));
            foreach($filenames as $filename) {

                if(!file_exists(Config::get('app.sippy_location').$CompanyGatewayID.'/' . basename($filename))) {
                    $param = array();
                    $param['filename'] = $filename;
                    $param['download_path'] = Config::get('app.sippy_location').$CompanyGatewayID.'/';
                    //$param['download_temppath'] = Config::get('app.temp_location').$CompanyGatewayID.'/';
                    $sippy->downloadCDR($param);
                    Log::info("SippySSH download file".$filename);
                    //$sippy->deleteCDR($param);
                }
            }
        }catch (Exception $e) {
            Log::error($e);
        }
        Log::info("SippySSH end");
        $dataactive['DownloadActive'] = 0;
        $CronJob->update($dataactive);
    }

}