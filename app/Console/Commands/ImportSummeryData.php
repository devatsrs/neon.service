<?php namespace App\Console\Commands;

use App\Lib\CronHelper;
use App\Lib\SummeryData;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Maatwebsite\Excel\Facades\Excel;
use App\Lib\NeonExcelIO;
use Webpatser\Uuid\Uuid;

class ImportSummeryData extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'importsummerydata';

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


		$dir = 'C:/temp/CDRS/';
        $filenames =  [
            '85.13.211.22'  => 'VOS-CDR-85.13.211.22.csv',
            '89.187.70.170' => 'VOS-CDR-89.187.70.170.csv',
            '67.228.185.54' => 'SIPPY-CDR-67.228.185.54.csv',
            '85.13.206.74'  => 'SIPPY-CDR-85.13.206.74.csv',
        ];


        Log::useFiles(storage_path() . '/logs/impotySummeryData-' . date('Y-m-d') . '.log');

        try {
            $ProcessID = Uuid::generate();
            foreach ($filenames as $IP => $filename) {


                $filepath = $dir . $filename;

                Log::info($filepath . '  - Processing ');

                //$results = Excel::load($filepath)->toArray();
                $NeonExcel = new NeonExcelIO($filepath);
                $results = $NeonExcel->read();

                Log::info(count($results) . '  - Records Found ');

                $lineno = 2;
                $error = array();


                if (strstr($filename, "VOS")) {


                    foreach ($results as $temp_row) {
                        //Log::error($temp_row);
                        //check empty row
                        $checkemptyrow = array_filter(array_values($temp_row));
                        if(!empty($checkemptyrow)){
                            $tempItemData = array();

                            $tempItemData['ProcessID'] = $ProcessID;
                            $tempItemData['CompanyID'] = 1;
                            $tempItemData['IP'] = $IP;
                            $tempItemData['Gateway'] = $filename;


                            if (isset($temp_row['account_id']) && !empty($temp_row['account_id'])) {
                                $tempItemData['GatewayAccountID'] = $temp_row['account_id'];
                            } else {
                                $error[] = 'account_id is blank at line no: ' . $lineno;
                            }
                            if (isset($temp_row['account_name'])) {
                                $tempItemData['AccountName'] = trim($temp_row['account_name']);
                            }
                            if (isset($temp_row['area_prefix'])) {
                                $tempItemData['AreaPrefix'] = $temp_row['area_prefix'];
                            }
                            if (isset($temp_row['area_name'])) {
                                $tempItemData['AreaName'] = $temp_row['area_name'];
                            }
                            if (isset($temp_row['total_duration'])) {
                                $tempItemData['Duration'] = $temp_row['total_duration'];
                            }
                            if (isset($temp_row['number_of_cdr'])) {
                                $tempItemData['TotalCalls'] = $temp_row['number_of_cdr'];
                            }

                            if (isset($temp_row['total_charges'])) {
                                $tempItemData['TotalCharge'] = number_format(str_replace(",", "",$temp_row['total_charges']), 8 , "." , "" );
                            }
                            if (isset($temp_row['account_name']) && !empty($temp_row['account_name']) && isset($temp_row['total_charges']) && isset($temp_row['total_charges'])) {

                                //Log::error($tempItemData);
                                SummeryData::create($tempItemData);
                                Log::error($temp_row['account_id'] . ' Inserted ');
                            } else {
                                Log::error($temp_row['account_id'] . ' skipped line number' . $lineno);

                            }
                        }

                        $lineno++;

                    }

                } else if (strstr($filename, "SIPPY")) {

                    foreach ($results as $temp_row) {
                        //check empty row
                        $checkemptyrow = array_filter(array_values($temp_row));
                        if(!empty($checkemptyrow)){
                            $tempItemData = array();

                            $tempItemData['ProcessID'] =$ProcessID;
                            $tempItemData['CompanyID'] = 1;
                            $tempItemData['IP'] = $IP;
                            $tempItemData['Gateway'] = $filename;

                            if (isset($temp_row['customer_name']) && !empty($temp_row['customer_name'])) {
                                $tempItemData['GatewayAccountID'] = str_replace("Acct. ","",$temp_row['customer_name']);
                            } else {
                                $error[] = 'Account id is blank at line no: ' . $lineno;
                            }
                            if (isset($temp_row['customer_name'])) {
                                $tempItemData['AccountName'] = trim($temp_row['customer_name']);
                            }
                            if (isset($temp_row['prefix'])) {
                                $tempItemData['Areaprefix'] = $temp_row['prefix'];
                            }
                            if (isset($temp_row['description'])) {
                                $tempItemData['AreaName'] = $temp_row['description'];
                            }
                            if (isset($temp_row['billed_duration_min'])) {
                                $tempItemData['Duration'] = $temp_row['billed_duration_min']*60;
                            }
                            if (isset($temp_row['number_of_calls'])) {
                                $tempItemData['TotalCalls'] = $temp_row['number_of_calls'];
                            }
                            if (isset($temp_row['country'])) {
                                $tempItemData['Country'] = $temp_row['country'];
                            }
                            if (isset($temp_row['charged_amount'])) {
                                $tempItemData['TotalCharge'] = number_format(str_replace(",", "", $temp_row['charged_amount']), 8 , "." , "" );
                            }
                            if (isset($temp_row['customer_name']) && !empty($temp_row['customer_name']) && isset($temp_row['charged_amount']) && isset($temp_row['charged_amount'])) {
                                //Log::error($tempItemData);
                                SummeryData::create($tempItemData);
                                Log::error($lineno . ' line no. Inserted ');
                            } else {
                                Log::error(' skipped line number' . $lineno);
                            }
                        }
                        $lineno++;

                    }

                } else {
                    Log::error(" unknown file   " . $filepath);

                }

            }

        }catch (\Exception $ex){

            Log::error($ex);
        }


        CronHelper::after_cronrun($this->name, $this);

    }


}
