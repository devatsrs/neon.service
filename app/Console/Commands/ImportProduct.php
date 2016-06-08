<?php namespace App\Console\Commands;

use App\Lib\CronHelper;
use App\Lib\Product;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Log;
use Maatwebsite\Excel\Facades\Excel;
use App\Lib\NeonExcelIO;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;

class ImportProduct extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'importProducts';

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

        CronHelper::before_cronrun($this);

		$file = 'I:/bk/www/projects/aamir/rm/downloads/items.csv';



         //$results =  Excel::load($file)->toArray();
        $NeonExcel = new NeonExcelIO($file);
        $results = $NeonExcel->read();
         $lineno = 2;
        $error = array();
        foreach ($results as $temp_row) {
            //check empty row
            $checkemptyrow = array_filter(array_values($temp_row));
            if(!empty($checkemptyrow)){
                $tempItemData = array();
                if(isset($temp_row['name']) && !empty($temp_row['name']) ){
                    $tempItemData['name'] =$temp_row['name'];
                }else{
                    $error[] = 'name is blank at line no: '.$lineno;
                }
                if(isset($temp_row['description']) ){
                    $tempItemData['description'] =$temp_row['description'];
                }
                if(isset($temp_row['cost']) ){
                    $tempItemData['Amount'] =$temp_row['cost'];
                }
                if(isset($temp_row['name']) && !empty($temp_row['name']) && isset($temp_row['description']) && isset($temp_row['cost']) ) {
                    $tempItemData['CompanyId'] =1;
                    $tempItemData['Active'] =1;
                    $tempItemData['CreatedBy'] ='Imported';

                    Product::create($tempItemData);
                    Log::error($temp_row['name'] . ' Inserted ');
                }else{
                    Log::error($temp_row['name'] . ' skipped ');

                }
            }
                $lineno++;

        }
         Log::error(print_r($error,true));


        CronHelper::after_cronrun($this);

    }


}
