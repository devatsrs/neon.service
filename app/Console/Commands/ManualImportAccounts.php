<?php namespace App\Console\Commands;

use App\Lib\Account;
use App\Lib\CronHelper;
use App\Lib\Product;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Maatwebsite\Excel\Facades\Excel;
use App\Lib\NeonExcelIO;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;
use Webpatser\Uuid\Uuid;

class ManualImportAccounts extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'manualimportaccounts';

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

        CronHelper::before_cronrun($this->name, $this );

		//$file = 'D:/www/deven/neon/service/branches/staging/storage/Vendor.xls';
		$file = 'D:/www/deven/neon/service/branches/staging/storage/new_voover_vendor.csv';
        // There will be 2 columns one is gateway name and ip.
        //Gateway name	Ip


        $CompanyID = 1;

        $NeonExcel = new NeonExcelIO($file);
        $results = $NeonExcel->read();

        $lineno = 2;
        $error = array();
        $AccountType = 1 ; //Accounts
        $IsVendor = 1;
        $IsCustomer = 0;
        $CurrencyID = 1;
        $ProcessID = (string) Uuid::generate();

        $counter = 0;
        $bacth_insert_limit = 200;
        $batch_insert_array = array();
        $AccountNumber = 94 ;// Account::getLastAccountNo($CompanyID);
        foreach ($results as $temp_row) {
            //check empty row
            $checkemptyrow = array_filter(array_values($temp_row));

            if(!empty($checkemptyrow)){

                $tempItemData = array();
                if(isset($temp_row['AccountName']) && !empty($temp_row['AccountName']) ){
                    $tempItemData['AccountName'] =$temp_row['AccountName'];
                }else{
                    $error[] = 'name is blank at line no: '.$lineno;
                }
                //if(isset($temp_row['IP']) ){
                $tempItemData['IP'] =$temp_row['IP'];
                //}

                if(isset($temp_row['AccountName']) && !empty($temp_row['AccountName']) ) {
                    $tempItemData['CompanyId'] =1;
                    $tempItemData['created_by'] ='System Imported';

                    $tempItemData['AccountType'] = $AccountType;
                    $tempItemData['Number'] = $AccountNumber++;
                    $tempItemData['IsVendor'] = $IsVendor;
                    $tempItemData['IsCustomer'] = $IsCustomer;
                    $tempItemData['Currency'] = $CurrencyID;
                    $tempItemData['ProcessID'] = $ProcessID;

                    $batch_insert_array[] = $tempItemData;
                    $counter++;

                }

                if ($counter == $bacth_insert_limit) {
                    Log::info('Batch insert start');
                    Log::info('global counter' . $lineno);
                    Log::info('insertion start');
                    DB::table('tblTempAccount')->insert($batch_insert_array);
                    Log::info('insertion end');
                    $batch_insert_array = [];
                    $counter = 0;

                }

                Log::error($temp_row['AccountName'] . ' Inserted ');
            }else{

                Log::error($temp_row['AccountName'] . ' skipped ');
            }

            $lineno++;
        }

        if (!empty($batch_insert_array)) {
            Log::info('Batch insert start');
            Log::info('global counter' . $lineno);
            Log::info('insertion start');
            Log::info('last batch insert ' . count($batch_insert_array));
            DB::table('tblTempAccount')->insert($batch_insert_array);
            Log::info('insertion end');
        }

        //$Skipped_ = DB::select("CALL  prc_ManualImportAccount ('" . $ProcessID . "')");
        //Log::info("CALL  prc_ManualImportAccount ('" . $ProcessID . "')");


        Log::error(print_r($error,true));


        CronHelper::after_cronrun($this->name, $this);

    }

    public function add_column() {


        /*"IF NOT EXISTS( SELECT NULL
            FROM INFORMATION_SCHEMA.COLUMNS
           WHERE table_name = 'tblTempAccount'
                AND table_schema = 'db_name'
                AND column_name = 'columnname')  THEN
              ALTER TABLE `TableName` ADD `ColumnName` int(1) NOT NULL default '0';
            END IF;"
    */

    }


}
