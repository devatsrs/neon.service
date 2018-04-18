<?php
namespace App\Lib;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Maatwebsite\Excel\Facades\Excel;

class AutoImportSetting extends \Eloquent {


    protected $guarded = array("TicketID");

    protected $table = 'tblAutoImportSetting';

    protected $primaryKey = "AutoImportSettingID";

    public static function  getSendingMailfromSetting()
    {


    }

}