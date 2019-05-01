<?php
namespace App\Lib;
use Illuminate\Support\Facades\DB;

class RateTable extends \Eloquent {
	protected $fillable = [];
    public $timestamps = false; // no created_at and updated_at

    protected $guarded = array('RateTableId');

    protected $table = 'tblRateTable';

    protected  $primaryKey = "RateTableId";

    const clientRateTable = '`clientrm`.`cl_clientrates`';
    const clientRateTableRate = '`clientrm`.`ra_rates`';


    public static function createTempPBXRateTable($tempRateTableRate = ""){

        DB::statement('DROP TABLE IF EXISTS `' . $tempRateTableRate . '`');
        $sql_create_table = 'CREATE TABLE IF NOT EXISTS `' . $tempRateTableRate . '` (
                            `TempRateID` INT(11) NOT NULL AUTO_INCREMENT,
                            `ra_id` INT(11) NULL DEFAULT NULL,
                            `ra_cl_id` INT(11) NULL DEFAULT NULL,
                            `unique_id` INT(11) NULL DEFAULT NULL,
                            `ra_prefix` VARCHAR(255) NULL DEFAULT NULL,
                            `ra_country` VARCHAR(255) NULL DEFAULT NULL,
                            `ra_cost` DECIMAL(10,5) NULL DEFAULT NULL,
                            PRIMARY KEY (`TempRateID`)
                            )';
        DB::statement($sql_create_table);
    }
}