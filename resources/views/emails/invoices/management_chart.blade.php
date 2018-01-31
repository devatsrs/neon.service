<main>
    <div class="ChargesTitle clearfix">
        <div style="text-align: center">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_LBL_MANAGEMENT_REPORT")}}</div>
    </div>
<?php $ManagementReportTemplate = json_decode($InvoiceTemplate->ManagementReport,true); $reportcount=1;?>
    @foreach($ManagementReportTemplate as $ManagementReportTemplateRow)
        @if($ManagementReportTemplateRow['Status'] == 1)
            <?php
            $reportcount++;
            if($ManagementReportTemplateRow['Title'] == 'Longest Calls'){
                $table_data = $ManagementReports['LongestCalls'];
            } else if($ManagementReportTemplateRow['Title'] == 'Most Expensive Calls'){
                $table_data = $ManagementReports['ExpensiveCalls'];
            } else if($ManagementReportTemplateRow['Title'] == 'Frequently Called Numbers'){
                $table_data = $ManagementReports['DialledNumber'];
            } else if($ManagementReportTemplateRow['Title'] == 'Daily Summary'){
                $table_data = $ManagementReports['DailySummary'];
            } else if($ManagementReportTemplateRow['Title'] == 'Usage by Category'){
                $table_data = $ManagementReports['UsageCategory'];
            }
            ?>

                <div class="{{$reportcount%2 == 0?'left-col':'right-col'}}">
                <div class="ChargesTitle clearfix">
                    <div class="pull-left flip">{{$ManagementReportTemplateRow['UsageName']}}</div>
                </div>
                        <table  border="0"  width="50%" cellpadding="0" cellspacing="0" id="backinvoice" class="bg_graycolor">
                            <thead>
                            <tr>
                                @if($ManagementReportTemplateRow['Title'] == 'Longest Calls' || $ManagementReportTemplateRow['Title'] == 'Most Expensive Calls' || $ManagementReportTemplateRow['Title'] == 'Frequently Called Numbers')
                                    <th>{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_LBL_FROM")}}</th>
                                @elseif($ManagementReportTemplateRow['Title'] == 'Daily Summary')
                                    <th>{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_DATE")}}</th>
                                @elseif($ManagementReportTemplateRow['Title'] == 'Usage by Category')
                                    <th>{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_DESCRIPTION")}}</th>
                                @endif

                                @if($ManagementReportTemplateRow['Title'] == 'Longest Calls' || $ManagementReportTemplateRow['Title'] == 'Most Expensive Calls')
                                    <th>{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_TO")}}</th>
                                    <th>{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_MINS")}}</th>
                                    <th>{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_CHARGE")}}</th>
                                @elseif($ManagementReportTemplateRow['Title'] == 'Frequently Called Numbers' || $ManagementReportTemplateRow['Title'] == 'Daily Summary' || $ManagementReportTemplateRow['Title'] == 'Usage by Category')
                                    <th>{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_CALLS")}}</th>
                                    <th>{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_MINS")}}</th>
                                    <th>{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_CHARGE")}}</th>
                                @endif

                            </tr>
                            </thead>
                            <tbody>
                            <?php  $billed_duration = $cost = $call_count = 0?>
                            @foreach($table_data as $call_row)
                                <?php
                                if($ManagementReportTemplateRow['Title'] == 'Frequently Called Numbers' || $ManagementReportTemplateRow['Title'] == 'Daily Summary' || $ManagementReportTemplateRow['Title'] == 'Usage by Category'){
                                    $call_count += $call_row['col2'];
                                }

                                $billed_duration += $call_row['col3'];
                                $cost += $call_row['col4'];
                                ?>
                                <tr>
                                    <td>{{$call_row['col1']}}</td>
                                    <td>{{$call_row['col2']}}</td>
                                    <td>{{$call_row['col3']}}</td>
                                    <td>{{$CurrencySymbol.number_format($call_row['col4'],$RoundChargesAmount)}}</td>
                                </tr>
                            @endforeach
                            </tbody>
                            <tfoot>
                            <tr>
                                <td><strong>{{cus_lang("TABLE_TOTAL")}}</strong></td>
                                <td>
                                    @if($ManagementReportTemplateRow['Title'] == 'Frequently Called Numbers' || $ManagementReportTemplateRow['Title'] == 'Daily Summary' || $ManagementReportTemplateRow['Title'] == 'Usage by Category')
                                        {{$call_count}}
                                    @endif
                                </td>
                                <td>{{$billed_duration}}</td>
                                <td>{{$CurrencySymbol.number_format($cost,$RoundChargesAmount)}}</td>
                            </tr>
                            </tfoot>
                        </table>
                    </div>

        @endif
    @endforeach

</main>