<?php namespace App\Console\Commands;

use App\Lib\Product;
use App\Lib\UsageDownloadFiles;
use App\SippySSH;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Log;
use Maatwebsite\Excel\Facades\Excel;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;

class SippyMissingCDRFileFix extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'sippymissingcdrfilefix';

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

	/**
	 * Execute the console command.
	 *
	 * @return mixed
	 */
	public function fire()
	{


		try {

			$GatewayIDs = [11,12];

			Log::info("Start");

			foreach($GatewayIDs as $CompanyGatewayID){

				Log::useFiles(storage_path() . '/logs/sippy_missing_cdrfile_fix-' . $CompanyGatewayID . '-' . date('Y-m-d') . '.log');

				Log::info("SIPPYFILE_LOCATION  " . getenv("SIPPYFILE_LOCATION") . $CompanyGatewayID );


				$all_sippy_filenames = scandir(getenv("SIPPYFILE_LOCATION") . $CompanyGatewayID);

				foreach ((array)$all_sippy_filenames as $file) {

					if (strpos($file, 'complete_' . SippySSH::$customer_cdr_file_name) !== false) {
						$split_arr = explode(".",$file);
						$cdrfile_time = array_pop($split_arr);

						$datefrom = strtotime("2016-03-13 00:00:00");
						$dateto = strtotime("2016-03-20 00:00:00");



						if(is_numeric($cdrfile_time) && $cdrfile_time >= $datefrom && $cdrfile_time <= $dateto ){

							Log::info("cdrfile_time  " . $cdrfile_time . " datefrom " . $datefrom . " dateto " . $dateto );

							Log::info("file converted " . $file);

							$pending_file_name = str_replace('complete_', '', basename($file) );
							SippySSH::changeCDRFilesStatus("complete-to-pending" , $file , $CompanyGatewayID ,true );
							UsageDownloadFiles::where("CompanyGatewayID",$CompanyGatewayID)->where("FileName",$pending_file_name)->delete();
							Log::info("  pending_file_name  " . $pending_file_name);
						}else{

							Log::info("--cdrfile_time  " . $cdrfile_time . " datefrom " . $datefrom . " dateto " . $dateto );

						}
					}
				}
			}
			Log::info("END");

		}catch (\Exception $e) {

			Log::error($e);


		}

		//Log::error(print_r($error,true));


	}


}

