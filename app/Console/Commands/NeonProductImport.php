<?php namespace App\Console\Commands;

use App\Lib\CronHelper;
use App\Lib\NeonAPI;
use App\Lib\ServiceTemplate;
use App\Lib\Package;
use App\Lib\DynamicFieldsValue;
use App\Lib\DynamicFields;
use App\Lib\Summary;
use App\Lib\Company;
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
        $joblogdata = array();
        $joblogdata['CronJobID'] = $CronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';

        Log::useFiles(storage_path() . '/logs/neonproductimport-companyid-'.$CompanyID . '-cronjobid-'.$CronJobID.'-' . date('Y-m-d') . '.log');
        try{
            
            //Start Transaction
           // DB::connection('neon_routingengine')->beginTransaction();
            CronJob::createLog($CronJobID);
            $ServiceId = $cronsetting['ServiceId'];
            $PackageId = $cronsetting['PackageID'];
            
            //ProductID this field name will be unique 
            // we will not give any 
            $FieldsProductID = $cronsetting['ProductID'];
            $ProductID = DynamicFields::where(['FieldName'=>$FieldsProductID])->pluck('DynamicFieldsID');
            
            if (!empty($ProductID)) { 
                
                $CurrencyId = Company::where(['CompanyID'=>$CompanyID])->pluck('CurrencyId');
                $Getdata = array();
                $APIResponse = NeonAPI::callGetAPI($Getdata,"api/Products","http://api-neon.speakintelligence.com/");
                if (isset($APIResponse["error"])) {
                    Log::info('neonproductimport Error in  api/Products service.' . print_r($APIResponse["error"]));
                } else {
                    $ProductResponses = json_decode($APIResponse["response"]);

                    foreach($ProductResponses as $ProductResponse) {
                        Log::info('ProductResponse.' . $ProductResponse->isPackage);
                       // var_dump($ProductResponse->isPackage);
                        if($ProductResponse->isPackage == false) {
                            Log::info('ProductResponse. Template');
                            $DynamicFieldsID = DynamicFields::where(['CompanyID' => $CompanyID, 'FieldName' => $FieldsProductID])->pluck('DynamicFieldsID');
                            $DynamicFieldsParentID = DynamicFieldsValue::where(['CompanyID' => $CompanyID, 'FieldValue' => $ProductResponse->productId, 'DynamicFieldsID' => $DynamicFieldsID])->pluck('ParentID');
                            Log::info('ProductResponse. Template' . $DynamicFieldsID . ' ' . $DynamicFieldsParentID);
                            $productdata = array();
                            $productdata['ServiceId'] = $ServiceId;
                            $productdata['Name'] = $ProductResponse->name;

                            $productdata['country'] = $ProductResponse->countryName;
                            $productdata['prefixName'] = $ProductResponse->prefixName;
                            $productdata['CurrencyId'] = $CurrencyId;
                            $productdata['CompanyID'] = $CompanyID;
                            $city_tariff = '';
                            if (!empty($ProductResponse->cityName)) {
                                $city_tariff = $ProductResponse->cityName;
                            } else {
                                $city_tariff = $ProductResponse->tariff;
                            }
                            $productdata['city_tariff'] = $city_tariff;

                            if (!empty($DynamicFieldsParentID)) {
                                ServiceTemplate::where(["ServiceTemplateId" => $DynamicFieldsParentID])->update($productdata);
                            }else {
                                try {
                                    $ServiceTemplate = ServiceTemplate::create($productdata);
                                $dyndata = array();
                                $dyndata['CompanyID'] = $CompanyID;
                                $dyndata['ParentID'] = $ServiceTemplate->ServiceTemplateId;
                                $dyndata['DynamicFieldsID'] = $DynamicFieldsID;
                                $dyndata['FieldValue'] = $ProductResponse->productId;
                                    Log::info('Dynamic Field Data.' . print_r($dyndata));
                                DynamicFieldsValue::insert($dyndata);
                                }catch(Exception $ex){
                                    Log::useFiles(storage_path() . '/logs/neonproductimport-Error-' . date('Y-m-d') . '.log');
                                    Log::error($ex);
                                }
                            }
                        }else{
                            Log::info('ProductResponse. Template' . $DynamicFieldsID . ' ' . $DynamicFieldsParentID);
                            Log::info('ProductResponse. Package');
                            $DynamicFieldsID = DynamicFields::where(['CompanyID' => $CompanyID, 'FieldName' => $PackageId])->pluck('DynamicFieldsID');
                            $DynamicFieldsParentID = DynamicFieldsValue::where(['CompanyID' => $CompanyID, 'FieldValue' => $ProductResponse->productId, 'DynamicFieldsID' => $DynamicFieldsID])->pluck('ParentID');;
                            $packagedata = array();
                            $packagedata['Name'] = $ProductResponse->name;
                            $packagedata['CurrencyId'] = $CurrencyId;
                            $packagedata['CompanyID'] = $CompanyID;
                            if (!empty($DynamicFieldsParentID)) {
                                Package::where(["PackageId" => $DynamicFieldsParentID])->update($packagedata);
                            }else {
                                try {
                                    $Package = Package::create($packagedata);
                                    $dyndata = array();
                                    $dyndata['CompanyID'] = $CompanyID;
                                    $dyndata['ParentID'] = $Package['PackageId'];
                                    $dyndata['DynamicFieldsID'] = $DynamicFieldsID;
                                    $dyndata['FieldValue'] = $ProductResponse->productId;

                                    DynamicFieldsValue::insert($dyndata);
                                    } catch (Exception $ex) {
                                    Log::useFiles(storage_path() . '/logs/neonproductimport-Error-' . date('Y-m-d') . '.log');

                                    Log::error($ex);
                                    }
                                }
                            }
                    }
                }
            }else{
                Log::info('neonproductimport Not Find DynamicFieldsID.');
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
