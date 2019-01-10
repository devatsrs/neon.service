<?php
namespace App\Lib;

use \Illuminate\Support\Facades\Log;
class NeonAPI
{





    public static function  endsWith($haystack, $needle) {
        // search forward starting from end minus needle length characters
        if ($needle === '') {
            return true;
        }
        $diff = \strlen($haystack) - \strlen($needle);
        return $diff >= 0 && strpos($haystack, $needle, $diff) !== false;
    }

    public static function callAPI($postdata,$call_method,$api_url)
    {
        $url = $api_url . $call_method;
        Log::info("Call API URL :" . $url);
        $APIresponse = array();
        $curl = curl_init();
        $auth = base64_encode(getenv("NEON_USER_NAME") . ':' . getenv("NEON_USER_PASSWORD"));
        curl_setopt_array($curl, array(
            CURLOPT_URL => $url,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_ENCODING => "",
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 30,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_CUSTOMREQUEST => "POST",
            CURLOPT_POSTFIELDS => http_build_query($postdata, '', '&'),
            CURLOPT_HTTPHEADER => array(
                "accept: application/json",
                "authorization: Basic " . $auth,
            ),
        ));

        $response = curl_exec($curl);
        $err = curl_error($curl);

        curl_close($curl);

        if ($err) {
            $APIresponse["error"] = $err;
        } else {
            $APIresponse["response"] = $response;
        }

        return $APIresponse;
    }
}