<?php

namespace App\Lib;

use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\DB;
use \Exception;


class Retention {

    public static function setAccountServiceNumberAndPackage($CompanyID){
        $error = '';
        $setting = CompanySetting::getKeyVal($CompanyID,'DataRetention');

                        try {
                            DB::connection('sqlsrv')->beginTransaction();
                            $date = date('Y-m-d');
                            $query = "CALL prc_SetAccountServiceNumberAndPackage('" . $date . "')";
                            Log::info($query);
                            DB::connection('sqlsrv')->statement($query);
                            DB::connection('sqlsrv')->commit();
                        } catch (\Exception $e) {
                            try {
                                DB::connection('sqlsrv')->rollback();
                            } catch (\Exception $err) {
                                Log::error($err);
                            }
                            Log::error($e);
                            $error = "Set AccountService Number And Package \n\r";
                        }

        return $error;
    }

    public static function deleteCustomerCDR($CompanyID ,$key){
        $error = '';
        $setting = CompanySetting::getKeyVal($CompanyID,'DataRetention');
        if(isset($setting) && $setting!='Invalid Key'){
            $CustomerCDR = json_decode($setting,true);
            if(!empty($CustomerCDR[$key]) && (int)$CustomerCDR[$key] > 0){
                $CDRDays = (int)$CustomerCDR[$key];
                $CDRDays = '-'.$CDRDays.' Day';
                $date = UsageHeader::getMinDateUsageHeader($CompanyID);
                $startdate = date("Y-m-d", strtotime($date));
                $enddate = date("Y-m-d", strtotime($CDRDays));
                if(isset($startdate) && isset($enddate) && $startdate < $enddate){
                    $start = $startdate;
                    while ($start <= $enddate) {
                        $Start_Cdr_Date = $start;
                        $start = date('Y-m-d', strtotime('+1 day', strtotime($start)));
                        try {
                            DB::connection('sqlsrvcdr')->beginTransaction();
                            $query = "call prc_deleteCustomerCDRByRetention($CompanyID,'" . $Start_Cdr_Date . "', '".$key."')";
                            Log::info($query);
                            DB::connection('sqlsrvcdr')->statement($query);
                            DB::connection('sqlsrvcdr')->commit();
                        } catch (\Exception $e) {
                            try {
                                DB::connection('sqlsrvcdr')->rollback();
                            } catch (\Exception $err) {
                                Log::error($err);
                            }
                            Log::error($e);
                            Log::info("Customer CDR - ".$Start_Cdr_Date);
                            $error = "Delete Customer CDR Fail \n\r";
                        }
                    }
                }else{
                    Log::info('No Data Need To Delete');
                }

            }
        }
        return $error;
    }

    public static function deleteVendorCDR($CompanyID, $key){
        $error = '';
        $setting = CompanySetting::getKeyVal($CompanyID,'DataRetention');
        if(isset($setting) && $setting!='Invalid Key'){
            $VendorCDR = json_decode($setting,true);
            if(!empty($VendorCDR[$key]) && (int)$VendorCDR[$key] > 0){
                $CDRDays = (int)$VendorCDR[$key];
                $CDRDays = '-'.$CDRDays.' Day';
                $date = UsageHeader::getMinDateVendorCDRHeader($CompanyID);
                $startdate = date("Y-m-d", strtotime($date));
                $enddate = date("Y-m-d", strtotime($CDRDays));
                if(isset($startdate) && isset($enddate) && $startdate < $enddate){
                    $start = $startdate;
                    while ($start <= $enddate) {
                        $Start_Cdr_Date = $start;
                        $start = date('Y-m-d', strtotime('+1 day', strtotime($start)));
                        try {
                            DB::connection('sqlsrvcdr')->beginTransaction();
                            $query = "call prc_deleteVendorCDRByRetention($CompanyID,'" . $Start_Cdr_Date . "','" . $key . "')";
                            Log::info($query);
                            DB::connection('sqlsrvcdr')->statement($query);
                            DB::connection('sqlsrvcdr')->commit();
                        } catch (\Exception $e) {
                            try {
                                DB::connection('sqlsrvcdr')->rollback();
                            } catch (\Exception $err) {
                                Log::error($err);
                            }
                            Log::error($e);
                            Log::info("Vendor CDR - ".$Start_Cdr_Date);
                            $error = "Delete Vendor CDR Fail \n\r";
                        }
                    }
                }else{
                    Log::info('Vendor CDR - No Data Need To Delete');
                }

            }
        }
        return $error;
    }

