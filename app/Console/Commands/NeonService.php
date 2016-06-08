<?php namespace App\Console\Commands;

use App\Lib\Company;
use App\Lib\CronHelper;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;

class NeonService extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'neonservice';

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
		Log::useFiles(storage_path() . '/logs/neonservice' . '-' . date('Y-m-d') . '.log');

		CronHelper::before_cronrun($this);

		Log::info($this->name . "########### Service Starts ###########");

		$Company = Company::all();
		foreach($Company as $CompanID){
			if(getenv('APP_OS') == 'Linux') {
				pclose(popen( env('PHPExePath')." ".env('RMArtisanFileLocation').' rmservice '.$CompanID->CompanyID . " &","r"));
			}else{
				pclose(popen("start /B " . env('PHPExePath')." ".env('RMArtisanFileLocation').' rmservice '.$CompanID->CompanyID. " ", "r"));
			}
			Log::info('neon service started');
		}

		CronHelper::after_cronrun($this);

	}



}
