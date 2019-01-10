<!DOCTYPE html>
<html lang="en-US">
<head>
    <meta charset="utf-8">
</head>
<body>

<div id="content">
    <?php
    $SuccessDepositAccounts = $data['SuccessDepositAccount'];
    $FailureDepositFundAccounts = $data['FailureDepositFund'];
    $ErrorDepositFundAccounts = $data['ErrorDepositFund'];
    ?>
    <div id="content">

        <table width="100%" cellpadding="0" cellspacing="0" style="border:1px solid #ccc;">
            <tr>
                <td>
                    Successfull Top Up Account Details
                </td>
            </tr>
        </table>

            <table width="100%" border="1" cellpadding="0" cellspacing="0" style="border:1px solid #ccc;">
                <thead>
                    <tr>
                        <th width="20%" align="center">Account ID</th>
                        <th width="20%" align="center">Account Name</th>
                        <th width="60%" align="center">Deposit Amount</th>
                    </tr>
                </thead>
            <tbody>


                @foreach($SuccessDepositAccounts as $SuccessDepositAccount)
                    <tr>
                    <td width="20%" align="center">{{$SuccessDepositAccount["AccountID"]}}</td>
                    <td width="20%" align="center">{{$SuccessDepositAccount["AccountName"]}}</td>
                    <td width="60%" align="center">{{$SuccessDepositAccount["Amount"]}}</td>
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
                <th width="20%" align="center">Account ID</th>
                <th width="20%" align="center">Account Name</th>
                <th width="60%" align="center">Failed Reason</th>
            </tr>
            </thead>
            <tbody>


                @foreach($FailureDepositFundAccounts as $FailureDepositFundAccount)
                    <tr>
                    <td width="20%" align="center">{{$FailureDepositFundAccount["AccountID"]}}</td>
                    <td width="20%" align="center">{{$FailureDepositFundAccount["AccountName"]}}</td>
                    <td width="60%" align="center">{{$FailureDepositFundAccount["Response"]->message}}</td>
                    </tr>
                @endforeach


            </tbody>
        </table>

        <br/>

        <table width="100%" cellpadding="0" cellspacing="0" style="border:1px solid #ccc;">
            <tr>
                <td>
                    General Error
                </td>
            </tr>
        </table>

        <table width="100%" border="1" cellpadding="0" cellspacing="0" style="border:1px solid #ccc;">
            <thead>
            <tr>
                <th width="20%" align="center">Account ID</th>
                <th width="20%" align="center">Account Name</th>
                <th width="60%" align="center">Failed Reason</th>
            </tr>
            </thead>
            <tbody>


                @foreach($ErrorDepositFundAccounts as $ErrorDepositFundAccount)
                    <tr>
                    <td width="20%" align="center">{{$ErrorDepositFundAccount["AccountID"]}}</td>
                    <td width="20%" align="center">{{$ErrorDepositFundAccount["AccountName"]}}</td>
                    <td width="60%" align="center">{{print_r($ErrorDepositFundAccount["Response"],true)}}</td>
                    </tr>
                @endforeach


            </tbody>
        </table>

    </div>

</div>
</body>
</html>