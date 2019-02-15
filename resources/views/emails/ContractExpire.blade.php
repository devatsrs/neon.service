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
            <th width="33%" align="center">Account Name</th>
            <th width="33%" align="center">Service Title</th>
            <th width="33%" align="center">Service Name</th>
        </tr>
        </thead>
        <tbody>
        @foreach($ExpireContracts as $ex)
            <tr>
                <td width="33%" align="center">{{$ex["AccountName"]}}</td>
                <td width="33%" align="center">{{$ex['ServiceTitle']}}</td>
                <td width="33%" align="center">{{$ex["serviceNames"]}}</td>
            </tr>
        @endforeach
        </tbody>
        </table>

    </div>
</div>
</body>
</html>