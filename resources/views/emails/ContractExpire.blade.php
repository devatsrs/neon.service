<!DOCTYPE html>
<html lang="en-US">
<head>
    <meta charset="utf-8">
</head>
<body>

<div id="content">
    <?php $ExpireContracts =  $data['ExpireContracts']; ?>
    <div id="content">
        <table width="100%" border="1" cellpadding="0" cellspacing="0" style="border:1px solid #ccc;">
        <thead>
        <tr>
            <th width="25%" align="center">Account Name</th>
            <th width="25%" align="center">Service Title</th>
            <th width="25%" align="center">Service Name</th>
            <th width="25%" align="center">Contract End Date</th>
        </tr>
        </thead>
        <tbody>
        @foreach($ExpireContracts as $ex)
            <tr>
                <td width="25%" align="center">{{$ex["AccountName"]}}</td>
                <td width="25%" align="center">{{$ex['ServiceTitle']}}</td>
                <td width="25%" align="center">{{$ex["serviceNames"]}}</td>
                <td width="25%" align="center">{{$ex["ContractEndDate"]}}</td>

            </tr>
        @endforeach
        </tbody>
        </table>

    </div>
</div>
</body>
</html>