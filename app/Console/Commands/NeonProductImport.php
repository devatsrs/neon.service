<?php namespace App\Console\Commands;

use App\Lib\CronHelper;
use App\Lib\NeonAPI;
use App\Lib\ServiceTemplate;
use App\Lib\Summary;
use App\Lib\VendorRate;
use Illuminate\Console\Command;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\Retention;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use \Exception;
use Symfony\Component\Console\Input\InputArgument;
use App\Lib\CompanyGateway;

class NeonProductImport extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'neonproductimport';

	/**
	 * The console command description.
	 *
	 * @var string
	 */
	protected $description = 'Product Import From Neon speakintelligence Data Command description.';

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
        
        
        CronHelper::before_cronrun($this->name, $this );

        $arguments = $this->argument();
        $CompanyID = $arguments["CompanyID"];
        $CronJobID = $arguments["CronJobID"];
        
        $CronJob =  CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings,true);
        CronJob::activateCronJob($CronJob);
        CronJob::createLog($CronJobID);
        
        Log::useFiles(storage_path() . '/logs/neonproductimport-companyid:'.$CompanyID . '-cronjobid:'.$CronJobID.'-' . date('Y-m-d') . '.log');
        $joblogdata = array();
        $joblogdata['CronJobID'] = $CronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';
        try{
            
            //Start Transaction
           // DB::connection('neon_routingengine')->beginTransaction();
            CronJob::createLog($CronJobID);
            $ServiceId = $cronsetting['ServiceId'];
            $Getdata = array();
            $APIResponse = NeonAPI::callGetAPI($Getdata,"api/Products","http://api-neon.speakintelligence.com/");
            if (isset($APIResponse["error"])) {
                Log::info('neonproductimport Error in  api/Products service.' . print_r($APIResponse["error"]));
            } else {
                $ProductResponses = json_decode($APIResponse["response"]);
                
                foreach($ProductResponses as $ProductResponse) {
                    
                    $productdata = array();
                    $productdata['ServiceTemplateId'] = $ProductResponse->productId;
                    $productdata['ServiceId']       = $ServiceId;
                    $productdata['Name']            = $ProductResponse->name;
                    $productdata['CurrencyId']            = 9;
                    $city_tariff='';
                    if (!empty($ProductResponse->cityName)) {
                        $city_tariff=$ProductResponse->cityName;
                    }else{
                        $city_tariff=$ProductResponse->tariff;
                    }
                    $productdata['city_tariff'] = $city_tariff;
                                        
                    $ServiceTemplateId = ServiceTemplate::where(['ServiceTemplateId'=>$ProductResponse->productId])->pluck('ServiceTemplateId');
                    $ServiceTemplateName = ServiceTemplate::where(['Name'=>$ProductResponse->name])->pluck('Name');
                    if (!empty($ServiceTemplateId)) {
                        ServiceTemplate::where(["ServiceTemplateId" => $ProductResponse->productId])->update($productdata);
                    }else if (!empty($ServiceTemplateName)) {
                        ServiceTemplate::where(["Name" => $ProductResponse->name])->update($productdata);
                    }else{
                        ServiceTemplate::insert($productdata);
                    }
                }
            }
            Log::info('neonproductimport Next step in  api/Products service.');
            //Track The Log          
            $joblogdata['Message'] = 'neonproductimport Successfully Done';
            $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
            CronJobLog::insert($joblogdata);
          //  DB::connection('neon_routingengine')->commit(); 
            
            $result = CronJob::CronJobSuccessEmailSend($CronJobID);
            
        }catch (\Exception $e){
            Log::useFiles(storage_path() . '/logs/neonproductimport-Error-' . date('Y-m-d') . '.log');
            
            Log::error($e);
            $this->info('Failed:' . $e->getMessage());
            $joblogdata['Message'] ='Error:'.$e->getMessage();
            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
            CronJobLog::insert($joblogdata);
            if(!empty($cronsetting['ErrorEmail'])) {
                $result = CronJob::CronJobErrorEmailSend($CronJobID,$e);
                Log::error("**Email Sent Status " . $result['status']);
                Log::error("**Email Sent message " . $result['message']);
            }


    }
    
        CronJob::deactivateCronJob($CronJob);
        CronHelper::after_cronrun($this->name, $this);
    }

}