    public static function deleteUsageDownloadLog($CompanyID){
        $error = '';
        $count = 0;
        $setting = CompanySetting::getKeyVal($CompanyID,'DataRetention');
        if(isset($setting) && $setting!='Invalid Key'){
            $UsageDownloadLog = json_decode($setting,true);
            if(!empty($UsageDownloadLog['CDR']) && (int)$UsageDownloadLog['CDR'] > 0) {
                $CDRDays = (int)$UsageDownloadLog['CDR'];
                $CDRDays = '-' . $CDRDays . ' Day';
                $deletedate = date("Y-m-d", strtotime($CDRDays));
                try {
                    $count = TempUsageDownloadLog::where(['CompanyID' => $CompanyID])->where('start_time', '<', $deletedate)->count();
                }catch (\Exception $e) {
                    Log::error($e);
                    $error = "Delete Temp Usage Download Log Fail \n\r";
                }
                if($count>0){
                    TempUsageDownloadLog::where(['CompanyID'=>$CompanyID])->where('start_time','<',$deletedate)->delete();
                    Log::info('Usage Download Log - '.$deletedate.' - '.$count.' Records Delete' );
                }else{
                    Log::info('Usage Download Log - '.$deletedate.' - No Data Need To Delete');
                }
            }
        }
        return $error;
    }

    public static function deleteJobOrCronJobLog($CompanyID,$Name){
        $error = '';
        $setting = CompanySetting::getKeyVal($CompanyID,'DataRetention');
        if(!empty($Name) && isset($setting) && $setting!='Invalid Key'){
            $Log = json_decode($setting,true);
            if(!empty($Log[$Name]) && (int)$Log[$Name] > 0) {
                $LogDays = (int)$Log[$Name];
                $LogDays = '-' . $LogDays . ' Day';
                $deletedate = date("Y-m-d", strtotime($LogDays));
                try {
                    DB::beginTransaction();
                    $query = "call prc_deleteJobOrCronJobLogByRetention($CompanyID,'" . $deletedate . "','".$Name."')";
                    Log::info($query);
                    DB::statement($query);
                    DB::commit();
                } catch (\Exception $e) {
                    try {
                        DB::rollback();
                    } catch (\Exception $err) {
                        Log::error($err);
                    }
                    Log::error($e);
                    Log::info($Name." Log - ".$deletedate);
                    $error = "Delete '.$Name.' Fail \n\r";
                }
            }
        }

        return $error;
    }

    public static function deleteAllOldRate($CompanyID){
        $error = '';
        try {
            DB::beginTransaction();

            Log::info('DBcleanup: prc_WSCronJobDeleteOldVendorRate Start.');
                DB::statement("CALL prc_WSCronJobDeleteOldVendorRate('System')");
            Log::info('DBcleanup: prc_WSCronJobDeleteOldVendorRate Done.');

            Log::info('DBcleanup: prc_WSCronJobDeleteOldCustomerRate Start.');
                DB::statement("CALL prc_WSCronJobDeleteOldCustomerRate('System')");
            Log::info('DBcleanup: prc_WSCronJobDeleteOldCustomerRate Done.');

            Log::info('DBcleanup: prc_WSCronJobDeleteOldRateTableRate Start.');
                DB::statement("CALL prc_WSCronJobDeleteOldRateTableRate('System')");
            Log::info('DBcleanup: prc_WSCronJobDeleteOldRateTableRate Done.');

            Log::info('DBcleanup: prc_WSCronJobDeleteOldRateTableDIDRate Start.');
                DB::statement("CALL prc_WSCronJobDeleteOldRateTableDIDRate('System')");
            Log::info('DBcleanup: prc_WSCronJobDeleteOldRateTableDIDRate Done.');

            Log::info('DBcleanup: prc_WSCronJobDeleteOldRateTablePKGRate Start.');
                DB::statement("CALL prc_WSCronJobDeleteOldRateTablePKGRate('System')");
            Log::info('DBcleanup: prc_WSCronJobDeleteOldRateTablePKGRate Done.');

            Log::info('DBcleanup: prc_WSCronJobDeleteOldRateSheetDetails Start.');
                DB::statement("CALL prc_WSCronJobDeleteOldRateSheetDetails()");
            Log::info('DBcleanup: prc_WSCronJobDeleteOldRateSheetDetails Done.');

            DB::commit();
        } catch (\Exception $e) {
            try {
                DB::rollback();
            } catch (\Exception $err) {
                Log::error($err);
            }
            Log::error($e);
            $error = "All Old Rate Delete Fail \n\r";
        }
        return $error;
    }

