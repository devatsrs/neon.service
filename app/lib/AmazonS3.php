<?php
/**
 * Created by PhpStorm.
 * User: deven
 * Date: 24/02/2015
 * Time: 12:00 PM
 */
namespace App\Lib;

use Aws\S3\S3Client;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Log;

class AmazonS3 {

    public static $isAmazonS3;
    public static $dir = array(
        'AUTOIMPORT_UPLOAD' =>  'AutoImportUploads',
        'CODEDECK_UPLOAD' =>  'CodedecksUploads',
        'VENDOR_UPLOAD' =>  'VendorUploads',
        'VENDOR_DOWNLOAD' =>  'VendorDownloads',
        'CUSTOMER_DOWNLOAD' =>  'CustomerDownloads',
        'ACCOUNT_APPROVAL_CHECKLIST_FORM' =>  'AccountApprovalChecklistForms',
        'ACCOUNT_DOCUMENT' =>  'AccountDocuments',
        'INVOICE_COMPANY_LOGO' =>  'InvoiceCompanyLogos',
        'INVOICE_USAGE_FILE' =>  'InvoiceUsageFile',
        'INVOICE_UPLOAD' =>  'Invoices',
		'EMAIL_ATTACHMENT'=>'EmailAttachment',
		'REPORT_ATTACHMENT'=>'ReportAttachment',
		'DIGITAL_SIGNATURE_KEY'=>'DigitalSignature',
        'GATEWAY_KEY'=>'GatewayKey',

    );

    // Instantiate an S3 client
    private static function getS3Client($CompanyID){

	$AmazonData			=	\App\Lib\SiteIntegration::CheckIntegrationConfiguration(true,\App\Lib\SiteIntegration::$AmazoneSlug,$CompanyID);
	if(!$AmazonData){
        self::$isAmazonS3='NoAmazon';
		return 'NoAmazon';
	}else{
        self::$isAmazonS3='Amazon';
        $Amazone=array(
            'region' => $AmazonData->AmazonAwsRegion,
            'credentials' => array(
                'key' => $AmazonData->AmazonKey,
                'secret' => $AmazonData->AmazonSecret
            ),
        );
        if(isset($AmazonData->SignatureVersion) && $AmazonData->SignatureVersion!=''){
            $Amazone['signature']=$AmazonData->SignatureVersion;
        }
		return $s3Client = S3Client::factory($Amazone);
	}
		
       /* $AMAZONS3_KEY  = getenv("AMAZONS3_KEY");
        $AMAZONS3_SECRET = getenv("AMAZONS3_SECRET");
        $AWS_REGION = getenv("AWS_REGION");

        if(empty($AMAZONS3_KEY) || empty($AMAZONS3_SECRET) || empty($AWS_REGION) ){
            return 'NoAmazon';
        }else {

            return $s3Client = S3Client::factory(array(
                'region' => $AWS_REGION,
                'credentials' => array(
                    'key' => $AMAZONS3_KEY,
                    'secret' => $AMAZONS3_SECRET
                ),
            ));
        }*/
    }
	
	public static function getAmazonSettings($CompanyID){

      /*  $cache = CompanyConfiguration::getConfiguration();
        $amazon = array();
        if(isset($cache['Amazon'])) {

            $amazoneJson = $cache['Amazon'];

            if (!empty($amazoneJson)) {
                $amazon = json_decode($amazoneJson, true);
             }
        }*/
		$amazon 		= 	array();
		$AmazonData		=	\App\Lib\SiteIntegration::CheckIntegrationConfiguration(true,\App\Lib\SiteIntegration::$AmazoneSlug,$CompanyID);
		
		if($AmazonData){
			$amazon 	=	 array("AWS_BUCKET"=>$AmazonData->AmazonAwsBucket,"AMAZONS3_KEY"=>$AmazonData->AmazonKey,"AMAZONS3_SECRET"=>$AmazonData->AmazonSecret,"AWS_REGION"=>$AmazonData->AmazonAwsRegion);	
		}
		
        return $amazon;
    }
	
    public static function getBucket($CompanyID){
        $amazon = self::getAmazonSettings($CompanyID);
        if(isset($amazon['AWS_BUCKET'])){

            return $amazon['AWS_BUCKET'];
        }else {
            return "";
        }

    }

    /*
     * Generate Path
     * Ex. WaveTell/18-Y/VendorUploads/2015/05
     * */
    static function generate_upload_path($dir ='',$accountId = '',$CompanyID, $noDateFolders=false) {

        if(empty($dir))
            return false;

        $path = self::generate_path($dir,$CompanyID,$accountId, $noDateFolders);

        return $path;
    }

