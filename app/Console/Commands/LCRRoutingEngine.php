<?php namespace App\Console\Commands;

use App\Lib\CronHelper;
use App\Lib\Summary;
use App\Lib\RoutingEngine;
use Illuminate\Console\Command;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\Retention;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use \Exception;
use Symfony\Component\Console\Input\InputArgument;
use App\Lib\CompanyGateway;

class LCRRoutingEngine extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'lcrroutingengine';

	/**
	 * The console command description.
	 *
	 * @var string
	 */
	protected $description = 'LCR RoutingEngine Command description.';

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
        try{
            
            CronHelper::before_cronrun($this->name, $this );

            $arguments = $this->argument();
            $CompanyID = $arguments["CompanyID"];
            $CronJobID = $arguments["CronJobID"];
            
           // $trunk = DB::table('tblTrunk')->where(array('CompanyId'=>$CompanyID));
            //$unPaidInvoices = DB::connection('sqlsrv2')->select('CALL prc_getPaymentPendingInvoice( ' . $CompanyID . ',' . $AccountID .',' . $PaymentDueInDays .',' . $AutoPay .")");
            $select = "select * from tblTrunk where CompanyId = ".$CompanyID;
            $result = DB::connection('sqlsrv')->getPdo()->query($select);
            $TrunkList = $result->fetchAll(\PDO::FETCH_ASSOC);
            
                //Get TIMEZONE LIST
                $select = "select * from tblTimezones";
                $result = DB::connection('sqlsrv')->getPdo()->query($select);
                $TodayDate=date('Y-m-d');//'2018-12-26'
                $Timezones = $result->fetchAll(\PDO::FETCH_ASSOC);
            
                $lcrArr = array('LCR'=>'2','LCR + PREFIX'=>'1');
                //Get Trunk List
                foreach ($TrunkList as $key1 => $value1) {
                   // "TRUNK: ".$value1['Trunk']."----";
                    echo $TrunkVal = $value1['Trunk'];
                     //LCR Loop
                    foreach ($lcrArr as $key => $value) {
                        echo "LCR:".$value."----";
                        $LCRPolicy=$value;
                        //Get TimeZONE LIST
                        foreach ($Timezones as $key2 => $value2) {
                            echo "Timezones: ".$value2['Title']."---";echo "\n";
                            $Timezone=$value2['TimezonesID'];
                            //Insert the Records--------------------------------
                            $tempItemData = array();
                            $tempItemData['LCRPolicy'] =$key;
                            $tempItemData['Date'] =$TodayDate;
                            $tempItemData['Trunk'] =$value1['TrunkID'];
                            $tempItemData['Timezone'] =$value2['TimezonesID'];
                            try{
                                 $select = "select LCRPolicy,Date,Trunk,Timezone from tblLCRHeader where Trunk='".$value1['TrunkID']."' AND  LCRPolicy='".$key."' AND Timezone=".$value2['TimezonesID'];
                                $result = DB::connection('neon_routingengine')->getPdo()->query($select);
                                $firstResult    = $result->fetch(\PDO::FETCH_ASSOC);
                                $LCRHeaderID    ='';
                                if(count($firstResult)>0 && $firstResult['LCRPolicy']!=''){
                                    //Do Nothing for duplicate
                                }else{
                                    $LCRHeader =RoutingEngine::create($tempItemData);
                                    $LCRHeaderID    =   $LCRHeader['LCRHeaderID'];
                                }
                            }catch (Exception $err) {
                                echo ($err);
                            }
                            
                           
                            //--------------------------------------------------
                            if($LCRHeaderID!=''){
                                //Insert Records in tblLCRDetail
                                $VendorConnectionID='';$OriginationCode='';$Code='';$Rate='';$VendorID='';$VendorName='';$ConnectionFee='';
                                $VendorPosition = '';//$LCRData->VendorPosition;
                                $ConnectionFee = '';//$LCRData->ConnectionFee;
                                $IP = '';//$LCRData->IP;
                                $Port = '';//$LCRData->Port;
                                $Username = '';//$LCRData->Username;
                                $Password = '';//$LCRData->Password;
                                $SipHeader = '';//$LCRData->SipHeader;
                                $AuthenticationMode = '';//$LCRData->AuthenticationMode;
                                $CLITranslationRule = '';//$LCRData->CLITranslationRule;
                                $CLDTranslationRule = '';//$LCRData->CLDTranslationRule;
                                if($value=='2'){
                                //CALL prc_GetLCR (1,1,'1',11,'3','','','91','','',1,10,'asc','0','5','1','description','2018-12-26','1' ,'0' ,'0' ,2) 
                                //codedesk 11 - check codedesk
                                //currency 3
                               // $qry="CALL prc_GetLCR (1,1,'1',11,'3','','','91','','',1,10,'asc','0','5','1','description','2018-12-26','1' ,'0' ,'0' ,2) ";
                               // $GetLCRInfo = DB::connection('sqlsrv')->select($qry);
                                //print_r($GetLCRInfo);die();
                                $GetLCRInfo = DB::connection('sqlsrv')->select('call prc_GetLCR ( "' . $CompanyID . '","' . $value1['TrunkID'] .'","' . $value2['TimezonesID'] .'",11,3,"","","91","","",1,10,"asc","0","5","1","description","'.$TodayDate.'","1" ,"0" ,"0" ,2)');
                                foreach ($GetLCRInfo as $LCRData) {
                                   echo "\n"; echo 'Pro:';
                                    
                                   if(isset($LCRData->VendorConnectionID)){
                                        $VendorConnectionID = $LCRData->VendorConnectionID;
                                   }
                                   if(isset($LCRData->OriginationCode)){
                                        $OriginationCode = $LCRData->OriginationCode;
                                   }
                                   if(isset($LCRData->Code)){
                                       $Code = $LCRData->Code;
                                   }
                                   if(isset($LCRData->Rate)){
                                       $Rate = $LCRData->Rate;
                                   }
                                   if(isset($LCRData->AccountId)){
                                       $VendorID = $LCRData->AccountId;
                                       
                                       //tblVendorConnection
                                        $select = "select IP,Port,Username,Password,SipHeader,AuthenticationMode from tblVendorConnection where TrunkID='".$value1['TrunkID']."' AND AccountId='".$VendorID."' AND CompanyID=".$CompanyID;
                                        $result = DB::connection('sqlsrv')->getPdo()->query($select);
                                        $firstResult    = $result->fetch(\PDO::FETCH_ASSOC);
                                        if(count($firstResult)>0){
                                            
                                            $IP             = $firstResult['IP'];
                                            $Port           = $firstResult['Port'];
                                            $Username       = $firstResult['Username'];
                                            $Password       = $firstResult['Password'];
                                            $SipHeader      = $firstResult['SipHeader'];
                                            $AuthenticationMode = $firstResult['AuthenticationMode'];
                                        }
                                   }
                                   if(isset($LCRData->ConnectionFee)){
                                       $ConnectionFee = $LCRData->ConnectionFee;
                                   }
                                   
                                   
                                   $VendorPosition = '';//$LCRData->VendorPosition;
                                   
                                   $CLITranslationRule = '';//$LCRData->CLITranslationRule;
                                   $CLDTranslationRule = '';//$LCRData->CLDTranslationRule;
                                   
                                   if(isset($LCRData->AccountName)){
                                       $VendorName = $LCRData->AccountName;
                                   }
                                   //Insert the Records into tblLCRDetail --------------------------
                                    $sql = "insert into tblLCRDetail (LCRHeaderID,OriginatioCode,DestinationCode"
                                            . ",Rate"
                                            . ",ConnectionFee"
                                            . ",VendorID"
                                            . ",VendorPosition"
                                            . ",IP"
                                            . ",Port"
                                            . ",Username"
                                            . ",Password"
                                            . ",SipHeader"
                                            . ",AuthenticationMode"
                                            . ",CLITranslationRule"
                                            . ",CLDTranslationRule"
                                            . ",VendorName)";
                                    $sql .= " values('".$LCRHeaderID."','".$Code."','".$OriginationCode."'"
                                            . ",'".$Rate."'"
                                            . ",'".$ConnectionFee."'"
                                            . ",'".$VendorID."'"
                                            . ",'".$VendorPosition."'"
                                            . ",'".$IP."'"
                                            . ",'".$Port."'"
                                            . ",'".$Username."'"
                                            . ",'".$Password."'"
                                            . ",'".$SipHeader."'"
                                            . ",'".$AuthenticationMode."'"
                                            . ",'".$CLITranslationRule."'"
                                            . ",'".$CLDTranslationRule."'"
                                            . ",'".$VendorName."')";
                                    echo "\n";echo "\n";
                                    //DB::connection('neon_routingengine')->statement($sql);
                                    $select = "select LCRHeaderID from tblLCRDetail where LCRHeaderID='".$LCRHeaderID."' AND  VendorID='".$VendorID."' ";
                                    $result = DB::connection('neon_routingengine')->getPdo()->query($select);
                                    $firstResult    = $result->fetch(\PDO::FETCH_ASSOC);
                                    if(count($firstResult)>0 && $firstResult['LCRHeaderID']!=''){
                                        //Do Nothing for duplicate
                                    }else{
                                        DB::connection('neon_routingengine')->statement($sql);
                                    }
                                    //$tblLCRDetailID=DB::getPdo()->lastInsertId();
                                    //--------------------------------------------------
                            
                                    echo "\n";
                                }
                            }else if($value=='1'){
                                //CALL prc_GetLCR (1,1,'1',11,'3','','','91','','',1,10,'asc','0','5','1','description','2018-12-26','1' ,'0' ,'0' ,2) 
                                //codedesk 11 - check codedesk
                                //currency 3
                                //$qry="CALL prc_GetLCRwithPrefix (1,1,'1',11,'3','','','91','','',1,10,'asc','0','5','1','description','2018-12-26','1' ,'0' ,'0' ,2) ";
                                //$GetLCRInfo = DB::connection('sqlsrv')->select($qry);
                                //print_r($GetLCRInfo);die();
                                $GetLCRInfo = DB::connection('sqlsrv')->select('call prc_GetLCRwithPrefix ( "' . $CompanyID . '","' . $value1['TrunkID'] .'","' . $value2['TimezonesID'] .'",11,3,"","","91","","",1,10,"asc","0","5","1","description","'.$TodayDate.'","1" ,"0" ,"0" ,2)');
                                foreach ($GetLCRInfo as $LCRData) {
                                   echo "\n"; echo 'Pro';
                                    
                                   if(isset($LCRData->VendorConnectionID)){
                                        $VendorConnectionID = $LCRData->VendorConnectionID;
                                   }
                                   if(isset($LCRData->OriginationCode)){
                                        $OriginationCode = $LCRData->OriginationCode;
                                   }
                                   if(isset($LCRData->Code)){
                                       $Code = $LCRData->Code;
                                   }
                                   if(isset($LCRData->Rate)){
                                       $Rate = $LCRData->Rate;
                                   }
                                   if(isset($LCRData->AccountId)){
                                       $VendorID = $LCRData->AccountId;
                                       //tblVendorConnection
                                        $select = "select IP,Port,Username,Password,SipHeader,AuthenticationMode from tblVendorConnection where TrunkID='".$value1['TrunkID']."' AND AccountId='".$VendorID."' AND CompanyID=".$CompanyID;
                                        $result = DB::connection('sqlsrv')->getPdo()->query($select);
                                        $firstResult    = $result->fetch(\PDO::FETCH_ASSOC);
                                        if(count($firstResult)>0){
                                            $IP             = $firstResult['IP'];
                                            $Port           = $firstResult['Port'];
                                            $Username       = $firstResult['Username'];
                                            $Password       = $firstResult['Password'];
                                            $SipHeader      = $firstResult['SipHeader'];
                                            $AuthenticationMode = $firstResult['AuthenticationMode'];
                                        }
                                   }
                                   if(isset($LCRData->ConnectionFee)){
                                       $ConnectionFee = $LCRData->ConnectionFee;
                                   }
                                   $VendorPosition = '';//$LCRData->VendorPosition;
                                   $CLITranslationRule = '';//$LCRData->CLITranslationRule;
                                   $CLDTranslationRule = '';//$LCRData->CLDTranslationRule;
                                   
                                   if(isset($LCRData->AccountName)){
                                       $VendorName = $LCRData->AccountName;
                                   }
                                   
                                   //Insert the Records into tblLCRDetail --------------------------
                                    $sql = "insert into tblLCRDetail (LCRHeaderID,OriginatioCode,DestinationCode"
                                            . ",Rate"
                                            . ",ConnectionFee"
                                            . ",VendorID"
                                            . ",VendorPosition"
                                            . ",IP"
                                            . ",Port"
                                            . ",Username"
                                            . ",Password"
                                            . ",SipHeader"
                                            . ",AuthenticationMode"
                                            . ",CLITranslationRule"
                                            . ",CLDTranslationRule"
                                            . ",VendorName)";
                                     $sql .= " values('".$LCRHeaderID."','".$Code."','".$OriginationCode."'"
                                            . ",'".$Rate."'"
                                            . ",'".$ConnectionFee."'"
                                            . ",'".$VendorID."'"
                                            . ",'".$VendorPosition."'"
                                            . ",'".$IP."'"
                                            . ",'".$Port."'"
                                            . ",'".$Username."'"
                                            . ",'".$Password."'"
                                            . ",'".$SipHeader."'"
                                            . ",'".$AuthenticationMode."'"
                                            . ",'".$CLITranslationRule."'"
                                            . ",'".$CLDTranslationRule."'"
                                            . ",'".$VendorName."')";
                                     
                                        $select = "select LCRHeaderID from tblLCRDetail where LCRHeaderID='".$LCRHeaderID."' AND  VendorID='".$VendorID."' ";
                                        $result = DB::connection('neon_routingengine')->getPdo()->query($select);
                                        $firstResult    = $result->fetch(\PDO::FETCH_ASSOC);
                                        if(count($firstResult)>0 && $firstResult['LCRHeaderID']!=''){
                                            //Do Nothing for duplicate
                                        }else{
                                            DB::connection('neon_routingengine')->statement($sql);
                                        }
                                    
                                    //$tblLCRHeaderID=DB::getPdo()->lastInsertId();
                                    //--------------------------------------------------
                            
                                    echo "\n";
                                }
                            }
                            
                            }
                        }
                    }
                    echo "\n";echo "\n";
                }
                
            echo "DONE With LCRRoutingEngine";
            Log::info('Run Cron.');
        }catch (\Exception $e){

        }
    }

}
