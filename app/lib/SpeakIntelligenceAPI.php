<?php
namespace App\Lib;

use Cartalyst\Stripe\Laravel\Facades\Stripe;
use Curl\Curl;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Log;

class SpeakIntelligenceAPI{

    public static function BalanceAlert($APIURL,$data=array()){

        log::info($APIURL);
        Log::info("Request : BalanceAlertDetails=");
        Log::info(print_r($data,true));
        $curl = new Curl();
        $curl->post($APIURL, array(
            'ActiveCallData' => $data,
	    ));
        $curl->close();
        $response = json_decode($curl->response);  
        return $response;
    }




}