    public static function deleteStorageLog($CompanyID){
        Log::info('Delete Storage Log Start');
        //front end storage

        $LogDeleteDay = CompanyConfiguration::get($CompanyID,'DELETE_STORAGE_LOG_DAYS');

        $FrontStoragePath = CompanyConfiguration::get($CompanyID,'FRONT_STORAGE_PATH');
        if(!empty($FrontStoragePath) && isset($LogDeleteDay) && $LogDeleteDay>0){
            Log::info('Front End Delete Storage Log Start');
            $Front_Command = 'find '.$FrontStoragePath.'/logs -maxdepth 1  -name "*.log" -mtime +'.$LogDeleteDay.' -type f -exec rm {} \;';
            $Front_Output = RemoteSSH::run($CompanyID,[$Front_Command]);
            Log::info($Front_Command);
            if(count($Front_Output)>0){
                Log::info($Front_Output);
            }
            Log::info('Front End Delete Storage Log End');
        }

        //service storage

        $StoragePath = storage_path();
        //$StoragePath = 'find /var/www/html/neon-service-branch/dev-mysql/bhavin/storage';
        if(!empty($StoragePath) && isset($LogDeleteDay) && $LogDeleteDay>0){
            Log::info('Back End(Service) Delete Storage Log Start');
            $command = 'find '.$StoragePath.'/logs -maxdepth 1  -name "*.log" -mtime +'.$LogDeleteDay.' -type f -exec rm {} \;';
            $output = RemoteSSH::run($CompanyID,[$command]);
            Log::info($command);
            if(count($output)>0){
                Log::info($output);
            }
            Log::info('Back End(Service) Delete Storage Log End');
        }

        Log::info('Delete Storage Log End');

    }

    public static function deleteTempFiles($CompanyID){
        Log::info('Delete Temp Files Start');

        $TempPath = CompanyConfiguration::get($CompanyID,'TEMP_PATH');
        $LogDeleteDay = CompanyConfiguration::get($CompanyID,'DELETE_TEMP_FILES_DAYS');

        if(!empty($TempPath) && isset($LogDeleteDay) && $LogDeleteDay>0){
            $command = 'find '.$TempPath.'* -maxdepth 1 -mtime +'.$LogDeleteDay.' -type f -exec rm {} \;';
            $output = RemoteSSH::run($CompanyID,[$command]);
            Log::info($command);
            if(count($output)>0){
                Log::info($output);
            }
        }

        Log::info('Delete Temp Files End');
    }

