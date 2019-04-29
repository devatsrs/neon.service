<?php
/**
 * Created by PhpStorm.
 * User: srs2
 * Date: 25/05/2015
 * Time: 06:58
 */
//if you change anything in this file then you need to change also in VendorRateUpload,RateTableRateUpload in service and RateUploadController.php->ReviewRates() in web

namespace App\Console\Commands;

use App\Lib\AmazonS3;
use App\Lib\CompanyConfiguration;
use App\Lib\CompanySetting;
use App\Lib\CompanyGateway;
use App\Lib\CronHelper;
use App\Lib\Job;
use App\Lib\JobFile;
use App\Lib\NeonExcelIO;
use App\Lib\RateTable;
use App\Lib\ServiceTemplate;
use App\Lib\TempRateTableDIDRate;
use App\Lib\FileUploadTemplate;
use App\Lib\Timezones;
use App\Lib\Currency;
use Exception;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;

class RateTableDIDRateUpload extends Command
{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'ratetabledidfileupload';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Rate table DID file upload.';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }

    protected function getArguments()
    {
        return [
            ['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID '],
            ['JobID', InputArgument::REQUIRED, 'Argument JobID'],
        ];
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function fire()
    {
        CronHelper::before_cronrun($this->name, $this );

        $arguments = $this->argument();
        $getmypid = getmypid(); // get proccess id added by abubakar
        $JobID = $arguments["JobID"];
        $job = Job::find($JobID);
        $p_UserName = $job->CreatedBy;
        $ProcessID = CompanyGateway::getProcessID();
        Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Change by abubakar
        $CompanyID = $arguments["CompanyID"];
        $bacth_insert_limit = 250;
        $counter = 0;
        $DialStringId = 0;
        $dialcode_separator = 'null';
        Log::useFiles(storage_path() . '/logs/ratetabledidfileupload-' .  $JobID. '-' . date('Y-m-d') . '.log');
        $TEMP_PATH = CompanyConfiguration::get($CompanyID,'TEMP_PATH').'/';
        $error = array();
        try {

            if (!empty($job)) {
                $jobfile = JobFile::where(['JobID' => $JobID])->first();
                $joboptions = json_decode($jobfile->Options);
                if (count($joboptions) > 0) {
                    $rateTable = RateTable::find($joboptions->RateTableID);

                    if(isset($joboptions->uploadtemplate) && !empty($joboptions->uploadtemplate)){
                        $uploadtemplate = FileUploadTemplate::find($joboptions->uploadtemplate);
                        $templateoptions = json_decode($uploadtemplate->Options);
                    }else{
                        $templateoptions = json_decode($joboptions->Options);
                    }
                    $csvoption = $templateoptions->option;
                    $attrselection = $templateoptions->selection;
                    if(!empty($templateoptions->importdialcodessheet)) {
                        $attrselection2 = $templateoptions->selection2;
                    }

                    // check dialstring mapping or not
                    if (isset($attrselection->DialString) && !empty($attrselection->DialString)) {
                        $DialStringId = $attrselection->DialString;
                    } else {
                        $DialStringId = 0;
                    }

                    if (isset($attrselection->DialCodeSeparator)) {
                        if ($attrselection->DialCodeSeparator == '') {
                            $dialcode_separator = 'null';
                        } else {
                            $dialcode_separator = $attrselection->DialCodeSeparator;
                        }
                    }
                    if(isset($attrselection2->DialCodeSeparator)){
                        if($attrselection2->DialCodeSeparator == ''){
                            $dialcode_separator = $dialcode_separator == 'null' ? 'null' : $dialcode_separator;
                        }else{
                            $dialcode_separator = $attrselection2->DialCodeSeparator;
                        }
                    }
                    $seperatecolumn = 2;
                    if(isset($attrselection->OriginationDialCodeSeparator)){
                        if($attrselection->OriginationDialCodeSeparator == ''){
                            $dialcode_separator = $dialcode_separator == 'null' ? 'null' : $dialcode_separator;
                        }else{
                            $dialcode_separator = $attrselection->OriginationDialCodeSeparator;
                            $seperatecolumn = 1;
                        }
                    }
                    if(isset($attrselection2->OriginationDialCodeSeparator)){
                        if($attrselection2->OriginationDialCodeSeparator == ''){
                            $dialcode_separator = $dialcode_separator == 'null' ? 'null' : $dialcode_separator;
                        }else{
                            $dialcode_separator = $attrselection2->OriginationDialCodeSeparator;
                            $seperatecolumn = 1;
                        }
                    }

                    if (isset($attrselection->FromCurrency) && !empty($attrselection->FromCurrency)) {
                        $CurrencyConversion = 1;
                        $CurrencyID = $attrselection->FromCurrency;
                    } else {
                        $CurrencyConversion = 0;
                        $CurrencyID = 0;
                    }

                    if (empty($joboptions->ProcessID)) {
                        if ($jobfile->FilePath) {
                            $path = AmazonS3::unSignedUrl($jobfile->FilePath, $CompanyID);
                            if (strpos($path, "https://") !== false) {
                                $file = $TEMP_PATH . basename($path);
                                file_put_contents($file, file_get_contents($path));
                                $jobfile->FilePath = $file;
                            } else {
                                $jobfile->FilePath = $path;
                            }
                        }

                        $data = json_decode(json_encode($templateoptions), true);
                        $data['start_row'] = $data['skipRows']['start_row'];
                        $data['end_row'] = $data['skipRows']['end_row'];
                        if(!empty($data['importdialcodessheet'])) {
                            $data['start_row_sheet2'] = $data['skipRows_sheet2']['start_row'];
                            $data['end_row_sheet2'] = $data['skipRows_sheet2']['end_row'];
                        }
                        //convert excel to CSV
                        $file_name = $file_name2 = $file_name_with_path = $jobfile->FilePath;
                        //$NeonExcel = new NeonExcelIO($file_name_with_path, $data['option'], $data['importratesheet']);
                        //$file_name = $NeonExcel->convertExcelToCSV($data);

                        if(!empty($data['importdialcodessheet'])) {
                            $data2 = $data;
                            $data2['start_row'] = $data["start_row_sheet2"];
                            $data2['end_row'] = $data["end_row_sheet2"];
                            //$NeonExcelSheet2 = new NeonExcelIO($file_name_with_path, $data2['option'], $data2['importdialcodessheet']);
                            //$file_name2 = $NeonExcelSheet2->convertExcelToCSV($data2);
                        }

                        if(isset($templateoptions->skipRows)) {
                            $skipRows              = $templateoptions->skipRows;

                            if($csvoption->Firstrow == 'columnname'){
                                $lineno                 = intval($skipRows->start_row) + 2;
                            }
                            if($csvoption->Firstrow == 'data'){
                                $lineno                 = intval($skipRows->start_row) + 1;
                            }
                            NeonExcelIO::$start_row = intval($skipRows->start_row);
                            NeonExcelIO::$end_row   = intval($skipRows->end_row);

                        } else if ($csvoption->Firstrow == 'data') {
                            $lineno = 1;
                        } else {
                            $lineno = 2;
                        }

                        $NeonExcel = new NeonExcelIO($file_name, (array) $csvoption, $data['importratesheet']);
                        $ratesheet = $NeonExcel->read();

                        if(!empty($data['importdialcodessheet'])) {
                            $skipRows_sheet2 = $templateoptions->skipRows_sheet2;
                            NeonExcelIO::$start_row = intval($skipRows_sheet2->start_row);
                            NeonExcelIO::$end_row = intval($skipRows_sheet2->end_row);
                            $NeonExcel2 = new NeonExcelIO($file_name2, (array)$csvoption, $data2['importdialcodessheet']);
                            $dialcodessheet = $NeonExcel2->read();
                        }

                        $results = array();
                        // if multisheet rate upload - rate sheet and dialcode sheet are different
                        if(!empty($data['importdialcodessheet'])) {
                            $Join1  = !empty($data["selection"]['Join1']) ? $data["selection"]['Join1'] : '';
                            $Join2  = !empty($data["selection2"]['Join2']) ? $data["selection2"]['Join2'] : '';
                            $Join1O = !empty($data["selection"]['Join1O']) ? $data["selection"]['Join1O'] : '';
                            $Join2O = !empty($data["selection2"]['Join2O']) ? $data["selection2"]['Join2O'] : '';

                            $OCountryCode   = $attrselection2->OriginationCountryCode != $attrselection2->CountryCode ? $attrselection2->OriginationCountryCode : 'OriginationCountryCode';
                            $OCode          = $attrselection2->OriginationCode != $attrselection2->Code ? $attrselection2->OriginationCode : 'OriginationCode';
                            $ODescription   = $attrselection2->OriginationDescription != $attrselection2->Description ? $attrselection2->OriginationDescription : 'OriginationDescription';

                            $i = 0;
                            foreach($ratesheet as $key => $value)
                            {
                                //if description is not blank in ratesheet file then we will match it with dial-code file otherwise record will be skipped
                                if(!empty($value[$Join1])) {
                                    $code_keys = array_keys(array_column($dialcodessheet, $Join2), $value[$Join1]);
                                    foreach ($code_keys as $index => $code_key) {
                                        if (isset($dialcodessheet[$code_key])) {
                                            // if origination code is not mapped, only destination mapped
                                            if (empty($Join1O) || empty($Join2O)) {
                                                $results[$i] = $ratesheet[$key];
                                                $results[$i][$attrselection2->CountryCode]  = !empty($dialcodessheet[$code_key][$attrselection2->CountryCode]) ? $dialcodessheet[$code_key][$attrselection2->CountryCode] : '';
                                                $results[$i][$attrselection2->Code]         = $dialcodessheet[$code_key][$attrselection2->Code];
                                                $results[$i][$attrselection2->Description]  = !empty($dialcodessheet[$code_key][$attrselection2->Description]) ? $dialcodessheet[$code_key][$attrselection2->Description] : '';

                                                $results[$i][$OCountryCode] = NULL;
                                                $results[$i][$OCode]        = NULL;
                                                $results[$i][$ODescription] = NULL;

                                                if (!empty($attrselection2->EffectiveDate)) {
                                                    $results[$i][$attrselection2->EffectiveDate] = $dialcodessheet[$code_key][$attrselection2->EffectiveDate];
                                                }
                                                $i++;
                                            } else { // if both origination and destination are mapped
                                                //if origination description is not blank in ratesheet file then we will match it with dial-code file
                                                // otherwise record will be skipped
                                                if(!empty($value[$Join1O])) {
                                                    $code_keys_o = array_keys(array_column($dialcodessheet, $Join2O), $value[$Join1O]);
                                                    foreach ($code_keys_o as $index_o => $code_key_o) {
                                                        if (isset($dialcodessheet[$code_key_o])) {
                                                            $results[$i] = $ratesheet[$key];
                                                            $results[$i][$attrselection2->CountryCode]  = !empty($dialcodessheet[$code_key][$attrselection2->CountryCode]) ? $dialcodessheet[$code_key][$attrselection2->CountryCode] : '';
                                                            $results[$i][$attrselection2->Code]         = $dialcodessheet[$code_key][$attrselection2->Code];
                                                            $results[$i][$attrselection2->Description]  = !empty($dialcodessheet[$code_key][$attrselection2->Description]) ? $dialcodessheet[$code_key][$attrselection2->Description] : '';

                                                            $results[$i][$OCountryCode] = $dialcodessheet[$code_key_o][$attrselection2->OriginationCountryCode];
                                                            $results[$i][$OCode]        = $dialcodessheet[$code_key_o][$attrselection2->OriginationCode];
                                                            $results[$i][$ODescription] = $dialcodessheet[$code_key_o][$attrselection2->OriginationDescription];

                                                            if (!empty($attrselection2->EffectiveDate)) {
                                                                $results[$i][$attrselection2->EffectiveDate] = $dialcodessheet[$code_key][$attrselection2->EffectiveDate];
                                                            }
                                                        } else {
                                                            $error[] = 'Origination Code not exist against ' . $value[$Join1O] . ' in dialcode sheet';
                                                        }
                                                        $i++;
                                                    }
                                                } else {
                                                    $results[$i] = $ratesheet[$key];
                                                    $results[$i][$attrselection2->CountryCode]  = $dialcodessheet[$code_key][$attrselection2->CountryCode];
                                                    $results[$i][$attrselection2->Code]         = $dialcodessheet[$code_key][$attrselection2->Code];
                                                    $results[$i][$attrselection2->Description]  = $dialcodessheet[$code_key][$attrselection2->Description];

                                                    $results[$i][$OCountryCode] = NULL;
                                                    $results[$i][$OCode]        = NULL;
                                                    $results[$i][$ODescription] = NULL;

                                                    if (!empty($attrselection2->EffectiveDate)) {
                                                        $results[$i][$attrselection2->EffectiveDate] = $dialcodessheet[$code_key][$attrselection2->EffectiveDate];
                                                    }
                                                    $i++;
                                                }
                                            }

                                        } else {
                                            $error[] = 'Destination Code not exist against ' . $value[$Join1] . ' in dialcode sheet';
                                        }
                                    }
                                }
                            }

                            $attrselection2->OriginationCountryCode = $OCountryCode;
                            $attrselection2->OriginationCode        = $OCode;
                            $attrselection2->OriginationDescription = $ODescription;
                        }else{
                            $results = $ratesheet;
                        }

                        // if EndDate is mapped and not empty than data will store in and insert from $batch_insert_array
                        // if EndDate is mapped and     empty than data will store in and insert from $batch_insert_array2
                        $batch_insert_array = $batch_insert_array2 = [];

                        foreach ($attrselection as $key => $value) {
                            $attrselection->$key = str_replace("\r",'',$value);
                            $attrselection->$key = str_replace("\n",'',$attrselection->$key);
                        }
                        if(!empty($data['importdialcodessheet'])) {
                            foreach ($attrselection2 as $key => $value) {
                                $attrselection2->$key = str_replace("\r", '', $value);
                                $attrselection2->$key = str_replace("\n", '', $attrselection2->$key);
                            }
                        }

                        $error = array();

                        $CostComponents = [];
                        $CostComponents[] = 'OneOffCost';
                        $CostComponents[] = 'MonthlyCost';
                        $CostComponents[] = 'CostPerCall';
                        $CostComponents[] = 'CostPerMinute';
                        $CostComponents[] = 'SurchargePerCall';
                        $CostComponents[] = 'SurchargePerMinute';
                        $CostComponents[] = 'OutpaymentPerCall';
                        $CostComponents[] = 'OutpaymentPerMinute';
                        $CostComponents[] = 'Surcharges';
                        $CostComponents[] = 'Chargeback';
                        $CostComponents[] = 'CollectionCostAmount';
                        $CostComponents[] = 'CollectionCostPercentage';
                        $CostComponents[] = 'RegistrationCostPerNumber';

                        $component_currencies   = Currency::getCurrencyDropdownIDList($CompanyID);
                        $CountryPrefix          = ServiceTemplate::getCountryPrefixDD();
                        $AccessTypes            = ServiceTemplate::getAccessTypeDD($CompanyID);
                        $Codes                  = ServiceTemplate::getPrefixDD($CompanyID);
                        $City                   = ServiceTemplate::getCityDD($CompanyID);
                        $Tariff                 = ServiceTemplate::getTariffDD($CompanyID);

                        //get how many rates mapped against timezones
                        $AllTimezones = Timezones::getTimezonesIDList();//all timezones

                        $lineno1 = $lineno;
                        foreach ($AllTimezones as $TimezoneID => $Title) {
                            $id = $TimezoneID == 1 ? '' : $TimezoneID;
                            $OneOffCostColumn                 = 'OneOffCost'.$id;
                            $MonthlyCostColumn                = 'MonthlyCost'.$id;
                            $CostPerCallColumn                = 'CostPerCall'.$id;
                            $CostPerMinuteColumn              = 'CostPerMinute'.$id;
                            $SurchargePerCallColumn           = 'SurchargePerCall'.$id;
                            $SurchargePerMinuteColumn         = 'SurchargePerMinute'.$id;
                            $OutpaymentPerCallColumn          = 'OutpaymentPerCall'.$id;
                            $OutpaymentPerMinuteColumn        = 'OutpaymentPerMinute'.$id;
                            $SurchargesColumn                 = 'Surcharges'.$id;
                            $ChargebackColumn                 = 'Chargeback'.$id;
                            $CollectionCostAmountColumn       = 'CollectionCostAmount'.$id;
                            $CollectionCostPercentageColumn   = 'CollectionCostPercentage'.$id;
                            $RegistrationCostPerNumberColumn  = 'RegistrationCostPerNumber'.$id;

                            $OneOffCostCurrencyColumn                 = 'OneOffCostCurrency'.$id;
                            $MonthlyCostCurrencyColumn                = 'MonthlyCostCurrency'.$id;
                            $CostPerCallCurrencyColumn                = 'CostPerCallCurrency'.$id;
                            $CostPerMinuteCurrencyColumn              = 'CostPerMinuteCurrency'.$id;
                            $SurchargePerCallCurrencyColumn           = 'SurchargePerCallCurrency'.$id;
                            $SurchargePerMinuteCurrencyColumn         = 'SurchargePerMinuteCurrency'.$id;
                            $OutpaymentPerCallCurrencyColumn          = 'OutpaymentPerCallCurrency'.$id;
                            $OutpaymentPerMinuteCurrencyColumn        = 'OutpaymentPerMinuteCurrency'.$id;
                            $SurchargesCurrencyColumn                 = 'SurchargesCurrency'.$id;
                            $ChargebackCurrencyColumn                 = 'ChargebackCurrency'.$id;
                            $CollectionCostAmountCurrencyColumn       = 'CollectionCostAmountCurrency'.$id;
                            $RegistrationCostPerNumberCurrencyColumn  = 'RegistrationCostPerNumberCurrency'.$id;

                            // check if rate is mapped against timezone
                            //if (!empty($attrselection->$MonthlyCostColumn)) {
                                $lineno = $lineno1;

                                foreach ($results as $temp_row) {
                                    if ($csvoption->Firstrow == 'data') {
                                        array_unshift($temp_row, null);
                                        unset($temp_row[0]);
                                    }

                                    /*foreach ($temp_row as $key => $value) {
                                        $key = str_replace("\r", '', $key);
                                        $key = str_replace("\n", '', $key);
                                        $temp_row[$key] = $value;
                                    }*/
                                    $temp_row = filterArrayRemoveNewLines($temp_row);

                                    $tempratetabledata = array();
                                    $tempratetabledata['codedeckid'] = $joboptions->codedeckid;
                                    $tempratetabledata['ProcessId'] = (string)$ProcessID;

                                    //check empty row
                                    $checkemptyrow = array_filter(array_values($temp_row));
                                    if (!empty($checkemptyrow)) {

                                        if (!empty($attrselection->OriginationCountryCode) || !empty($attrselection2->OriginationCountryCode)) {
                                            if (!empty($attrselection->OriginationCountryCode)) {
                                                $selection_CountryCode_Origination = $attrselection->OriginationCountryCode;
                                            } else if (!empty($attrselection2->OriginationCountryCode)) {
                                                $selection_CountryCode_Origination = $attrselection2->OriginationCountryCode;
                                            }

                                            if (array_key_exists($selection_CountryCode_Origination, $CountryPrefix)) {// if Country selected from Neon Database
                                                $tempratetabledata['OriginationCountryCode'] = $selection_CountryCode_Origination;
                                            } else if (!empty($temp_row[$selection_CountryCode_Origination])) {// if Country selected from file
                                                $tempratetabledata['OriginationCountryCode'] = trim($temp_row[$selection_CountryCode_Origination]);
                                            } else {
                                                $tempratetabledata['OriginationCountryCode'] = '';
                                            }
                                        }

                                        if (!empty($attrselection->CountryCode) || !empty($attrselection2->CountryCode)) {
                                            if (!empty($attrselection->CountryCode)) {
                                                $selection_CountryCode = $attrselection->CountryCode;
                                            } else if (!empty($attrselection2->CountryCode)) {
                                                $selection_CountryCode = $attrselection2->CountryCode;
                                            }

                                            if (array_key_exists($selection_CountryCode, $CountryPrefix)) {// if Country selected from Neon Database
                                                $tempratetabledata['CountryCode'] = $selection_CountryCode;
                                            } else if (!empty($temp_row[$selection_CountryCode])) {// if Country selected from file
                                                $tempratetabledata['CountryCode'] = trim($temp_row[$selection_CountryCode]);
                                            } else {
                                                $tempratetabledata['CountryCode'] = '';
                                            }
                                        }

                                        if (!empty($attrselection->OriginationCode) || !empty($attrselection2->OriginationCode)) {
                                            if (!empty($attrselection->OriginationCode)) {
                                                $selection_Code_Origination = $attrselection->OriginationCode;
                                            } else if (!empty($attrselection2->OriginationCode)) {
                                                $selection_Code_Origination = $attrselection2->OriginationCode;
                                            }

                                            if (array_key_exists($selection_Code_Origination, $Codes)) {// if OriginationCode selected from Neon Database
                                                $tempratetabledata['OriginationCode'] = $selection_Code_Origination;
                                            } else if (!empty($temp_row[$selection_Code_Origination])) {// if OriginationCode selected from file
                                                $tempratetabledata['OriginationCode'] = trim($temp_row[$selection_Code_Origination]);
                                            } else {
                                                $tempratetabledata['OriginationCode'] = '';
                                            }
                                            $tempratetabledata['OriginationDescription'] = $tempratetabledata['OriginationCode'];
                                        }

                                        if (!empty($attrselection->Code) || !empty($attrselection2->Code)) {
                                            if (!empty($attrselection->Code)) {
                                                $selection_Code = $attrselection->Code;
                                            } else if (!empty($attrselection2->Code)) {
                                                $selection_Code = $attrselection2->Code;
                                            }

                                            if (array_key_exists($selection_Code, $Codes)) {// if OriginationCode selected from Neon Database
                                                $tempratetabledata['Code'] = $selection_Code;
                                            } else if (isset($temp_row[$selection_Code]) && trim($temp_row[$selection_Code]) != '') {// if Code selected from file
                                                $tempratetabledata['Code'] = trim($temp_row[$selection_Code]);
                                            } else if (!empty($tempratetabledata['CountryCode'])) {
                                                $tempratetabledata['Code'] = "";  // if code is blank but country code is not blank than mark code as blank., it will be merged with country code later ie 91 - 1 -> 911
                                            } else {
                                                $error[] = 'Code is blank at line no:' . $lineno;
                                            }
                                            $tempratetabledata['Description'] = $tempratetabledata['Code'];
                                        }

                                        /*if (isset($attrselection->FromCurrency) && !empty($attrselection->FromCurrency) && $attrselection->FromCurrency != 0) {
                                            $tempratetabledata['CurrencyID'] = $attrselection->FromCurrency;
                                        }*/

                                        if (isset($attrselection->Action) && !empty($attrselection->Action)) {
                                            if (empty($temp_row[$attrselection->Action])) {
                                                $tempratetabledata['Change'] = 'I';
                                            } else {
                                                $action_value = $temp_row[$attrselection->Action];
                                                if (isset($attrselection->ActionDelete) && !empty($attrselection->ActionDelete) && trim(strtolower($action_value)) == trim(strtolower($attrselection->ActionDelete))) {
                                                    $tempratetabledata['Change'] = 'D';
                                                } else if (isset($attrselection->ActionUpdate) && !empty($attrselection->ActionUpdate) && trim(strtolower($action_value)) == trim(strtolower($attrselection->ActionUpdate))) {
                                                    $tempratetabledata['Change'] = 'U';
                                                } else if (isset($attrselection->ActionInsert) && !empty($attrselection->ActionInsert) && trim(strtolower($action_value)) == trim(strtolower($attrselection->ActionInsert))) {
                                                    $tempratetabledata['Change'] = 'I';
                                                } else {
                                                    $tempratetabledata['Change'] = 'I';
                                                }
                                            }

                                        } else {
                                            $tempratetabledata['Change'] = 'I';
                                        }

                                        if (!empty($attrselection->City)) {
                                            if (array_key_exists($attrselection->City, $City)) {// if City selected from Neon Database
                                                $tempratetabledata['City'] = $attrselection->City;
                                            } else if (!empty($temp_row[$attrselection->City])) {// if City selected from file
                                                $tempratetabledata['City'] = $temp_row[$attrselection->City];
                                            } else {
                                                $tempratetabledata['City'] = '';
                                            }
                                        } else {
                                            $tempratetabledata['City'] = '';
                                        }
                                        if (!empty($attrselection->Tariff)) {
                                            if (array_key_exists($attrselection->Tariff, $Tariff)) {// if Tariff selected from Neon Database
                                                $tempratetabledata['Tariff'] = $attrselection->Tariff;
                                            } else if (!empty($temp_row[$attrselection->Tariff])) {// if Tariff selected from file
                                                $tempratetabledata['Tariff'] = $temp_row[$attrselection->Tariff];
                                            } else {
                                                $tempratetabledata['Tariff'] = '';
                                            }
                                        } else {
                                            $tempratetabledata['Tariff'] = '';
                                        }

                                        if (!empty($attrselection->AccessType)) {
                                            if (array_key_exists($attrselection->AccessType, $AccessTypes)) {// if AccessType selected from Neon Database
                                                $tempratetabledata['AccessType'] = $attrselection->AccessType;
                                            } else if (isset($temp_row[$attrselection->AccessType])) {// if AccessType selected from file
                                                $tempratetabledata['AccessType'] = $temp_row[$attrselection->AccessType];
                                            } else {
                                                $tempratetabledata['AccessType'] = '';
                                            }
                                        } else {
                                            $tempratetabledata['AccessType'] = '';
                                        }

                                        $CostComponentsMapped = 0;

                                        if (!empty($attrselection->$OneOffCostColumn) && isset($temp_row[$attrselection->$OneOffCostColumn])) {
                                            $tempratetabledata['OneOffCost'] = trim($temp_row[$attrselection->$OneOffCostColumn]);
                                            $CostComponentsMapped++;
                                        } else {
                                            $tempratetabledata['OneOffCost'] = NULL;
                                        }

                                        if (!empty($attrselection->$MonthlyCostColumn) && isset($temp_row[$attrselection->$MonthlyCostColumn])) {
                                            $tempratetabledata['MonthlyCost'] = trim($temp_row[$attrselection->$MonthlyCostColumn]);
                                            $CostComponentsMapped++;
                                        } else {
                                            $tempratetabledata['MonthlyCost'] = NULL;
                                        }

                                        if (!empty($attrselection->$CostPerCallColumn) && isset($temp_row[$attrselection->$CostPerCallColumn])) {
                                            $tempratetabledata['CostPerCall'] = trim($temp_row[$attrselection->$CostPerCallColumn]);
                                            $CostComponentsMapped++;
                                        } else {
                                            $tempratetabledata['CostPerCall'] = NULL;
                                        }

                                        if (!empty($attrselection->$CostPerMinuteColumn) && isset($temp_row[$attrselection->$CostPerMinuteColumn])) {
                                            $tempratetabledata['CostPerMinute'] = trim($temp_row[$attrselection->$CostPerMinuteColumn]);
                                            $CostComponentsMapped++;
                                        } else {
                                            $tempratetabledata['CostPerMinute'] = NULL;
                                        }

                                        if (!empty($attrselection->$SurchargePerCallColumn) && isset($temp_row[$attrselection->$SurchargePerCallColumn])) {
                                            $tempratetabledata['SurchargePerCall'] = trim($temp_row[$attrselection->$SurchargePerCallColumn]);
                                            $CostComponentsMapped++;
                                        } else {
                                            $tempratetabledata['SurchargePerCall'] = NULL;
                                        }

                                        if (!empty($attrselection->$SurchargePerMinuteColumn) && isset($temp_row[$attrselection->$SurchargePerMinuteColumn])) {
                                            $tempratetabledata['SurchargePerMinute'] = trim($temp_row[$attrselection->$SurchargePerMinuteColumn]);
                                            $CostComponentsMapped++;
                                        } else {
                                            $tempratetabledata['SurchargePerMinute'] = NULL;
                                        }

                                        if (!empty($attrselection->$OutpaymentPerCallColumn) && isset($temp_row[$attrselection->$OutpaymentPerCallColumn])) {
                                            $tempratetabledata['OutpaymentPerCall'] = trim($temp_row[$attrselection->$OutpaymentPerCallColumn]);
                                            $CostComponentsMapped++;
                                        } else {
                                            $tempratetabledata['OutpaymentPerCall'] = NULL;
                                        }

                                        if (!empty($attrselection->$OutpaymentPerMinuteColumn) && isset($temp_row[$attrselection->$OutpaymentPerMinuteColumn])) {
                                            $tempratetabledata['OutpaymentPerMinute'] = trim($temp_row[$attrselection->$OutpaymentPerMinuteColumn]);
                                            $CostComponentsMapped++;
                                        } else {
                                            $tempratetabledata['OutpaymentPerMinute'] = NULL;
                                        }

                                        if (!empty($attrselection->$SurchargesColumn) && isset($temp_row[$attrselection->$SurchargesColumn])) {
                                            $tempratetabledata['Surcharges'] = trim($temp_row[$attrselection->$SurchargesColumn]);
                                            $CostComponentsMapped++;
                                        } else {
                                            $tempratetabledata['Surcharges'] = NULL;
                                        }

                                        if (!empty($attrselection->$ChargebackColumn) && isset($temp_row[$attrselection->$ChargebackColumn])) {
                                            $tempratetabledata['Chargeback'] = trim($temp_row[$attrselection->$ChargebackColumn]);
                                            $CostComponentsMapped++;
                                        } else {
                                            $tempratetabledata['Chargeback'] = NULL;
                                        }

                                        if (!empty($attrselection->$CollectionCostAmountColumn) && isset($temp_row[$attrselection->$CollectionCostAmountColumn])) {
                                            $tempratetabledata['CollectionCostAmount'] = trim($temp_row[$attrselection->$CollectionCostAmountColumn]);
                                            $CostComponentsMapped++;
                                        } else {
                                            $tempratetabledata['CollectionCostAmount'] = NULL;
                                        }

                                        if (!empty($attrselection->$CollectionCostPercentageColumn) && isset($temp_row[$attrselection->$CollectionCostPercentageColumn])) {
                                            $tempratetabledata['CollectionCostPercentage'] = trim($temp_row[$attrselection->$CollectionCostPercentageColumn]);
                                            $CostComponentsMapped++;
                                        } else {
                                            $tempratetabledata['CollectionCostPercentage'] = NULL;
                                        }

                                        if (!empty($attrselection->$RegistrationCostPerNumberColumn) && isset($temp_row[$attrselection->$RegistrationCostPerNumberColumn])) {
                                            $tempratetabledata['RegistrationCostPerNumber'] = trim($temp_row[$attrselection->$RegistrationCostPerNumberColumn]);
                                            $CostComponentsMapped++;
                                        } else {
                                            $tempratetabledata['RegistrationCostPerNumber'] = NULL;
                                        }

                                        if($CostComponentsMapped > 0) {
                                            $CostComponentsError = 1;
                                            foreach ($CostComponents as $key => $component) {
                                                if ($tempratetabledata[$component] != NULL) {
                                                    $CostComponentsError = 0;
                                                    break;
                                                }
                                            }
                                        } else {
                                            $CostComponentsError = 0;
                                        }
                                        if($CostComponentsError==1) {
                                            $error[] = 'All Cost Component is blank at line no:' . $lineno;
                                        }

                                        if (!empty($attrselection->$OneOffCostCurrencyColumn)) {
                                            if(array_key_exists($attrselection->$OneOffCostCurrencyColumn, $component_currencies)) {// if currency selected from Neon Currencies
                                                $tempratetabledata['OneOffCostCurrency'] = $attrselection->$OneOffCostCurrencyColumn;
                                            } else if(isset($temp_row[$attrselection->$OneOffCostCurrencyColumn]) && array_search($temp_row[$attrselection->$OneOffCostCurrencyColumn],$component_currencies)) {// if currency selected from file
                                                $tempratetabledata['OneOffCostCurrency'] = array_search($temp_row[$attrselection->$OneOffCostCurrencyColumn],$component_currencies);
                                            } else {
                                                $tempratetabledata['OneOffCostCurrency'] = NULL;
                                                $error[] = 'One-Off Cost Currency is not match at line no:' . $lineno;
                                            }
                                        } else {
                                            $tempratetabledata['OneOffCostCurrency'] = NULL;
                                        }

                                        if (!empty($attrselection->$MonthlyCostCurrencyColumn)) {
                                            if(array_key_exists($attrselection->$MonthlyCostCurrencyColumn, $component_currencies)) {// if currency selected from Neon Currencies
                                                $tempratetabledata['MonthlyCostCurrency'] = $attrselection->$MonthlyCostCurrencyColumn;
                                            } else if(isset($temp_row[$attrselection->$MonthlyCostCurrencyColumn]) && array_search($temp_row[$attrselection->$MonthlyCostCurrencyColumn],$component_currencies)) {// if currency selected from file
                                                $tempratetabledata['MonthlyCostCurrency'] = array_search($temp_row[$attrselection->$MonthlyCostCurrencyColumn],$component_currencies);
                                            } else {
                                                $tempratetabledata['MonthlyCostCurrency'] = NULL;
                                                $error[] = 'Monthly Cost Currency is not match at line no:' . $lineno;
                                            }
                                        } else {
                                            $tempratetabledata['MonthlyCostCurrency'] = NULL;
                                        }

                                        if (!empty($attrselection->$CostPerCallCurrencyColumn)) {
                                            if(array_key_exists($attrselection->$CostPerCallCurrencyColumn, $component_currencies)) {// if currency selected from Neon Currencies
                                                $tempratetabledata['CostPerCallCurrency'] = $attrselection->$CostPerCallCurrencyColumn;
                                            } else if(isset($temp_row[$attrselection->$CostPerCallCurrencyColumn]) && array_search($temp_row[$attrselection->$CostPerCallCurrencyColumn],$component_currencies)) {// if currency selected from file
                                                $tempratetabledata['CostPerCallCurrency'] = array_search($temp_row[$attrselection->$CostPerCallCurrencyColumn],$component_currencies);
                                            } else {
                                                $tempratetabledata['CostPerCallCurrency'] = NULL;
                                                $error[] = 'Cost Per Call Currency is not match at line no:' . $lineno;
                                            }
                                        } else {
                                            $tempratetabledata['CostPerCallCurrency'] = NULL;
                                        }

                                        if (!empty($attrselection->$CostPerMinuteCurrencyColumn)) {
                                            if(array_key_exists($attrselection->$CostPerMinuteCurrencyColumn, $component_currencies)) {// if currency selected from Neon Currencies
                                                $tempratetabledata['CostPerMinuteCurrency'] = $attrselection->$CostPerMinuteCurrencyColumn;
                                            } else if(isset($temp_row[$attrselection->$CostPerMinuteCurrencyColumn]) && array_search($temp_row[$attrselection->$CostPerMinuteCurrencyColumn],$component_currencies)) {// if currency selected from file
                                                $tempratetabledata['CostPerMinuteCurrency'] = array_search($temp_row[$attrselection->$CostPerMinuteCurrencyColumn],$component_currencies);
                                            } else {
                                                $tempratetabledata['CostPerMinuteCurrency'] = NULL;
                                                $error[] = 'Cost Per Minute Currency is not match at line no:' . $lineno;
                                            }
                                        } else {
                                            $tempratetabledata['CostPerMinuteCurrency'] = NULL;
                                        }

                                        if (!empty($attrselection->$SurchargePerCallCurrencyColumn)) {
                                            if(array_key_exists($attrselection->$SurchargePerCallCurrencyColumn, $component_currencies)) {// if currency selected from Neon Currencies
                                                $tempratetabledata['SurchargePerCallCurrency'] = $attrselection->$SurchargePerCallCurrencyColumn;
                                            } else if(isset($temp_row[$attrselection->$SurchargePerCallCurrencyColumn]) && array_search($temp_row[$attrselection->$SurchargePerCallCurrencyColumn],$component_currencies)) {// if currency selected from file
                                                $tempratetabledata['SurchargePerCallCurrency'] = array_search($temp_row[$attrselection->$SurchargePerCallCurrencyColumn],$component_currencies);
                                            } else {
                                                $tempratetabledata['SurchargePerCallCurrency'] = NULL;
                                                $error[] = 'Surcharge Per Call Currency is not match at line no:' . $lineno;
                                            }
                                        } else {
                                            $tempratetabledata['SurchargePerCallCurrency'] = NULL;
                                        }

                                        if (!empty($attrselection->$SurchargePerMinuteCurrencyColumn)) {
                                            if(array_key_exists($attrselection->$SurchargePerMinuteCurrencyColumn, $component_currencies)) {// if currency selected from Neon Currencies
                                                $tempratetabledata['SurchargePerMinuteCurrency'] = $attrselection->$SurchargePerMinuteCurrencyColumn;
                                            } else if(isset($temp_row[$attrselection->$SurchargePerMinuteCurrencyColumn]) && array_search($temp_row[$attrselection->$SurchargePerMinuteCurrencyColumn],$component_currencies)) {// if currency selected from file
                                                $tempratetabledata['SurchargePerMinuteCurrency'] = array_search($temp_row[$attrselection->$SurchargePerMinuteCurrencyColumn],$component_currencies);
                                            } else {
                                                $tempratetabledata['SurchargePerMinuteCurrency'] = NULL;
                                                $error[] = 'Surcharge Per Minute Currency is not match at line no:' . $lineno;
                                            }
                                        } else {
                                            $tempratetabledata['SurchargePerMinuteCurrency'] = NULL;
                                        }

                                        if (!empty($attrselection->$OutpaymentPerCallCurrencyColumn)) {
                                            if(array_key_exists($attrselection->$OutpaymentPerCallCurrencyColumn, $component_currencies)) {// if currency selected from Neon Currencies
                                                $tempratetabledata['OutpaymentPerCallCurrency'] = $attrselection->$OutpaymentPerCallCurrencyColumn;
                                            } else if(isset($temp_row[$attrselection->$OutpaymentPerCallCurrencyColumn]) && array_search($temp_row[$attrselection->$OutpaymentPerCallCurrencyColumn],$component_currencies)) {// if currency selected from file
                                                $tempratetabledata['OutpaymentPerCallCurrency'] = array_search($temp_row[$attrselection->$OutpaymentPerCallCurrencyColumn],$component_currencies);
                                            } else {
                                                $tempratetabledata['OutpaymentPerCallCurrency'] = NULL;
                                                $error[] = 'Outpayment Per Call Currency is not match at line no:' . $lineno;
                                            }
                                        } else {
                                            $tempratetabledata['OutpaymentPerCallCurrency'] = NULL;
                                        }

                                        if (!empty($attrselection->$OutpaymentPerMinuteCurrencyColumn)) {
                                            if(array_key_exists($attrselection->$OutpaymentPerMinuteCurrencyColumn, $component_currencies)) {// if currency selected from Neon Currencies
                                                $tempratetabledata['OutpaymentPerMinuteCurrency'] = $attrselection->$OutpaymentPerMinuteCurrencyColumn;
                                            } else if(isset($temp_row[$attrselection->$OutpaymentPerMinuteCurrencyColumn]) && array_search($temp_row[$attrselection->$OutpaymentPerMinuteCurrencyColumn],$component_currencies)) {// if currency selected from file
                                                $tempratetabledata['OutpaymentPerMinuteCurrency'] = array_search($temp_row[$attrselection->$OutpaymentPerMinuteCurrencyColumn],$component_currencies);
                                            } else {
                                                $tempratetabledata['OutpaymentPerMinuteCurrency'] = NULL;
                                                $error[] = 'Outpayment Per Minute Currency is not match at line no:' . $lineno;
                                            }
                                        } else {
                                            $tempratetabledata['OutpaymentPerMinuteCurrency'] = NULL;
                                        }

                                        if (!empty($attrselection->$SurchargesCurrencyColumn)) {
                                            if(array_key_exists($attrselection->$SurchargesCurrencyColumn, $component_currencies)) {// if currency selected from Neon Currencies
                                                $tempratetabledata['SurchargesCurrency'] = $attrselection->$SurchargesCurrencyColumn;
                                            } else if(isset($temp_row[$attrselection->$SurchargesCurrencyColumn]) && array_search($temp_row[$attrselection->$SurchargesCurrencyColumn],$component_currencies)) {// if currency selected from file
                                                $tempratetabledata['SurchargesCurrency'] = array_search($temp_row[$attrselection->$SurchargesCurrencyColumn],$component_currencies);
                                            } else {
                                                $tempratetabledata['SurchargesCurrency'] = NULL;
                                                $error[] = 'Surcharges Currency is not match at line no:' . $lineno;
                                            }
                                        } else {
                                            $tempratetabledata['SurchargesCurrency'] = NULL;
                                        }

                                        if (!empty($attrselection->$ChargebackCurrencyColumn)) {
                                            if(array_key_exists($attrselection->$ChargebackCurrencyColumn, $component_currencies)) {// if currency selected from Neon Currencies
                                                $tempratetabledata['ChargebackCurrency'] = $attrselection->$ChargebackCurrencyColumn;
                                            } else if(isset($temp_row[$attrselection->$ChargebackCurrencyColumn]) && array_search($temp_row[$attrselection->$ChargebackCurrencyColumn],$component_currencies)) {// if currency selected from file
                                                $tempratetabledata['ChargebackCurrency'] = array_search($temp_row[$attrselection->$ChargebackCurrencyColumn],$component_currencies);
                                            } else {
                                                $tempratetabledata['ChargebackCurrency'] = NULL;
                                                $error[] = 'Chargeback Currency is not match at line no:' . $lineno;
                                            }
                                        } else {
                                            $tempratetabledata['ChargebackCurrency'] = NULL;
                                        }

                                        if (!empty($attrselection->$CollectionCostAmountCurrencyColumn)) {
                                            if(array_key_exists($attrselection->$CollectionCostAmountCurrencyColumn, $component_currencies)) {// if currency selected from Neon Currencies
                                                $tempratetabledata['CollectionCostAmountCurrency'] = $attrselection->$CollectionCostAmountCurrencyColumn;
                                            } else if(isset($temp_row[$attrselection->$CollectionCostAmountCurrencyColumn]) && array_search($temp_row[$attrselection->$CollectionCostAmountCurrencyColumn],$component_currencies)) {// if currency selected from file
                                                $tempratetabledata['CollectionCostAmountCurrency'] = array_search($temp_row[$attrselection->$CollectionCostAmountCurrencyColumn],$component_currencies);
                                            } else {
                                                $tempratetabledata['CollectionCostAmountCurrency'] = NULL;
                                                $error[] = 'Collection Cost Amount Currency is not match at line no:' . $lineno;
                                            }
                                        } else {
                                            $tempratetabledata['CollectionCostAmountCurrency'] = NULL;
                                        }

                                        if (!empty($attrselection->$RegistrationCostPerNumberCurrencyColumn)) {
                                            if(array_key_exists($attrselection->$RegistrationCostPerNumberCurrencyColumn, $component_currencies)) {// if currency selected from Neon Currencies
                                                $tempratetabledata['RegistrationCostPerNumberCurrency'] = $attrselection->$RegistrationCostPerNumberCurrencyColumn;
                                            } else if(isset($temp_row[$attrselection->$RegistrationCostPerNumberCurrencyColumn]) && array_search($temp_row[$attrselection->$RegistrationCostPerNumberCurrencyColumn],$component_currencies)) {// if currency selected from file
                                                $tempratetabledata['RegistrationCostPerNumberCurrency'] = array_search($temp_row[$attrselection->$RegistrationCostPerNumberCurrencyColumn],$component_currencies);
                                            } else {
                                                $tempratetabledata['RegistrationCostPerNumberCurrency'] = NULL;
                                                $error[] = 'Registration Cost Per Number Currency is not match at line no:' . $lineno;
                                            }
                                        } else {
                                            $tempratetabledata['RegistrationCostPerNumberCurrency'] = NULL;
                                        }

                                        if (!empty($attrselection->EffectiveDate) || !empty($attrselection2->EffectiveDate)) {
                                            if (!empty($attrselection->EffectiveDate)) {
                                                $selection_EffectiveDate = $attrselection->EffectiveDate;
                                                $selection_dateformat = $attrselection->DateFormat;
                                            } else if (!empty($attrselection2->EffectiveDate)) {
                                                $selection_EffectiveDate = $attrselection2->EffectiveDate;
                                                $selection_dateformat = $attrselection2->DateFormat;
                                            }

                                            if (isset($selection_EffectiveDate) && !empty($selection_EffectiveDate) && !empty($temp_row[$selection_EffectiveDate])) {
                                                try {
                                                    $tempratetabledata['EffectiveDate'] = formatSmallDate(str_replace('/', '-', $temp_row[$selection_EffectiveDate]), $selection_dateformat);
                                                } catch (\Exception $e) {
                                                    $error[] = 'Date format is Wrong  at line no:' . $lineno;
                                                }
                                            } elseif (empty($selection_EffectiveDate)) {
                                                $tempratetabledata['EffectiveDate'] = date('Y-m-d');
                                            } elseif ($tempratetabledata['Change'] == 'D') {
                                                $tempratetabledata['EffectiveDate'] = date('Y-m-d');
                                            } elseif ($tempratetabledata['Change'] != 'D') {
                                                $error[] = 'EffectiveDate is blank at line no:' . $lineno;
                                            }
                                        } else {
                                            $tempratetabledata['EffectiveDate'] = date('Y-m-d');
                                        }

                                        if (isset($attrselection->EndDate) && !empty($attrselection->EndDate) && !empty($temp_row[$attrselection->EndDate])) {
                                            try {
                                                $tempratetabledata['EndDate'] = formatSmallDate(str_replace('/', '-', $temp_row[$attrselection->EndDate]), $attrselection->DateFormat);
                                            } catch (\Exception $e) {
                                                $error[] = 'Date format is Wrong  at line no:' . $lineno;
                                            }
                                        }

                                        if (!empty($DialStringId)) {
                                            if (isset($attrselection->DialStringPrefix) && !empty($attrselection->DialStringPrefix) && isset($temp_row[$attrselection->DialStringPrefix])) {
                                                $tempratetabledata['DialStringPrefix'] = trim($temp_row[$attrselection->DialStringPrefix]);
                                            } else {
                                                $tempratetabledata['DialStringPrefix'] = '';
                                            }
                                        }

                                        $tempratetabledata['TimezonesID'] = $TimezoneID;

                                        if (isset($tempratetabledata['Code']) && isset($tempratetabledata['Description']) && ($CostComponentsMapped>0 || $tempratetabledata['Change'] == 'D') && isset($tempratetabledata['EffectiveDate'])) {
                                            if (isset($tempratetabledata['EndDate'])) {
                                                $batch_insert_array[] = $tempratetabledata;
                                            } else {
                                                $batch_insert_array2[] = $tempratetabledata;
                                            }
                                            $counter++;
                                        }
                                    }
                                    if ($counter == $bacth_insert_limit) {
                                        Log::info('Batch insert start');
                                        Log::info('global counter' . $lineno);
                                        Log::info('insertion start');
                                        if(!empty($batch_insert_array)) {
                                            TempRateTableDIDRate::insert($batch_insert_array);
                                        }
                                        if(!empty($batch_insert_array2)) {
                                            TempRateTableDIDRate::insert($batch_insert_array2);
                                        }
                                        Log::info('insertion end');
                                        $batch_insert_array = [];
                                        $batch_insert_array2 = [];
                                        $counter = 0;
                                    }
                                    $lineno++;
                                } // loop over
//                            } // if rate is mapped against timezone condition

                            if(!empty($batch_insert_array) || !empty($batch_insert_array2)){
                                Log::info('Batch insert start');
                                Log::info('global counter' . $lineno);
                                Log::info('insertion start');
                                Log::info('last batch insert ' . count($batch_insert_array));
                                Log::info('last batch insert 2 ' . count($batch_insert_array2));
                                if(!empty($batch_insert_array)) {
                                    TempRateTableDIDRate::insert($batch_insert_array);
                                }
                                if(!empty($batch_insert_array2)) {
                                    TempRateTableDIDRate::insert($batch_insert_array2);
                                }
                                Log::info('insertion end');
                                $batch_insert_array = [];
                                $batch_insert_array2 = [];
                                $counter = 0;
                            }
                        } // $Ratekeys loop over

                    } else {
                        $ProcessID = $joboptions->ProcessID;
                    }
                    $JobStatusMessage = array();
                    $duplicatecode=0;

                    if(!empty($attrselection->CountryMapping) || !empty($attrselection2->CountryMapping) || !empty($attrselection->OriginationCountryMapping) || !empty($attrselection2->OriginationCountryMapping)) {
                        $CountryMapping             = !empty($attrselection->CountryMapping) || !empty($attrselection2->CountryMapping) ? 1 : 0;
                        $OriginationCountryMapping  = !empty($attrselection->OriginationCountryMapping) || !empty($attrselection2->OriginationCountryMapping) ? 1 : 0;

                        $query_CM = "CALL prc_WSMapCountryRateTableDIDRate ('" . $ProcessID . "','".$CountryMapping."','".$OriginationCountryMapping."')";

                        // map country against rates with tblCountry table, if not found then throw error - if option is checked at upload time
                        Log::info('Start '.$query_CM);
                        try {
                            DB::beginTransaction();
                            $JobStatusMessage_CM = DB::select($query_CM);
                            Log::info('End ' . $query_CM);
                            DB::commit();

                            $JobStatusMessage_CM = array_reverse(json_decode(json_encode($JobStatusMessage_CM), true));
                            Log::info($JobStatusMessage_CM);
                            Log::info(count($JobStatusMessage_CM));

                            if(count($JobStatusMessage_CM) >= 1){
                                $prc_error_CM = array();
                                foreach ($JobStatusMessage_CM as $JobStatusMessage_CM1) {
                                    $prc_error_CM[] = $JobStatusMessage_CM1['Message'];
                                }

                                //unset($error[0]);
                                $jobdata['JobStatusMessage'] = implode('<br>',fix_jobstatus_meassage($prc_error_CM));
                                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','F')->pluck('JobStatusID');
                                Job::where(["JobID" => $JobID])->update($jobdata);
                            }
                        } catch ( Exception $err ) {
                            DB::rollback();
                            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                            $jobdata['JobStatusMessage'] = 'Exception: ' . $err->getMessage();
                            Job::where(["JobID" => $JobID])->update($jobdata);
                            Log::error($err);
                        }

                    }

                    // if no error from prc_WSMapCountryRateTableDIDRate then only further process
                    if(empty($jobdata)) {

                        $RateApprovalProcess = CompanySetting::getKeyVal($CompanyID,'RateApprovalProcess');
                        if($RateApprovalProcess == 1 && $rateTable->AppliedTo != RateTable::APPLIED_TO_VENDOR) {
                            $query = "CALL  prc_WSProcessRateTableDIDRateAA ('" . $joboptions->RateTableID . "','" . $joboptions->checkbox_replace_all . "','" . $joboptions->checkbox_rates_with_effected_from . "','" . $ProcessID . "','" . $joboptions->checkbox_add_new_codes_to_code_decks . "','" . $CompanyID . "','" . $DialStringId . "','" . $dialcode_separator . "'," . $seperatecolumn . "," . $CurrencyID . "," . $joboptions->radio_list_option . ",'" . $p_UserName . "')";
                        } else {
                            $query = "CALL  prc_WSProcessRateTableDIDRate ('" . $joboptions->RateTableID . "','" . $joboptions->checkbox_replace_all . "','" . $joboptions->checkbox_rates_with_effected_from . "','" . $ProcessID . "','" . $joboptions->checkbox_add_new_codes_to_code_decks . "','" . $CompanyID . "','" . $DialStringId . "','" . $dialcode_separator . "'," . $seperatecolumn . "," . $CurrencyID . "," . $joboptions->radio_list_option . ",'" . $p_UserName . "')";
                        }
                        Log::info("start " . $query);

                        try {
                            DB::beginTransaction();
                            $JobStatusMessage = DB::select($query);
                            Log::info("end " . $query);
                            DB::commit();

                            $JobStatusMessage = array_reverse(json_decode(json_encode($JobStatusMessage), true));
                            Log::info($JobStatusMessage);
                            Log::info(count($JobStatusMessage));
                            if (!empty($error) || count($JobStatusMessage) > 1) {
                                $prc_error = array();
                                foreach ($JobStatusMessage as $JobStatusMessage1) {
                                    $prc_error[] = $JobStatusMessage1['Message'];
                                    if (strpos($JobStatusMessage1['Message'], 'DUPLICATE CODE') !== false) {
                                        $duplicatecode = 1;
                                    }
                                }
                                $job = Job::find($JobID);
                                if ($duplicatecode == 1) {
                                    $error = array_merge($prc_error, $error);
                                    unset($error[0]);
                                    $jobdata['JobStatusMessage'] = implode(',\n\r', fix_jobstatus_meassage($error));
                                    $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                                } else {
                                    $error = array_merge($prc_error, $error);
                                    $jobdata['JobStatusMessage'] = implode(',\n\r', fix_jobstatus_meassage($error));
                                    $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'PF')->pluck('JobStatusID');
                                }
                                //$jobdata['JobStatusMessage'] = implode(',\n\r',$error);
                                $jobdata['updated_at'] = date('Y-m-d H:i:s');
                                $jobdata['ModifiedBy'] = 'RMScheduler';
                                Log::info($jobdata);
                                Job::where(["JobID" => $JobID])->update($jobdata);
                            } elseif (!empty($JobStatusMessage[0]['Message'])) {
                                $job = Job::find($JobID);
                                $jobdata['JobStatusMessage'] = $JobStatusMessage[0]['Message'];
                                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'S')->pluck('JobStatusID');
                                $jobdata['updated_at'] = date('Y-m-d H:i:s');
                                $jobdata['ModifiedBy'] = 'RMScheduler';
                                Job::where(["JobID" => $JobID])->update($jobdata);
                            }

                        } catch (Exception $err) {
                            DB::rollback();
                            Log::error($err);

                            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                            $jobdata['JobStatusMessage'] = 'Exception: ' . $err->getMessage();
                            $jobdata['updated_at'] = date('Y-m-d H:i:s');
                            $jobdata['ModifiedBy'] = 'RMScheduler';
                            Job::where(["JobID" => $JobID])->update($jobdata);
                            Log::error($err);
                        }
                    }

                }
            }

        } catch (\Exception $e) {
            try{
                DB::rollback();
            }catch (Exception $err) {
                Log::error($err);
            }
            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
            $jobdata['JobStatusMessage'] = 'Exception: ' . $e->getMessage();
            $jobdata['updated_at'] = date('Y-m-d H:i:s');
            $jobdata['ModifiedBy'] = 'RMScheduler';
            Job::where(["JobID" => $JobID])->update($jobdata);
            Log::error($e);
        }
        Job::send_job_status_email($job,$CompanyID);

        CronHelper::after_cronrun($this->name, $this);

    }

}