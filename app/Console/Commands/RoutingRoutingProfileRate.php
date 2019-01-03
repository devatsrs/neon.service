<?php namespace App\Console\Commands;

use App\Lib\CronHelper;
use App\Lib\Summary;
use App\Lib\RoutingProfileRate;
use Illuminate\Console\Command;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\Retention;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use \Exception;
use Symfony\Component\Console\Input\InputArgument;
use App\Lib\CompanyGateway;

class RoutingRoutingProfileRate extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'routingprofilerate';

	/**
	 * The console command description.
	 *
	 * @var string
	 */
	protected $description = 'RoutingProfileRate Command description.';

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
        
        //print_r($cronsetting);die();
        Log::useFiles(storage_path() . '/logs/RoutingProfileRates-companyid:'.$CompanyID . '-cronjobid:'.$CronJobID.'-' . date('Y-m-d') . '.log');
        try{
            
            DB::connection('neon_routingengine')->table('tblRoutingProfileRate')->truncate();
            
            DB::beginTransaction();
            try {
                $GetRoutingInfo = DB::connection('sqlsrv')->select('call prc_RoutingRoutingProfileRate()');
                DB::commit();
            } catch (Exception $ex) {
                DB::rollback();
            }
//            foreach ($GetRoutingInfo as $RoutingData) {
//                $tempItemData = array();
//                if(isset($RoutingData->RoutingProfileID)){
//                    $tempItemData['RoutingProfileId']   = $RoutingData->RoutingProfileID;
//                }
//                if(isset($RoutingData->CompanyID)){
//                    $tempItemData['CompanyId']          = $RoutingData->CompanyID;
//                }
//                if(isset($RoutingData->TrunkID)){
//                    $tempItemData['TrunkId'] = $RoutingData->TrunkID;
//                }
//                if(isset($RoutingData->VendorID)){
//                    $tempItemData['VendorID'] = $RoutingData->VendorID;
//                }
//                if(isset($RoutingData->OriginationCode)){
//                    $tempItemData['OriginationCode'] = $RoutingData->OriginationCode;
//                }
//                if(isset($RoutingData->DestinationCode)){
//                    $tempItemData['DestinationCode'] = $RoutingData->DestinationCode;
//                }
//                if(isset($RoutingData->Rate)){
//                    $tempItemData['Rate'] = $RoutingData->Rate;
//                }
//                if(isset($RoutingData->ConnectionFee)){
//                    $tempItemData['ConnectionFee'] = $RoutingData->ConnectionFee;
//                }
//                if(isset($RoutingData->IP)){
//                    $tempItemData['IP'] = $RoutingData->IP;
//                }
//                if(isset($RoutingData->Port)){
//                    $tempItemData['Port'] = $RoutingData->Port;
//                }
//                if(isset($RoutingData->Username)){
//                    $tempItemData['Username'] = $RoutingData->Username;
//                }
//                
//                if(isset($RoutingData->Password)){
//                    $tempItemData['Password'] = $RoutingData->Password;
//                }
//                if(isset($RoutingData->SipHeader)){
//                    $tempItemData['SipHeader'] = $RoutingData->SipHeader;
//                }
//                if(isset($RoutingData->AuthenticationMode)){
//                    $tempItemData['AuthenticationMode'] = $RoutingData->AuthenticationMode;
//                }
//                if(isset($RoutingData->CLIRule)){
//                    $tempItemData['CLITranslationRule'] = $RoutingData->CLIRule;
//                }
//                if(isset($RoutingData->CLDRule)){
//                    $tempItemData['CLDTranslationRule'] = $RoutingData->CLDRule;
//                }
//                if(isset($RoutingData->VendorName)){
//                    $tempItemData['VendorName'] = $RoutingData->VendorName;
//                }
//                if(isset($RoutingData->Trunk)){
//                    $tempItemData['Trunk'] = $RoutingData->Trunk;
//                }
//                if(isset($RoutingData->VendorConnectionName)){
//                    $tempItemData['VendorConnectionName'] = $RoutingData->VendorConnectionName;
//                }
//                if(isset($RoutingData->Currency)){
//                    $tempItemData['Currency'] = $RoutingData->Currency;
//                }
//                if(isset($RoutingData->Preference)){
//                    $tempItemData['Preference'] = $RoutingData->Preference;
//                    if(trim($tempItemData['Preference'])==""){
//                        $tempItemData['Preference']=5;
//                    }
//                }
//                
//                if(isset($RoutingData->TimezoneId)){
//                    $tempItemData['TimezoneId'] = $RoutingData->TimezoneId;
//                }
//                if(isset($RoutingData->RoutingCategoryOrder)){
//                    $tempItemData['RoutingCategoryOrder'] = $RoutingData->RoutingCategoryOrder;
//                }
//                
//                $RoutingProfileRate = RoutingProfileRate::create($tempItemData);
//                $id    =   $RoutingProfileRate['id'];
//            
//            }
                        
            echo "DONE With RoutingProfileRates";
            
            $result = CronJob::CronJobSuccessEmailSend($CronJobID);
            
            Log::info('Run Cron.');
        }catch (\Exception $e){
            Log::useFiles(storage_path() . '/logs/RoutingProfileRates-Error-' . date('Y-m-d') . '.log');
            //Log::info('LCRRoutingEngine Error.');
            Log::useFiles(storage_path() . '/logs/RoutingProfileRates-Error-' . date('Y-m-d') . '.log');
            
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
    }

}
