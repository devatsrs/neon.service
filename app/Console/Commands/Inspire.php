<?php namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class Inspire extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'inspire';

	/**
	 * The console command description.
	 *
	 * @var string
	 */
	protected $description = 'Display an inspiring quote';

	/**
	 * Execute the console command.
	 *
	 * @return mixed
	 */
	public function handle()
	{
        //DB::statement("[prc_ArchiveOldCustomerRate] 1,1");
        Log::info('I am in Inspire. :-  ' . PHP_EOL.Inspiring::quote().PHP_EOL);
        //$this->comment(PHP_EOL.Inspiring::quote().PHP_EOL);
	}

}
