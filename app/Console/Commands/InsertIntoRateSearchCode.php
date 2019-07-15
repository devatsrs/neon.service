<?php namespace App\Console\Commands;

use App\Lib\AccountBalance;
use App\Lib\ActiveCall;
use App\Lib\CronHelper;
use App\Lib\Helper;
use App\Lib\SpeakIntelligenceAPI;
use Illuminate\Console\Command;
use Symfony\Component\Console\Input\InputArgument;
use App\Lib\CompanyGateway;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\AccountPaymentAutomation;
use App\Lib\Company;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Config;
use \Exception;

class InsertIntoRateSearchCode extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'insert_into_rate_search_code';

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
        $CompanyID = $arguments['CompanyID'];

       Log::useFiles(storage_path() . '/logs/insert_into_rate_search_code-' . date('Y-m-d') . '.log');
       Log::error(' ========================== prc_InsertIntoRateSearchCode start =============================');


        try {

            DB::beginTransaction();

            Log::error("CALL  prc_InsertIntoRateSearchCode ('" . $CompanyID . "') start");
            DB::statement("CALL  prc_InsertIntoRateSearchCode ('" . $CompanyID . "')");
            Log::error("CALL  prc_InsertIntoRateSearchCode ('" . $CompanyID . "') end");

            DB::commit();


        } catch (\Exception $e) {
            try {
                DB::rollback();
            } catch (\Exception $err) {
                Log::error($err);
            }

            Log::error($e);
        }


        Log::error(' ========================== prc_InsertIntoRateSearchCode  end =============================');

        CronHelper::after_cronrun($this->name, $this);

    }

}
