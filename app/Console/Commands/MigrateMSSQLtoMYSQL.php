<?php
namespace App\Console\Commands;

use Symfony\Component\Console\Input\InputArgument;
use Carbon\Carbon;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use \Exception;

class MigrateMSSQLtoMYSQL extends Command
{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'migratemssqltomysql';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'migrate MSSQL to MYSQL';

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
     * Get the console command arguments.
     *
     * @return array
     */
    protected function getArguments()
    {
        return [
            ['Limit', InputArgument::REQUIRED, 'Argument limit'],
            ['SourceConnection', InputArgument::REQUIRED, 'Argument Source Connection'],
            ['DestinationConnection', InputArgument::REQUIRED, 'Argument Destination Connection'],
            ['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID'],
            ['Tables', InputArgument::REQUIRED, 'Argument Tables'],
        ];
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function fire()
    {
        $arguments = $this->argument();
        $Limit = $arguments['Limit'];
        $SourceConnection = $arguments['SourceConnection'];
        $DestinationConnection = $arguments['DestinationConnection'];
        $CompanyID = $arguments['CompanyID'];
        $Tables = $arguments['Tables'];
        $getmypid = getmypid(); // get proccess id
        Log::useFiles(storage_path() . '/logs/migratemssqltomysql-' . date('Y-m-d') . '.log');
        Log::error(' PID : ' . $getmypid);
        $insertLimit = $Limit;
        $Tables = explode(',',$Tables);
        foreach ($Tables as $table) {
            Log::error(' ========================== Table : ' . $table . ' start =============================');
            try {
                Log::error('set connection');
                DB::connection($SourceConnection)->setFetchMode(\PDO::FETCH_ASSOC);
                Log::error('start fetching and insertion in chunks with limit : ' . $insertLimit);
                $bool = 0;
                $row = DB::connection($SourceConnection)->table($table)->first();
                $keys = array_keys($row);
                $primarykey = $keys[0];
                array_walk($keys, function(&$value) {
                    $value = strtolower($value);
                });
                if(in_array('companyid',$keys)){
                    $bool = 1;
                }

                if($bool==1){
                    DB::connection($SourceConnection)->table($table)->where('CompanyId',$CompanyID)->chunk($insertLimit, function ($chunk) use ($table,$primarykey,$DestinationConnection) {
                        Log::error('--------start chunk--------');
                        $count = count($chunk);
                        Log::error('start ' . $primarykey . ' : ' . $chunk[0][$primarykey]);
                        Log::error('end ' . $primarykey . ' : ' . $chunk[$count - 1][$primarykey]);
                        Log::error('start insertion');
                        $chunk = $this->removeElementWithValue($chunk);
                        DB::connection($DestinationConnection)->table($table)->insert($chunk);
                        Log::error('end insertion');
                        Log::error('---------end chunk---------');
                        return true;
                    });
                }else{
                    DB::connection($SourceConnection)->table($table)->chunk($insertLimit, function ($chunk) use ($table,$primarykey,$DestinationConnection) {
                        Log::error('--------start chunk--------');
                        $count = count($chunk);
                        Log::error('start ' . $primarykey . ' : ' . $chunk[0][$primarykey]);
                        Log::error('end ' . $primarykey . ' : ' . $chunk[$count - 1][$primarykey]);
                        Log::error('start insertion');
                        $chunk = $this->removeElementWithValue($chunk);
                        DB::connection($DestinationConnection)->table($table)->insert($chunk);
                        Log::error('end insertion');
                        Log::error('---------end chunk---------');
                        return true;
                    });
                }
                Log::error('completed ---');
                Log::error(' ========================== Table ' . $table . ' end =============================');
            } catch (\Exception $e) {
                Log::error($e);
            }
        }
    }

    function removeElementWithValue($array){
        $keys = array_keys($array[0]);
        if(in_array('row_num',$keys)){
            for($i=0;$i<count($array);$i++){
                unset($array[$i]['row_num']);
            }
        }
        return $array;
    }
}