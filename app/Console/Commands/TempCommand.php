<?php namespace App\Console\Commands;

use App\Lib\CompanyGateway;
use App\Lib\CronJob;
use App\Lib\TempUsageDetail;
use App\Lib\TempUsageDownloadLog;
use App\Lib\UsageDetail;
use App\Porta;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use League\Flysystem\Exception;
use Symfony\Component\Console\Input\InputArgument;
use Webpatser\Uuid\Uuid;

class TempCommand extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'tempcommand';

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
    public function handle()
	{

        

    }

}