    static function generate_path($dir ='',$companyId , $accountId = '', $noDateFolders=false ) {
        $UPLOADPATH = CompanyConfiguration::get($companyId,'UPLOAD_PATH');
        $path = $companyId  ."/";

        if($accountId > 0){
            $path .= $accountId ."/";
        }

        if($noDateFolders){
            $path .=  $dir . "/";
        }else{
            $path .=  $dir . "/". date("Y")."/".date("m") ."/" .date("d") ."/";
        }
        $dir = $UPLOADPATH . '/'. $path;
        if (!file_exists($dir)) {
            //exec("chmod -R 777 " . getenv('UPLOAD_PATH'));
            //@mkdir($dir, 0777, TRUE);
            RemoteSSH::make_dir($companyId,$dir);
        }
        if (!is_dir($dir)) {
            //@mkdir($dir, 0777, true);
            RemoteSSH::make_dir($companyId,$dir);

        }


        return $path;
    }


    static function upload($file,$dir,$CompanyID){

        // Instantiate an S3 client
        $s3 = self::getS3Client($CompanyID);

        //When no amazon return true;
        if($s3 == 'NoAmazon'){
            return true;
        }

        $bucket = self::getBucket($CompanyID);
        // Upload a publicly accessible file. The file size, file type, and MD5 hash
        // are automatically calculated by the SDK.
        try {
            $resource = fopen($file, 'r');
            $s3->upload($bucket, $dir.basename($file), $resource, 'public-read');
            @unlink($file); // remove from local
            return true;
        } catch (S3Exception $e) {
            return false ; //"There was an error uploading the file.\n";
        }
    }

    static function preSignedUrl($key='',$CompanyID){

        $s3 = self::getS3Client($CompanyID);
        $Uploadpath = CompanyConfiguration::get($CompanyID,'UPLOAD_PATH') . '/' .$key;
        //When no amazon ;

        if ( file_exists($Uploadpath) ) {
            return $Uploadpath;
        }
        elseif(self::$isAmazonS3=='Amazon')
        {
            $bucket = self::getBucket($CompanyID);

            // Get a command object from the client and pass in any options
            // available in the GetObject command (e.g. ResponseContentDisposition)
            $command = $s3->getCommand('GetObject', array(
                'Bucket' => $bucket,
                'Key' => $key,
                'ResponseContentDisposition' => 'attachment; filename="'. basename($key) . '"'
            ));

            // Create a signed URL from the command object that will last for
            // 10 minutes from the current time
            return $command->createPresignedUrl('+10 minutes');
        }
        else
        {
            return "";
        }
    }

    static function unSignedUrl($key='',$CompanyID){
        $s3 = self::getS3Client($CompanyID);
		$Uploadpath = CompanyConfiguration::get($CompanyID,'UPLOAD_PATH') . '/' .$key;

        if ( file_exists($Uploadpath) ) {
            return $Uploadpath;
        } elseif(self::$isAmazonS3=='Amazon') {
            $bucket = self::getBucket($CompanyID);
			$unsignedUrl = $s3->getObjectUrl($bucket, $key);
			return $unsignedUrl;
        } else {
			return "";
		}
    }

    static function delete($file,$CompanyID){
        $return=false;
        if(strlen($file)>0) {
            // Instantiate an S3 client
            $s3 = self::getS3Client($CompanyID);

            //When no amazon ;

            $Uploadpath = CompanyConfiguration::get($CompanyID,'UPLOAD_PATH') . "/"."".$file;
            if ( file_exists($Uploadpath) ) {
                @unlink($Uploadpath);
                if(self::$isAmazonS3=="NoAmazon")
                {
                    $return=true;
                }
            }

            if(self::$isAmazonS3=="Amazon")
            {
                $AmazonSettings  = self::getAmazonSettings($CompanyID);
                $bucket 		 = $AmazonSettings['AWS_BUCKET'];
                // Upload a publicly accessible file. The file size, file type, and MD5 hash
                // are automatically calculated by the SDK.
                try {
                    $s3->deleteObject(array('Bucket' => $bucket, 'Key' => $file));
                    $return=true;
                } catch (S3Exception $e) {
                    $return=false; //"There was an error uploading the file.\n";
                }
            }
        }

        return $return;
    }

    static function download($CompanyID,$key,$destination){
        $path = self::unSignedUrl($key,$CompanyID);
        if (strpos($path, "https://") !== false) {
            $file = $destination;
            file_put_contents($file, file_get_contents($path));
        }
        return $path;

    }
} 