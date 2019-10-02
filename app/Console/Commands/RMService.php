<?php namespace App\Console\Commands;

use App\Lib\CompanyConfiguration;
use App\Lib\CronHelper;
use App\Lib\DataTableSql;
use App\Lib\Nodes;
use App\Lib\User;
use Illuminate\Console\Command;
use App\Lib\CronJob;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Queue;
use Symfony\Component\Console\Input\InputArgument;

class RMService extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'rmservice';

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
    public function handle()
    {
        try {

            CronHelper::before_cronrun($this->name, $this );

            $arguments = $this->argument();
            $CompanyID = $arguments["CompanyID"];
            $PHP_EXE_PATH = CompanyConfiguration::get($CompanyID,'PHP_EXE_PATH');
            $RMArtisanFileLocation = CompanyConfiguration::get($CompanyID,'RM_ARTISAN_FILE_LOCATION');
            $query = "CALL prc_CronJobAllPending ( $CompanyID )";
            $allpending = DataTableSql::of($query)->getProcResult(array(
                'PendingUploadCDR',
                'PendingInvoiceGenerate',
                'PendingPortaSheet',
                'getActiveCronCommand',
                //'getVosDownloadCommand',
                'PendingBulkMailSend',
                'PortVendorSheet',
                'CDRRecalculate',
                'VendorCDRRecalculate',
                'PendingInvoiceUsageFileGeneration',
                'PendingCustomerRateSheet',
                'InvoiceRegenerate',
                'BulkLeadEmail',
                'BulkAccountEmail',
                'PendingVendorUpload',
                'PendingCodeDeckUpload',
                'PendingImportTranslations',
                'InvoiceReminder',
                'CustomerSippySheetDownload',
                'VendorSippySheetDownload',
                'CustomerVOSSheetDownload',
                'VendorVOSSheetDownload',
                'RateTableGeneration',
                'RateTableFileUpload',
                'RateTableDIDFileUpload',
                'RateTablePKGFileUpload',
                'VendorCDRUpload',
                //'getSippyDownloadCommand',
				'ImportAccount',
                'DialStringUpload',
                'QuickBookInvoicePost',
                'ImportAccountIP',
                'ItemUpload',
                'CustomerMorSheetDownload',
                'VendorMorSheetDownload',
                'XeroInvoicePost',
                'CustomerM2SheetDownload',
                'VendorM2SheetDownload',
                'QuickBookPaymentsPost',
                'PendingDisputeBulkMailSend',
                'DisputeBulkMail',
                'PendingBulkCreditNoteSend'
            ));

            /*$cmdarray = $allpending['data']['getVosDownloadCommand'];
            foreach ($cmdarray as $com) {
                if (isset($com->CronJobID) && $com->CronJobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHPExePath." ".$RMArtisanFileLocation." ".$com->Command." ". $CompanyID." ".$com->CronJobID . " &","r"));
                    }else{
                        pclose(popen("start /B ". $PHPExePath." ".$RMArtisanFileLocation." ".$com->Command." ". $CompanyID." ".$com->CronJobID, "r"));
                    }

                }
            }*/
            foreach($allpending['data']['PendingUploadCDR'] as $pedingcdrrow){
                if (isset($pedingcdrrow->JobID) && $pedingcdrrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." cdrupload " . $CompanyID . " " . $pedingcdrrow->JobID . " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " cdrupload " . $CompanyID . " " . $pedingcdrrow->JobID . " ", "r"));
                    }
                }
            }
            foreach($allpending['data']['PendingInvoiceGenerate'] as $pedinginvoicerow){
                if (isset($pedinginvoicerow->JobID) && $pedinginvoicerow->JobID>0) {
                    $Options = json_decode($pedinginvoicerow->Options);
                    $CronJobID = $Options->CronJobID;
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." invoicegenerator " . $CompanyID . " $CronJobID " . $pedinginvoicerow->JobLoggedUserID . " $pedinginvoicerow->JobID &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " invoicegenerator " . $CompanyID . " $CronJobID " . $pedinginvoicerow->JobLoggedUserID . " $pedinginvoicerow->JobID ", "r"));
                    }
                }
            }
            foreach($allpending['data']['PendingPortaSheet'] as $pedingportarow){
                if (isset($pedingportarow->JobID) && $pedingportarow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." customerportasheet " . $CompanyID . " " . $pedingportarow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " customerportasheet " . $CompanyID . " " . $pedingportarow->JobID . " ", "r"));
                    }
                }
            }
            foreach($allpending['data']['PendingBulkMailSend'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." bulkinvoicesend " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " bulkinvoicesend " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }
            foreach($allpending['data']['PendingBulkCreditNoteSend'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." bulkcreditnotesend " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " bulkcreditnotesend " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }
            foreach($allpending['data']['PortVendorSheet'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." portavendorsheet " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " portavendorsheet " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }
            foreach($allpending['data']['CDRRecalculate'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." cdrrecal " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " cdrrecal " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }
            foreach($allpending['data']['VendorCDRRecalculate'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." vendorcdrrecal " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " vendorcdrrecal " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }
            foreach($allpending['data']['InvoiceRegenerate'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." regenerateinvoice " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " regenerateinvoice " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }
            foreach($allpending['data']['PendingVendorUpload'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." vendorfileupload " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " vendorfileupload " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }
            foreach($allpending['data']['PendingCodeDeckUpload'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." codedecksupload " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " codedecksupload " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }
            foreach($allpending['data']['PendingImportTranslations'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." translationimport " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " translationimport " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }

            foreach($allpending['data']['InvoiceReminder'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." invoicereminder " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " invoicereminder " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }
            foreach($allpending['data']['PendingInvoiceUsageFileGeneration'] as $pendinginvoiceusagefilerow){
                if (isset($pendinginvoiceusagefilerow->JobID) && $pendinginvoiceusagefilerow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." invoiceusagefilegenerator " . $CompanyID . " " . $pendinginvoiceusagefilerow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " invoiceusagefilegenerator " . $CompanyID . " " . $pendinginvoiceusagefilerow->JobID . " ", "r"));
                    }
                }
            }
            foreach($allpending['data']['BulkLeadEmail'] as $bulkleademail){
                if (isset($bulkleademail->JobID) && $bulkleademail->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." bulkleademailsend " . $CompanyID . " " . $bulkleademail->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " bulkleademailsend " . $CompanyID . " " . $bulkleademail->JobID . " ", "r"));
                    }
                }
            }
            foreach($allpending['data']['BulkAccountEmail'] as $bulkaccountemail){
                if (isset($bulkaccountemail->JobID) && $bulkaccountemail->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." bulkleademailsend " . $CompanyID . " " . $bulkaccountemail->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " bulkleademailsend " . $CompanyID . " " . $bulkaccountemail->JobID . " ", "r"));
                    }
                }
            }

            foreach($allpending['data']['CustomerSippySheetDownload'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." customersippysheetgeneration " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " customersippysheetgeneration " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }

            foreach($allpending['data']['VendorSippySheetDownload'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." vendorsippysheetgeneration " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " vendorsippysheetgeneration " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }

            foreach($allpending['data']['CustomerVOSSheetDownload'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." customervossheetgeneration " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " customervossheetgeneration " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }

            foreach($allpending['data']['VendorVOSSheetDownload'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." vendorvossheetgeneration " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " vendorvossheetgeneration " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }

            foreach($allpending['data']['RateTableGeneration'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." ratetablegenerator " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " ratetablegenerator " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }

            foreach($allpending['data']['RateTableFileUpload'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." ratetablefileupload " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " ratetablefileupload " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }

            foreach($allpending['data']['RateTableDIDFileUpload'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." ratetabledidfileupload " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " ratetabledidfileupload " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }

            foreach($allpending['data']['RateTablePKGFileUpload'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." ratetablepkgfileupload " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " ratetablepkgfileupload " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }

            foreach($allpending['data']['VendorCDRUpload'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." vcdrupload " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " vcdrupload " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }

            /* Sippy CDR File download */
            /*$cmdarray = $allpending['data']['getSippyDownloadCommand'];
            foreach ($cmdarray as $com) {
                if (isset($com->CronJobID) && $com->CronJobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHPExePath." ".$RMArtisanFileLocation." ".$com->Command." ". $CompanyID." ".$com->CronJobID . " &","r"));
                    }else{
                        pclose(popen("start /B ". $PHPExePath." ".$RMArtisanFileLocation." ".$com->Command." ". $CompanyID." ".$com->CronJobID, "r"));
                    }

                }
            }*/
			
			//import account by csv or manually,import leads
            foreach($allpending['data']['ImportAccount'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." importaccount " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " importaccount " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }

			//dialstring upload
            foreach($allpending['data']['DialStringUpload'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." dialstringupload " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " dialstringupload " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }

            //Quickbook Invoice Post
            foreach($allpending['data']['QuickBookInvoicePost'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." quickbookinvoicepost " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " quickbookinvoicepost " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }
            //Account Import IPs
            foreach($allpending['data']['ImportAccountIP'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." importaccountip " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " importaccountip " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }
            //Item Upload
            foreach($allpending['data']['ItemUpload'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." itemupload " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " itemupload " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }
            //Customer Mor RateSheet Download
            foreach($allpending['data']['CustomerMorSheetDownload'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." customermorsheet " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " customermorsheet " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }
            //Vendor Mor RateSheet Download
            foreach($allpending['data']['VendorMorSheetDownload'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." vendormorsheet " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " vendormorsheet " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }

            //Xero Invoice Post
            foreach($allpending['data']['XeroInvoicePost'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." xeroinvoicepost " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " xeroinvoicepost " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }

            //Customer M2 RateSheet Download
            foreach($allpending['data']['CustomerM2SheetDownload'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." customerm2sheetgeneration " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " customerm2sheetgeneration " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }
            //Vendor M2 RateSheet Download
            foreach($allpending['data']['VendorM2SheetDownload'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." vendorm2sheetgeneration " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " vendorm2sheetgeneration " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }

            //------------------------ Cron job start here------------------------//
          
            $cmdarray  = $allpending['data']['getActiveCronCommand'];//CronJob::getActiveCronCommand($CompanyID. " &","r"));
            foreach ($cmdarray as $com) {
                if (CronJob::checkStatus($com->CronJobID,$com->Command)) {
                    if(Nodes::GetActiveNodeFromCronjobNodes($com->CronJobID,$CompanyID)){
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation. " " . $com->Command . " " . $CompanyID . " " . $com->CronJobID . " ". " &","r"));
                    }
                }
            }
            foreach($allpending['data']['PendingCustomerRateSheet'] as $allpendingrs){
                if (isset($allpendingrs->JobID) && $allpendingrs->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." customerratesheet " . $CompanyID . " " . $allpendingrs->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " customerratesheet " . $CompanyID . " " . $allpendingrs->JobID . " ", "r"));
                    }
                }
            }
            //Quickbook Payments Post
            foreach($allpending['data']['QuickBookPaymentsPost'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." quickbookpaymentspost " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " quickbookpaymentspost " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }

            //dispute send
            foreach($allpending['data']['PendingDisputeBulkMailSend'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." bulkdisputesend " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " bulkdisputesend " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }

            //dispute BulkMail
            foreach($allpending['data']['DisputeBulkMail'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen($PHP_EXE_PATH." ".$RMArtisanFileLocation." disputebulkemail " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " disputebulkemail " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }


        }catch(\Exception $e){
            Log::error($e);
        }


        CronHelper::after_cronrun($this->name, $this);

    }

    /**
     * Get the console command arguments.
     *
     * @return array
     */
    protected function getArguments()
    {
        return [
            ['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID '],
        ];
    }



}

