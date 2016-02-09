<!DOCTYPE html>
<html lang="en-US">
<head>
    <meta charset="utf-8">
</head>
<body>
<h2>Rate Generator</h2>
<div id="content">
    Dear {{$data['FirstName']}} {{$data['LastName']}},

    Our rates for {{$data['data']['RateTableName']}}

    for all codes will be updating from
    {{$data['data']['EffectiveDate']}}

    .

    Please find attached updated rate table rate sheet.

    Regards
    {{$data['CompanyName']}}

</div>
</body>
</html>