<?php namespace App\Lib;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class UsageDownloadFiles extends Model {

    protected $fillable = [];
    protected $connection = 'sqlsrv2';
    protected $guarded = array('UsageDownloadFilesID');

    protected $table = 'tblUsageDownloadFiles';

    protected  $primaryKey = "UsageDownloadFilesID";


    /**
     * Remove already downloaded files from array
     * not in use
     */
    public static function remove_downloaded_files($CompanyGatewayID,$files){
        $response_files = $tmp_files = [];
        if(count($files)> 0) {
            $p_files = implode(",", $files);
            $result = DB::connection('sqlsrv2')->select("CALL prc_checkIfFileAlreadyDownloaded(" . $CompanyGatewayID . ",'" . $p_files . "');");
            foreach($result as $row){
                $tmp_files[] = $row->FileName;
            }
            $response_files = array_diff($files , $tmp_files);
        }
        return $response_files;

    }
    public static function getInProcessfile($CompanyID,$CompanyGatewayID,$ErrorEmail,$JobTitle){
        $UsageDownloadFiles = UsageDownloadFiles::where(array('CompanyGatewayID'=>$CompanyGatewayID,'Status'=>2))->get(['FileName'])->toArray();
        $renamefilenames = array();
        foreach($UsageDownloadFiles as $UsageDownloadFilesrow){
            $renamefilenames[] = $UsageDownloadFilesrow['FileName'];
        }
        if(count($renamefilenames)) {
            Helper::sendFileRenamed($CompanyID, $ErrorEmail, $JobTitle, $renamefilenames);
        }
    }

    /** get vos pending files */
    public static function getVosPendingFile($CompanyGatewayID){
        $filenames = array();
        $new_filenames = UsageDownloadFiles::where(array('CompanyGatewayID'=>$CompanyGatewayID,'Status'=>1))->orderby('created_at')->get();
        foreach ($new_filenames as $file) {
            $filenames[$file->UsageDownloadFilesID] = $file->FileName;
        }
        return $filenames;

    }
    /** get sippy pending files */
    public static function getSippyPendingFile($CompanyGatewayID,$type){
        $filenames = array();
        $new_filenames = UsageDownloadFiles::where(array('CompanyGatewayID'=>$CompanyGatewayID,'Status'=>1))
            ->where('FileName','like','%'.$type.'%')->orderby('created_at')->get();
        foreach ($new_filenames as $file) {
            $filenames[$file->UsageDownloadFilesID] = $file->FileName;
        }
        return $filenames;

    }
    /** update file status to progress */
    public static function UpdateFileStausToProcess($UsageDownloadFilesID,$processID){
        $UsageDownloadFiles = UsageDownloadFiles::find($UsageDownloadFilesID);
        if(!empty($UsageDownloadFiles)){
            $process_count = $UsageDownloadFiles->ProcessCount+1;
            $process_at = date('Y-m-d H:i:s');
            $message = $UsageDownloadFiles->Message.' process_at = '.$process_at.' processid = '.$processID."\r\n";
            $UsageDownloadFiles->update(array('Status'=>2,'ProcessCount'=>$process_count,'process_at'=>$process_at,'Message'=>$message));
        }
    }
    /** get process file make them pending*/
    public static function UpdateProcessToPending($CompanyID,$CompanyGatewayID,$CronJob,$cronsetting){
        if(!empty($cronsetting['ErrorEmail'])) {
            UsageDownloadFiles::getInProcessfile($CompanyID,$CompanyGatewayID, $cronsetting['ErrorEmail'], $CronJob->JobTitle);
        }
        UsageDownloadFiles::where(array('CompanyGatewayID'=>$CompanyGatewayID,'Status'=>2))->update(array('Status'=>1));
    }
    /** update file process to completed */
    public static function UpdateProcessToComplete($delete_files = array()){
        if(!empty($delete_files)) {
            $success_at = ' success_at = '.date('Y-m-d H:i:s');
            UsageDownloadFiles::whereIn('UsageDownloadFilesID', $delete_files)->where('Status',2)->update(array('Status' => 3,'Message'=>DB::raw("CONCAT(Message ,'".$success_at."')")));
        }
    }
    /** update file process to completed */
    public static function UpdateToPending($delete_files = array()){
        if(!empty($delete_files)) {
            UsageDownloadFiles::whereIn('UsageDownloadFilesID', $delete_files)->where('Status',2)->update(array('Status' => 1));
        }
    }
    /** update file status to progress */
    public static function UpdateFileStatusToError($CompanyID,$cronsetting,$JobTitle,$UsageDownloadFilesID,$errormsg){
        $UsageDownloadFiles = UsageDownloadFiles::find($UsageDownloadFilesID);
        if(!empty($UsageDownloadFiles) && !empty($cronsetting['ErrorEmail'])){
            $message = $UsageDownloadFiles->Message.$errormsg;
            $UsageDownloadFiles->update(array('Status'=>4,'Message'=>$message));
            Helper::errorFiles($CompanyID, $cronsetting['ErrorEmail'], $JobTitle, $UsageDownloadFiles->FileName);
        }
    }

}
