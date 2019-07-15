<!DOCTYPE html>
<html lang="en-US">
<head>
    <meta charset="utf-8">
</head>
<body>

<div id="content">
    <?php
        //Log::info("AutoTop Notification: " . json_encode($data));
    $SuccessDepositAccounts = $data['SuccessDepositAccount'];
    $FailureDepositFundAccounts = $data['FailureDepositFund'];
    ?>
    <div id="content">

        <table width="100%" cellpadding="0" cellspacing="0" style="border:1px solid #ccc;">
            <tr>
                <td>
                    Successful Top Up Account Details
                </td>
            </tr>
        </table>

            <table width="100%" border="1" cellpadding="0" cellspacing="0" style="border:1px solid #ccc;">
                <thead>
                    <tr>
                        <th width="20%" align="center">Account Number</th>
                        <th width="20%" align="center">Account Name</th>
                        <th width="60%" align="center">Deposit Amount</th>
                    </tr>
                </thead>
            <tbody>


                @foreach($SuccessDepositAccounts as $SuccessDepositAccount)
                    <tr>
                    <td width="20%" align="center">{{ isset($SuccessDepositAccount["Number"]) ? $SuccessDepositAccount["Number"] : '' }}</td>
                    <td width="20%" align="center">{{ isset($SuccessDepositAccount["AccountName"]) ? $SuccessDepositAccount["AccountName"] : '' }}</td>
                    <td width="60%" align="center">{{ isset($SuccessDepositAccount["Amount"]) ? $SuccessDepositAccount["Amount"] : '' }}</td>
                    </tr>
                @endforeach


            </tbody>
            </table>

        <br/>

        <table width="100%" cellpadding="0" cellspacing="0" style="border:1px solid #ccc;">
            <tr>
                <td>
                    Failed Top Up Account Details
                </td>
            </tr>
        </table>

        <table width="100%" border="1" cellpadding="0" cellspacing="0" style="border:1px solid #ccc;">
            <thead>
            <tr>
                <th width="20%" align="center">Account Number</th>
                <th width="20%" align="center">Account Name</th>
                <th width="60%" align="center">Failed Reason</th>
            </tr>
            </thead>
            <tbody>


                @foreach($FailureDepositFundAccounts as $FailureDepositFundAccount)
                    <tr>
                    <td width="20%" align="center">{{ isset($FailureDepositFundAccount["Number"]) ? $FailureDepositFundAccount["Number"] : '' }}</td>
                    <td width="20%" align="center">{{ isset($FailureDepositFundAccount["AccountName"]) ? $FailureDepositFundAccount["AccountName"] : '' }}</td>
                    <td width="60%" align="center">{{ isset($FailureDepositFundAccount["Response"]) ? $FailureDepositFundAccount["Response"] : '' }}</td>
                    </tr>
                @endforeach


            </tbody>
        </table>

    </div>

</div>
</body>
</html>