<?php
function custom_replace( &$item, $key ) {
    $item = str_replace('usd', '{{sign}}', $item);
}
function generic_replace($data){
    return str_replace($data['extra'], $data['replace'], $data['text']);
}
function is_amazon(){
    $AMAZONS3_KEY  = getenv("AMAZONS3_KEY");
    $AMAZONS3_SECRET = getenv("AMAZONS3_SECRET");
    $AWS_REGION = getenv("AWS_REGION");

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

                $NextInvoiceDate = date("Y-m-d", strtotime("+1 month", $newDate ));

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

        if(strpos($date,":" !== FALSE )){
            $dateformat = $dateformat ." H:i:s";
        }
        if(strpos(strtolower($date),"am") !== FALSE  || strpos(strtolower($date),"pm")  !== FALSE ){
            $dateformat = $dateformat ." A";
        }
    }

    $_date_time = date_parse_from_format($dateformat, $date);

    if (isset($_date_time['warnings']) && $_date_time['warnings'] > 0 ) {

        throw new Exception($date . ': Error  ' . implode(",",$_date_time['warnings']));
    }

    if (isset($_date_time['error_count']) && $_date_time['error_count'] > 0 && isset($_date_time['errors'])) {

        throw new Exception($date . ': Error  ' . implode(",",$_date_time['errors']));
    }

    $datetime = $_date_time['year'].'-'.$_date_time['month'].'-'.$_date_time['day'];

    if(!empty($_date_time['hour']) && !empty($_date_time['minute']) && !empty($_date_time['second'])){
        $datetime = ' '. $_date_time['hour'].':'.$_date_time['minute'].':'.$_date_time['second'];
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
function searcharray($value, $key, $array) {
    foreach ($array as $k => $val) {
        if ($val[$key] == $value) {
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



