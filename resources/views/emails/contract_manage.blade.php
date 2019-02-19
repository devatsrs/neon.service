<!DOCTYPE html>
<html lang="en-US">
<head>
    <meta charset="utf-8">
</head>
<body>

<div id="content">
    <?php


        $CancelContracts = $data['CancelContract'];
        $RenewContracts = $data['RenewContract'];

    ?>
    <div id="content">
        @if(!empty($CancelContracts))
            <table width="100%" cellpadding="0" cellspacing="0" style="border:1px solid #ccc;">
                <tr>
                    <td>
                        Cancel Contracts
                    </td>
                </tr>
            </table>

            <table width="100%" border="1" cellpadding="0" cellspacing="0" style="border:1px solid #ccc;">
                <thead>
                <tr>
                    <th width="20%" align="center">Account Name</th>
                    <th width="20%" align="center">Service Title</th>
                    <th width="20%" align="center">Service Name</th>
                    <th width="40%" align="center">Message</th>
                </tr>
                </thead>
                <tbody>
                    @foreach($CancelContracts as $cancelContract)
                        <tr>
                            <td width="20%" align="center">{{$cancelContract["AccountName"]}}</td>
                            <td width="20%" align="center">{{$cancelContract["ServiceTitle"]}}</td>
                            <td width="20%" align="center">{{$cancelContract["ServiceName"]}}</td>
                            <td width="40%" align="center">Contract Cancel</td>
                        </tr>
                    @endforeach
                </tbody>
            </table>

            <br/>
        @endif
        @if(!empty($RenewContracts))

            <table width="100%" cellpadding="0" cellspacing="0" style="border:1px solid #ccc;">
                <tr>
                    <td>
                        Renewal Contracts
                    </td>
                </tr>
            </table>

            <table width="100%" border="1" cellpadding="0" cellspacing="0" style="border:1px solid #ccc;">
                <thead>
                <tr>
                    <th width="20%" align="center">Account Name</th>
                    <th width="20%" align="center">Service Title</th>
                    <th width="20%" align="center">Service Name</th>
                    <th width="40%" align="center">Message</th>
                </tr>
                </thead>
                <tbody>
                @foreach($RenewContracts as $RenewContract)
                    <tr>
                        <td width="20%" align="center">{{$RenewContract["AccountName"]}}</td>
                        <td width="20%" align="center">{{$RenewContract["ServiceTitle"]}}</td>
                        <td width="20%" align="center">{{$RenewContract["ServiceName"]}}</td>
                        <td width="40%" align="center">Contract Renew</td>
                    </tr>
                @endforeach
                </tbody>
            </table>
        @endif

    </div>

</div>
</body>
</html>