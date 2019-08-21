<?php


namespace App\Lib;


class PaymentGateway extends \Eloquent {
    protected $fillable = [];
    protected $table = "tblPaymentGateway";
    protected $primaryKey = "PaymentGatewayID";
    protected $guarded = array('PaymentGatewayID');

    const  AuthorizeNet	= 	1;
    const  Stripe		=	2;
    const  StripeACH	=	3;
    const  SagePayDirectDebit	=	4;
    const  FideliPay	=	5;
    const  PeleCard	    =	6;
    const  MerchantWarrior	    =	7;

    public static $paymentgateway_name = array(''=>'' ,self::AuthorizeNet => 'AuthorizeNet',self::Stripe=>'Stripe',self::StripeACH=>'StripeACH',self::FideliPay=>'FideliPay',self::PeleCard=>'PeleCard',self::MerchantWarrior=>'MerchantWarrior');

    public static function getName($PaymentGatewayID)
    {
        return PaymentGateway::where(array('PaymentGatewayID' => $PaymentGatewayID))->pluck('Title');
    }

        public static function addTransaction($PaymentGateway,$amount,$options,$account,$AccountPaymentProfileID,$CompanyID)
    {
        switch($PaymentGateway) {
            case 'AuthorizeNet':
                $transaction = self::addAuthorizeNetTransaction($amount,$options,$CompanyID);
                $Notes = '';
                if($transaction->response_code == 1) {
                    $Notes = 'AuthorizeNet transaction_id ' . $transaction->transaction_id;
                    $Status = TransactionLog::SUCCESS;
                }else{
                    $Status = TransactionLog::FAILED;
                    $Notes = isset($transaction->real_response->xml->messages->message->text) && $transaction->real_response->xml->messages->message->text != '' ? $transaction->real_response->xml->messages->message->text : $transaction->error_message ;
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
                $transactiondata['Response'] = json_encode($transaction);
                TransactionLog::insert($transactiondata);
                return $transactionResponse;

            case 'Stripe':

                $CurrencyCode = Currency::getCurrencyCode($account->CurrencyId);
                $stripedata = array();
                $stripedata['currency'] = strtolower($CurrencyCode);
                $stripedata['amount'] = $amount;
                $stripedata['description'] = $options->InvoiceNumber.' (Invoice) Payment';
                $stripedata['customerid'] = $options->CustomerProfileID;

                $transactionResponse = array();

                $stripepayment = new StripeBilling($CompanyID);
                $transaction = $stripepayment->createchargebycustomer($stripedata);

                $Notes = '';
                if(!empty($transaction['response_code']) && $transaction['response_code'] == 1) {
                    $Notes = 'Stripe transaction_id ' . $transaction['id'];
                    $Status = TransactionLog::SUCCESS;
                }else{
                    $Status = TransactionLog::FAILED;
                    $Notes = empty($transaction['error']) ? '' : $transaction['error'];
                    //AccountPaymentProfile::setProfileBlock($AccountPaymentProfileID);
                }
                $transactionResponse['transaction_notes'] =$Notes;
                if(!empty($transaction['response_code'])) {
                    $transactionResponse['response_code'] = $transaction['response_code'];
                }
                $transactionResponse['transaction_payment_method'] = 'CREDIT CARD';
                $transactionResponse['failed_reason'] = $Notes;
                if(!empty($transaction['id'])) {
                    $transactionResponse['transaction_id'] = $transaction['id'];
                }
                $transactiondata = array();
                $transactiondata['CompanyID'] = $account->CompanyId;
                $transactiondata['AccountID'] = $account->AccountID;
                if(!empty($transaction['id'])) {
                    $transactiondata['Transaction'] = $transaction['id'];
                }
                $transactiondata['Notes'] = $Notes;
                if(!empty($transaction['amount'])) {
                    $transactiondata['Amount'] = floatval($transaction['amount']);
                }
                $transactiondata['Status'] = $Status;
                $transactiondata['created_at'] = date('Y-m-d H:i:s');
                $transactiondata['updated_at'] = date('Y-m-d H:i:s');
                $transactiondata['CreatedBy'] = "RMScheduler";
                $transactiondata['ModifyBy'] = "RMScheduler";
                $transactiondata['Response'] = json_encode($transaction);
                TransactionLog::insert($transactiondata);
                return $transactionResponse;

            case 'StripeACH':

                $CurrencyCode = Currency::getCurrencyCode($account->CurrencyId);
                $stripedata = array();
                $stripedata['currency'] = strtolower($CurrencyCode);
                $stripedata['amount'] = $amount;
                $stripedata['description'] = $options->InvoiceNumber.' (Invoice) Payment';
                $stripedata['customerid'] = $options->CustomerProfileID;

                $transactionResponse = array();

                $stripepayment = new StripeACH($CompanyID);
                $transaction = $stripepayment->createchargebycustomer($stripedata);

                $Notes = '';
                if(!empty($transaction['response_code']) && $transaction['response_code'] == 1) {
                    $Notes = 'Stripe ACH transaction_id ' . $transaction['id'];
                    $Status = TransactionLog::SUCCESS;
                }else{
                    $Status = TransactionLog::FAILED;
                    $Notes = empty($transaction['error']) ? '' : $transaction['error'];
                    //AccountPaymentProfile::setProfileBlock($AccountPaymentProfileID);
                }
                $transactionResponse['transaction_notes'] =$Notes;
                if(!empty($transaction['response_code'])) {
                    $transactionResponse['response_code'] = $transaction['response_code'];
                }
                $transactionResponse['transaction_payment_method'] = 'BANK TRANSFER';
                $transactionResponse['failed_reason'] = $Notes;
                if(!empty($transaction['id'])) {
                    $transactionResponse['transaction_id'] = $transaction['id'];
                }
                $transactiondata = array();
                $transactiondata['CompanyID'] = $account->CompanyId;
                $transactiondata['AccountID'] = $account->AccountID;
                if(!empty($transaction['id'])) {
                    $transactiondata['Transaction'] = $transaction['id'];
                }
                $transactiondata['Notes'] = $Notes;
                if(!empty($transaction['amount'])) {
                    $transactiondata['Amount'] = floatval($transaction['amount']);
                }
                $transactiondata['Status'] = $Status;
                $transactiondata['created_at'] = date('Y-m-d H:i:s');
                $transactiondata['updated_at'] = date('Y-m-d H:i:s');
                $transactiondata['CreatedBy'] = "RMScheduler";
                $transactiondata['ModifyBy'] = "RMScheduler";
                $transactiondata['Response'] = json_encode($transaction);
                TransactionLog::insert($transactiondata);
                return $transactionResponse;


            case 'GoCardLess':

                $CurrencyCode = Currency::getCurrencyCode($account->CurrencyId);
                $goCardLessData = array();
                $goCardLessData['currency'] = strtolower($CurrencyCode);
                $goCardLessData['amount'] = $amount;
                $goCardLessData['description'] = $options->InvoiceNumber.' (Invoice) Payment';
                $goCardLessData['customerid'] = $options->CustomerProfileID;

                $transactionResponse = array();

                $goCardLessPayment = new \GoCardLess($CompanyID);
                $transaction = $goCardLessPayment->createchargebycustomer($goCardLessData);

                $Notes = '';
                if(!empty($transaction['response_code']) && $transaction['response_code'] == 1) {
                    $Notes = 'GoCardLess transaction_id ' . $transaction['id'];
                    $Status = TransactionLog::SUCCESS;
                }else{
                    $Status = TransactionLog::FAILED;
                    $Notes = empty($transaction['error']) ? '' : $transaction['error'];
                    //AccountPaymentProfile::setProfileBlock($AccountPaymentProfileID);
                }
                $transactionResponse['transaction_notes'] =$Notes;
                if(!empty($transaction['response_code'])) {
                    $transactionResponse['response_code'] = $transaction['response_code'];
                }
                $transactionResponse['transaction_payment_method'] = 'BANK TRANSFER';
                $transactionResponse['failed_reason'] = $Notes;
                if(!empty($transaction['id'])) {
                    $transactionResponse['transaction_id'] = $transaction['id'];
                }
                $transactiondata = array();
                $transactiondata['CompanyID'] = $account->CompanyId;
                $transactiondata['AccountID'] = $account->AccountID;
                if(!empty($transaction['id'])) {
                    $transactiondata['Transaction'] = $transaction['id'];
                }
                $transactiondata['Notes'] = $Notes;
                if(!empty($transaction['amount'])) {
                    $transactiondata['Amount'] = floatval($transaction['amount']);
                }
                $transactiondata['Status'] = $Status;
                $transactiondata['created_at'] = date('Y-m-d H:i:s');
                $transactiondata['updated_at'] = date('Y-m-d H:i:s');
                $transactiondata['CreatedBy'] = "RMScheduler";
                $transactiondata['ModifyBy'] = "RMScheduler";
                $transactiondata['Response'] = json_encode($transaction);
                TransactionLog::insert($transactiondata);
                return $transactionResponse;

            case 'FideliPay':

                $Fidelipaydata = array();
                $Fidelipaydata['Amount'] = $amount;
                $Fidelipaydata['Invoice'] = $options->InvoiceNumber;
                $Fidelipaydata['Description'] = $options->InvoiceNumber.' (Invoice) Payment';
                $Fidelipaydata['CustomerNumber'] = $options->CustomerNumber;

                $transactionResponse = array();

                $fidelipaypayment = new FideliPay($CompanyID);
                $transaction = $fidelipaypayment->createchargebycustomer($Fidelipaydata);

                $Notes = '';
                if(!empty($transaction['response_code']) && $transaction['response_code'] == 1) {
                    $Notes = 'FideliPay transaction_id ' . $transaction['id'];
                    $Status = TransactionLog::SUCCESS;
                }else{
                    $Status = TransactionLog::FAILED;
                    $Notes = empty($transaction['error']) ? '' : $transaction['error'];
                    //AccountPaymentProfile::setProfileBlock($AccountPaymentProfileID);
                }
                $transactionResponse['transaction_notes'] =$Notes;
                if(!empty($transaction['response_code'])) {
                    $transactionResponse['response_code'] = $transaction['response_code'];
                }
                $transactionResponse['transaction_payment_method'] = 'CREDIT CARD';
                $transactionResponse['failed_reason'] = $Notes;
                if(!empty($transaction['id'])) {
                    $transactionResponse['transaction_id'] = $transaction['id'];
                }
                $transactiondata = array();
                $transactiondata['CompanyID'] = $account->CompanyId;
                $transactiondata['AccountID'] = $account->AccountID;
                if(!empty($transaction['id'])) {
                    $transactiondata['Transaction'] = $transaction['id'];
                }
                $transactiondata['Notes'] = $Notes;
                if(!empty($transaction['amount'])) {
                    $transactiondata['Amount'] = floatval($transaction['amount']);
                }
                $transactiondata['Status'] = $Status;
                $transactiondata['created_at'] = date('Y-m-d H:i:s');
                $transactiondata['updated_at'] = date('Y-m-d H:i:s');
                $transactiondata['CreatedBy'] = "RMScheduler";
                $transactiondata['ModifyBy'] = "RMScheduler";
                $transactiondata['Response'] = json_encode($transaction);
                TransactionLog::insert($transactiondata);
                return $transactionResponse;

            case self::$paymentgateway_name[self::PeleCard]:

                $PeleCarddata = array();
                $PeleCarddata['GrandTotal']     = $amount;
                $PeleCarddata['InvoiceNumber']  = $options->InvoiceNumber;
                $PeleCarddata['AccountID']      = $account->AccountID;
                $PeleCarddata['Token']          = $options->Token;
                $PeleCarddata['CVVNumber']      = $options->CVVNumber;
                $PeleCarddata['PeleCardID']     = !empty($options->PeleCardID) ? $options->PeleCardID : '';

                $transactionResponse = array();

                $pelecardpayment = new PeleCard($CompanyID);
                $transaction = $pelecardpayment->pay_invoice($PeleCarddata);

                $Notes = '';
                if(!empty($transaction['status']) && $transaction['status'] == 'success') {
                    $Notes = 'PeleCard transaction_id ' . $transaction['transaction_id'];
                    $Status = TransactionLog::SUCCESS;
                }else{
                    $Status = TransactionLog::FAILED;
                    $Notes = empty($transaction['error']) ? '' : $transaction['error'];
                    //AccountPaymentProfile::setProfileBlock($AccountPaymentProfileID);
                }
                if(!empty($transaction['response_code'])) {
                    $transactionResponse['response_code'] = $transaction['response_code'];
                }
                $transactionResponse['transaction_notes']           = $Notes;
                $transactionResponse['transaction_payment_method']  = 'CREDIT CARD';
                $transactionResponse['failed_reason']               = $Notes;
                if(!empty($transaction['transaction_id'])) {
                    $transactionResponse['transaction_id'] = $transaction['transaction_id'];
                }
                $transactiondata = array();
                $transactiondata['CompanyID'] = $account->CompanyId;
                $transactiondata['AccountID'] = $account->AccountID;
                if(!empty($transaction['transaction_id'])) {
                    $transactiondata['Transaction'] = $transaction['transaction_id'];
                }
                $transactiondata['Notes'] = $Notes;
                if(!empty($transaction['amount'])) {
                    $transactiondata['Amount'] = floatval($transaction['amount']);
                }
                $transactiondata['Status'] = $Status;
                $transactiondata['created_at'] = date('Y-m-d H:i:s');
                $transactiondata['updated_at'] = date('Y-m-d H:i:s');
                $transactiondata['CreatedBy'] = "RMScheduler";
                $transactiondata['ModifyBy'] = "RMScheduler";
                $transactiondata['Response'] = json_encode($transaction);
                TransactionLog::insert($transactiondata);
                return $transactionResponse;

            case self::$paymentgateway_name[self::MerchantWarrior]:

                $MerchantWarriordata = array();
                $MerchantWarriordata['CompanyID']       = $CompanyID;
                $MerchantWarriordata['AccountID']       = $account->AccountID;
                $MerchantWarriordata['GrandTotal']      = $amount;
                $MerchantWarriordata['InvoiceNumber']   = $options->InvoiceNumber;
                $MerchantWarriordata['cardID']          = $options->cardID;

                $transactionResponse = array();

                $merchantwarriorpayment = new MerchantWarrior($CompanyID);
                $transaction = $merchantwarriorpayment->pay_invoice($MerchantWarriordata);

                $Notes = '';
                if(!empty($transaction['status']) && $transaction['status'] == 'success') {
                    $Notes = 'MerchantWarrior transaction_id ' . $transaction['transaction_id'];
                    $Status = TransactionLog::SUCCESS;
                }else{
                    $Status = TransactionLog::FAILED;
                    $Notes = empty($transaction['error']) ? '' : $transaction['response']['responseData']['responseMessage'];
                    //AccountPaymentProfile::setProfileBlock($AccountPaymentProfileID);
                }

                if(!empty($transaction['response_code'])) {
                    $transactionResponse['response_code'] = $transaction['response_code'];
                }
                $transactionResponse['transaction_notes']           = $Notes;
                $transactionResponse['transaction_payment_method']  = 'CREDIT CARD';
                $transactionResponse['failed_reason']               = $Notes;
                if(!empty($transaction['transaction_id'])) {
                    $transactionResponse['transaction_id'] = $transaction['transaction_id'];
                }
                $transactiondata = array();
                $transactiondata['CompanyID'] = $account->CompanyId;
                $transactiondata['AccountID'] = $account->AccountID;
                if(!empty($transaction['transaction_id'])) {
                    $transactiondata['Transaction'] = $transaction['transaction_id'];
                }
                $transactiondata['Notes'] = $Notes;
                if(!empty($transaction['amount'])) {
                    $transactiondata['Amount'] = floatval($transaction['amount']);
                }
                $transactiondata['Status'] = $Status;
                $transactiondata['created_at'] = date('Y-m-d H:i:s');
                $transactiondata['updated_at'] = date('Y-m-d H:i:s');
                $transactiondata['CreatedBy'] = "RMScheduler";
                $transactiondata['ModifyBy'] = "RMScheduler";
                $transactiondata['Response'] = json_encode($transaction);
                TransactionLog::insert($transactiondata);
                return $transactionResponse;

            case 'AccountBalance':

                $AccountBalancedata = array();
                $AccountBalancedata['CompanyID']     = $CompanyID;
                $AccountBalancedata['GrandTotal']     = $amount;
                $AccountBalancedata['InvoiceNumber']  = $options->InvoiceNumber;
                $AccountBalancedata['AccountID']      = $account->AccountID;

                $transactionResponse = array();
                $transaction = AccountBalance::AutoPayInvoice($AccountBalancedata);

                $Notes = '';
                if(!empty($transaction['status']) && $transaction['status'] == 'success') {
                    $Notes = 'Account Balance transaction_id ' . $transaction['id'];
                    $Status = TransactionLog::SUCCESS;
                }else{
                    $Status = TransactionLog::FAILED;
                    $Notes = empty($transaction['error']) ? '' : $transaction['error'];
                    //AccountPaymentProfile::setProfileBlock($AccountPaymentProfileID);
                }
                if(!empty($transaction['response_code'])) {
                    $transactionResponse['response_code'] = $transaction['response_code'];
                }
                $transactionResponse['transaction_notes']           = $Notes;
                $transactionResponse['transaction_payment_method']  = 'Account Balance';
                $transactionResponse['failed_reason']               = $Notes;
                if(!empty($transaction['id'])) {
                    $transactionResponse['transaction_id'] = $transaction['id'];
                }
                $transactiondata = array();
                $transactiondata['CompanyID'] = $account->CompanyId;
                $transactiondata['AccountID'] = $account->AccountID;
                if(!empty($transaction['id'])) {
                    $transactiondata['Transaction'] = $transaction['id'];
                }
                $transactiondata['Notes'] = $Notes;
                if(!empty($transaction['amount'])) {
                    $transactiondata['Amount'] = floatval($transaction['amount']);
                }
                $transactiondata['Status'] = $Status;
                $transactiondata['created_at'] = date('Y-m-d H:i:s');
                $transactiondata['updated_at'] = date('Y-m-d H:i:s');
                $transactiondata['CreatedBy'] = "RMScheduler";
                $transactiondata['ModifyBy'] = "RMScheduler";
                $transactiondata['Response'] = json_encode($transaction);
                TransactionLog::insert($transactiondata);
                return $transactionResponse;

            case '':
                return '';

        }

    }

    public static function addAuthorizeNetTransaction($amount, $options,$CompanyID)
    {
		$AuthorizeData 					= 	\App\Lib\SiteIntegration::CheckIntegrationConfiguration(true,\App\Lib\SiteIntegration::$AuthorizeSlug,$CompanyID);
		$AUTHORIZENET_API_LOGIN_ID  	= 	isset($AuthorizeData->AuthorizeLoginID)?$AuthorizeData->AuthorizeLoginID:'';		
		$AUTHORIZENET_TRANSACTION_KEY  	= 	isset($AuthorizeData->AuthorizeTransactionKey)?$AuthorizeData->AuthorizeTransactionKey:'';
		$isSandbox						=	isset($AuthorizeData->AuthorizeTestAccount)?$AuthorizeData->AuthorizeTestAccount:'';
		
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

    public static function getPaymentGatewayIDByName($PaymentMehod){
        $PaymentGateway = PaymentGateway::$paymentgateway_name;
        $PaymentGatewayID = array_search($PaymentMehod, $PaymentGateway);
        return $PaymentGatewayID;
    }

}