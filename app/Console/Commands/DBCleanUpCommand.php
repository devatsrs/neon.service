<?php namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use League\Flysystem\Exception;

class DBCleanUpCommand extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'dbcleanup';

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
    public function handle()
	{

        try{

            DB::beginTransaction();
                Log::info('DBcleanup Starts.');
            DB::statement("CALL prc_WSCronJobDeleteOldVendorRate()");
                Log::info('DBcleanup: prc_WSCronJobDeleteOldVendorRate Done.');
            DB::statement("CALL prc_WSCronJobDeleteOldCustomerRate()");
                Log::info('DBcleanup: prc_WSCronJobDeleteOldCustomerRate Done.');
            DB::statement("CALL prc_WSCronJobDeleteOldRateTableRate()");
                Log::info('DBcleanup: prc_WSCronJobDeleteOldRateTableRate Done.');
            DB::statement("CALL prc_WSCronJobDeleteOldRateSheetDetails()");
                Log::info('DBcleanup: prc_WSCronJobDeleteOldRateSheetDetails Done.');
            DB::commit();
            Log::info('DBcleanup Done.');

        }catch (Exception $e){
            Log::info('DBcleanup Rollback Today.');
            DB::rollback();
        }

    }

}
