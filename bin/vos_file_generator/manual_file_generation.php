<?php
// copy this script in temp command and generate script

//generate duplicate file /home/webcdr/bin/extract_vos3000_data and change output directory
///home/webcdr/bin/extract_vos3000_data_cus

// Start date
$date = '2018-05-25 00:00:00';
// End date
$end_date = '2018-05-31';

$date = date("Y-m-d H:i:s", strtotime("-30 minute", strtotime($date)));

while (strtotime($date) <= strtotime($end_date)) {

    $date = date ("Y-m-d H:i:s", strtotime("+30 minute", strtotime($date)));
    $end = date ("Y-m-d H:i:s", strtotime("+30 minute", strtotime($date)));

    if(isset($datetimefrom)){
        $date1 = date("Y-m-d H:i:s", strtotime("+1 second", strtotime($date)));
        $datetimefrom = date("YmdHis",strtotime($date1));

    } else {
        $datetimefrom = date("YmdHis",strtotime($date));
    }

    $datetimeto = date("YmdHis",strtotime($end));


    echo "\n /home/webcdr/bin/extract_vos3000_data_cus --start-time $datetimefrom --end-time $datetimeto";

}
