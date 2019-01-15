<?php namespace App\Console\Commands;

use App\Lib\CronHelper;
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

class PushUpdatedRatesRoutingengine extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'pushupdatedratesroutingengine';

	/**
	 * The console command description.
	 *
	 * @var string
	 */
	protected $description = 'Push updated rates to routing engine';

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
        Log::useFiles(storage_path() . '/logs/pushupdatedratesroutingengine-companyid:'.$CompanyID . '-cronjobid:'.$CronJobID.'-' . date('Y-m-d') . '.log');
        try{
            
            
            $select = "select * from tblTempRateAudit where section_update = tblAccount ";
            $result = DB::connection('neon_routingengine')->getPdo()->query($select);
            $accountList = $result->fetchAll(\PDO::FETCH_ASSOC);
            foreach ($accountList as $key1 => $value1) {
                echo $IsVendor = $value1['IsVendor'];
                $Status = $value1['Status'];$AccountID = $value1['AccountID'];
                
                //Update/Del/Insert Account
                $qry="SELECT rp.RoutingProfileID,
	vc.TrunkID ,
	v.AccountID AS `VendorID` ,
	origRate.Code AS `OriginationCode` ,
	destRate.Code AS `DestinationCode` ,
	rtr.`Rate` ,
	rtr.`ConnectionFee` ,
	vc.`IP` ,
	vc.`Port` ,
	vc.`Username` ,
	vc.`Password` ,
	vc.`SipHeader` ,
	vc.`AuthenticationMode` ,
	vc.CLIRule ,
	vc.CLDRule ,
	v.AccountName AS `VendorName` ,
	trunk.`Trunk` ,
	vc.CallPrefix AS `TrunkPrefix` ,
	vc.Name AS `VendorConnectionName` ,
	curr.Code AS `Currency` ,
	rtr.Preference ,
	rtr.TimezonesID AS `TimezoneId` ,
	rpc.`Order` AS RoutingCategoryOrder,
	rp.CompanyID,rc.Name,rc.RoutingCategoryID
FROM 
speakintelligentRouting.tblRoutingProfile rp
	JOIN speakintelligentRouting.tblRoutingProfileCategory rpc ON rp.RoutingProfileID = rpc.RoutingProfileID 
	JOIN tblRateTableRate rtr ON rpc.RoutingCategoryID =  rtr.RoutingCategoryID
	JOIN speakintelligentRouting.tblRoutingCategory rc ON rpc.RoutingCategoryID =  rc.RoutingCategoryID		
	JOIN tblRateTable rt ON  rtr.RateTableID = rt.RateTableId
		AND rt.CompanyId = rp.CompanyID  
	JOIN tblVendorConnection vc ON rt.RateTableId = vc.RateTableID
	JOIN tblAccount v ON vc.AccountId = v.AccountId 
			AND v.CompanyId = rp.CompanyID  
	JOIN tblRate destRate  ON  rtr.RateID = destRate.RateId
	JOIN tblCurrency curr  ON  rt.CurrencyID = curr.CurrencyId
	LEFT JOIN tblTrunk trunk  ON  vc.TrunkID = trunk.TrunkID 
	LEFT JOIN tblRate origRate ON rtr.OriginationRateID = origRate.RateID
WHERE vc.Active = 1 
		AND vc.RateTypeID = 1
		AND v.AccountID = $AccountID		
		AND v.CurrencyId IS NOT NULL
		AND EffectiveDate <= NOW() 
		AND ( rtr.EndDate IS NULL OR  rtr.EndDate > NOW() )   
		AND rtr.Blocked = 0
		AND rp.`Status` = 1";
                $result1 = DB::connection('neon_routingengine')->getPdo()->query($qry);
                $RoutingProfileRate = $result1->fetchAll(\PDO::FETCH_ASSOC);
                foreach ($RoutingProfileRate as $key2 => $value2) {
                    $RoutingProfileId=$value2['RoutingProfileID'];
                    $TrunkID=$value2['TrunkID'];
                    $VendorID=$value2['VendorID'];
                    $OriginationCode=$value2['OriginationCode'];
                    $DestinationCode=$value2['DestinationCode'];
                    $CompanyID=$value2['CompanyID'];$RoutingCategoryID=$value2['RoutingCategoryID'];
                    
                    if($IsVendor=='0' || $Status=='0'){
                        $deletequey = "delete from tblRoutingProfileRate where RoutingProfileId =$RoutingProfileId AND CompanyId =$CompanyID "
                        . " AND TrunkId =$TrunkID AND VendorID=$VendorID AND OriginationCode=$OriginationCode  AND DestinationCode=$DestinationCode "
                        . " AND RoutingCategoryID=$RoutingCategoryID ";
                        DB::connection('neon_routingengine')->statement($deletequey);
                    }else{
                        //Set Array
                        $DataArray              = array();
                        $DataArray['RoutingProfileId']=$value2['RoutingProfileID'];
                        $DataArray['CompanyId']=$value2['CompanyID'];
                        $DataArray['TrunkId']=$value2['TrunkID'];
                        $DataArray['VendorID']=$value2['VendorID'];
                        $DataArray['OriginationCode']=$value2['OriginationCode'];
                        $DataArray['DestinationCode']=$value2['DestinationCode'];
                        $DataArray['Rate']=$value2['Rate'];
                        $DataArray['ConnectionFee']=$value2['ConnectionFee'];
                        $DataArray['IP']=$value2['IP'];
                        $DataArray['Port']=$value2['Port'];
                        $DataArray['Username']=$value2['Username'];
                        $DataArray['Password']=$value2['Password'];
                        $DataArray['SipHeader']=$value2['SipHeader'];
                        $DataArray['AuthenticationMode']=$value2['AuthenticationMode'];
                        $DataArray['CLITranslationRule']=$value2['CLIRule'];
                        $DataArray['CLDTranslationRule']=$value2['CLDRule'];
                        $DataArray['VendorName']=$value2['VendorName'];
                        $DataArray['Trunk']=$value2['Trunk'];
                        $DataArray['TrunkPrefix']=$value2['TrunkPrefix'];
                        $DataArray['VendorConnectionName']=$value2['VendorConnectionName'];
                        $DataArray['Currency']=$value2['Currency'];
                        $DataArray['Preference']=$value2['Preference'];
                        $DataArray['TimezoneId']=$value2['TimezoneId'];
                        $DataArray['Location']='';
                        $DataArray['RoutingCategoryOrder']=$value2['RoutingCategoryOrder'];
                        $DataArray['selectionCode']='';
                        $DataArray['RoutingCategoryID']=$value2['RoutingCategoryID'];
                        $DataArray['CategoryName']=$value2['Name'];
                        $qryParts = array();
                        foreach ($DataArray as $keyTbl => $valueTbl) {
                            $qryParts[] = "`" . $keyTbl . "` = '".$valueTbl."'";
                        }
                            
                        $selectVendorID = "select VendorID from tblRoutingProfileRate where RoutingProfileId =$RoutingProfileId AND CompanyId =$CompanyID "
                        . " AND TrunkId =$TrunkID AND VendorID=$VendorID AND OriginationCode=$OriginationCode  AND DestinationCode=$DestinationCode "
                        . " AND RoutingCategoryID=$RoutingCategoryID ";;
                        $resultHave = DB::connection('neon_routingengine')->getPdo()->query($selectVendorID);
                        $firstResultRoutingProfileRate = $resultHave->fetch(\PDO::FETCH_ASSOC);
                        $VendorIDRoutingProfileRate = $firstResultRoutingProfileRate['VendorID'];
                        if($VendorIDRoutingProfileRate!=''){
                            
                            $querytblRoutingProfileRate = "UPDATE tblRoutingProfileRate SET ";
                            $sqlUpdate = $querytblRoutingProfileRate . implode(",", $qryParts) . " WHERE RoutingProfileId =$RoutingProfileId AND CompanyId =$CompanyID "
                            . " AND TrunkId =$TrunkID AND VendorID=$VendorID AND OriginationCode=$OriginationCode  AND DestinationCode=$DestinationCode ";
                            DB::connection('neon_routingengine')->statement($sqlUpdate);
                            
                        }else{
                            
                            $querytblRoutingProfileRate = "INSERT INTO tblRoutingProfileRate SET ";
                            $sqlInsert = $querytblRoutingProfileRate . implode(",", $qryParts) . " ";
                            DB::connection('neon_routingengine')->statement($sqlInsert);
                            
                        }
                    }
                }
                
                //Update/Del/tblVendorRate
                $qry="SELECT 
	vc.TrunkID ,
	v.AccountID AS `VendorID` ,
	origRate.Code AS `OriginationCode` ,
	destRate.Code AS `DestinationCode` ,
	rtr.`Rate` ,
	rtr.`ConnectionFee` ,
	vc.`IP` ,
	vc.`Port` ,
	vc.`Username` ,
	vc.`Password` ,
	vc.`SipHeader` ,
	vc.`AuthenticationMode` ,
	vc.CLIRule ,
	vc.CLDRule ,
	v.AccountName AS `VendorName` ,
	trunk.`Trunk` ,
	vc.CallPrefix AS `TrunkPrefix` ,
	vc.Name AS `VendorConnectionName` ,
	curr.Code AS `Currency` ,
	COALESCE(rtr.Preference,5) AS Preference ,
	rtr.TimezonesID AS `TimezoneId` ,
	v.CompanyId,rc.Name,rc.RoutingCategoryID
FROM tblVendorConnection vc
	JOIN tblAccount v ON vc.AccountId = v.AccountId 
	JOIN tblRateTable rt ON  vc.RateTableID = rt.RateTableId
			AND v.CompanyId = rt.CompanyId
	JOIN tblRateTableRate rtr ON  rtr.RateTableID = rt.RateTableId
	JOIN speakintelligentRouting.tblRoutingCategory rc ON rtr.RoutingCategoryID =  rc.RoutingCategoryID
	JOIN tblRate destRate  ON  rtr.RateID = destRate.RateId		
	JOIN tblCurrency curr  ON  rt.CurrencyID = curr.CurrencyId
	LEFT JOIN tblTrunk trunk  ON  vc.TrunkID = trunk.TrunkID 
	LEFT JOIN tblRate origRate ON rtr.OriginationRateID = origRate.RateID
		
	WHERE vc.Active = 1 
		AND vc.RateTypeID = 1
		AND v.AccountID = $AccountID
		AND v.CurrencyId IS NOT NULL
			AND EffectiveDate <= NOW() 
		AND ( rtr.EndDate IS NULL OR  rtr.EndDate > NOW() )   
		AND rtr.Blocked = 0;";
                $result1 = DB::connection('neon_routingengine')->getPdo()->query($qry);
                $VendorRate = $result1->fetchAll(\PDO::FETCH_ASSOC);
                foreach ($VendorRate as $key3 => $value3) {
                    $TrunkID=$value3['TrunkID'];
                    $VendorID=$value3['VendorID'];
                    $OriginationCode=$value3['OriginationCode'];
                    $DestinationCode=$value3['DestinationCode'];
                    $CompanyID=$value3['CompanyID'];
                    $RoutingCategoryID=$value3['RoutingCategoryID'];
                    
                    
                    ///---------------------------------------------------------
                    if($IsVendor=='0' || $Status=='0'){
                        $deletequey = "delete from tblVendorRate where CompanyId =$CompanyID "
                        . " AND TrunkId =$TrunkID AND VendorID=$VendorID AND OriginationCode=$OriginationCode  AND DestinationCode=$DestinationCode "
                        . " AND RoutingCategoryID=$RoutingCategoryID ";
                        DB::connection('neon_routingengine')->statement($deletequey);
                    }else{
                        //Set Array
                        $DataArray              = array();
                        $DataArray['CompanyId']=$value2['CompanyID'];
                        $DataArray['TrunkId']=$value2['TrunkID'];
                        $DataArray['VendorID']=$value2['VendorID'];
                        $DataArray['OriginationCode']=$value2['OriginationCode'];
                        $DataArray['DestinationCode']=$value2['DestinationCode'];
                        $DataArray['Rate']=$value2['Rate'];
                        $DataArray['ConnectionFee']=$value2['ConnectionFee'];
                        $DataArray['IP']=$value2['IP'];
                        $DataArray['Port']=$value2['Port'];
                        $DataArray['Username']=$value2['Username'];
                        $DataArray['Password']=$value2['Password'];
                        $DataArray['SipHeader']=$value2['SipHeader'];
                        $DataArray['AuthenticationMode']=$value2['AuthenticationMode'];
                        $DataArray['CLITranslationRule']=$value2['CLIRule'];
                        $DataArray['CLDTranslationRule']=$value2['CLDRule'];
                        $DataArray['VendorName']=$value2['VendorName'];
                        $DataArray['Trunk']=$value2['Trunk'];
                        $DataArray['TrunkPrefix']=$value2['TrunkPrefix'];
                        $DataArray['VendorConnectionName']=$value2['VendorConnectionName'];
                        $DataArray['Currency']=$value2['Currency'];
                        $DataArray['Preference']=$value2['Preference'];
                        $DataArray['TimezoneId']=$value2['TimezoneId'];
                        $DataArray['RoutingCategoryID']=$value2['RoutingCategoryID'];
                        $DataArray['CategoryName']=$value2['Name'];
                        
                        $qryParts = array();
                        foreach ($DataArray as $keyTbl => $valueTbl) {
                            $qryParts[] = "`" . $keyTbl . "` = '".$valueTbl."'";
                        }
                            
                        $selectVendorID = "select VendorID from tblVendorRate where CompanyId =$CompanyID "
                        . " AND TrunkId =$TrunkID AND VendorID=$VendorID AND OriginationCode=$OriginationCode  AND DestinationCode=$DestinationCode "
                        . " AND RoutingCategoryID=$RoutingCategoryID ";;
                        $resultHave = DB::connection('neon_routingengine')->getPdo()->query($selectVendorID);
                        $firstResultRoutingProfileRate = $resultHave->fetch(\PDO::FETCH_ASSOC);
                        $VendorIDRoutingProfileRate = $firstResultRoutingProfileRate['VendorID'];
                        if($VendorIDRoutingProfileRate!=''){
                            
                            $querytblRoutingProfileRate = "UPDATE tblVendorRate SET ";
                            $sqlUpdate = $querytblRoutingProfileRate . implode(",", $qryParts) . " WHERE CompanyId =$CompanyID "
                            . " AND TrunkId =$TrunkID AND VendorID=$VendorID AND OriginationCode=$OriginationCode  AND DestinationCode=$DestinationCode ";
                            DB::connection('neon_routingengine')->statement($sqlUpdate);
                            
                        }else{
                            
                            $querytblRoutingProfileRate = "INSERT INTO tblVendorRate SET ";
                            $sqlInsert = $querytblRoutingProfileRate . implode(",", $qryParts) . " ";
                            DB::connection('neon_routingengine')->statement($sqlInsert);
                            
                        }
                    }
                    
                }
            }
            
            Log::info('Run Cron.');
        }catch (\Exception $e){
            Log::useFiles(storage_path() . '/logs/RoutingVendorRate-Error-' . date('Y-m-d') . '.log');
            //Log::info('LCRRoutingEngine Error.');
            Log::useFiles(storage_path() . '/logs/RoutingVendorRate-Error-' . date('Y-m-d') . '.log');
            
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
