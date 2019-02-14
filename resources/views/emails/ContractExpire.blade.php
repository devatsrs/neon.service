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
            <th width="20%" align="center">Account Name</th>
            <th width="20%" align="center">Service Name</th>
            <th width="20%" align="center">Company ID</th>
            <th width="40%" align="center">Message</th>
        </tr>
        </thead>
        <tbody>
        @foreach($ExpireContracts as $ex)
            <tr>
                <td width="20%" align="center">{{$ex["AccountName"]}}</td>
                <td width="20%" align="center">{{$ex['ServiceTitle']}}</td>
                <td width="20%" align="center">{{$ex["CompanyId"]}}</td>
                <td width="40%" align="center">Contract Will Expire In 30 Days! </td>
            </tr>
        @endforeach
        </tbody>
        </table>

    </div>
</div>
</body>
</html>