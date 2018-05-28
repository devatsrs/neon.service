<?php
namespace App\Lib;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Maatwebsite\Excel\Facades\Excel;

class AutoImportInboxSetting extends \Eloquent {


    protected $guarded = array("TicketID");

    protected $table = 'tblAutoImportInboxSetting';

    protected $primaryKey = "AutoImportInboxSettingID";


    public static function  getAutoImportMail()
    {


    }

}