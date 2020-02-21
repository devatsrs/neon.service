<?php namespace App\Console\Commands;

use App\Lib\Company;
use App\Lib\CompanyConfiguration;
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

		CronHelper::before_cronrun($this->name, $this );

		Log::info($this->name . "########### Service Starts ###########");

		$Company = Company::select('tblCompany.CompanyID')
		->leftJoin('tblReseller', 'tblReseller.ChildCompanyID','=','tblCompany.CompanyID')
        ->leftJoin('tblAccount', 'tblReseller.AccountID','=','tblAccount.AccountID')
        ->where('tblAccount.Status','=',1)
		->orderBy("tblCompany.CompanyID")->get();

		$Company = json_decode($Company,true);
        $AddCompany['CompanyID'] = 1;
        array_push($Company, $AddCompany);
		
		foreach($Company as $CompanID){
            $PHP_EXE_PATH = CompanyConfiguration::get($CompanID['CompanyID'],'PHP_EXE_PATH');
            $RMArtisanFileLocation = CompanyConfiguration::get($CompanID['CompanyID'],'RM_ARTISAN_FILE_LOCATION');
			if(getenv('APP_OS') == 'Linux') {
				pclose(popen( $PHP_EXE_PATH." ".$RMArtisanFileLocation.' rmservice '.$CompanID['CompanyID'] . " &","r"));
			}else{
				pclose(popen("start /B " . $PHP_EXE_PATH." ".$RMArtisanFileLocation.' rmservice '.$CompanID['CompanyID']. " ", "r"));
			}
			Log::info('neon service started');
		}

		CronHelper::after_cronrun($this->name, $this);

	}



}
