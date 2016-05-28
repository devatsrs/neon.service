<?php
namespace App\Console\Commands;


use App\Lib\CompanyGateway;
use App\Lib\CompanySetting;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\Summary;
use App\Lib\TempUsageDetail;
use App\Lib\TempUsageDownloadLog;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;

class CreateVendorSummary extends Command{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'createvendorsummary';

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
            ['Live', InputArgument::REQUIRED, 'Argument Live'],
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
        $CompanyID = $arguments["CompanyID"];
        $CronJobID = $arguments["CronJobID"];
        $Live = $arguments["Live"];
        $CronJob =  CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings,true);
        Log::useFiles(storage_path() . '/logs/createvendorsummary-' . $CompanyID . '-' . date('Y-m-d') . '.log');
        try {

            Summary::generateVendorSummary($CompanyID, $Live);
            if($Live == 0){
                CompanySetting::setKeyVal($CompanyID,'LastVendorSummaryDate',date("Y-m-d"));
            }

        } catch (\Exception $e) {
            try {
                //DB::connection('neon_report')->rollback();
            } catch (\Exception $err) {
                Log::error($err);
            }
            Log::error($e);
            if(!empty($cronsetting['ErrorEmail'])) {

                $result = CronJob::CronJobErrorEmailSend($CronJobID,$e);
                Log::error("**Email Sent Status " . $result['status']);
                Log::error("**Email Sent message " . $result['message']);
            }
        }

    }

}
