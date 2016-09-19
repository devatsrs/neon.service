<?php
function custom_replace( &$item, $key ) {
    $item = str_replace('usd', '{{sign}}', $item);
}
function generic_replace($data){
    return str_replace($data['extra'], $data['replace'], $data['text']);
}
function is_amazon($CompanyID){
	$AmazonData			=	\App\Lib\SiteIntegration::CheckIntegrationConfiguration(true,\App\Lib\SiteIntegration::$AmazoneSlug,$CompanyID);	
	$AMAZONS3_KEY 		= 	isset($AmazonData->AmazonKey)?$AmazonData->AmazonKey:'';
	$AMAZONS3_SECRET 	= 	isset($AmazonData->AmazonSecret)?$AmazonData->AmazonSecret:'';
	$AWS_REGION 		= 	isset($AmazonData->AmazonAwsRegion)?$AmazonData->AmazonAwsRegion:'';
    /*$AMAZONS3_KEY  = getenv("AMAZONS3_KEY");
    $AMAZONS3_SECRET = getenv("AMAZONS3_SECRET");
    $AWS_REGION = getenv("AWS_REGION");*/

    if(empty($AMAZONS3_KEY) || empty($AMAZONS3_SECRET) || empty($AWS_REGION) ){
        return false;
    }
    return true;
}
function get_image_data($path){
    $type = pathinfo($path, PATHINFO_EXTENSION);
    $data = file_get_contents($path);
    $base64 = 'data:image/' . $type . ';base64,' . base64_encode($data);
    return $base64;
}
function invoice_date_fomat($DateFormat){
    if(empty($DateFormat)){
        $DateFormat = 'd-m-Y';
    }
    return $DateFormat;
}
function change_timezone($billing_timezone,$timezone,$date){
    if(empty($timezone)){
        $timezone = getenv("DEFAULT_TIMEZONE");
    }
    if(empty($billing_timezone)){
        $billing_timezone = getenv("DEFAULT_BILLING_TIMEZONE");
    }
    date_default_timezone_set($billing_timezone);
    $strtotime = strtotime($date);
    date_default_timezone_set($timezone);
    $changed_date = date('Y-m-d H:i:s',$strtotime);
    date_default_timezone_set(Config::get('app.timezone'));
    return $changed_date;
}
function next_billing_date($BillingCycleType,$BillingCycleValue,$BillingStartDate){
    $NextInvoiceDate = '';
    if(isset($BillingCycleType)) {
        switch ($BillingCycleType) {
            case 'weekly':
                if (!empty($BillingCycleValue)) {
                     $NextInvoiceDate = date("Y-m-d", strtotime("next " . $BillingCycleValue,$BillingStartDate));
                }else{
                    $NextInvoiceDate = date("Y-m-d", strtotime("next monday")); /** default value set to monday if not set in account **/
                }
                break;
            case 'monthly':
                $NextInvoiceDate = date("Y-m-d", strtotime("first day of next month ",$BillingStartDate));
                break;
            case 'daily':
                $NextInvoiceDate = date("Y-m-d", strtotime("+1 Days",$BillingStartDate));
                break;
            case 'in_specific_days':
                if (!empty($BillingCycleValue)) {
                    $NextInvoiceDate = date("Y-m-d", strtotime("+" . intval($BillingCycleValue)  . " Day",$BillingStartDate));
                }
                break;
            case 'monthly_anniversary':

                $day = date("d",  strtotime($BillingCycleValue)); // Date of Anivarsary
                $month = date("m",  $BillingStartDate); // Month of Last Invoice date or Start Date
                $year = date("Y",  $BillingStartDate); // Year of Last Invoice date or Start Date

                $newDate = strtotime($year . '-' . $month . '-' . $day);

                if($day<=date("d",  $BillingStartDate)) {
                    $NextInvoiceDate = date("Y-m-d", strtotime("+1 month", $newDate));
                }else{
                    $NextInvoiceDate = date("Y-m-d",$newDate);
                }

                break;
            case 'fortnightly':
                $fortnightly_day = date("d", $BillingStartDate);
                if($fortnightly_day > 15){
                    $NextInvoiceDate = date("Y-m-d", strtotime("first day of next month ",$BillingStartDate));
                }else{
                    $NextInvoiceDate = date("Y-m-16", $BillingStartDate);
                }
                break;
            case 'quarterly':
                $quarterly_month = date("m", $BillingStartDate);
                if($quarterly_month < 4){
                    $NextInvoiceDate = date("Y-m-d", strtotime("first day of april ",$BillingStartDate));
                }else if($quarterly_month > 3 && $quarterly_month < 7) {
                    $NextInvoiceDate = date("Y-m-d", strtotime("first day of july ",$BillingStartDate));
                }else if($quarterly_month > 6 && $quarterly_month < 10) {
                    $NextInvoiceDate = date("Y-m-d", strtotime("first day of october ",$BillingStartDate));
                }else if($quarterly_month > 9){
                    $NextInvoiceDate = date("Y-01-01", strtotime('+1 year ',$BillingStartDate));
                }
                break;
        }

    }
     return $NextInvoiceDate;
}
function formatDate($date,$dateformat='d-m-y',$smallDate = false)
{

    $date = str_replace('/', '-', $date);

    if(!$smallDate){

        if(strpos($date,":" ) !== FALSE ) {
            $dateformat = $dateformat . " H:i:s";

            if (strpos(strtolower($date), "am") !== FALSE || strpos(strtolower($date), "pm") !== FALSE) {
                $dateformat = $dateformat . " A";
            }
        }
    }

    $_date_time = date_parse_from_format($dateformat, $date);

    if (isset($_date_time['warning_count']) &&  isset($_date_time['warnings']) && count($_date_time['warnings']) > 0 ) {

        $error  = $date . ': Date Format Error  ' . implode(",",(array)$_date_time['warnings']);
        //throw new Exception($error);
    }

    if (isset($_date_time['error_count']) && $_date_time['error_count'] > 0 && isset($_date_time['errors'])) {

        $error = $date . ': Date Format Error  ' . implode(",",(array)$_date_time['errors']);
        //throw new Exception($error);

    }

    $datetime = $_date_time['year'].'-'.$_date_time['month'].'-'.$_date_time['day'];

    if(is_numeric($_date_time['hour']) && is_numeric($_date_time['minute']) && is_numeric($_date_time['second'])){

        $datetime = $datetime . ' '. $_date_time['hour'].':'.$_date_time['minute'].':'.$_date_time['second'];
    }
    return $datetime;

}
function formatDuration($duration){
    if (strpos($duration,':') !== false){
        $duration_array = explode(':',$duration);
        $duration = $duration_array[2]+$duration_array[1]*60+$duration_array[0]*60*60;
    }else{
        $duration = (int)$duration;
    }
    return $duration;
}
function formatSmallDate($date,$dateformat='d-m-y')
{
    return formatDate($date,$dateformat,true);
}
function get_timezone_offset($remote_tz, $origin_tz = null) {
    if($origin_tz === null) {
        if(!is_string($origin_tz = date_default_timezone_get())) {
            return false; // A UTC timestamp was returned -- bail out!
        }
    }
	if(empty($remote_tz)){
		$remote_tz = 'GMT';
	}
    $origin_dtz = new DateTimeZone($origin_tz);
    $remote_dtz = new DateTimeZone($remote_tz);
    $origin_dt = new DateTime("now", $origin_dtz);
    $remote_dt = new DateTime("now", $remote_dtz);
    $offset = $origin_dtz->getOffset($origin_dt) - $remote_dtz->getOffset($remote_dt);
    return $offset;
}
function searcharray($val1, $key1, $val2='',$key2='',$array) {
    foreach ($array as $k => $val) {
        if(array_search($val1,$val)== $key1 && array_search($val2,$val)== $key2){
            return $k;
        }
    }
    return null;
}
function add_duration ($duration1,$duration2){
    $duration1array = explode(':',$duration1);
    $duration2array = explode(':',$duration2);
    $totalduration = $duration1array[0]*60+$duration1array[1]+$duration2array[0]*60+$duration2array[1];
   return (int)($totalduration/60).':'.$totalduration%60;
}
function time_elapsed($start_time,$end_time){
    $datetime1 = new \DateTime($start_time);
    $datetime2 = new \DateTime($end_time);
    $interval = $datetime1->diff($datetime2);
    return $elapsed = $interval->format('%i minutes %S seconds');
}
function fix_jobstatus_meassage($message){
    if(count($message)>100) {
        $message = array_slice($message, 0, 100);
        $message[] = '...';
    }
    return $message;
}
function translation_rule($CLITranslationRule){
    $replacement =$patternrules =  array();
    $CLITranslationRule = explode(',',$CLITranslationRule);
    foreach($CLITranslationRule as $CLITranslationRulerow){
        $CLITranslation = explode('/',$CLITranslationRulerow);
        if(isset($CLITranslation[1])) {
            $patternrules[] = '/'.$CLITranslation[1].'/';
        }
        if(isset($CLITranslation[2])) {
            $replacement[] = $CLITranslation[2];
        }
    }
    $return['replacement'] = $replacement;
    $return['patternrules'] = $patternrules;
    return $return;

}
function sippy_vos_areaprefix($area_prefix,$RateCDR){
    if($RateCDR == 1 || empty($area_prefix)){
        $area_prefix = 'Other';
    }
    $area_prefix = preg_replace('/^00/','',$area_prefix);
    $area_prefix = preg_replace('/^2222/','',$area_prefix);
    $area_prefix = preg_replace('/^3333/','',$area_prefix);
return $area_prefix;
}
function template_var_replace($EmailMessage,$replace_array){
    $extra = [
        '{{FirstName}}',
        '{{LastName}}',
        '{{Email}}',
        '{{Address1}}',
        '{{Address2}}',
        '{{Address3}}',
        '{{City}}',
        '{{State}}',
        '{{PostCode}}',
        '{{Country}}',
        '{{InvoiceNumber}}',
        '{{GrandTotal}}',
        '{{OutStanding}}',
        '{{TotalOutStanding}}',
        '{{Signature}}',
        '{{BalanceAmount}}',
        '{{BalanceThreshold}}',
    ];

    foreach($extra as $item){
        $item_name = str_replace(array('{','}'),array('',''),$item);
        if(isset($replace_array[$item_name])) {
            $EmailMessage = str_replace($item,$replace_array[$item_name],$EmailMessage);
        }
    }
    return $EmailMessage;
}

