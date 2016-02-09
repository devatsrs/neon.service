<!DOCTYPE html>
<html lang="en-US">
<head>
    <meta charset="utf-8">
</head>
<body>

<div id="content">
    <div id="content">
        <p>
            {{$data['JobTitle']}} Cron Job is currently running behind by {{$data['RunningBehindDuration']}}  minutes
        </p>

       @if(!empty($data['LastRunningBehindTime']) && !empty($data['LastRunningBehindDuration']))

                   it was behind by {{$data['LastRunningBehindDuration']}}  minutes at {{$data['LastRunningBehindTime']}}  <br /><br />

                   @if($data['RunningBehindDuration'] > $data['LastRunningBehindDuration'])

                       There is need to improvement in proccess. <br /><br />

                   @elseif($data['RunningBehindDuration'] < $data['LastRunningBehindDuration'])

                       There is some improvement in proccess.<br /><br />

                   @else
                       There is no improvement.<br /><br />
                   @endif
       @endif
        <p>
            Terminate Url : <a href='{{$data['Url']}}'>{{$data['Url']}}</a> <br><br>
        </p>
        <p>
        <br />Regards<br />
        {{$data['CompanyName']}}
        </p>

    </div>

</div>
</body>
</html>