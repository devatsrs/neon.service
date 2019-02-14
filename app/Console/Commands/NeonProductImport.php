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
        $DynamicFieldsID ='';
        $DynamicFieldsParentID = '';
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
            $APIMethod = $cronsetting['ProductAPIMethod'];
            $APIUrl = $cronsetting['ProductAPIURL'];

            //ProductID this field name will be unique
            // we will not give any 
            $FieldsProductID = $cronsetting['ProductID'];
            $ProductID = DynamicFields::where(['FieldName'=>$FieldsProductID])->pluck('DynamicFieldsID');
            
            
            
            if (!empty($ProductID)) { 
                
                $CurrencyId = Company::where(['CompanyID'=>$CompanyID])->pluck('CurrencyId');
                $Getdata = array();
                $APIResponse = NeonAPI::callGetAPI($Getdata,$APIMethod, $APIUrl);
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
                            $productdata['ServiceId'] = $ServiceId[0];
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
            
            
            //Insert other Company Packages
            $this->otherCompanyPackages($CompanyID,$PackageId);
            $this->otherCompanyProducts($CompanyID,$FieldsProductID);
            
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
    public function otherCompanyPackages($CompanyID,$PackageId){
        $CompanyList = Company::where("CompanyID",'!=', $CompanyID)->get();
        
        $DynamicFieldsIDOld = DynamicFields::where(['CompanyID' => $CompanyID, 'FieldName' => $PackageId])->pluck('DynamicFieldsID');
        $DynamicFieldsObj  = DynamicFieldsValue::where(['CompanyID' => $CompanyID, 'DynamicFieldsID' => $DynamicFieldsIDOld])->get();
        
        foreach ($CompanyList as $Company) {
            $CurrencyId=$Company->CurrencyId;
            if(empty($CurrencyId)){
                $CurrencyId=1;
            }
            $DynamicFieldsID = DynamicFields::where(['CompanyID' => $Company->CompanyID, 'FieldName' => $PackageId])->pluck('DynamicFieldsID');
            if (!empty($DynamicFieldsID)) {
            }else {
                $DynamicFieldsdata = array();
                $DynamicFieldsdata['Type'] = 'package';
                $DynamicFieldsdata['FieldDomType'] = 'string';
                $DynamicFieldsdata['CompanyID'] = $Company->CompanyID;
                $DynamicFieldsdata['FieldName'] = $PackageId;
                $DynamicFieldsdata['FieldSlug'] = $PackageId;
                $DynamicFields = DynamicFields::create($DynamicFieldsdata);
                $DynamicFieldsID=$DynamicFields['DynamicFieldsID'];
            }
            
            $PackageList = Package::where(['CompanyID'=>$CompanyID])->get();
            foreach ($PackageList as $ProductResponse) {
                
                $PackageIds = Package::where(['CompanyID' => $Company->CompanyID, 'Name' => $ProductResponse->Name])->pluck('PackageId');
                $packagedata = array();
                $packagedata['Name'] = $ProductResponse->Name;
                $packagedata['CurrencyId'] = $CurrencyId;
                $packagedata['CompanyID'] = $Company->CompanyID;
                
                 if (!empty($PackageIds)) {
                 }else{
                     $Package = Package::create($packagedata);
                     $PackageIds=$Package['PackageId'];
                 }
                
                    //save dynamic field value
//                 foreach ($DynamicFieldsObj as $DynamicFieldsRes) {
//                    $DynamicFieldsParentID          = DynamicFieldsValue::where(['CompanyID' => $Company->CompanyID, 'FieldValue' => $DynamicFieldsRes->FieldValue, 'DynamicFieldsID' => $DynamicFieldsID, 'ParentID' => $PackageIds])->pluck('ParentID');;
//                    if (!empty($DynamicFieldsParentID)) {
//                    }else {
//                        try {
//                            $dyndata = array();
//                            $dyndata['CompanyID'] = $Company->CompanyID;
//                            $dyndata['ParentID'] = $PackageIds;
//                            $dyndata['DynamicFieldsID'] = $DynamicFieldsID;
//                            $dyndata['FieldValue'] = $DynamicFieldsRes->FieldValue;
//
//                            DynamicFieldsValue::insert($dyndata);
//
//                        } catch (Exception $ex) {
//                            print_r($ex);
//                           die();
//                        }
//                    }
//                 }
                
                
            }
        }
        
    }
    public function otherCompanyProducts($CompanyID,$FieldsProductID){
        $CompanyList = Company::where("CompanyID",'!=', $CompanyID)->get();
        
        $DynamicFieldsIDOld = DynamicFields::where(['CompanyID' => $CompanyID, 'FieldName' => $FieldsProductID])->pluck('DynamicFieldsID');
        $DynamicFieldsObj  = DynamicFieldsValue::where(['CompanyID' => $CompanyID, 'DynamicFieldsID' => $DynamicFieldsIDOld])->get();
        
        foreach ($CompanyList as $Company) {
            $CurrencyId=$Company->CurrencyId;
            if(empty($CurrencyId)){
                $CurrencyId=1;
            }
            $DynamicFieldsID = DynamicFields::where(['CompanyID' => $Company->CompanyID, 'FieldName' => $FieldsProductID])->pluck('DynamicFieldsID');
            if (!empty($DynamicFieldsID)) {
            }else {
                $DynamicFieldsdata = array();
                $DynamicFieldsdata['Type'] = 'package';
                $DynamicFieldsdata['FieldDomType'] = 'string';
                $DynamicFieldsdata['CompanyID'] = $Company->CompanyID;
                $DynamicFieldsdata['FieldName'] = $FieldsProductID;
                $DynamicFieldsdata['FieldSlug'] = $FieldsProductID;
                $DynamicFields = DynamicFields::create($DynamicFieldsdata);
                $DynamicFieldsID=$DynamicFields['DynamicFieldsID'];
            }
            
            $PackageList = ServiceTemplate::where(['CompanyID'=>$CompanyID])->get();
            foreach ($PackageList as $ProductResponse) {
                
                $PackageIds = ServiceTemplate::where(['CompanyID' => $Company->CompanyID, 'Name' => $ProductResponse->Name, 'ServiceId' => $ProductResponse->ServiceId])->pluck('ServiceTemplateId');
                $productdata = array();
                $productdata['ServiceId'] = $ProductResponse->ServiceId;
                $productdata['Name'] = $ProductResponse->name;

                $productdata['country'] = $ProductResponse->country;
                $productdata['prefixName'] = $ProductResponse->prefixName;
                $productdata['CurrencyId'] = $CurrencyId;
                $productdata['CompanyID'] = $Company->CompanyID;
                $productdata['city_tariff'] = $ProductResponse->city_tariff;
                
                 if (!empty($PackageIds)) {
                 }else{
                     $Package = ServiceTemplate::create($productdata);
                     $PackageIds=$Package['ServiceTemplateId'];
                 }
                 
                  //save dynamic field value
//                 foreach ($DynamicFieldsObj as $DynamicFieldsRes) {
//                    $DynamicFieldsParentID          = DynamicFieldsValue::where(['CompanyID' => $Company->CompanyID, 'FieldValue' => $DynamicFieldsRes->FieldValue, 'DynamicFieldsID' => $DynamicFieldsID, 'ParentID' => $PackageIds])->pluck('ParentID');;
//                    if (!empty($DynamicFieldsParentID)) {
//                    }else {
//                        try {
//                            $dyndata = array();
//                            $dyndata['CompanyID'] = $Company->CompanyID;
//                            $dyndata['ParentID'] = $PackageIds;
//                            $dyndata['DynamicFieldsID'] = $DynamicFieldsID;
//                            $dyndata['FieldValue'] = $DynamicFieldsRes->FieldValue;
//
//                            DynamicFieldsValue::insert($dyndata);
//
//                        } catch (Exception $ex) {
//                            print_r($ex);
//                           die();
//                        }
//                    }
//                 }
                
            }
        }
        
    }

}
