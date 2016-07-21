<!DOCTYPE html>
<html lang="en-US">
<head>
    <meta charset="utf-8">
</head>
<body>

<div id="content">
    <div id="content">

        <h2>Disk Space Of Server</h2>

        <p>Before Server Clean Up Cron Job Start</p>

        <pre>{{$data['BeforeDiskSpaceOutput']}}</pre>

        <p><br><br>After Server Clean Up Cron Job Complete</p>

        <pre>{{$data['AfterDiskSpaceOutput']}}</pre>

        <p>
            Regards<br>
            {{$data['CompanyName']}}
        </p>
    </div>

</div>
</body>
</html>