    public static function deleteCDRFiles($CompanyID){
        Log::info('Delete CDR File Start');
        $setting = CompanySetting::getKeyVal($CompanyID,'FileRetention');
        $DeleteCDR = 0;
        $CDRMoves = 0;
        $SippyLocation = CompanyConfiguration::get($CompanyID,'SIPPYFILE_LOCATION');
        $VosLocation = CompanyConfiguration::get($CompanyID,'VOS_LOCATION');

        if(isset($setting) && $setting!='Invalid Key'){
            $CDRFiles = json_decode($setting,true);
            if(CronJob::checkCDRDownloadFiles($CompanyID)){
                if(!empty($SippyLocation) || !empty($VosLocation)){
                    $DeleteCDR = 1;
                }
            }
            if(!empty($CDRFiles['CDR']) && (int)$CDRFiles['CDR'] > 0 && $DeleteCDR === 1){

                $DeleteDays = $CDRFiles['CDR'];

                if(!empty($CDRFiles['CDRMoves']) && $CDRFiles['CDRMoves']==1){
                    $CDRMoves = 1;
                }else{
                    $CDRMoves = 0;
                }

                if(!empty($CDRFiles['CDRFilesDelete']) && $CDRFiles['CDRFilesDelete']){
                    $CDRFilesDelete = 1;
                }else{
                    $CDRFilesDelete = 0;
                }

                if(!empty($SippyLocation)) {
                    Log::info('Sippy Start');
                    Log::info('Retention::deleteFilesByGateway('.$CompanyID.',Sippy,'.$SippyLocation.','.$DeleteDays.','.$CDRMoves.','.$CDRFilesDelete.');');
                    Retention::deleteFilesByGateway($CompanyID,'Sippy',$SippyLocation,$DeleteDays,$CDRMoves,$CDRFilesDelete);
                    Log::info('Sippy End');
                }

                if(!empty($VosLocation)) {
                    Log::info('Vos Start');
                    Log::info('Retention::deleteFilesByGateway('.$CompanyID.',Vos,'.$VosLocation.','.$DeleteDays.','.$CDRMoves.','.$CDRFilesDelete.');');
                    Retention::deleteFilesByGateway($CompanyID,'Vos',$VosLocation,$DeleteDays,$CDRMoves,$CDRFilesDelete);
                    Log::info('Vos End');
                }

            }
        }
        Log::info('Delete CDR File End');
    }

