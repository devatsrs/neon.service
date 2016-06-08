<?php namespace App\Console\Commands;

use App\Lib\Account;
use App\Lib\Company;
use App\Lib\CompanySetting;
use App\Lib\CronHelper;
use App\Lib\CSVImporter;
use App\Lib\Currency;
use App\Lib\DataTableSql;
use App\Lib\Helper;
use App\Lib\Invoice;
use App\Lib\InvoiceDetail;
use App\Lib\InvoiceTemplate;
use App\Lib\Product;
use App\Lib\TaxRate;
use App\Lib\User;
use Illuminate\Support\Facades\Config;
use Symfony\Component\Console\Input\InputArgument;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Lib\Job;

use Webpatser\Uuid\Uuid;

class DemoData extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'demodata';

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
     * Get the console command arguments.
     *
     * @return array
     */
    protected function getArguments()
    {
        return [
            ['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID'],
        ];
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function fire()
    {

        CronHelper::before_cronrun($this);

        $arguments = $this->argument();
        $CompanyID = $arguments["CompanyID"];
        Log::useFiles(storage_path().'/logs/demodata-'.date('Y-m-d').'.log');
        try {
            $this->deleteOld($CompanyID);
            $CSVImporter = new CSVImporter();
            $CSVImporter->companyid = $CompanyID;
            $CSVImporter->relations=$this->getRelations();
            $path = getenv('DEMO_DATA_PATH');

            $currentpath = $path.'\ratemanagement';
            $CSVImporter->getDirectory($currentpath,'sqlsrv');
            $currentpath = $path.'\RmBilling';
            $CSVImporter->getDirectory($currentpath,'sqlsrv2');
            $currentpath = $path.'\RMCRD';
            $CSVImporter->getDirectory($currentpath,'sqlsrvcdr');

            $processID = "2a36a340-1693-11e5-aedc-759f5f6fbd4e";
            DB::connection('sqlsrvcdr')->statement("CALL prc_insertCDR('" . $processID . "')");
            $this->CronJobs($CompanyID);
            $this->updations($CompanyID);

        } catch (\Exception $e) {
            Log::error($e->getMessage());
        }

        CronHelper::after_cronrun($this);

    }

    public function getRelations(){
        $relation['tblAccount'][0] = array('table'=>'tblAccount','field'=>'CodeDeckId','referencetable'=>'tblCodeDeck','referencefield'=>'CodeDeckName','select'=>'CodeDeckId','connection'=>'sqlsrv');
        $relation['tblAccount'][1] = array('table'=>'tblAccount','field'=>'Owner','referencetable'=>'tblUser','referencefield'=>'EmailAddress','select'=>'UserID','connection'=>'sqlsrv');
        $relation['tblAccount'][2] = array('table'=>'tblAccount','field'=>'CurrencyId','referencetable'=>'tblCurrency','referencefield'=>'Code','select'=>'CurrencyId','connection'=>'sqlsrv');
        $relation['tblAccount'][3] = array('table'=>'tblAccount','field'=>'TaxRateId','referencetable'=>'tblTaxRate','referencefield'=>'Title','select'=>'TaxRateId','connection'=>'sqlsrv');

        $relation['tblAccountApprovalList'][0] = array('table'=>'tblAccountApprovalList','field'=>'AccountApprovalID','referencetable'=>'tblAccountApproval','referencefield'=>'[Key]','select'=>'AccountApprovalID','connection'=>'sqlsrv');
        $relation['tblAccountApprovalList'][1] = array('table'=>'tblAccountApprovalList','field'=>'AccountID','referencetable'=>'tblAccount','referencefield'=>'AccountName','select'=>'AccountID','connection'=>'sqlsrv');

        $relation['tblContact'][0] = array('table'=>'tblContact','field'=>'Owner','referencetable'=>'tblAccount','referencefield'=>'AccountName','select'=>'AccountID','connection'=>'sqlsrv');
        $relation['tblRate'][0] = array('table'=>'tblRate','field'=>'CodeDeckId','referencetable'=>'tblCodeDeck','referencefield'=>'CodeDeckName','select'=>'CodeDeckId','connection'=>'sqlsrv');

        $relation['tblRateGenerator'][0] = array('table'=>'tblRateGenerator','field'=>'CodeDeckId','referencetable'=>'tblCodeDeck','referencefield'=>'CodeDeckName','select'=>'CodeDeckId','connection'=>'sqlsrv');
        $relation['tblRateGenerator'][1] = array('table'=>'tblRateGenerator','field'=>'TrunkID','referencetable'=>'tblTrunk','referencefield'=>'Trunk','select'=>'TrunkID','connection'=>'sqlsrv');

        $relation['tblCustomerTrunk'][0] = array('table'=>'tblCustomerTrunk','field'=>'CodeDeckId','referencetable'=>'tblCodeDeck','referencefield'=>'CodeDeckName','select'=>'CodeDeckId','connection'=>'sqlsrv');
        $relation['tblCustomerTrunk'][1] = array('table'=>'tblCustomerTrunk','field'=>'TrunkID','referencetable'=>'tblTrunk','referencefield'=>'Trunk','select'=>'TrunkID','connection'=>'sqlsrv');
        $relation['tblCustomerTrunk'][2] = array('table'=>'tblCustomerTrunk','field'=>'AccountID','referencetable'=>'tblAccount','referencefield'=>'AccountName','select'=>'AccountID','connection'=>'sqlsrv');

        $relation['tblVendorTrunk'][0] = array('table'=>'tblVendorTrunk','field'=>'CodeDeckId','referencetable'=>'tblCodeDeck','referencefield'=>'CodeDeckName','select'=>'CodeDeckId','connection'=>'sqlsrv');
        $relation['tblVendorTrunk'][1] = array('table'=>'tblVendorTrunk','field'=>'TrunkID','referencetable'=>'tblTrunk','referencefield'=>'Trunk','select'=>'TrunkID','connection'=>'sqlsrv');
        $relation['tblVendorTrunk'][2] = array('table'=>'tblVendorTrunk','field'=>'AccountID','referencetable'=>'tblAccount','referencefield'=>'AccountName','select'=>'AccountID','connection'=>'sqlsrv');

        $relation['tblCustomerRate'][0] = array('table'=>'tblCustomerRate','field'=>'RateID','referencetable'=>'tblRate','referencefield'=>'Code','select'=>'RateID','connection'=>'sqlsrv');
        $relation['tblCustomerRate'][1] = array('table'=>'tblCustomerRate','field'=>'CustomerID','referencetable'=>'tblAccount','referencefield'=>'AccountName','select'=>'AccountID','connection'=>'sqlsrv');
        $relation['tblCustomerRate'][2] = array('table'=>'tblCustomerRate','field'=>'TrunkID','referencetable'=>'tblTrunk','referencefield'=>'Trunk','select'=>'TrunkID','connection'=>'sqlsrv');

        $relation['tblVendorRate'][0] = array('table'=>'tblVendorRate','field'=>'RateID','referencetable'=>'tblRate','referencefield'=>'Code','select'=>'RateID','connection'=>'sqlsrv');
        $relation['tblVendorRate'][1] = array('table'=>'tblVendorRate','field'=>'AccountID','referencetable'=>'tblAccount','referencefield'=>'AccountName','select'=>'AccountID','connection'=>'sqlsrv');
        $relation['tblVendorRate'][2] = array('table'=>'tblVendorRate','field'=>'TrunkID','referencetable'=>'tblTrunk','referencefield'=>'Trunk','select'=>'TrunkID','connection'=>'sqlsrv');
        $relation['tblVendorRate'][3] = array('table'=>'tblVendorRate','field'=>'companygatewayids','referencetable'=>'tblCompanyGateway','referencefield'=>'Title','select'=>'CompanyGatewayID','connection'=>'sqlsrv');

        $relation['tblCronJobCommand'][1] = array('table'=>'tblCronJobCommand','field'=>'GatewayID','referencetable'=>'tblCompanyGateway','referencefield'=>'Title','select'=>'CompanyGatewayID','connection'=>'sqlsrv');

        $relation['tblInvoice'][0] = array('table'=>'tblInvoice','field'=>'AccountID','referencetable'=>'tblAccount','referencefield'=>'AccountName','select'=>'AccountID','connection'=>'sqlsrv');
        $relation['tblInvoiceDetail'][0] = array('table'=>'tblInvoiceDetail','field'=>'InvoiceID','referencetable'=>'tblInvoice','referencefield'=>'InvoiceNumber','select'=>'InvoiceID','connection'=>'sqlsrv2');
        $relation['tblInvoiceDetail'][1] = array('table'=>'tblInvoiceDetail','field'=>'SubscriptionID','referencetable'=>'tblBillingSubscription','referencefield'=>'Name','select'=>'SubscriptionID','connection'=>'sqlsrv2');
        $relation['tblPayment'][0] = array('table'=>'tblPayment','field'=>'AccountID','referencetable'=>'tblAccount','referencefield'=>'AccountName','select'=>'AccountID','connection'=>'sqlsrv');

        $relation['tblUsageHourly'][0] = array('table'=>'tblUsageHourly','field'=>'CompanyGatewayID','referencetable'=>'tblCompanyGateway','referencefield'=>'Title','select'=>'CompanyGatewayID','connection'=>'sqlsrv');
        $relation['tblUsageHourly'][1] = array('table'=>'tblUsageHourly','field'=>'AccountID','referencetable'=>'tblAccount','referencefield'=>'AccountName','select'=>'AccountID','connection'=>'sqlsrv');
        $relation['tblUsageHourly'][2] = array('table'=>'tblUsageHourly','field'=>'Trunk','referencetable'=>'tblTrunk','referencefield'=>'Trunk','select'=>'TrunkID','connection'=>'sqlsrv');

        $relation['tblRateTable'][0] = array('table'=>'tblRateTable','field'=>'CodeDeckId','referencetable'=>'tblCodeDeck','referencefield'=>'CodeDeckName','select'=>'CodeDeckId','connection'=>'sqlsrv');
        $relation['tblRateTable'][1] = array('table'=>'tblRateTable','field'=>'TrunkID','referencetable'=>'tblTrunk','referencefield'=>'Trunk','select'=>'TrunkID','connection'=>'sqlsrv');
        $relation['tblRateTable'][2] = array('table'=>'tblRateTable','field'=>'rategeneratorid','referencetable'=>'tblRateGenerator','referencefield'=>'RateGeneratorName','select'=>'RateGeneratorId','connection'=>'sqlsrv');

        $relation['tblRateTableRate'][0] = array('table'=>'tblRateTableRate','field'=>'RateTableId','referencetable'=>'tblRateTable','referencefield'=>'RateTableName','select'=>'RateTableId','connection'=>'sqlsrv');
        $relation['tblRateTableRate'][1] = array('table'=>'tblRateTableRate','field'=>'RateID','referencetable'=>'tblRate','referencefield'=>'Code','select'=>'RateID','connection'=>'sqlsrv');

        $relation['tblGatewayAccount'][0] = array('table'=>'tblGatewayAccount','field'=>'CompanyGatewayID','referencetable'=>'tblCompanyGateway','referencefield'=>'Title','select'=>'CompanyGatewayID','connection'=>'sqlsrv');
        $relation['tblGatewayAccount'][1] = array('table'=>'tblGatewayAccount','field'=>'AccountID','referencetable'=>'tblAccount','referencefield'=>'AccountName','select'=>'AccountID','connection'=>'sqlsrv');

        $relation['tblBillingSubscription'][0] = array('table'=>'tblBillingSubscription','field'=>'CurrencyID','referencetable'=>'tblCurrency','referencefield'=>'Code','select'=>'CurrencyId','connection'=>'sqlsrv');

        $relation['tblTempUsageDetail'][0] = array('table'=>'tblTempUsageDetail','field'=>'CompanyGatewayID','referencetable'=>'tblCompanyGateway','referencefield'=>'Title','select'=>'CompanyGatewayID','connection'=>'sqlsrv');
        $relation['tblTempUsageDetail'][1] = array('table'=>'tblTempUsageDetail','field'=>'AccountID','referencetable'=>'tblAccount','referencefield'=>'AccountName','select'=>'AccountID','connection'=>'sqlsrv');

        $relation['tblAccountSubscription'][0] = array('table'=>'tblAccountSubscription','field'=>'AccountID','referencetable'=>'tblAccount','referencefield'=>'AccountName','select'=>'AccountID','connection'=>'sqlsrv');
        $relation['tblAccountSubscription'][1] = array('table'=>'tblAccountSubscription','field'=>'SubscriptionID','referencetable'=>'tblBillingSubscription','referencefield'=>'Name','select'=>'SubscriptionID','connection'=>'sqlsrv2');

        return $relation;
    }

    public function CronJobs($CompanyID){

        $sql = "insert into tblCronJobCommand (CompanyID,GatewayID,Title,Command,Settings,Status,created_at,created_by)";
        $sql .= " values(".$CompanyID.",3,'Download VOS  CDR','vosaccountusage','";
        $sql .= '[[{"title":"Job Time","type":"select","value":{"":"Select run time","HOUR":"Hourly","MINUTE":"Minute"},"name":"JobTime"},{"title":"Job Interval","type":"select","value":{},"name":"JobInterval"},{"title":"Job Day","type":"select","placeholder":"Select day","value":{"SUN":"Sunday","MON":"Monday","TUE":"Tuesday","WED":"Wednesday","THU":"Thursday","FRI":"Friday","SAT":"Saturday"},"name":"JobDay","multiple":"multiple"},{"title":"Job Start Time","type":"text","value":"","name":"JobStartTime","timepicker":"timepicker"}]]';
        $sql .= "',1,GETDATE(),'RateManagementSystem')";
        DB::connection('sqlsrv')->statement($sql);
        $sql = "insert into tblCronJob (CompanyID,CronJobCommandID,JobTitle,Settings,Status,created_at,created_by,Active)";
        $sql .= " values(".$CompanyID.",".DB::getPdo()->lastInsertId().",'Download VOS  CDR','";
        $sql .= '{"JobTime":"HOUR","JobInterval":"1","JobDay":["MON","TUE","WED"],"JobStartTime":"12:00:00 AM"}';
        $sql .= "',0,GETDATE(),'RateManagementSystem',0)";
        DB::connection('sqlsrv')->statement($sql);

        $sql = "insert into tblCronJobCommand (CompanyID,GatewayID,Title,Command,Settings,Status,created_at,created_by)";
        $sql .= " values(".$CompanyID.",2,'Download Porta CDR','portaaccountusage','";
        $sql .= '[[{"title":"Job Time","type":"select","value":{"":"Select run time","MINUTE":"Minute","HOUR":"Hourly","DAILY":"Daily"},"name":"JobTime"},{"title":"Job Interval","type":"select","value":{},"name":"JobInterval"},{"title":"Job Day","type":"select","placeholder":"Select day","value":{"SUN":"Sunday","MON":"Monday","TUE":"Tuesday","WED":"Wednesday","THU":"Thursday","FRI":"Friday","SAT":"Saturday"},"name":"JobDay","multiple":"multiple"},{"title":"Job Start Time","type":"text","value":"","name":"JobStartTime","timepicker":"timepicker"},{"title":"Porta Max Interval","type":"text","value":"","name":"MaxInterval"}]]';
        $sql .= "',1,GETDATE(),'RateManagementSystem')";
        DB::connection('sqlsrv')->statement($sql);
        $sql = "insert into tblCronJob (CompanyID,CronJobCommandID,JobTitle,Settings,Status,created_at,created_by,Active)";
        $sql .= " values(".$CompanyID.",".DB::getPdo()->lastInsertId().",'Download Porta CDR','";
        $sql .= '{"JobTime":"MINUTE","JobInterval":"20","JobDay":["THU","FRI","SAT"],"JobStartTime":"12:00:00 AM","MaxInterval":"1440"}';
        $sql .= "',0,GETDATE(),'RateManagementSystem',0)";
        DB::connection('sqlsrv')->statement($sql);

        $sql = "insert into tblCronJobCommand (CompanyID,GatewayID,Title,Command,Settings,Status,created_at,created_by)";
        $sql .= " values(".$CompanyID.",1,'Download Sippy CDR','sippyaccountusage','";
        $sql .= '[[{"title":"Job Time","type":"select","value":{"":"Select run time","HOUR":"Hourly","MINUTE":"Minute"},"name":"JobTime"},{"title":"Job Interval","type":"select","value":{},"name":"JobInterval"},{"title":"Job Day","type":"select","placeholder":"Select day","value":{"SUN":"Sunday","MON":"Monday","TUE":"Tuesday","WED":"Wednesday","THU":"Thursday","FRI":"Friday","SAT":"Saturday"},"name":"JobDay","multiple":"multiple"},{"title":"Job Start Time","type":"text","value":"","name":"JobStartTime","timepicker":"timepicker"},{"title":"Sippy Max Interval","type":"text","value":"","name":"MaxInterval"}]]';
        $sql .= "',1,GETDATE(),'RateManagementSystem')";
        DB::connection('sqlsrv')->statement($sql);
        $sql = "insert into tblCronJob (CompanyID,CronJobCommandID,JobTitle,Settings,Status,created_at,created_by,Active)";
        $sql .= " values(".$CompanyID.",".DB::getPdo()->lastInsertId().",'Download Sippy CDR','";
        $sql .= '{"JobTime":"HOUR","JobInterval":"2","JobDay":["SUN"],"JobStartTime":"12:00:00 AM","MaxInterval":"130"}';
        $sql .= "',0,GETDATE(),'RateManagementSystem',0)";
        DB::connection('sqlsrv')->statement($sql);

        $sql = "insert into tblCronJobCommand (CompanyID,GatewayID,Title,Command,Settings,Status,created_at,created_by)";
        $sql .= " values(".$CompanyID.",NULL,'Rate Generator','rategenerator','";
        $sql .= '[[{"title":"Job Day","type":"select","placeholder":"Select day","value":{"SUN":"Sunday","MON":"Monday","TUE":"Tuesday","WED":"Wednesday","THU":"Thursday","FRI":"Friday","SAT":"Saturday"},"name":"JobDay"},{"title":"Effective Day","type":"text","value":"","name":"EffectiveDay"},{"title":"Job Start Time","type":"text","value":"","name":"JobStartTime","timepicker":"timepicker"}]]';
        $sql .= "',1,GETDATE(),'RateManagementSystem')";
        DB::connection('sqlsrv')->statement($sql);
    }

    public function updations($CompanyID){
        $select = "select InvoiceTemplateID from tblInvoiceTemplate where Name='DemoInvoiceTemplate' and CompanyId=".$CompanyID;

        $result = DB::connection('sqlsrv2')->getPdo()->query($select);
        $firstResult = $result->fetch(\PDO::FETCH_ASSOC);
        $InvoiceTemplateID = $firstResult['InvoiceTemplateID'];

        $select = "select CurrencyId from tblCurrency where Code='USD' and CompanyId=".$CompanyID;

        $result = DB::connection('sqlsrv')->getPdo()->query($select);
        $firstResult = $result->fetch(\PDO::FETCH_ASSOC);
        $CurrencyId = $firstResult['CurrencyId'];

        $sql = "update tblCompanySetting set Value='".$InvoiceTemplateID."' where [Key]='InvoiceTemplateID' and CompanyId=".$CompanyID;
        DB::connection('sqlsrv')->statement($sql);
        $sql = "update tblCompany set CustomerAccountPrefix = 2222, Country = 'UNITED KINGDOM', DueSheetEmail = 'deven@code-desk.com,girish.vadher@code-desk.com', TimeZone = 'Europe/London', CurrencyId = ".$CurrencyId.", PaymentRequestEmail = 'deven@code-desk.com,girish.vadher@code-desk.com'  where CompanyID=".$CompanyID;
        DB::connection('sqlsrv')->statement($sql);
        $sql = "update tblAccount set InvoiceTemplateID=".$InvoiceTemplateID." where CompanyId=".$CompanyID;
        DB::connection('sqlsrv')->statement($sql);
    }
    public function deleteOld($CompanyID){
        $accountdb = Config::get('database.connections.sqlsrv.database');

        $duplicatedeletequey = "
        delete from tblProduct where CompanyId =$CompanyID
        delete from tblInvoiceTemplate where CompanyId =$CompanyID
        delete from tblBillingSubscription where CompanyId =$CompanyID
        delete from tblAccountSubscription where AccountID in (select AccountID from $accountdb.dbo.tblAccount where CompanyId =$CompanyID)
        delete from tblInvoiceDetail where InvoiceID in (select InvoiceID from tblInvoice where CompanyId =$CompanyID)
        delete from tblInvoice where CompanyId =$CompanyID
        delete from tblPayment where CompanyId =$CompanyID
        delete from tblGatewayAccount where CompanyId =$CompanyID
        ";
        DB::connection('sqlsrv2')->statement($duplicatedeletequey);

        $duplicatedeletequey = "
        delete from tblUsageHeader where CompanyId =$CompanyID
        delete from tblUsageDetails where UsageHeaderID in (select UsageHeaderID from tblUsageHeader where CompanyId =$CompanyID)
        ";
        DB::connection('sqlsrvcdr')->statement($duplicatedeletequey);

        $duplicatedeletequey = "
        delete from tblCodeDeck where CompanyId =$CompanyID
        delete from tblTrunk where CompanyId =$CompanyID
        delete from tblTaxRate where CompanyId =$CompanyID
        delete from tblRateGenerator where CompanyId =$CompanyID
        delete from tblCurrency where CompanyId =$CompanyID
        delete from tblUser where CompanyId =$CompanyID
        delete from tblAccount where CompanyId =$CompanyID
        delete from tblCompanyGateway where CompanyId =$CompanyID
        delete from tblContact where CompanyId =$CompanyID
        delete from tblCustomerTrunk where CompanyId =$CompanyID
        delete from tblCustomerRate where CustomerID in (select AccountID from tblAccount where CompanyId =$CompanyID)
        delete from tblVendorTrunk where CompanyId =$CompanyID
        delete from tblCompanySetting where CompanyId =$CompanyID
        delete from tblRateTableRate where RateTableId in (select RateTableId from tblRateTable where CompanyId =$CompanyID)
        delete from tblRateTable where CompanyId =$CompanyID
        delete from tblRate where CompanyId =$CompanyID
        delete from tblCronJobCommand where CompanyId =$CompanyID
        delete from tblCronJob where CompanyId =$CompanyID
        ";
        DB::connection('sqlsrv')->statement($duplicatedeletequey);


    }
}