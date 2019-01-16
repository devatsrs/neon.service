<?php
namespace App\Lib;

use \Illuminate\Support\Facades\Log;
use App\Lib\User;
use Illuminate\Support\Facades\Crypt;
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
        $auth = base64_encode(getenv("NEON_USER_NAME") . ':' . Crypt::decrypt(User::get_user_password(getenv("NEON_USER_NAME"))));
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
            Log::info("Call API URL :" . print_r($err,true));
        } else {
            $APIresponse["response"] = $response;
            Log::info("Call API URL :" . print_r($response,true));
        }

        return $APIresponse;
    }
}