    public static function deleteFilesByGateway($CompanyID,$gateway,$location,$DeleteDays,$CDRMoves=0,$CDRFilesDelete=0){

        $BackupName =  'Backup_'.$gateway.'_'.date('Y-m-d_H-i-s');
        $errorupload = 0;
        $FileExits = 0;

        if(!empty($CDRMoves) && $CDRMoves == 1){

            //make a zip files from server
            $Zip_Command = 'find '.$location.'*  -mindepth 2  -maxdepth 3 -mtime +'.$DeleteDays.' -type f | xargs tar -czvPf '.$location.'/'.$BackupName.'.tar.gz';
            $Zip_Output = RemoteSSH::run($CompanyID,[$Zip_Command]);
            Log::info('Make a zip of older files - '.$Zip_Command);
            Log::info($Zip_Output);

            /*
             * example file exits check
             * [[ -f /var/www/html/neon-service-branch/dev-mysql/bhavin/storage/logs/en/Backup_Sippy_2016-07-15_13-28-14.tar.gz ]] && echo "File exist" || echo "File does not exist"
             * */
            $Check_File_Exits = '[[ -f '.$location.'/'.$BackupName.'.tar.gz ]] && echo "File exist" || echo "File does not exist"';
            $Output = RemoteSSH::run($CompanyID,[$Check_File_Exits]);
            Log::info('File Exits Check - '.$Check_File_Exits);
            Log::info($Output);

            // check message in return output
            foreach ($Output as $Message) {
                if(strpos($Message, 'File exist') !==false){
                    $FileExits = 1;
                }
            }
            if($FileExits == 1){
                //echo $command;

                if(is_amazon($CompanyID)){
                    //upload zip file from server to amazon s3
                    //$bucket = getenv('AWS_BUCKET')
                    $bucket = AmazonS3::getBucket($CompanyID);
                    $amazonpath = 's3://'.$bucket.'/Backup/CDR/';
                    $AmazonData			=	SiteIntegration::CheckIntegrationConfiguration(true,SiteIntegration::$AmazoneSlug,$CompanyID);
                    $AMAZONS3_KEY 		= 	isset($AmazonData->AmazonKey)?$AmazonData->AmazonKey:'';
                    $AMAZONS3_SECRET 	= 	isset($AmazonData->AmazonSecret)?$AmazonData->AmazonSecret:'';
                    $AWS_REGION 		= 	isset($AmazonData->AmazonAwsRegion)?$AmazonData->AmazonAwsRegion:'';
                    /**
                     * example
                     * /usr/bin/s3cmd put --recursive /home/autobackup/uk-others-backup s3://neon.backup/
                     */
                    //$UploadCommand = 'solo -port=6001 s3cmd sync '.$location.'/'.$BackupName.'.tar.gz '.$amazonpath;
                    $UploadCommand = '/usr/bin/s3cmd put --recursive --access_key='.$AMAZONS3_KEY.' --secret_key='.$AMAZONS3_SECRET.' --region='.$AWS_REGION.' '.$location.'/'.$BackupName.'.tar.gz '.$amazonpath;
                    $Upload_Output = RemoteSSH::run($CompanyID,[$UploadCommand]);
                    Log::info('Upload Files to amazon - '.$UploadCommand);
                    Log::info($Upload_Output);

                    foreach ($Upload_Output as $JobStatusMessage1) {
                        if(strpos($JobStatusMessage1, 'ERROR:') !==false){
                            $errorupload = 1;
                        }
                    }
                }

                //if any error occur when upload zip then files will not delete from server
                if($errorupload == 0){

                    if($CDRFilesDelete == 1){
                        // delete files from server
                        $DeleteCommand = 'find '.$location.'* -mindepth 2  -maxdepth 3 -mtime +'.$DeleteDays.' -type f -exec rm {} \;';
                        $Delete_Output = RemoteSSH::run($CompanyID,[$DeleteCommand]);
                        Log::info('Deleted Files From server - '.$DeleteCommand);
                        Log::info($Delete_Output);
                    }

                    //delete temp zip file from server
                    $DeleteZipCommand = 'rm '.$location.'/'.$BackupName.'.tar.gz';
                    $DeleteZip_Output = RemoteSSH::run($CompanyID,[$DeleteZipCommand]);
                    Log::info('Deleted Zip From server - '.$DeleteZipCommand);
                    Log::info($DeleteZip_Output);
                }else{
                    Log::info('Error in upload files');
                }
            }else{
                Log::info('File does not exits');
            }

        }else{
            if($CDRFilesDelete == 1) {
                //delete files from server
                $command = 'find ' . $location . '* -mindepth 2  -maxdepth 3 -mtime +' . $DeleteDays . ' -type f -exec rm {} \;';
                $Front_Output = RemoteSSH::run($CompanyID, [$command]);
                Log::info('Without amazon delete files - ' . $command);
                Log::info($Front_Output);
            }
        }
    }

    public static function getDiskSpaceOfServer($CompanyID){
        $Command = 'df -Ph | awk \'{printf "%-35s%-10s%-10s%-10s%-10s%s\n",$1,$2,$3,$4,$5,$6}\'';
        //$Command = 'df -h';
        $Output = RemoteSSH::run($CompanyID,[$Command]);
        Log::info('Disk FileSystem - '.$Command);
        Log::info("output \n\r".$Output[0]);
        return $Output;
    }
    public static function FileRetentionEmailSend($CompanyID,$BeforeDiskSpaceOutput,$AfterDiskSpaceOutput,$FileRetentionEmail){
        $emaildata = array();
        $message = '';

        $ComanyName = Company::getName($CompanyID);
        if(empty($BeforeDiskSpaceOutput)){
            $BeforeDiskSpaceOutput = '';
        }

        if(empty($AfterDiskSpaceOutput)){
            $AfterDiskSpaceOutput = '';
        }

        $emaildata['CompanyID'] = $CompanyID;
        $emaildata['CompanyName'] = $ComanyName;
        $emaildata['EmailTo'] = $FileRetentionEmail;
        //$emaildata['EmailFrom'] = 'sumera.staging@code-desk.com';
        $emaildata['EmailToName'] = '';
        $emaildata['Subject'] = 'File Retention Email';
        $emaildata['message'] = $message;
        $emaildata['BeforeDiskSpaceOutput'] = $BeforeDiskSpaceOutput;
        $emaildata['AfterDiskSpaceOutput'] = $AfterDiskSpaceOutput;

        $result = Helper::sendMail('emails.FileRetentionEmail', $emaildata);
        return $result;
    }

