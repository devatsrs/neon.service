<!DOCTYPE html>
<html lang="en-US">
<head>
    <meta charset="utf-8">
</head>
<body>
<b> Job Title: </b> {{$data['Title']}}<br />
<b> Job Status: </b> {{$data['Status']}}<br />
<b> Job Message: </b> {{ str_replace('\n\r','<br>' ,$data['JobStatusMessage'])}} <br />
</body>
</html>