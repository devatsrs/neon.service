<?php namespace App\Console\Commands;

use App\Lib\CronHelper;
use App\Lib\NeonAPI;
use App\Lib\ServiceTemplate;
use App\Lib\Package;
use App\Lib\Packagetemp;
use App\Lib\Producttemp;
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
        $DynamicFieldsID ='';
        $DynamicFieldsParentID = '';
        $joblogdata = array();
        $joblogdata['CronJobID'] = $CronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';

        Log::useFiles(storage_path() . '/logs/z_productimport-companyid-'.$CompanyID . '-cronjobid-'.$CronJobID.'-' . date('Y-m-d') . '.log');
        try{
            
            //Start Transaction
           // DB::connection('neon_routingengine')->beginTransaction();
            CronJob::createLog($CronJobID);
            $ServiceId = $cronsetting['ServiceId'];
            $PackageId = $cronsetting['PackageID'];
            $APIMethod = $cronsetting['ProductAPIMethod'];
            $APIUrl = $cronsetting['ProductAPIURL'];

            //ProductID this field name will be unique
            // we will not give any 
            $FieldsProductID = $cronsetting['ProductID'];
            $ProductID = DynamicFields::where(['FieldName'=>$FieldsProductID])->pluck('DynamicFieldsID');
            
            Producttemp::truncate();
            Packagetemp::truncate();
            
            if (!empty($ProductID)) { 
                
                $CurrencyId = Company::where(['CompanyID'=>$CompanyID])->pluck('CurrencyId');
                $Getdata = array();
                $APIResponse = NeonAPI::callGetAPI($Getdata,$APIMethod, $APIUrl);
                if (isset($APIResponse["error"])) {
                    Log::info('z_neonproductimport1 Error in  api/Products service.' . print_r($APIResponse["error"]));
                } else {
                    $ProductResponses = json_decode($APIResponse["response"]);

                    foreach($ProductResponses as $ProductResponse) {
                        Log::info('z_ProductResponse2.' . $ProductResponse->isPackage);
                       // var_dump($ProductResponse->isPackage);
                        if($ProductResponse->isPackage == false) {
                            Log::info('z_ProductResponse3. Template');
                            $productdata = array();
                            $productdata['ServiceId']   = $ServiceId[0];
                            $productdata['ProductId']   = $ProductResponse->productId;
                            $productdata['Name']        = $ProductResponse->name;
                            $productdata['country']     = $ProductResponse->countryName;
                            $productdata['prefixName']  = str_replace(" ","",$ProductResponse->prefixName);
                            $productdata['CurrencyId']  = $CurrencyId;
                            $productdata['CompanyID']   = $CompanyID;
                            $productdata['FieldName']   = $FieldsProductID;
                            //$city_tariff = '';
                            if (!empty($ProductResponse->cityName)) {
                                $City = $ProductResponse->cityName;
                                $productdata['City'] = $City;
                            }
                            if ($ProductResponse->tariff != '') { 
                                $Tariff = $ProductResponse->tariff.' '.$ProductResponse->tariffType;
                                $productdata['Tariff'] = $Tariff;
                            }
                            // $productdata['City'] = $city_tariff;
                            // $productdata['Tariff'] = $city_tariff;
                            if (!empty($ProductResponse->accessTypeName)) {
                                $productdata['accessType'] = $ProductResponse->accessTypeName;
                            }
                            if (!empty($ProductResponse->countryCode)) {
                                $productdata['countryCode'] = $ProductResponse->countryCode;
                            }
                            $ServiceTemplate            = Producttemp::create($productdata);
                            
                            
//                            
//                            $DynamicFieldsID = DynamicFields::where(['CompanyID' => $CompanyID, 'FieldName' => $FieldsProductID])->pluck('DynamicFieldsID');
//                            $DynamicFieldsParentID = DynamicFieldsValue::where(['CompanyID' => $CompanyID, 'FieldValue' => $ProductResponse->productId, 'DynamicFieldsID' => $DynamicFieldsID])->pluck('ParentID');
//                            Log::info('ProductResponse. Template' . $DynamicFieldsID . ' ' . $DynamicFieldsParentID);
//                            $productdata = array();
//                            $productdata['ServiceId'] = $ServiceId[0];
//                            $productdata['Name'] = $ProductResponse->name;
//
//                            $productdata['country'] = $ProductResponse->countryName;
//                            $productdata['prefixName'] = $ProductResponse->prefixName;
//                            $productdata['CurrencyId'] = $CurrencyId;
//                            $productdata['CompanyID'] = $CompanyID;
//                            $city_tariff = '';
//                            if (!empty($ProductResponse->cityName)) {
//                                $city_tariff = $ProductResponse->cityName;
//                            } else {
//                                $city_tariff = $ProductResponse->tariff;
//                            }
//                            $productdata['city_tariff'] = $city_tariff;
//
//                            if (!empty($DynamicFieldsParentID)) {
//                                ServiceTemplate::where(["ServiceTemplateId" => $DynamicFieldsParentID])->update($productdata);
//                            }else {
//                                try {
//                                    $ServiceTemplate = ServiceTemplate::create($productdata);
//                                $dyndata = array();
//                                $dyndata['CompanyID'] = $CompanyID;
//                                $dyndata['ParentID'] = $ServiceTemplate->ServiceTemplateId;
//                                $dyndata['DynamicFieldsID'] = $DynamicFieldsID;
//                                $dyndata['FieldValue'] = $ProductResponse->productId;
//                                    Log::info('Dynamic Field Data.' . print_r($dyndata));
//                                DynamicFieldsValue::insert($dyndata);
//                                }catch(Exception $ex){
//                                    Log::useFiles(storage_path() . '/logs/neonproductimport-Error-' . date('Y-m-d') . '.log');
//                                    Log::error($ex);
//                                }
//                            }
                        }else{
                            Log::info('z_ProductResponse. Package');
                                $productdata = array();
                            
                                $packagedata = array();
                                $packagedata['ProductId']   = $ProductResponse->productId;
                                $packagedata['Name']        = $ProductResponse->name;
                                $packagedata['CurrencyId']  = $CurrencyId;
                                $packagedata['CompanyID']   = $CompanyID;
                                $packagedata['FieldName']   = $PackageId;
                                $Packagetemp            = Packagetemp::create($packagedata);
                            
//                                $DynamicFieldsID = DynamicFields::where(['CompanyID' => $CompanyID, 'FieldName' => $PackageId])->pluck('DynamicFieldsID');
//                                $DynamicFieldsParentID = DynamicFieldsValue::where(['CompanyID' => $CompanyID, 'FieldValue' => $ProductResponse->productId, 'DynamicFieldsID' => $DynamicFieldsID])->pluck('ParentID');;
//                                $packagedata = array();
//                                $packagedata['Name'] = $ProductResponse->name;
//                                $packagedata['CurrencyId'] = $CurrencyId;
//                                $packagedata['CompanyID'] = $CompanyID;
//                                if (!empty($DynamicFieldsParentID)) {
//                                    Package::where(["PackageId" => $DynamicFieldsParentID])->update($packagedata);
//                                }else {
//                                    try {
//                                        $Package = Package::create($packagedata);
//                                        $dyndata = array();
//                                        $dyndata['CompanyID'] = $CompanyID;
//                                        $dyndata['ParentID'] = $Package['PackageId'];
//                                        $dyndata['DynamicFieldsID'] = $DynamicFieldsID;
//                                        $dyndata['FieldValue'] = $ProductResponse->productId;
//
//                                        DynamicFieldsValue::insert($dyndata);
//                                        } catch (Exception $ex) {
//                                        Log::useFiles(storage_path() . '/logs/neonproductimport-Error-' . date('Y-m-d') . '.log');
//
//                                        Log::error($ex);
//                                        }
//                                    }
                            }
                    }
                }
            }else{
                Log::info('z_neonproductimport5 Not Find DynamicFieldsID.');
            }
            
            
            //Insert other Company Packages
            $result = DB::connection('sqlsrv')->select("CALL  Prc_ImportProducttemp( '" . $CompanyID . "','" . $FieldsProductID . "','" . $PackageId . "')");
            //$result = DB::connection('sqlsrv')->select("CALL  Prc_ImportProducttemp( '" . $CompanyID . "','" . $FieldsProductID . "')");
            
            
            $result = DB::connection('sqlsrv')->select("CALL  Prc_ImportProducts()");
            
            
            Log::info('z_neonproductimport Next step in  api/Products service.');
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
