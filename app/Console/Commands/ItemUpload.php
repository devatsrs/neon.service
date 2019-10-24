<?php namespace App\Console\Commands;

use App\Lib\AccountService;
use App\Lib\CompanyConfiguration;
use App\Lib\CompanyGateway;
use App\Lib\CronHelper;
use App\Lib\Gateway;
use App\Lib\AmazonS3;
use App\Lib\Job;
use App\Lib\Currency;
use App\Lib\Country;
use App\Lib\JobFile;
use App\Lib\Product;
use App\Lib\Service;
use App\Lib\User;
use App\Lib\FileUploadTemplate;
use App\Lib\VendorFileUploadTemplate;
use Illuminate\Support\Facades\DB;
use App\Lib\NeonExcelIO;
use Maatwebsite\Excel\Facades\Excel;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Log;
use App\Lib\Account;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;
use Webpatser\Uuid\Uuid;
use \Exception;

class ItemUpload extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'itemupload';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Item Upload Service';

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
            ['JobID', InputArgument::REQUIRED, 'Argument JobID '],
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

        $jobdata = array();
        $errorslog = array();
        $CompanyID = $arguments["CompanyID"];
        $bacth_insert_limit = 50;
        $counter = 0;
        $error = array();
        $importoptions = array();
        $joboptions = array();
        $tempProcessID = '';

        Log::useFiles(storage_path().'/logs/itemupload-'.$JobID.'-'.date('Y-m-d').'.log');
        $TEMP_PATH = CompanyConfiguration::get($CompanyID,'TEMP_PATH').'/';
        try {

            $ProcessID = (string) Uuid::generate();
            Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Change by abubakar

            if (!empty($job)) {
                $jobfile = JobFile::where(['JobID' => $JobID])->first();
                $joboptions = json_decode($jobfile->Options);

                $batch_insert_array = [];
                $batch_insert_dynamic_field_array = [];
                if (count($joboptions) > 0){

                    if(isset($joboptions->UploadTemplate) && !empty($joboptions->UploadTemplate)) {
                        $UploadTemplate = FileUploadTemplate::find($joboptions->UploadTemplate);
                        $templateoptions = json_decode($UploadTemplate->Options);
                    }else{
                        $templateoptions = $joboptions->option;

                    }
//print_r($templateoptions);exit;
                    $csvoption = $templateoptions;
                    $attrselection = $joboptions->selection;
                    if (!empty($jobfile->FilePath)) {
                        $path = AmazonS3::unSignedUrl($jobfile->FilePath,$CompanyID);
                        if (strpos($path, "https://") !== false) {
                            $file = $TEMP_PATH . basename($path);
                            file_put_contents($file, file_get_contents($path));
                            $jobfile->FilePath = $file;
                        } else {
                            $jobfile->FilePath = $path;
                        }
                    }

                    $NeonExcel = new NeonExcelIO($jobfile->FilePath, (array) $csvoption);
                    $results = $NeonExcel->read();
                    $lineno = 2;
                    if ($csvoption->Firstrow == 'data') {
                        $lineno = 1;
                    }

                    foreach ($results as $temp_row) {
                        if ($csvoption->Firstrow == 'data') {
                            array_unshift($temp_row, null);
                            unset($temp_row[0]);

                        }
                        $temp_row = filterArrayRemoveNewLines($temp_row);
                        $tempservice=1;
                        $tempItemData = array();
                        $DynamicFields = array();
                        $checkemptyrow = array_filter(array_values($temp_row));
                        if(!empty($checkemptyrow)) {

                            if (isset($attrselection->Name) && !empty($attrselection->Name) && !empty($temp_row[$attrselection->Name])) {
                                $tempItemData['Name'] = trim($temp_row[$attrselection->Name]);
                            }else{
                                $error[] = 'Name field is blank at line no:' . $lineno;
                            }
                            if (isset($attrselection->Code) && !empty($attrselection->Code) && !empty($temp_row[$attrselection->Code])) {
                                $tempItemData['Code'] = trim($temp_row[$attrselection->Code]);
                            }else{
                                $error[] = 'Code field is blank at line no:' . $lineno;
                            }
                            if (isset($attrselection->Description) && !empty($attrselection->Description) && !empty($temp_row[$attrselection->Description])) {
                                $tempItemData['Description'] = trim($temp_row[$attrselection->Description]);
                            }else{
                                $error[] = 'Description field is blank at line no:' . $lineno;
                            }
                            if (isset($attrselection->Amount) && !empty($attrselection->Amount) && !empty($temp_row[$attrselection->Amount])) {
//                                $roundplaces = get_round_decimal_places();
                                $roundplaces = 2;
                                $tempItemData['Amount'] = $data["Amount"] = number_format(str_replace(",","",trim($temp_row[$attrselection->Amount])),$roundplaces,".","");
                            }else{
                                $error[] = 'Cost field is blank at line no:' . $lineno;
                            }
                            /*if (isset($attrselection->BarCode) && !empty($attrselection->BarCode) && !empty($temp_row[$attrselection->BarCode])) {
                                $tempItemData['BarCode'] = trim($temp_row[$attrselection->BarCode]);
                            }else{
                                $tempItemData['BarCode'] = '';
                            }*/
                            if (isset($attrselection->Note) && !empty($attrselection->Note) && !empty($temp_row[$attrselection->Note])) {
                                $tempItemData['Note'] = trim($temp_row[$attrselection->Note]);
                            }else{
                                $tempItemData['Note'] = '';
                            }
                            if (isset($attrselection->AppliedTo) && !empty($attrselection->AppliedTo) && !empty($temp_row[$attrselection->AppliedTo])) {
                                $AppliedTo = strtolower(trim($temp_row[$attrselection->AppliedTo]));
                                if($AppliedTo=='reseller'){
                                    $tempItemData['AppliedTo'] = Product::Reseller;
                                }else{
                                    $tempItemData['AppliedTo'] = Product::Customer;
                                }
                            }else{
                                $tempItemData['AppliedTo'] = Product::Customer;
                            }
                            if (isset($attrselection->Action) && !empty($attrselection->Action)) {
                                $action_value = $temp_row[$attrselection->Action];
                                if (isset($attrselection->ActionDelete) && !empty($attrselection->ActionDelete) && strtolower($action_value) == strtolower($attrselection->ActionDelete) ) {
                                    $tempItemData['Change'] = 'D';
                                }else if (isset($attrselection->ActionUpdate) && !empty($attrselection->ActionUpdate) && strtolower($action_value) == strtolower($attrselection->ActionUpdate)) {
                                    $tempItemData['Change'] = 'U';
                                }else if (isset($attrselection->ActionInsert) && !empty($attrselection->ActionInsert) && strtolower($action_value) == strtolower($attrselection->ActionInsert)) {
                                    $tempItemData['Change'] = 'I';
                                }else{
                                    $tempItemData['Change'] = 'I';
                                }
                            }else{
                                $tempItemData['Change'] = 'I';
                            }

                            $attrDynamicFields = preg_grep("/^DynamicFields/", array_keys((array) $attrselection));
//                            echo "<pre>";print_r($DynamicFields);exit;

                            if(count($attrDynamicFields) > 0){
                                $j=0;
                                foreach($attrDynamicFields as $fieldName => $fieldValue){
                                    if(!empty($temp_row[$attrselection->$fieldValue])){
                                        $DynamicFields[$j]['FieldValue'] = trim($temp_row[$attrselection->$fieldValue]);
                                    } else {
                                        $DynamicFields[$j]['FieldValue'] = "";
                                    }
                                    $DynamicFields[$j]['DynamicFieldsID'] = (int) str_replace("DynamicFields-", "", $fieldValue);
                                    $DynamicFields[$j]['CompanyID'] = $CompanyID;
                                    $DynamicFields[$j]['ProcessID'] = $ProcessID;
                                    $DynamicFields[$j]['created_at'] = date('Y-m-d H:i:s.000');
                                    $DynamicFields[$j]['created_by'] = 'Imported';
                                    $j++;
                                }
                            }
//                            echo "<pre>";print_r($DynamicFields);exit();

                            if (isset($tempItemData['Name']) && isset($tempItemData['Code']) && isset($tempItemData['Description']) && isset($tempItemData['Amount'])) {
                                $tempItemData['Active'] = 1;
                                $tempItemData['CompanyID'] = $CompanyID;
                                $tempItemData['ProcessID'] = $ProcessID;
                                $tempItemData['created_at'] = date('Y-m-d H:i:s.000');
                                $tempItemData['created_by'] = 'Imported';
                                $batch_insert_array[] = $tempItemData;
                                $batch_insert_dynamic_field_array[] = $DynamicFields;
                                $counter++;
                            }

                        }
                        if ($counter == $bacth_insert_limit) {
                            Log::info('Batch insert start');
                            Log::info('global counter' . $lineno);
                            Log::info('insertion start');
//                            DB::connection('sqlsrv2')->table('tblTempProduct')->insert($batch_insert_array);

                            for($i=0; $i<count($batch_insert_array); $i++) {
                                $id = DB::connection('sqlsrv2')->table('tblTempProduct')->insertGetId($batch_insert_array[$i]);

                                for($k=0; $k<count($batch_insert_dynamic_field_array[$i]); $k++) {
                                    $batch_insert_dynamic_field_array[$i][$k]['ParentID'] = $id;
                                    DB::connection('sqlsrv2')->table('tblTempDynamicFieldsValue')->insert($batch_insert_dynamic_field_array[$i][$k]);
                                }
                            }

                            //Log::info(print_r($batch_insert_array,true));
                            Log::info('insertion end');
                            $batch_insert_array = [];
                            $batch_insert_dynamic_field_array = [];
                            $counter = 0;
                        }
                        $lineno++;
                    }

                    if (!empty($batch_insert_array)) {
                        Log::info('Batch insert start');
                        Log::info('global counter' . $lineno);
                        Log::info('insertion start');
                        Log::info('last batch insert ' . count($batch_insert_array));
//                        DB::connection('sqlsrv2')->table('tblTempProduct')->insert($batch_insert_array);

                        for($i=0; $i<count($batch_insert_array); $i++) {
                            $id = DB::connection('sqlsrv2')->table('tblTempProduct')->insertGetId($batch_insert_array[$i]);

                            for($k=0; $k<count($batch_insert_dynamic_field_array[$i]); $k++) {
                                $batch_insert_dynamic_field_array[$i][$k]['ParentID'] = $id;
                                DB::connection('sqlsrv2')->table('tblTempDynamicFieldsValue')->insert($batch_insert_dynamic_field_array[$i][$k]);
                            }
                        }
                        //Log::info(print_r($batch_insert_array,true));
                        Log::info('insertion end');
                    }
//exit();
                    Log::info("start CALL  prc_WSProcessItemUpload ('" . $ProcessID . "','" . $CompanyID . "')");
                    try {
                        DB::beginTransaction();
                        $JobStatusMessage = DB::connection('sqlsrv2')->select("CALL  prc_WSProcessItemUpload ('" . $ProcessID . "','" . $CompanyID . "')");
                        Log::info("end CALL  prc_WSProcessItemUpload ('" . $ProcessID . "','" . $CompanyID . "')");
                        DB::commit();
                        $JobStatusMessage = array_reverse(json_decode(json_encode($JobStatusMessage),true));
                        Log::info($JobStatusMessage);
                        Log::info(count($JobStatusMessage));
                        if(!empty($error) || count($JobStatusMessage) > 1){
                            $prc_error = array();
                            foreach ($JobStatusMessage as $JobStatusMessage1) {
                                $prc_error[] = $JobStatusMessage1['Message'];
                            }
                            $error = array_merge($prc_error,$error);
                            $job = Job::find($JobID);
                            $jobdata['JobStatusMessage'] = implode(',\n\r',fix_jobstatus_meassage($error));
                            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','PF')->pluck('JobStatusID');
                            $jobdata['updated_at'] = date('Y-m-d H:i:s');
                            $jobdata['ModifiedBy'] = 'RMScheduler';
                            Log::info($jobdata);
                            Job::where(["JobID" => $JobID])->update($jobdata);
                        }elseif(!empty($JobStatusMessage[0]['Message'])){
                            $job = Job::find($JobID);
                            $jobdata['JobStatusMessage'] = $JobStatusMessage[0]['Message'];
                            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','S')->pluck('JobStatusID');
                            $jobdata['updated_at'] = date('Y-m-d H:i:s');
                            $jobdata['ModifiedBy'] = 'RMScheduler';
                            Job::where(["JobID" => $JobID])->update($jobdata);
                        }

                    }catch ( Exception $err ){
                        try{
                            DB::rollback();
                        }catch (Exception $err) {
                            Log::error($err);
                        }
                        $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                        $jobdata['JobStatusMessage'] = 'Exception: ' . $err->getMessage();
                        $jobdata['updated_at'] = date('Y-m-d H:i:s');
                        $jobdata['ModifiedBy'] = 'RMScheduler';
                        Job::where(["JobID" => $JobID])->update($jobdata);
                        Log::error($err);
                    }

                } // job option empty over



            } // job empty over


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