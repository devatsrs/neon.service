<?php namespace App\Console\Commands;

use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\CustomerRateUpdateHistory;
use App\Lib\NeonExcelIO;
use App\Lib\VendorRateUpdateHistory;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;

/** This command will be run immediately when any rate is updated in Customer or Vendor.
 * Class GenerateRateUpdateFile
 * @package App\Console\Commands
 */
class GenerateRateUpdateFile extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'generaterateupdatefile';

	/**
	 * The console command description.
	 *
	 * @var string
	 */
	protected $description = 'Command description.';

	protected $error = array();

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
			['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID'],
			['CronJobID', InputArgument::REQUIRED, 'Argument CronJobID'],
		];
	}

	/**
	 * Execute the console command.
	 *
	 * @return mixed
	 */
	public function fire()
	{
		/**
		 * @TODO: Need to sure Rate Table Generation cron job need to be generate in Same time zone of
		 * Gateway - ie. If Company Timezone is GMT +01:00 and Gateway Timezone is GMT 00:00
		 * Then Rate table should generate at GMT+1 11pm to match the Timezone of GMT
		 *
		 * Also there is no trigger when future effective date is current date.
		 */


		CronHelper::before_cronrun($this->name, $this );
		$arguments 		= 	$this->argument();

		$CronJobID 		= 	$arguments["CronJobID"];
		$CompanyID 		= 	$arguments["CompanyID"];

		$CronJob =  CronJob::find($CronJobID);
		$cronsetting = json_decode($CronJob->Settings, true);

		$joblogdata = array();
		$joblogdata['CronJobID'] = $CronJobID;
		$joblogdata['created_at'] = date('Y-m-d H:i:s');
		$joblogdata['created_by'] = 'RMScheduler';
		$joblogdata['Message'] = '';


		CronJob::activateCronJob($CronJob);

		try{

			$future_rates = $cronsetting["FutureRate"];

			if(!isset($cronsetting["FileLocation"]) || empty($cronsetting["FileLocation"])){
				throw new \Exception(" CSV File Generate Location not specified.");
			}

			$local_dir = $cronsetting["FileLocation"];

			$this->generate_file($CompanyID,'customer','current',$local_dir);
			$this->generate_file($CompanyID,'vendor','current',$local_dir);

			if($future_rates) {
				/**
				 * Need to manage future date at Gateway Side.
				 * So when current date = future date we done need to add in rate update history table.
				 * This scenario will be managed from gateway side if we update future rates in gateway.
				 */

				$this->generate_file($CompanyID,'customer','future',$local_dir);
				$this->generate_file($CompanyID,'vendor','future',$local_dir);
 			}


			if (count($this->errors) > 0) {

				$joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
				$joblogdata['Message'] = implode('\n\r', $this->errors);

			} else {

				$joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
				$joblogdata['Message'] = "Success";

			}
			CronJobLog::insert($joblogdata);


		}catch (Exception $e) {

			Log::error($e);
			CronJob::deactivateCronJob($CronJob);

			$joblogdata['Message'] = 'Error:' . $e->getMessage();
			$joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
			CronJobLog::insert($joblogdata);

		}

		CronHelper::after_cronrun($this->name, $this);

	}

	public function generate_file($CompanyID,$AccountType,$RateType,$local_dir ){

		$current_date = date("Y-m-d");

		$AccountType = strtolower($AccountType);
		$RateType = strtolower($RateType);

		$csv_data = DB::select("CALL prc_getRateUpdateHistory(" . $CompanyID . ",'".$AccountType."','".$RateType."','".$current_date."')");
		$csv_data = collect($csv_data)->groupBy("AccountID");
		/*
                        [
                            'account-x10' => [
                                ['account_id' => 'account-x10', 'product' => 'Chair'],
                                ['account_id' => 'account-x10', 'product' => 'Bookcase'],
                            ],
                            'account-x11' => [
                                ['account_id' => 'account-x11', 'product' => 'Desk'],
                            ],
                        ]
                    */

        $dir = $local_dir;
        if (!file_exists($dir)) {
            @mkdir($dir, 0777, TRUE);
        }

        foreach($csv_data as $AccountID => $rows) 	{

            $rows = collect($rows)->toArray();
            $rows = json_decode(json_encode($rows),true);

            $file_name = $AccountID . '_' . date('Y-m-d-H:i:s');
            $file_path = $dir  . '/' . $AccountType . '_' . $RateType . '_' . $file_name.'.csv';

			$sort_column = $AccountType == 'customer'?"CustomerRateUpdateHistoryID":"VendorRateUpdateHistoryID";

			$min_max_ids = $this->get_min_max_primary_key_id($sort_column,$rows); // take min and max primary key to update records.

            $NeonExcel = new NeonExcelIO($file_path);
			$NeonExcel->generate_rate_update_file($rows);

			if( file_exists($file_path) && is_numeric($min_max_ids["min_id"])  &&  is_numeric($min_max_ids["max_id"]) ){

				try {

					DB::beginTransaction();

					if($AccountType == 'customer'){

						CustomerRateUpdateHistory::where($sort_column,'>=',$min_max_ids["min_id"])->where($sort_column,'<=',$min_max_ids["max_id"])->where(["AccountID"=>$AccountID])->update(["FileCreated"=>1]);

					}else if($AccountType == 'vendor'){

						VendorRateUpdateHistory::where($sort_column,'>=',$min_max_ids["min_id"])->where($sort_column,'<=',$min_max_ids["max_id"])->where(["AccountID"=>$AccountID])->update(["FileCreated"=>1]);
					}

					DB::commit();

				} catch (\Exception $ex) {

					Log::error($ex);
					DB::rollback();
					@unlink($file_path);
					$this->errors[] = $ex->getMessage();

				}

			}

		};

	}

	public function get_min_max_primary_key_id($primary_key,$rows){

        $max_id = collect($rows)->sortByDesc($primary_key)->first()[$primary_key];
        $min_id = collect($rows)->sortBy($primary_key)->first()[$primary_key];

        return ["max_id" => $max_id , "min_id" => $min_id];
	}

}
