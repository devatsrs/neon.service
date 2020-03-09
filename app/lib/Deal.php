<?php
namespace App\Lib;


use Illuminate\Support\Facades\DB;

class Deal extends \Eloquent {

    protected $guarded      = array("DealID");
    protected $table        = 'tblDeal';
    protected $primaryKey   = "DealID";

    const StatusActive = "Active";
    const StatusClosed = "Closed";
    const TypeRevenue = "Revenue";
    const TypePayment = "Payment";

    public static $StatusDropDown = array(
        self::StatusActive => 'Active',
        self::StatusClosed => 'Closed'
    );
    public static $TypeDropDown = array(
        self::TypeRevenue => 'Revenue',
        self::TypePayment => 'Payment'
    );


    public static function dealSummary($CompanyID,$Deal,$DealDetails)
    {
        $deal_sum = ['planned_cost' => 0, 'planned_minutes' => 0, 'actual_cost' => 0, 'actual_minutes' => 0];

        $deal_summary = [];
        if (!empty($DealDetails)) {
            foreach ($DealDetails as $dealDetail) {

                $deal_sum['planned_cost'] += $dealDetail->Revenue;
                $deal_sum['planned_minutes'] += $dealDetail->Minutes;

                $trunks = $dealDetail->TrunkID;
                $prefixes = $dealDetail->Prefix;
                $country = $dealDetail->DestinationCountryID;
                $dtbreaks = $dealDetail->DestinationBreak;

                if($dealDetail->Type == "Customer") {

                    $query_common = DB::connection('neon_report')
                        ->table('tblHeader')
                        ->join('tblDimDate', 'tblDimDate.DateID', '=', 'tblHeader.DateID')
                        ->join('tblUsageSummaryDay', 'tblHeader.HeaderID', '=', 'tblUsageSummaryDay.HeaderID')
                        ->where(['tblHeader.CompanyID' => $CompanyID])
                        ->where(['tblHeader.AccountID' => $Deal->AccountID])
                        ->whereBetween('tblDimDate.date', array($Deal->StartDate, $Deal->EndDate));
                    $query_common2 = DB::connection('neon_report')
                        ->table('tblHeader')
                        ->join('tblDimDate', 'tblDimDate.DateID', '=', 'tblHeader.DateID')
                        ->join('tblUsageSummaryDayLive', 'tblHeader.HeaderID', '=', 'tblUsageSummaryDayLive.HeaderID')
                        ->where(['tblHeader.CompanyID' => $CompanyID])
                        ->where(['tblHeader.AccountID' => $Deal->AccountID])
                        ->whereBetween('tblDimDate.date', array($Deal->StartDate, $Deal->EndDate));
                    if (!empty($trunks)) {
                        $query_common->where('Trunk', $trunks);
                        $query_common2->where('Trunk', $trunks);
                    }
                    if (!empty($prefixes)) {
                        $query_common->where('AreaPrefix', $prefixes);
                        $query_common2->where('AreaPrefix', $prefixes);
                    }
                    if (!empty($country)) {
                        $query_common->where('CountryID', $country);
                        $query_common2->where('CountryID', $country);
                    }


                    $query_common->union($query_common2);

                    $customer_data = $query_common->get();
                    $deal_summary[$dealDetail->DealNoteID]['data'] = $customer_data;
                    $deal_summary[$dealDetail->DealNoteID]['detail'] = $dealDetail;
                    $TotalCharges = $TotalBilledDuration = 0;
                    if (!empty($customer_data)) {
                        foreach ($customer_data as $customer_data_row) {
                            $TotalCharges += $customer_data_row->TotalCharges;
                            $TotalBilledDuration += $customer_data_row->TotalBilledDuration;
                        }
                    }
                    $deal_summary[$dealDetail->DealNoteID]['data']['TotalCharges'] = $TotalCharges;
                    $deal_summary[$dealDetail->DealNoteID]['data']['TotalBilledDuration'] = $TotalBilledDuration;

                    $deal_sum['actual_minutes'] += (int)($TotalBilledDuration / 60);
                    $deal_sum['actual_cost'] += (int)($TotalBilledDuration / 60 * $dealDetail->PerMinutePL);

                } else if($dealDetail->Type == "Vendor") {

                    $query_common3 = DB::connection('neon_report')
                        ->table('tblHeaderV')
                        ->join('tblDimDate', 'tblDimDate.DateID', '=', 'tblHeaderV.DateID')
                        ->join('tblVendorSummaryDay', 'tblHeaderV.HeaderVID', '=', 'tblVendorSummaryDay.HeaderVID')
                        ->where(['tblHeaderV.CompanyID' => $CompanyID])
                        ->where(['tblHeaderV.VAccountID' => $Deal->AccountID])
                        ->whereBetween('tblDimDate.date', array($Deal->StartDate, $Deal->EndDate));
                    $query_common4 = DB::connection('neon_report')
                        ->table('tblHeaderV')
                        ->join('tblDimDate', 'tblDimDate.DateID', '=', 'tblHeaderV.DateID')
                        ->join('tblVendorSummaryDayLive', 'tblHeaderV.HeaderVID', '=', 'tblVendorSummaryDayLive.HeaderVID')
                        ->where(['tblHeaderV.CompanyID' => $CompanyID])
                        ->where(['tblHeaderV.VAccountID' => $Deal->AccountID])
                        ->whereBetween('tblDimDate.date', array($Deal->StartDate, $Deal->EndDate));

                    if (!empty($trunks)) {
                        $query_common3->where('Trunk', $trunks);
                        $query_common4->where('Trunk', $trunks);
                    }
                    if (!empty($prefixes)) {
                        $query_common3->where('AreaPrefix', $prefixes);
                        $query_common4->where('AreaPrefix', $prefixes);
                    }
                    if (!empty($country)) {
                        $query_common3->where('CountryID', $country);
                        $query_common4->where('CountryID', $country);
                    }
                    $query_common3->union($query_common4);

                    $vendor_data = $query_common3->get();

                    $deal_summary[$dealDetail->DealNoteID]['data'] = $vendor_data;
                    $deal_summary[$dealDetail->DealNoteID]['detail'] = $dealDetail;

                    $TotalCharges = $TotalBilledDuration = 0;
                    if (!empty($vendor_data)) {
                        foreach ($vendor_data as $vendor_data_row) {
                            $TotalCharges += $vendor_data_row->TotalSales;
                            $TotalBilledDuration += $vendor_data_row->TotalBilledDuration;
                        }
                    }
                    $deal_summary[$dealDetail->DealNoteID]['data']['TotalCharges'] = $TotalCharges;
                    $deal_summary[$dealDetail->DealNoteID]['data']['TotalBilledDuration'] = $TotalBilledDuration;

                    $deal_sum['actual_minutes'] += (int)($TotalBilledDuration / 60);
                    $deal_sum['actual_cost'] += (int)($TotalBilledDuration / 60 * $dealDetail->PerMinutePL);
                }

            }
        }
        $deal_summary['deal_sum'] = $deal_sum;

        return $deal_summary;
    }