    /** delete old deleted tickets from table after 6 month.
     * @param $CompanyID
     */
    public static function TicketDeleteFromDeleteTable($CompanyID) {

        try{

            //companyid not required.
            $q1 = "DELETE FROM tblTicketsDeletedLog WHERE created_at  < DATE_SUB(CURRENT_DATE , INTERVAL 6 MONTH) ";
            $q2 = "DELETE FROM AccountEmailLogDeletedLog where created_at  < DATE_SUB(CURRENT_DATE , INTERVAL 6 MONTH) ";

            Log::info("Deleting old deleted tickets");
            Log::info($q1);
            Log::info($q2);

            DB::delete($q1);
            DB::delete($q2);

            return;

        } catch (\Exception $err) {
            Log::error($err);
        }

        return "Failed to delete old deleted tickets from table after 6 month ";


    }

    public static function deleteArchiveOldRate($CompanyID,$Name,$processID){
        $error = '';
        $setting = CompanySetting::getKeyVal($CompanyID,'DataRetention');
        if(!empty($Name) && isset($setting) && $setting!='Invalid Key'){
            $Log = json_decode($setting,true);
            if(!empty($Log[$Name]) && (int)$Log[$Name] > 0) {
                $LogDays = (int)$Log[$Name];
                $LogDays = '-' . $LogDays . ' Day';
                $deletedate = date("Y-m-d", strtotime($LogDays));
                Log::info("===deleteArchiveOldRate(),DeleteDate=".$deletedate);

                try {
                    DB::beginTransaction();
                    $query = "call prc_deleteArchiveOldRate($CompanyID,'" . $deletedate . "','".$processID."')";
                    Log::info($query);
                    DB::statement($query);
                    DB::commit();
                } catch (\Exception $e) {
                    try {
                        DB::rollback();
                    } catch (\Exception $err) {
                        Log::error($err);
                    }
                    Log::error($e);
                    Log::info($Name." Log - ".$deletedate);
                    $error = "Delete '.$Name.' Fail \n\r";
                }
            }
        }

        return $error;
    }

    public static function deleteTickets($CompanyID,$Name,$processID){
        $error = '';
        $setting = CompanySetting::getKeyVal($CompanyID,'DataRetention');
        if(!empty($Name) && isset($setting) && $setting!='Invalid Key'){
            $Log = json_decode($setting,true);
            if(!empty($Log[$Name]) && (int)$Log[$Name] > 0) {
                $LogDays = (int)$Log[$Name];
                $LogDays = '-' . $LogDays . ' Day';
                $deletedate = date("Y-m-d", strtotime($LogDays));
                Log::info("===deleteTickets(),DeleteDate=".$deletedate);

                try {
                    DB::beginTransaction();
                    $query = "call prc_deleteTickets($CompanyID,'" . $deletedate . "','".$processID."')";
                    Log::info($query);
                    //DB::statement($query);
                    $attachments=DB::select($query);
                    Log::info("==== Attachments ====");
                    Log::info(print_r($attachments,true));
                    $Deletecnt=0;
                    foreach($attachments as $attachment){
                        $Filesarr=unserialize($attachment->attachment);
                        foreach($Filesarr as $result){
                            if(!empty($result['filepath'])){
                                $Deletecnt++;
                                AmazonS3::delete($result['filepath'],$CompanyID);
                            }
                        }
                    }
                    Log::info("Total Files for delete = ".$Deletecnt);
                    DB::commit();
                } catch (\Exception $e) {
                    try {
                        DB::rollback();
                    } catch (\Exception $err) {
                        Log::error($err);
                    }
                    Log::error($e);
                    Log::info($Name." Log - ".$deletedate);
                    $error = "Delete '.$Name.' Fail \n\r";
                }
            }
        }

        return $error;
    }

}