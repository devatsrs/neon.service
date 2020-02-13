<?php
namespace App\Lib;
use App\Lib\SiteIntegration;
use Illuminate\Support\Facades\Log;

class Exact
{
    private $BaseURL            = 'https://start.exactonline.nl';
    private $CompanyID          = '';
    private $redirectUrl        = '';
    private $client_id          = '';
    private $client_secret      = '';
    private $CurrentDivision    = '';

    private static $METHOD_POST     = 'POST';
    private static $METHOD_GET      = 'GET';
    private static $METHOD_PUT      = 'PUT';
    private static $METHOD_DELETE   = 'DELETE';

    public function __construct($CompanyID) {
        $this->CompanyID     = $CompanyID;
        $this->redirect_url  = CompanyConfiguration::get($CompanyID, 'WEB_URL') . "/exact";

        /*$ExactIntegration       = Integration::where(['CompanyID'=>$CompanyID,'Slug'=>ExactAuthentication::ExactConfigKey])->first();
        $EXACT_CONFIGURATION    = IntegrationConfiguration::where(array('CompanyId'=>$CompanyID,"IntegrationID"=>$ExactIntegration->IntegrationID))->first();
        $EXACT_CONFIGURATION    = json_decode($EXACT_CONFIGURATION->Settings, true);*/
        //$EXACT_CONFIGURATION    = json_decode(CompanyConfiguration::get($CompanyID, ExactAuthentication::ExactConfigKey), true);

        $EXACT_CONFIGURATION = SiteIntegration::CheckIntegrationConfiguration(true,ExactAuthentication::ExactConfigKey,$CompanyID);
        $EXACT_CONFIGURATION = json_decode(json_encode($EXACT_CONFIGURATION), true);

        if(!empty($EXACT_CONFIGURATION['ExactClientID']) && !empty($EXACT_CONFIGURATION['ExactClientSecret'])) {
            $this->client_id     = $EXACT_CONFIGURATION['ExactClientID'];
            $this->client_secret = $EXACT_CONFIGURATION['ExactClientSecret'];
        }
    }

    public function getAccessToken()
    {
        $response = array();
        $Authentication = ExactAuthentication::where(['CompanyID'=>$this->CompanyID])->first();

        if(!empty($Authentication)) {
            $CurrentTime        = strtotime(date('Y-m-d H:i:s'));
            $last_updated_at    = strtotime($Authentication->last_updated_at);
            $time_difference    = $CurrentTime-$last_updated_at;

            // check if token expire time exhausted
            if($time_difference >= $Authentication->expires_in) {
                $response = $this->refreshAccessToken();
            } else {
                $response['access_token'] = $Authentication->access_token;
            }
        } else {
            $response['faultCode']      = "";
            $response['faultString']    = "Access Token doesn't exist, Need to generate from frontend for the first time.";
        }

        return $response;
    }

