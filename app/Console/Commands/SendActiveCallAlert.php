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

class SendActiveCallAlert extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'send_active_call_alert';

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
            ['AccountID', InputArgument::REQUIRED, 'Argument AccountID '],
            ['APIURL', InputArgument::OPTIONAL, 'Argument APIURL '],
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
        $AccountID = $arguments['AccountID'];
        $APIURL = $arguments['APIURL'];

       Log::useFiles(storage_path() . '/logs/send_active_call_alert-' .$CompanyID .'-'.$AccountID.'-'. date('Y-m-d') . '.log');
       Log::error(' ========================== send_active_call_alert start =============================');


       $ActiveCallArr = '';
       $AccountBalance = AccountBalance::getAccountBalanceWithActiveCallRE($AccountID);
        try {
            // check auto top up is on or not
            if ($APIURL != '') {
                //log::info($APIURL);
                $UUIDS = ActiveCall::getUUIDByAccountID($AccountID);
                if (!empty($UUIDS[0])) {
                    $ActiveCallArr = array();
                    $ActiveCallArr['CustomerId'] = $AccountID;
                    $ActiveCallArr['Balance'] = $AccountBalance;
                    $ActiveCallArr['Uuids'] = $UUIDS;
                    $Result = SpeakIntelligenceAPI::BalanceAlert($APIURL, $ActiveCallArr);

                    //$LowBalanceArr[] = $ActiveCallArr;
                    Log::info("=====API Response =====");
                    //Log::info(print_r($ActiveCallArr, true));
                   // Log::info(print_r($Result, true));

                }
            }
        } catch (\Exception $e) {

            Log::error($e);
        }


        Log::error(' ========================== send_active_call_alert  end =============================');

        CronHelper::after_cronrun($this->name, $this);

    }

}