    public static function sendDealAlert($CompanyID) {
        $Company 	= Company::find($CompanyID);
        $TodayDate 	= date_create(date('Y-m-d'));

        $Deals = Deal::join("tblAccount", "tblAccount.AccountID","=","tblDeal.AccountID")->where(DB::raw('DATE(tblDeal.StartDate)'),'<=',$TodayDate)->where(DB::raw('DATE(tblDeal.EndDate)'),'>=',$TodayDate)->where(['CompanyID' => $CompanyID,'tbldeal.Status' => 'Active'])->whereNotNull('AlertEmail')->get();


        foreach ($Deals as $Deal) {
            $DealDetails = DealDetail::where('DealID', $Deal->DealID)->get();
            $deal_summary = self::dealSummary($CompanyID, $Deal, $DealDetails);
            //echo '<pre>'; print_r($deal_summary);exit;
            if($Deal->DealType == 'Revenue'){
                $deal_level = ($deal_summary['deal_sum']['planned_cost'] ? $deal_summary['deal_sum']['actual_cost']/$deal_summary['deal_sum']['planned_cost'] : "0") *100;
            } else {
                $deal_level = ($deal_summary['deal_sum']['planned_minutes'] ? $deal_summary['deal_sum']['actual_minutes']/$deal_summary['deal_sum']['planned_minutes'] : "0") *100;
            }
            if($deal_level >= 100) {
                $AccountID = $Deal->AccountID;
                $Accounts = Account::where(['AccountID' => $AccountID, 'Status' => 1])->get();
                foreach ($Accounts as $Account) {

                    $IsEmailSend = AccountEmailLog::where(['CompanyID' => $CompanyID, 'AccountID' => $Account->AccountID, 'EmailType' => AccountEmailLog::DealAlert])
                        ->where('created_at', 'like', date('Y-m-d') . '%')->count();

                    if (!($IsEmailSend > 0)) {
                        $EmailTemplate = EmailTemplate::getSystemEmailTemplate($CompanyID, 'DealEmailSend', $Account->LanguageID);
                        $EmailMessage = $EmailTemplate->TemplateBody;
                        $replace_array = Helper::create_replace_array($Account, array());
                        $EmailMessage = template_var_replace($EmailMessage, $replace_array);
                        $Subject = template_var_replace($EmailTemplate->Subject, $replace_array);
                        $EmailFrom = $EmailTemplate->EmailFrom;
                        $emailsTo[] = $Account->BillingEmail;


                        $emaildata = array(
                            'EmailToName' => $Company->CompanyName,
                            'EmailTo' => $emailsTo,
                            'EmailFrom' => $EmailFrom,
                            'Subject' => $Subject,
                            'CompanyID' => $CompanyID,
                            'CompanyName' => $Company->CompanyName,
                            'Message' => $EmailMessage
                        );

                        $emailstatus = Helper::sendMail('emails.template', $emaildata);

                        if ($emailstatus) {
                            $logdata = array(
                                'CompanyID' => $CompanyID,
                                'AccountID' => $Account->AccountID,
                                'CreatedBy' => 'System Notification',
                                'created_at' => date('Y-m-d H:i:s'),
                                'EmailTo' => implode(',', $emailsTo),
                                'Subject' => $Subject,
                                'Message' => $EmailMessage,
                                'EmailType' => AccountEmailLog::DealAlert
                            );

                            AccountEmailLog::insert($logdata);
                        }
                    }
                }
            }
        }
    }
}