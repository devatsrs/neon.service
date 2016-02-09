<?php
/**
 * Created by PhpStorm.
 * User: CodeDesk
 * Date: 6/15/2015
 * Time: 5:18 PM
 */

namespace App\Lib;

use Carbon\Carbon;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Maatwebsite\Excel\Facades\Excel;
use Illuminate\Support\Facades\DB;


class CSVImporter{

    public $companyid;
    public $relations;

    public function getquery($file,$connection){
        $tablew = basename($file,".csv");
        $table = explode("_",$tablew)[1];
        $datatypes = array('varchar','nvarchar','text','datetime','smalldatetime','date') ;
        $outerfirst = 1;
        $sql = '';
        $query = "SELECT";
         $query .= " AC.[name] AS [column_name],";
         $query .= " TY.[name] AS system_data_type";
         $query .= " FROM sys.[tables] AS T";
         $query .= " INNER JOIN sys.[all_columns] AC ON T.[object_id] = AC.[object_id]";
         $query .= " INNER JOIN sys.[types] TY ON AC.[system_type_id] = TY.[system_type_id] AND AC.[user_type_id] = TY.[user_type_id]";
          $query .= " WHERE T.[is_ms_shipped] = 0 AND t.name = '".$table."'";
          $query .= " ORDER BY T.[name], AC.[column_id]";
        $results = DB::connection($connection)->select($query);
        $columns = [];
        foreach($results as $row){
            $columns[strtolower($row->column_name)] = strtolower($row->system_data_type);
        }
        $relate = '';

        if($this->in_array_r($table,$this->relations)){
            $relate = $this->relations[$table];
        }

        Excel::load($file, function($reader) use($outerfirst,$table,&$sql,$datatypes,$columns,$relate,$query,$connection) {
            try{
            $results = $reader->get();
            $values = '';
            foreach($results as $row) {
                if($outerfirst!=1){
                    $values .= ",";
                }
                $innerfirst = 1;
                $attribute = '';
                $values .= "(";
                foreach($row as $index=>$value) {
                    $select = '';
                    $gettingField = 0;
                    $selectConnection = '';

                    if(is_array($relate)) {
                        for ($i = 0; $i < count($relate); $i++) {
                            if (strtolower($relate[$i]['field']) == $index && $value!= 'NULL' && $value!= '') {
                                $select = "select " . $relate[$i]['select'] . " from " . $relate[$i]['referencetable'] . " where " . $relate[$i]['referencefield'] . "='" . $value . "' AND CompanyID=".$this->companyid;
                                $selectConnection = $relate[$i]['connection'];
                                $result = DB::connection($selectConnection)->getPdo()->query($select);
                                $firstResult = $result->fetch(\PDO::FETCH_ASSOC);
                                $gettingField = $firstResult[$relate[$i]['select']];
                            }
                        }
                    }
                    if($table=='tblGatewayAccount' && $innerfirst==1){
                        $innerfirst++;
                    }
                    if($innerfirst>2){
                        $values .= ",";
                        $attribute .=",";
                    }
                    if($innerfirst>1) {
                        $attribute .= "[".$index."]";
                    }
                    if(strtolower($index)=='companyid'){
                        $values .= $this->companyid;
                        if($innerfirst==1) {
                            $attribute .= "[".$index."],";
                            $values.= ',';
                        }
                    }else{

                        if (in_array($columns[$index], $datatypes)) {
                        //if (!is_numeric($value)) {
                            if($index=='password'){
                                $value = Hash::make("'".$value."'");
                            }
                            if($innerfirst>1) {
                                if ($value == 'NULL') {
                                    $values .= $value;
                                } else {
                                    $pos = strpos($value, 'GETDATE()');
                                    if($pos === false){
                                        if ($select != "") {
                                            $values .= "'" . $gettingField . "'";
                                        } else {
                                            $values .= "'" . $value . "'";
                                        }
                                    }else{
                                        $values .= str_replace("'", "", $value);
                                    }
                                }
                            }

                        }else{
                            if($innerfirst>1){
                                if($select!=""){
                                    $values .= $gettingField;
                                }else{
                                    $values .= $value;
                                }
                            }
                        }
                    }
                    $innerfirst ++;
                }
                $outerfirst = 0;
                $values .= ")";
            }
            $sql = "INSERT INTO ".$table."(".$attribute.") VALUES ".$values;
            }catch (\Exception $ex){
                Log::error('table attribute:'.$index);;
                Log::error('table name:'.$table);
                Log::error('table query:'.$query);
                Log::error('table Connnection:'.$connection);
                Log::error('tablecureentquery'.$sql);
                Log::error('select:'.$select);
                echo $ex->getMessage();
            }
        });
        return $sql;

    }

    public function getDirectory($directory,$connection){
        $sql = '';
        try{
        if ($handle = opendir($directory)) {
            while (false !== ($entry = readdir($handle))) {
                $ext = substr($entry, strrpos($entry, '.') + 1);
                if($ext=='csv'){
                    $filepath = $directory.'/'.$entry;
                   $temp = $this->getquery($filepath,$connection);
                    DB::connection($connection)->statement($temp);
                }
            }
            closedir($handle);
        }
        }catch (\Exception $ex){
            Log::error($ex->getMessage());
        }
    }

    public function in_array_r($needle, $haystack) {
        $found = false;
        foreach ($haystack as $index=>$item) {
            if ($index === $needle) {
                $found = true;
                break;
            }
        }
        return $found;
    }



}