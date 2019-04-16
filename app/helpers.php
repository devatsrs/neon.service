<?php
function custom_replace( &$item, $key ) {
    $item = str_replace('usd', '{{Currency}}', $item);
}
//not in use
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
function change_timezone($billing_timezone,$timezone,$date,$CompanyID){
    $DEFAULT_TIMEZONE = \App\Lib\CompanyConfiguration::get($CompanyID,'DEFAULT_TIMEZONE');
    $DEFAULT_BILLING_TIMEZONE = \App\Lib\CompanyConfiguration::get($CompanyID,'DEFAULT_BILLING_TIMEZONE');
    if(empty($timezone)){
        $timezone = $DEFAULT_TIMEZONE;
    }
    if(empty($billing_timezone)){
        $billing_timezone = $DEFAULT_BILLING_TIMEZONE;
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
            case 'yearly':
                $NextInvoiceDate = date("Y-m-d", strtotime("+1 year", $BillingStartDate));
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
function searcharray($val1, $key1, $val2='',$key2='',$val3='',$key3='',$array) {
    foreach ($array as $k => $val) {
        if(array_search($val1,$val)== $key1 && array_search($val2,$val)== $key2 && array_search($val3,$val)== $key3){
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
    $minutes = $interval->h * 60;
    $minutes += $interval->i;
    return $minutes.' minutes '.$interval->s.' seconds';
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
function sippy_vos_areaprefix($area_prefix,$RateCDR, $RerateAccounts=0){
    if(($RateCDR == 1 && $RerateAccounts == 0) || empty($area_prefix) || strtolower($area_prefix) == 'null'){
        $area_prefix = 'Other';
    }
return $area_prefix;
}
function template_var_replace($EmailMessage,$replace_array){
    $extra = [
        '{{AccountName}}',
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
        '{{InvoiceGrandTotal}}',
        '{{InvoiceOutstanding}}',
        '{{OutstandingExcludeUnbilledAmount}}',
        '{{Signature}}',
        '{{OutstandingIncludeUnbilledAmount}}',
        '{{BalanceThreshold}}',
        '{{Currency}}',
        '{{CurrencySign}}',
        '{{CompanyName}}',
		"{{CompanyVAT}}",
		"{{CompanyAddress}}",
		"{{CompanyAddress1}}",
		"{{CompanyAddress2}}",
		"{{CompanyAddress3}}",
		"{{CompanyCity}}",
		"{{CompanyPostCode}}",
		"{{CompanyCountry}}",
		"{{Logo}}",
        "{{TrunkPrefix}}",
        "{{TrunkName}}",
        "{{CurrencyCode}}",
        "{{CurrencyDescription}}",
        "{{CurrencySymbol}}",
        "{{AccountBalance}}",
        "{{AccountExposure}}",
        "{{AccountBlocked}}",
        "{{InvoiceLink}}",
        "{{BillingAddress1}}",
        "{{BillingAddress2}}",
        "{{BillingAddress3}}",
        "{{BillingCity}}",
        "{{BillingPostCode}}",
        "{{BillingCountry}}",
        "{{BillingEmail}}",
        "{{CustomerID}}",
        "{{DirectDebit}}",
        "{{RegisterDutchFoundation}}",
        "{{COCNumber}}",
        "{{DutchProvider}}",
        "{{CountDown}}",
        "{{Date}}",
        "{{Time}}",

    ];

    foreach($extra as $item){
        $item_name = str_replace(array('{','}'),array('',''),$item);
        if(array_key_exists($item_name,$replace_array)) {
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
            $BillingDays = date("t", $BillingStartDate); // gives last day date 28,29 or 30,31
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
        case 'yearly':
            $year = date("Y",  $BillingStartDate);
            //multiple conditions to check the leap year
            if( (0 == $year % 4) and (0 != $year % 100) or (0 == $year % 400) ){
                $BillingDays = 366;
            } else {
                $BillingDays = 365;
            }
            break;

    }
    return $BillingDays;
}
function getdaysdiff($date1,$date2){
    $date1 = new DateTime($date1);
    $date2 = new DateTime($date2);
    return $date2->diff($date1)->format("%R%a");
}
/**
 * /^011//,/^0//,/[0-9]{10}$/1$0/ for US customer for voipnow to append 1 when strlen(cld) =10
 *  "/^.*(<.*>).*$/$1/,/<//,/>//" to keep only number inside <> ie. dev <123>
 * */
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

function cal_next_runtime($data){
    $strtotime_current = strtotime(date('Y-m-d H:i:00'));
    $strtotime = strtotime(date('Y-m-d H:i:00'));
    if(isset($data['Interval'])){
        $Interval = $data['Interval'];
    }
    if(isset($data['LastRunTime'])){
        $LastRunTime = $data['LastRunTime'];
    }
    if(isset($data['NextRunTime'])){
        $NextRunTime = $data['NextRunTime'];
    }
    if(isset($data['Day'])){
        $Day = $data['Day'];
    }
    if(isset($data['StartTime'])){
        $StartTime = $data['StartTime'];
    }
    if(isset($data['StartDay'])){
        $StartDay = $data['StartDay'];
    }
    switch($data['Time']) {
        case 'HOUR':
            if(isset($LastRunTime) && isset($NextRunTime) &&  $NextRunTime >= date('Y-m-d H:i:00') && $LastRunTime != ''){
                $strtotime = strtotime($LastRunTime);
                if(isset($Interval)){
                    $strtotime += $Interval*60*60;
                }
                if($strtotime_current > $strtotime){
                    $strtotime = $strtotime_current;
                }
            }
            $dayname = strtoupper(date('D'));
            if(isset($Day) && is_array($Day) && !in_array($dayname,$Day)){
                $strtotime = 0;
            }else if(isset($Day) && !is_array($Day) && $Day != $dayname){
                $strtotime = 0;
            }

            If(isset($StartTime) && date('Y-m-d H:i:00',strtotime(date('Y-m-d ').$StartTime)) > date('Y-m-d H:i:00')){
                $strtotime = 0;
            }
            return date('Y-m-d H:i:00',$strtotime);
        case 'MINUTE':
            if(isset($LastRunTime) && isset($NextRunTime) &&  $NextRunTime >= date('Y-m-d H:i:00') && $LastRunTime != ''){
                $strtotime = strtotime($LastRunTime);
                if(isset($Interval)){
                    $strtotime += $Interval*60;
                }
                if($strtotime_current > $strtotime){
                    $strtotime = $strtotime_current;
                }
            }
            $dayname = strtoupper(date('D'));
            if(isset($Day) && is_array($Day) && !in_array($dayname,$Day)){
                $strtotime = 0;
            }else if(isset($Day) && !is_array($Day) && $Day != $dayname){
                $strtotime = 0;
            }
            If(isset($StartTime) && date('Y-m-d H:i:00',strtotime(date('Y-m-d ').$StartTime)) > date('Y-m-d H:i:00')){
                $strtotime = 0;
            }
            return date('Y-m-d H:i:00',$strtotime);
        case 'DAILY':
            if(isset($LastRunTime) && isset($NextRunTime) &&  $NextRunTime >= date('Y-m-d H:i:00') && $LastRunTime != ''){
                $strtotime = strtotime($LastRunTime);
                if(isset($Interval)){
                    $strtotime += $Interval*60*60*24;
                }
                if($strtotime_current > $strtotime){
                    $strtotime = $strtotime_current;
                }
            }
            $dayname = strtoupper(date('D'));
            if(isset($Day) && is_array($Day) && !in_array($dayname,$Day)){
                $strtotime = 0;
            }else if(isset($Day) && !is_array($Day) && $Day != $dayname){
                $strtotime = 0;
            }
            If(isset($StartTime) && date('Y-m-d H:i:00',strtotime(date('Y-m-d ').$StartTime)) > date('Y-m-d H:i:00')){
                $strtotime = 0;
            }
            return date('Y-m-d H:i:00',$strtotime);
        case 'WEEKLY':
            if(isset($LastRunTime) && isset($NextRunTime) &&  $NextRunTime >= date('Y-m-d H:i:00') && $LastRunTime != ''){
                $strtotime = strtotime($LastRunTime);
                if(isset($Interval)){
                    $strtotime = strtotime("+$Interval week", $strtotime);
                }
                if($strtotime_current > $strtotime){
                    $strtotime = $strtotime_current;
                }
            }

            $dayname = strtoupper(date('D'));
            if(isset($Day) && is_array($Day) && !in_array($dayname,$Day)){
                $strtotime = 0;
            }else if(isset($Day) && !is_array($Day) && $Day != $dayname){
                $strtotime = 0;
            }
            If(isset($StartTime) && date('Y-m-d H:i:00',strtotime(date('Y-m-d ').$StartTime)) > date('Y-m-d H:i:00')){
                $strtotime = 0;
            }
            if(isset($StartDay) && date('d',$strtotime) != $StartDay){
                $strtotime = 0;
            }
            return date('Y-m-d H:i:00',$strtotime);
        case 'MONTHLY':
            if(isset($LastRunTime) && isset($NextRunTime) &&  $NextRunTime >= date('Y-m-d H:i:00') && $LastRunTime != ''){
                $strtotime = strtotime($LastRunTime);
                if(isset($Interval)){
                    $strtotime = strtotime("+$Interval month", $strtotime);
                }
                if($strtotime_current > $strtotime){
                    $strtotime = $strtotime_current;
                }
            }

            $dayname = strtoupper(date('D'));
            if(isset($Day) && is_array($Day) && !in_array($dayname,$Day)){
                $strtotime = 0;
            }else if(isset($Day) && !is_array($Day) && $Day != $dayname){
                $strtotime = 0;
            }
            If(isset($StartTime) && date('Y-m-d H:i:00',strtotime(date('Y-m-d ').$StartTime)) > date('Y-m-d H:i:00')){
                $strtotime = 0;
            }
            if(isset($StartDay) && date('d',$strtotime) != $StartDay){
                $strtotime = 0;
            }
            return date('Y-m-d H:i:00',$strtotime);
        case 'YEARLY':
            if(isset($LastRunTime) && isset($NextRunTime) &&  $NextRunTime >= date('Y-m-d H:i:00') && $LastRunTime != ''){
                $strtotime = strtotime($LastRunTime);
                if(isset($Interval)){
                    $strtotime = strtotime("+$Interval year", $strtotime);
                }
                if($strtotime_current > $strtotime){
                    $strtotime = $strtotime_current;
                }
            }

            $dayname = strtoupper(date('D'));
            if(isset($Day) && is_array($Day) && !in_array($dayname,$Day)){
                $strtotime = 0;
            }else if(isset($Day) && !is_array($Day) && $Day != $dayname){
                $strtotime = 0;
            }
            If(isset($StartTime) && date('Y-m-d H:i:00',strtotime(date('Y-m-d ').$StartTime)) > date('Y-m-d H:i:00')){
                $strtotime = 0;
            }
            if(isset($StartDay) && date('d',$strtotime) != $StartDay){
                $strtotime = 0;
            }
            return date('Y-m-d H:i:00',$strtotime);
        default:
            return '';
    }
}

function next_run_time($data){

    $Interval = $data['Interval'];
    if(isset($data['StartTime'])) {
        $StartTime = $data['StartTime'];
    }
    if(isset($data['LastRunTime'])){
        $LastRunTime = $data['LastRunTime'];
    }else{
        $LastRunTime = date('Y-m-d H:i:00');
    }
    switch($data['Time']) {
        case 'HOUR':
            if($LastRunTime == ''){
                $strtotime = strtotime('+'.$Interval.' hour');
            }else{
                $strtotime = strtotime($LastRunTime)+$Interval*60*60;
            }
            return date('Y-m-d H:i:00',$strtotime);
        case 'MINUTE':
            if($LastRunTime == ''){
                $strtotime = strtotime('+'.$Interval.' minute');
            }else{
                $strtotime = strtotime($LastRunTime)+$Interval*60;
            }
            return date('Y-m-d H:i:00',$strtotime);
        case 'DAILY':
            if($LastRunTime == ''){
                $strtotime = strtotime('+'.$Interval.' day');
            }else{
                $strtotime = strtotime($LastRunTime)+$Interval*60*60*24;
            }
            if(isset($StartTime)){
                return date('Y-m-d',$strtotime).' '.date("H:i:00", strtotime("$StartTime"));
            }
            return date('Y-m-d H:i:00',$strtotime);
        case 'WEEKLY':
            if($LastRunTime == ''){
                $strtotime = strtotime('+'.$Interval.' week');
            }else{
                $strtotime = strtotime("+$Interval week", strtotime($LastRunTime));
            }
            if(isset($StartTime)){
                return date('Y-m-d',$strtotime).' '.date("H:i:00", strtotime("$StartTime"));
            }
            return date('Y-m-d H:i:00',$strtotime);
        case 'MONTHLY':
            if($LastRunTime == ''){
                $strtotime = strtotime('+'.$Interval.' month');
            }else{
                $strtotime = strtotime("+$Interval month", strtotime($LastRunTime));
            }
            if(isset($StartTime)){
                return date('Y-m-d',$strtotime).' '.date("H:i:00", strtotime("$StartTime"));
            }
            return date('Y-m-d H:i:00',$strtotime);
        case 'YEARLY':
            if($LastRunTime == ''){
                $strtotime = strtotime('+'.$Interval.' year');
            }else{
                $strtotime = strtotime("+$Interval year", strtotime($LastRunTime));
            }
            if(isset($StartTime)){
                return date('Y-m-d',$strtotime).' '.date("H:i:00", strtotime("$StartTime"));
            }
            return date('Y-m-d H:i:00',$strtotime);
        default:
            return '';

    }
}

function check_account_age($settings,$Key,$getdaysdiff){

    if(isset($settings['Age'][$Key]) && intval($settings['Age'][$Key]) > 0 && $getdaysdiff >= $settings['Age'][$Key]){
        return true;
    }else if(isset($settings['Age'][$Key]) && intval($settings['Age'][$Key]) == 0){
        return true;
    }
    return false;
}

function validator_response($validator){


    if ($validator->fails()) {
        $errors = "";
        foreach ($validator->messages()->all() as $error){
            $errors .= $error."<br>";
        }
        return  array("status" => "failed", "message" => $errors);
    }

}

function MakeWebUrl($CompanyID,$path){
	return \App\Lib\CompanyConfiguration::getValueConfigurationByKey($CompanyID,'WEB_URL')."/download_file?file=".base64_encode($path);
}

function remove_extra_columns($usage_data,$usage_data_table){
    foreach ($usage_data as $row_key => $usage_data_row) {
        if (isset($usage_data_row['DurationInSec'])) {
            unset($usage_data_row['DurationInSec']);
        }
        if (isset($usage_data_row['BillDurationInSec'])) {
            unset($usage_data_row['BillDurationInSec']);
        }
        if (isset($usage_data_row['ServiceID'])) {
            unset($usage_data_row['ServiceID']);
        }
		$usage_data_row = array_replace(array_flip($usage_data_table['order']),$usage_data_row);
		$usage_data_row = array_intersect_key($usage_data_row, array_flip($usage_data_table['order']));
        foreach($usage_data_table['header'] as $table_h_row){
            if($table_h_row['Title'] != $table_h_row['UsageName'] && isset($usage_data_row[$table_h_row['Title']])){
                $table_h_row['UsageName'] = str_replace("<br>"," ",$table_h_row['UsageName']);
				 $keys = array_keys($usage_data_row);
				 $index = array_search($table_h_row['Title'], $keys);
				 $keys[$index] = $table_h_row['UsageName'];
				 $usage_data_row = array_combine($keys, array_values($usage_data_row));
            }
        }

        $usage_data[$row_key] = $usage_data_row;
    }
    return $usage_data;

}
function getUsageColumns($InvoiceTemplate){
    if(empty($InvoiceTemplate->UsageColumn)){
        $UsageColumn = \App\Lib\InvoiceTemplate::defaultUsageColumns();
    }else{
        $UsageColumn = json_decode($InvoiceTemplate->UsageColumn,true);
    }
    if($InvoiceTemplate->CDRType == \App\Lib\Account::SUMMARY_CDR){
        $UsageColumn = $UsageColumn['Summary'];
    }else{
        $UsageColumn = $UsageColumn['Detail'];
    }

    return $UsageColumn;
}

function get_client_ip() {
    $ipaddress = '';
    if (isset($_SERVER['HTTP_CLIENT_IP']))
        $ipaddress = $_SERVER['HTTP_CLIENT_IP'];
    else if(isset($_SERVER['HTTP_X_FORWARDED_FOR']))
        $ipaddress = $_SERVER['HTTP_X_FORWARDED_FOR'];
    else if(isset($_SERVER['HTTP_X_FORWARDED']))
        $ipaddress = $_SERVER['HTTP_X_FORWARDED'];
    else if(isset($_SERVER['HTTP_FORWARDED_FOR']))
        $ipaddress = $_SERVER['HTTP_FORWARDED_FOR'];
    else if(isset($_SERVER['HTTP_FORWARDED']))
        $ipaddress = $_SERVER['HTTP_FORWARDED'];
    else if(isset($_SERVER['REMOTE_ADDR']))
        $ipaddress = $_SERVER['REMOTE_ADDR'];
    else
        $ipaddress = 'UNKNOWN';
    return $ipaddress;

}

function extract_ip($data_remote_ip){
    if (preg_match('/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/', $data_remote_ip, $ip)) {
        $data_remote_ip = array_pop($ip);
    }
    return $data_remote_ip;
}

function cus_lang($key=""){
    return trans('routes.'.strtoupper($key));
}

function getCompanyLogo($CompanyID){
    $logo_url 				= combile_url_path(\App\Lib\CompanyConfiguration::getValueConfigurationByKey($CompanyID,'WEB_URL'),'assets/images/logo@2x.png');


    $domain_data  =     parse_url(\App\Lib\CompanyConfiguration::getValueConfigurationByKey($CompanyID,'WEB_URL'));
    $Host		  = 	$domain_data['host'];
    $result       =    \Illuminate\Support\Facades\DB::table('tblCompanyThemes')->where(["DomainUrl" => $Host,'ThemeStatus'=>\App\Lib\Themes::ACTIVE])->first();

    if(!empty($result)){

        if(!empty($result->Logo)){
            $path = \App\Lib\AmazonS3::unSignedUrl($result->Logo,$CompanyID);
            if(strpos($path, "https://") !== false){
                $logo_url = $path;
            }else if(!empty($path)){
                $logo_url = get_image_data($path);
            }
        }
    }
    return $logo_url;
}

function filterArrayRemoveNewLines($arr) { // remove new lines (/r/n) etc...
    //return preg_replace('/s+/', ' ', trim($arr));
    foreach ($arr as $key => $value) {
        $oldkey = $key;
        /*$key = str_replace("\r", '', $key);
        $key = str_replace("\n", '', $key);*/
        $key = trim(preg_replace('/\s+/', ' ',$key));
        $arr[$key] = $value;
        if($key != $oldkey)
            unset($arr[$oldkey]);
    }
    return $arr;
}

function array_key_exists_wildcard ( $arr, $search ) {
    $search = str_replace( '*', '###star_needle###', $search );
    $search = preg_quote( $search, '/' ); # This is important!
    $search = str_replace( '###star_needle###', '.*?', $search );
    $search = '/^' . $search . '$/i';

    return preg_grep( $search, array_keys( $arr ) );
}

function getCompanyDecimalPlaces($CompanyID, $value=""){
    $RoundChargesAmount = \App\Lib\CompanySetting::getKeyVal($CompanyID,'RoundChargesAmount');
    $RoundChargesAmount=($RoundChargesAmount !='Invalid Key')?$RoundChargesAmount:2;

    if(!empty($value) && is_numeric($value)){
        $formatedValue=number_format($value, $RoundChargesAmount);
        if($formatedValue){
            return $formatedValue;
        }
        return $value;
    }else{
        return $RoundChargesAmount;
    }
}

function terminateMysqlProcess($pid){
    $cmd="KILL ".$pid;
    DB::connection('sqlsrv2')->select($cmd);

}

function removeSpaceFromArrayKey($arr=array()){
    if(!empty($arr)){
        $a = array_map('trim', array_keys($arr));
        $b = array_map('trim', $arr);
        $arr = array_combine($a, $b);
    }
    return $arr;
}