    public function refreshAccessToken()
    {
        $response = array();
        $URL = ExactAuthentication::TOKEN_URL;
        $Authentication = ExactAuthentication::where(['CompanyID'=>$this->CompanyID])->first();

        $post_data['grant_type']     = ExactAuthentication::RESPONSE_TYPE_REFRESH;
        $post_data['refresh_token']  = $Authentication->refresh_token;
        $post_data['client_id']      = $this->client_id;
        $post_data['client_secret']  = $this->client_secret;

        $RequestType = self::$METHOD_POST;

        try {
            $result = $this->callAPI($RequestType,$URL,$post_data);

            if (!empty($result) && !isset($result['error'])) {
                $AuthData['access_token']       = $result['access_token'];
                $AuthData['refresh_token']      = $result['refresh_token'];
                $AuthData['expires_in']         = $result['expires_in'];
                $AuthData['last_updated_at']    = date('Y-m-d H:i:s');

                if($Authentication->update($AuthData)) {
                    $response['access_token'] = $Authentication->access_token;
                } else {
                    $response['faultCode']      = "";
                    $response['faultString']    = "Error while updating access_token in database.";
                }
            } else {
                $Company = Company::find($this->CompanyID);
                $error = isset($result['error']['message']) ? $result['error']['message'] : 'refreshAccessToken : No response from Exact API';
                $error = isset($result['error']) && isset($result['error_description']) ? $result['error'].', '.$result['error_description'].' Company: '.$Company->CompanyName : $error;
                $response['faultCode']      = !empty($result['error']['code']) ? $result['error']['code'] : "";
                $response['faultString']    = $error;
            }
        } catch (Exception $e) {
            $response['faultString']    = $e->getMessage();
            $response['faultCode']      = $e->getCode();
            Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $e->getCode(). ", Reason: " . $e->getMessage());
            throw new Exception($e->getMessage());
        }
        return $response;
    }

    public function getDivision()
    {
        $URL    = ExactAuthentication::DIVISION_URL;
        $filter = array();
        $select = "CurrentDivision";

        $response = $this->get($URL,$filter,$select);

        return $response;
    }

    public function getAccount($AccountNumber)
    {
        $URL    = ExactAuthentication::ACCOUNT_URL;
        $filter = ["trim(Code)"=>"'".$AccountNumber."'"];
        $select = "ID,Name,Code";

        $response = $this->get($URL,$filter,$select);

        return $response;
    }

    public function getItem($ItemName)
    {
        $URL    = ExactAuthentication::ITEM_URL;
        $filter = ["trim(Code)"=>"'".$ItemName."'"];
        $select = "ID,Description,Code";

        $response = $this->get($URL,$filter,$select);

        return $response;
    }

    public function createSalesInvoice($data)
    {
        $URL        = ExactAuthentication::SALES_INVOICE_URL;
        $response   = $this->post($URL,$data);

        return $response;
    }

    public function getSalesInvoiceLines($InvoiceID)
    {
        $URL    = ExactAuthentication::SALES_INVOICE_LINE_URL;
        $filter = ["InvoiceID"=>"guid'".$InvoiceID."'"];
        $select = "ItemCode,ItemDescription,CostUnit,AmountDC,GLAccount";

        $response = $this->get($URL,$filter,$select);

        return $response;
    }

    public function createSalesEntry($data)
    {
        $URL        = ExactAuthentication::SALES_ENTRY_URL;
        $response   = $this->post($URL,$data);

        return $response;
    }

    public function getSalesEntry($EntryID)
    {
        $URL    = ExactAuthentication::SALES_ENTRY_URL;
        $filter = ["EntryID"=>"guid'".$EntryID."'"];
        $select = "YourRef,AmountFC,Status";

        $response = $this->get($URL,$filter,$select);

        return $response;
    }

    public function getReceivablesListByAccount($AccountId)
    {
        $URL    = ExactAuthentication::RECEIVABLESLISTBYACCOUNT;
        $filter = "AccountId=guid'".$AccountId."'";
        $select = "InvoiceNumber,YourRef,DueDate,Amount";

        $response = $this->get($URL,$filter,$select);

        return $response;
    }

    public function getSalesEntryLines($EntryID)
    {
        $URL    = ExactAuthentication::SALES_ENTRY_LINE_URL;
        $filter = ["EntryID"=>"guid'".$EntryID."'"];
        $select = "Description,CostUnit,AmountDC,GLAccount";

        $response = $this->get($URL,$filter,$select);

        return $response;
    }

    public function getGLAccount($GLCode)
    {
        $URL    = ExactAuthentication::GLACCOUNTS_URL;
        $filter = ["trim(Code)"=>"'".$GLCode."'"];
        $select = "ID,Code,Description";

        $response = $this->get($URL,$filter,$select);

        return $response;
    }

    public function getDocumentType($Type)
    {
        $URL    = ExactAuthentication::DOCUMENT_TYPES_URL;
        $filter = ["trim(Description)"=>"'".$Type."'"];
        $select = "ID,Description";

        $response = $this->get($URL,$filter,$select);

        return $response;
    }

    public function createDocument($data)
    {
        $URL        = ExactAuthentication::DOCUMENT_URL;
        $response   = $this->post($URL,$data);

        return $response;
    }

    public function deleteDocument($data)
    {
        $URL        = ExactAuthentication::DOCUMENT_URL;
        $response   = $this->delete($URL,$data);

        return $response;
    }

    public function uploadDocumentFile($data,$FilePath)
    {
        if(file_exists($FilePath)) {
            //convert file to binary
            $file_data          = file_get_contents($FilePath);
            $binary_file        = base64_encode($file_data);
            $data['Attachment'] = $binary_file;

            $URL = ExactAuthentication::DOCUMENT_ATTACHMENTS_URL;
            $response = $this->post($URL, $data);
        } else {
            $response['faultCode']      = "";
            $response['faultString']    = "File does not exist, File : ".$FilePath;
        }
        return $response;
    }

    public function getJournal($Type)
    {
        //Type of Journal. The following values are supported: 10 (Cash) 12 (Bank) 16 (Payment service) 20 (Sales) 21 (Return invoice) 22 (Purchase) 23 (Received return invoice) 90 (General journal)
        $URL        = ExactAuthentication::JOURNALS_URL;
        $filter     = ["Type"=>$Type];
        $select     = "ID,Code,Description,Type";

        $response   = $this->get($URL,$filter,$select);

        return $response;
    }

    public function setDivision($Division) {
        $this->CurrentDivision = $Division;
    }

    public function get($URL,$filter,$select)
    {
        $response       = array();
        $RequestType    = self::$METHOD_GET;

        if(!empty($filter)) {
            if(is_array($filter)) {
                $post_data['$filter'] = "";
                foreach ($filter as $key => $value) {
                    $post_data['$filter'] = "$key eq " . $value . " and ";
                }
                $post_data['$filter'] = trim($post_data['$filter'], ' and ');
            } else {
                $filter = explode('=',$filter);
                $post_data[$filter[0]] = $filter[1];
            }
        }
        $post_data['$select']   = $select;//"ID,Description,Code";

        try {
            $result = $this->callAPI($RequestType,$URL,$post_data);

            if (!empty($result) && !isset($result['error'])) {
                $response = $result;
            } else {
                $error = isset($result['error']) ? $result['error']['message'] : $URL.' : No response from Exact API';
                $response['faultCode']      = !empty($result['error']['code']) ? $result['error']['code'] : "";
                $response['faultString']    = $error;
                if(!isset($result['error'])) {
                    $response['nodata'] = 1;
                }
            }
        } catch (Exception $e) {
            $response['faultString']    = $e->getMessage();
            $response['faultCode']      = $e->getCode();
            Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $e->getCode(). ", Reason: " . $e->getMessage());
            throw new Exception($e->getMessage());
        }
        return $response;
    }

    public function post($URL,$data)
    {
        $response       = array();
        $RequestType    = self::$METHOD_POST;

        try {
            $result = $this->callAPI($RequestType,$URL,$data);

            if (!empty($result) && !isset($result['error'])) {
                $response = $result;
            } else {
                $error = isset($result['error']) ? $result['error']['message'] : $URL.' : No response from Exact API';
                $response['faultCode']      = !empty($result['error']['code']) ? $result['error']['code'] : "";
                $response['faultString']    = $error;
            }
        } catch (Exception $e) {
            $response['faultString']    = $e->getMessage();
            $response['faultCode']      = $e->getCode();
            Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $e->getCode(). ", Reason: " . $e->getMessage());
            throw new Exception($e->getMessage());
        }
        return $response;
    }

    public function delete($URL,$data)
    {
        $response       = array();
        $RequestType    = self::$METHOD_DELETE;

        try {
            $result = $this->callAPI($RequestType,$URL,$data);

            if (!empty($result) && !isset($result['error'])) {
                $response = $result;
            } else {
                $error = isset($result['error']) ? $result['error']['message'] : $URL.' : No response from Exact API';
                $response['faultCode']      = !empty($result['error']['code']) ? $result['error']['code'] : "";
                $response['faultString']    = $error;
            }
        } catch (Exception $e) {
            $response['faultString']    = $e->getMessage();
            $response['faultCode']      = $e->getCode();
            Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $e->getCode(). ", Reason: " . $e->getMessage());
            throw new Exception($e->getMessage());
        }
        return $response;
    }

    public function callAPI($RequestType='POST',$API_URL,$data) {
        $URL = ExactAuthentication::BASE_URL.''.$API_URL;
        $request_headers = [];
        $access_token = '';
        //Log::info([$RequestType,$API_URL,$data]);
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, true);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

        if($API_URL != ExactAuthentication::AUTH_URL && $API_URL != ExactAuthentication::TOKEN_URL) {

            $result_access_token = $this->getAccessToken();
            if(!empty($result_access_token['access_token'])) {
                $access_token = $result_access_token['access_token'];
                $request_headers[] = 'Authorization: Bearer ' . $access_token;
            } else {
                return $result_access_token;
            }

            //if($RequestType==self::$METHOD_GET) {
                $request_headers[] = 'Accept: application/json';
                $request_headers[] = 'Content-Type: application/json';
                $request_headers[] = 'Prefer: return=representation';
            //}

            /*if($API_URL != ExactAuthentication::DIVISION_URL) {
                if(empty($this->CurrentDivision)) {
                    $division = $this->getDivision();

                    if (!empty($division[0]['CurrentDivision'])) {
                        $this->CurrentDivision = $division[0]['CurrentDivision'];
                    }
                }
                //array_walk_recursive($division, array($this, 'getCurrentDivisionFromArray'));

                $URL = str_replace('{division}', $this->CurrentDivision, $URL);
            }*/
            $URL = str_replace('{division}', $this->CurrentDivision, $URL);
        } else {
            $request_headers[] = 'Content-Type: application/x-www-form-urlencoded';
        }

        if($RequestType==self::$METHOD_POST) {
            curl_setopt($ch, CURLOPT_POST, 1);

            if($API_URL == ExactAuthentication::AUTH_URL || $API_URL == ExactAuthentication::TOKEN_URL) {
                curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data, '', '&'));
            } else {
                /*$request_headers[] = 'access_token:' . $access_token;
                $request_headers[] = 'Content-Type: application/json';
                $request_headers[] = 'Content-length: ' . strlen(json_encode($data));*/

                curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
            }
        } else if($RequestType==self::$METHOD_DELETE) { // $RequestType=='DELETE'
            if(!empty($data['ID'])) {
                $URL .= "(guid'".$data['ID']."')";
            }
            curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $RequestType);
        } else { // $RequestType=='GET'
            //$request_headers[] = 'Authorization: Bearer ' . $access_token;

            if(!empty($data)) {
                $URL .= '?';
                foreach ($data as $key => $value) {
                    $URL .= $key.'='.$value.'&';
                }
            }
        }

        $URL = trim($URL,'&');
        Log::info($URL);

        curl_setopt($ch, CURLOPT_URL, $URL);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $request_headers);
        //curl_setopt($ch, CURLOPT_HEADER, true); // to get response headers

        curl_setopt($ch, CURLOPT_HEADERFUNCTION,
            function($curl, $header) use (&$headers)
            {
                $len = strlen($header);
                $header = explode(':', $header, 2);
                if (count($header) < 2) // ignore invalid headers
                    return $len;

                $headers[strtolower(trim($header[0]))][] = trim($header[1]);

                return $len;
            }
        );

        $result     = curl_exec($ch);
        $statusCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $result     = $this->parseResponse($result,$headers,$statusCode);

        return $result;
    }

    public function parseResponse($response,$headers,$statusCode)
    {
        $limit_array_keys = array('x-ratelimit-limit','x-ratelimit-remaining','x-ratelimit-reset','x-ratelimit-minutely-limit','x-ratelimit-minutely-remaining','x-ratelimit-minutely-reset');
        //Log::info([$response,$headers]);
        $response = json_decode($response, true);

        $limit_array = [];
        foreach ($headers as $key => $value) {
            if(in_array($key,$limit_array_keys)) {
                $limit_array[$key] = $value[0];
            }
        }

        if(isset($limit_array['x-ratelimit-minutely-remaining']) && $limit_array['x-ratelimit-minutely-remaining'] <= 1) {
            $CurrentTime    = (time()*1000);//round(microtime(true) * 1000); // epoch time in milliseconds
            $SleepTime      = ($limit_array['x-ratelimit-minutely-reset'] - $CurrentTime)/1000;
            $SleepTime      += 1;
            //Log::info("Sleep : ".$SleepTime);
            sleep($SleepTime);
        }

        if(isset($response['d']['results']))  {
            $response = $response['d']['results'];
        } else if (isset($response['d']))  {
            $response = $response['d'];
        } else if (isset($response['error']['message']['value']))  {
            //$response['error']['code']      = $response['error']['code'];
            $response['error']['message']   = $response['error']['message']['value'];
        }

        /*$response['limit_array'] 	= $limit_array;
        $response['headers'] 		= $headers;
        $response['statusCode'] 	= $statusCode;*/

        return $response;
    }

}
