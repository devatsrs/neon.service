<?php


namespace App\Lib;


class PaymentGateway extends \Eloquent {
    protected $fillable = [];
    protected $table = "tblPaymentGateway";
    protected $primaryKey = "PaymentGatewayID";
    protected $guarded = array('PaymentGatewayID');

    public static function getName($PaymentGatewayID)
    {
        return PaymentGateway::where(array('PaymentGatewayID' => $PaymentGatewayID))->pluck('Title');
    }

    public static function addTransaction($PaymentGateway,$amount,$options,$account,$AccountPaymentProfileID)
    {
        switch($PaymentGateway) {
            case 'AuthorizeNet':
                $transaction = self::addAuthorizeNetTransaction($amount,$options);
                $Notes = '';
                if($transaction->response_code == 1) {
                    $Notes = 'AuthorizeNet transaction_id ' . $transaction->transaction_id;
                    $Status = TransactionLog::SUCCESS;
                }else{
                    $Status = TransactionLog::FAILED;
                    $Notes = $transaction->error_message;
                    AccountPaymentProfile::setProfileBlock($AccountPaymentProfileID);
                }
                $transactionResponse['transaction_id'] = $transaction->transaction_id;
                $transactionResponse['transaction_notes'] =$Notes;
                $transactionResponse['response_code'] = $transaction->response_code;
                $transactionResponse['transaction_payment_method'] = 'CREDIT CARD';
                $transactionResponse['failed_reason'] =$transaction->response_reason_text;
                $transactiondata = array();
                $transactiondata['CompanyID'] = $account->CompanyId;
                $transactiondata['AccountID'] = $account->AccountID;
                $transactiondata['Transaction'] = $transaction->transaction_id;
                $transactiondata['Notes'] = $Notes;
                $transactiondata['Amount'] = floatval($transaction->amount);
                $transactiondata['Status'] = $Status;
                $transactiondata['created_at'] = date('Y-m-d H:i:s');
                $transactiondata['updated_at'] = date('Y-m-d H:i:s');
                $transactiondata['CreatedBy'] = 'RMScheduler';
                $transactiondata['ModifyBy'] = 'RMScheduler';
                $transactiondata['Reposnse'] = json_encode($transaction);
                TransactionLog::insert($transactiondata);
                return $transactionResponse;
            case '':
                return '';

        }

    }

    public static function addAuthorizeNetTransaction($amount, $options)
    {
		$AuthorizeDbData 					= 	\App\Lib\SiteIntegration::is_authorize_configured(true);
		$AuthorizeData						=	isset($AuthorizeDbData->Settings)?json_decode($AuthorizeDbData->Settings):array();	
		$AUTHORIZENET_API_LOGIN_ID  		= 	isset($AuthorizeData->AuthorizeLoginID)?$AuthorizeData->AuthorizeLoginID:'';		
		$AUTHORIZENET_TRANSACTION_KEY  		= 	isset($AuthorizeData->AuthorizeTransactionKey)?$AuthorizeData->AuthorizeTransactionKey:'';
		$isSandbox							=	isset($AuthorizeDbData->AuthorizeTestAccount)?$AuthorizeDbData->AuthorizeTestAccount:'';
		
        define("AUTHORIZENET_API_LOGIN_ID", $AUTHORIZENET_API_LOGIN_ID);
        define("AUTHORIZENET_TRANSACTION_KEY", $AUTHORIZENET_TRANSACTION_KEY);
        //$isSandbox = getenv($isSandbox);
        //if($isSandbox==1){$isSandbox=true;}else{$isSandbox=false;}
        define("AUTHORIZENET_SANDBOX", $isSandbox);

        $transaction = new \AuthorizeNetTransaction();
        $request = new \AuthorizeNetCIM();
        $transaction->amount = $amount;
        $transaction->customerProfileId = $options->ProfileID;
        $transaction->customerPaymentProfileId = $options->PaymentProfileID;

        $response = $request->createCustomerProfileTransaction("AuthCapture", $transaction);
        return $transactionResponse = $response->getTransactionResponse();
    }

}