function combile_url_path($url, $path){

    return add_trailing_slash($url). $path;
}

/** Add slash at the end
 * @param string $str
 * @return string
 */
function add_trailing_slash($str = ""){

    if(!empty($str)){

        return rtrim($str, '/') . '/';

    }
}

/** Remove slash at the start
 * @param string $str
 * @return string
 */
function remove_front_slash($str = ""){

    if(!empty($str)){

        return ltrim($str, '/')  ;

    }
}
function getBillingDay($BillingStartDate,$BillingCycleType,$BillingCycleValue){
    $BillingDays = 0;
    switch ($BillingCycleType) {
        case 'weekly':
            $BillingDays = 7;
            break;
        case 'monthly':
            $BillingDays = date("t", $BillingStartDate);
            break;
        case 'daily':
            $BillingDays = 1;
            break;
        case 'in_specific_days':
            $BillingDays = intval($BillingCycleValue);
            break;
        case 'monthly_anniversary':

            $day = date("d",  strtotime($BillingCycleValue)); // Date of Anivarsary
            $month = date("m",  $BillingStartDate); // Month of Last Invoice date or Start Date
            $year = date("Y",  $BillingStartDate); // Year of Last Invoice date or Start Date

            $newDate = strtotime($year . '-' . $month . '-' . $day);

            if($day<=date("d",  $BillingStartDate)) {
                $NextInvoiceDate = date("Y-m-d", strtotime("+1 month", $newDate));
                $LastInvoiceDate = date("Y-m-d",$newDate);
            }else{
                $NextInvoiceDate = date("Y-m-d",$newDate);
                $LastInvoiceDate = date("Y-m-d", strtotime("-1 month", $newDate));
            }
            $date1 = new DateTime($LastInvoiceDate);
            $date2 = new DateTime($NextInvoiceDate);
            $interval = $date1->diff($date2);
            $BillingDays =  $interval->days;

            break;
        case 'fortnightly':
            $fortnightly_day = date("d", $BillingStartDate);
            if($fortnightly_day > 15){
                $NextInvoiceDate = date("Y-m-d", strtotime("first day of next month ",$BillingStartDate));
                $LastInvoiceDate = date("Y-m-16", $BillingStartDate);
            }else {
                $NextInvoiceDate = date("Y-m-16", $BillingStartDate);
                $LastInvoiceDate = date("Y-m-01", $BillingStartDate);
            }
            $date1 = new DateTime($LastInvoiceDate);
            $date2 = new DateTime($NextInvoiceDate);
            $interval = $date1->diff($date2);
            $BillingDays =  $interval->days;
            break;
        case 'quarterly':
            $quarterly_month = date("m", $BillingStartDate);
            if($quarterly_month < 4){
                $NextInvoiceDate = date("Y-m-d", strtotime("first day of april ",$BillingStartDate));
                $LastInvoiceDate = date("Y-m-d", strtotime("first day of january ",$BillingStartDate));
            }else if($quarterly_month > 3 && $quarterly_month < 7) {
                $NextInvoiceDate = date("Y-m-d", strtotime("first day of july ",$BillingStartDate));
                $LastInvoiceDate = date("Y-m-d", strtotime("first day of april ",$BillingStartDate));
            }else if($quarterly_month > 6 && $quarterly_month < 10) {
                $NextInvoiceDate = date("Y-m-d", strtotime("first day of october ",$BillingStartDate));
                $LastInvoiceDate = date("Y-m-d", strtotime("first day of july ",$BillingStartDate));
            }else if($quarterly_month > 9){
                $NextInvoiceDate = date("Y-01-01", strtotime('+1 year ',$BillingStartDate));
                $LastInvoiceDate = date("Y-m-d", strtotime("first day of october ",$BillingStartDate));
            }
            $date1 = new DateTime($LastInvoiceDate);
            $date2 = new DateTime($NextInvoiceDate);
            $interval = $date1->diff($date2);
            $BillingDays =  $interval->days;
            break;
    }
    return $BillingDays;
}
function getdaysdiff($date1,$date2){
    $date1 = new DateTime($date1);
    $date2 = new DateTime($date2);
    return $date2->diff($date1)->format("%R%a");
}
function apply_translation_rule($TranslationRule,$call_string){
    $replacement =$patternrules = array();
    if(!empty($TranslationRule)){
        $translation_rule = translation_rule($TranslationRule);
        $replacement =  $translation_rule['replacement'];
        $patternrules =  $translation_rule['patternrules'];
    }
    if(!empty($patternrules)){
        return preg_replace($patternrules,$replacement,$call_string);
    }else{
        return $call_string;
    }
}



