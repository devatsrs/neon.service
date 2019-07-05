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

    public static function callAPI($postdata,$call_method,$api_url,$contentType = '')
    {
        $url = $api_url . $call_method;
      //  Log::info("Call API URL :" . $url . '  ' . $postdata);
        $APIresponse = array();
        $curl = curl_init();


        //echo ' ' . Crypt::decrypt('eyJpdiI6IjRmZnRBQ1lKTm5ySEFlSU9hUHhha1E9PSIsInZhbHVlIjoiKytSU3JUK3FIdzRZaXhJRzhaNFwvbXc9PSIsIm1hYyI6IjllMmVhM2E1M2RkNzdlNjM5YmY3NGI2ZWUwMGQ1MDNmYjNjNmQwY2M2Y2Q1YWEwZGM5Nzg1NWU2OTBmYzQyOGEifQ==') . ' ';
        $auth = base64_encode(getenv("NEON_USER_NAME") . ':' . Crypt::decrypt(User::get_user_password(getenv("NEON_USER_NAME"))));

        $header = array(
            "accept: application/json",
            "authorization: Basic " . $auth,
        );

        if($contentType != '')
            $header[] = "content-type: " . $contentType;

        curl_setopt_array($curl, array(
            CURLOPT_URL => $url,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_ENCODING => "",
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 30,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_CUSTOMREQUEST => "POST",
            CURLOPT_POSTFIELDS => $postdata,
            CURLOPT_HTTPHEADER => $header,
        ));

        $response = curl_exec($curl);
        $err = curl_error($curl);
       // echo $response;
     //   $header_size = curl_getinfo($curl, CURLINFO_HEADER_SIZE);
      //  echo $header_size;
        $httpcode = curl_getinfo($curl, CURLINFO_HTTP_CODE);
      //  echo $httpcode;
        curl_close($curl);

        if ($httpcode != 200) {
            $APIresponse["error"] = $response;
            $APIresponse["HTTP_CODE"] = $httpcode;
          //  Log::info("Call API URL Error:" . print_r($APIresponse["error"],true));
        } else {
            $APIresponse["response"] = $response;
            $APIresponse["HTTP_CODE"] = $httpcode;
          //  Log::info("Call API URL Sucess:" . print_r($response,true));
        }

        return $APIresponse;
    }

    public static function callGetAPI($postdata,$call_method,$api_url)
    {
        $url = $api_url . $call_method;
        Log::info("Call GET API URL :" . $url);
        $APIresponse = array();
        $curl = curl_init();

        //echo ' Get Request ';
        try{
            //$auth = base64_encode(getenv("NEON_USER_NAME") . ':' . Crypt::decrypt(User::get_user_password(getenv("NEON_USER_NAME"))));
            curl_setopt_array($curl, array(
                CURLOPT_URL => $url,
                CURLOPT_RETURNTRANSFER => 1,
                CURLOPT_VERBOSE => 0,
                CURLOPT_HEADER => 1,
                CURLOPT_ENCODING => "",
                CURLOPT_MAXREDIRS => 10,
                CURLOPT_TIMEOUT => 120,
                CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
                CURLOPT_CUSTOMREQUEST => "GET",
                CURLOPT_POSTFIELDS => http_build_query($postdata, '', '&'),
                CURLOPT_HTTPHEADER => array(
                    "accept: */*",
                    'Authorization:Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJ3d3cuYXBpLnNwZWFraW50ZWxsaWdlbmNlLmNvbSIsImlhdCI6MTU0MzQwMTc0OCwiZXhwIjoxNTc0OTM3NzQ4LCJhdWQiOiJ3d3cuYXBpLnNwZWFraW50ZWxsaWdlbmNlLmNvbSIsInN1YiI6IiIsInVzZXJuYW1lIjoiVGVzdCIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6IlZlbmRvck1hbmFnZXIifQ.jdVEkXjR2q8swx8OFDNLQhJNSCtzM6y1P_TohN6ql-U',
                ),
            ));
            Log::info("Before curl_exec:" . $url);
            $response = curl_exec($curl);
            $err = curl_error($curl);
            Log::info("Next curl_exec:" . $url);
            $header_size = curl_getinfo($curl, CURLINFO_HEADER_SIZE);
            $header = substr($response, 0, $header_size);
            $body = substr($response, $header_size);
            Log::info("curl_close" . $url);
            curl_close($curl);
            if ($err) {
                $APIresponse["error"] = $err;
                Log::info("Call API URL Error:" . print_r($err,true));
            } else {
                $APIresponse["response"] = $body;
                Log::info("Call API URL Success:");
              // Log::info("Call API URL Success:" . print_r($response,true));
            }
            return $APIresponse;
        }catch (\Exception $e){
            Log::error('GET API Error:' . $e->getMessage());
            return $APIresponse["error"]="error";        

        }
    }

    public static function callPostAPI($postdata,$PricingJSONInput,$call_method,$api_url)
    {
        $url = $api_url . $call_method;
        Log::info("Call GET API URL :" . $url);
        $APIresponse = array();
        $curl = curl_init();


      //  echo ' Post Request ';
        // echo 'Authorization:"Bearer ' . 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJ3d3cuYXBpLnNwZWFraW50ZWxsaWdlbmNlLmNvbSIsImlhdCI6MTU0MzQwMTc0OCwiZXhwIjoxNTc0OTM3NzQ4LCJhdWQiOiJ3d3cuYXBpLnNwZWFraW50ZWxsaWdlbmNlLmNvbSIsInN1YiI6IiIsInVzZXJuYW1lIjoiVGVzdCIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6IlZlbmRvck1hbmFnZXIifQ.jdVEkXjR2q8swx8OFDNLQhJNSCtzM6y1P_TohN6ql-U' . '"';

        $auth = base64_encode(getenv("NEON_USER_NAME") . ':' . Crypt::decrypt(User::get_user_password(getenv("NEON_USER_NAME"))));
        curl_setopt_array($curl, array(
            CURLOPT_URL => $url,
            CURLOPT_RETURNTRANSFER => 1,
            CURLOPT_VERBOSE => 0,
            CURLOPT_HEADER => 1,
            CURLOPT_ENCODING => "",
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 120,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_CUSTOMREQUEST => "POST",
            CURLOPT_POSTFIELDS =>$PricingJSONInput,
            CURLOPT_HTTPHEADER => array(
                "accept: */*",
                'Authorization:Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJ3d3cuYXBpLnNwZWFraW50ZWxsaWdlbmNlLmNvbSIsImlhdCI6MTU0MzQwMTc0OCwiZXhwIjoxNTc0OTM3NzQ4LCJhdWQiOiJ3d3cuYXBpLnNwZWFraW50ZWxsaWdlbmNlLmNvbSIsInN1YiI6IiIsInVzZXJuYW1lIjoiVGVzdCIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6IlZlbmRvck1hbmFnZXIifQ.jdVEkXjR2q8swx8OFDNLQhJNSCtzM6y1P_TohN6ql-U',
            ),
        ));

        $response = curl_exec($curl);
        $err = curl_error($curl);

        $header_size = curl_getinfo($curl, CURLINFO_HEADER_SIZE);
        $header = substr($response, 0, $header_size);
        $body = substr($response, $header_size);

        curl_close($curl);

        if ($err) {
            $APIresponse["error"] = $err;
            Log::info("Call API URL Error:" . print_r($err,true));
        } else {
            $APIresponse["response"] = $body;
            Log::info("Call API URL Success body:" . $body);
            //Log::info("Call API URL Success 1:" . $response);
            // Log::info("Call API URL Success:" . print_r($response,true));
        }

        return $APIresponse;
    }

}