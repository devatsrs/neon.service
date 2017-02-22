<!DOCTYPE html>
<html lang="en-US">
<head>
    <meta charset="utf-8">
</head>
<body>
<h2>Pending Due Sheets</h2>
<div id="content">

        <?php
        $day = '';
        $type = '';
        $url = '';
        $first = 1;
         foreach($data['data'] as $row){ ?>
            @if ($row['type']!=$type)
                @if($first==0)
                        </tbody>
                    </table>
                @endif
                @if ($row['type'] == 'customer')
                    Customer
                    <?php $url = $WEBURL.'/customers_rates/' ?>
                @else
                    Vendor
                    <?php $url = $WEBURL.'/vendor_rates/' ?>
                @endif
                    <table>
                        <thead>
                        <tr role="row">
                            <th >Account Name</th>
                            <th>Trunk</th>
                            <th>Due Date</th>
                        </tr>
                        </thead>
                        <tbody>
            @endif
            @if ($row['DAYSDIFF']!=$day)
                @if ($row['DAYSDIFF'] == -1)
                    <tr><td colspan="3">Tomorrow Due Sheets</td></tr>
                @elseif ($row['DAYSDIFF'] == 1)
                    <tr><td colspan="3">Yesterday Due Sheets</td></tr>
                @else
                     <tr><td colspan="3">Today Due Sheets</td></tr>
                @endif
            @endif
            <tr>
                <td><a href="{{$url}}{{$row['AccountID']}}/download">{{$row['AccountName']}}</a></td>
                <td>{{$row['Trunk']}}</td>
                <td>{{$row['EffectiveDate']}}</td>
            </tr>

        <?php
        $day=$row['DAYSDIFF'];
        $type=$row['type'];
        $first = 0;
            }
        ?>
        </tbody>
    </table>

</div>
</body>
</html>