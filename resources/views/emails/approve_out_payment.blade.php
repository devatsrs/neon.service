<!DOCTYPE html>
<html lang="en-US">
<head>
    <meta charset="utf-8">
</head>
<body>

<div id="content">
    <?php
    $SuccessOutPayment = $data['SuccessOutPayment'];
    $FailureOutPayment = $data['FailureOutPayment'];
    ?>
    <div id="content">

        <table width="100%" cellpadding="0" cellspacing="0" style="border:1px solid #ccc;">
            <tr>
                <td>
                    Successful Approve Out Payment Details
                </td>
            </tr>
        </table>

        <table width="100%" border="1" cellpadding="0" cellspacing="0" style="border:1px solid #ccc;">
            <thead>
            <tr>
                <th width="40%" align="center">Account Name</th>
                <th width="60%" align="center">Out Payment Amount</th>
            </tr>
            </thead>
            <tbody>


            @foreach($SuccessOutPayment as $SuccessOutPay)
                <tr>
                    <td width="40%" align="center">{{$SuccessOutPay["AccountName"]}}</td>
                    <td width="60%" align="center">{{$SuccessOutPay["Amount"]}}</td>
                </tr>
            @endforeach


            </tbody>
        </table>

        <br/>

        <table width="100%" cellpadding="0" cellspacing="0" style="border:1px solid #ccc;">
            <tr>
                <td>
                    Failed Approve Out Payment Details
                </td>
            </tr>
        </table>

        <table width="100%" border="1" cellpadding="0" cellspacing="0" style="border:1px solid #ccc;">
            <thead>
            <tr>
                <th width="40%" align="center">Account Name</th>
                <th width="60%" align="center">Failed Reason</th>
            </tr>
            </thead>
            <tbody>


            @foreach($FailureOutPayment as $FailureOutPay)
                <tr>
                    <td width="40%" align="center">{{$FailureOutPay["AccountName"]}}</td>
                    <td width="60%" align="center">{{print_r($FailureOutPay["Response"])}}</td>
                </tr>
            @endforeach


            </tbody>
        </table>

    </div>

</div>
</body>
</html>