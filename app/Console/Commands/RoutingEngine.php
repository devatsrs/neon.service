<?php namespace App\Console\Commands;

use App\Lib\CronHelper;
use App\Lib\Summary;
use Illuminate\Console\Command;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\Retention;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use \Exception;
use Symfony\Component\Console\Input\InputArgument;
use App\Lib\CompanyGateway;

class RoutingEngine extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'routingengine';

	/**
	 * The console command description.
	 *
	 * @var string
	 */
	protected $description = 'RoutingEngine Command description.';

	protected function getArguments()
	{
		return [
			['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID '],
			['CronJobID', InputArgument::REQUIRED, 'Argument CronJobID'],
		];
	}

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
    public function handle() {
        try{

            echo "Yes now its runing.... adnan";
            Log::info('Run Cron.');
        }catch (\Exception $e){

        }
    }

}
