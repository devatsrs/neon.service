<?php
namespace App\Lib;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Response;
use Illuminate\View\Compilers\BladeCompiler;
use Illuminate\Filesystem\Filesystem;


class DataTableSql extends \Eloquent {
    
    
        public $query;
        public $iTotalRecords;
        public $iTotalDisplayRecords;
        public $data;
        public $Columns;
        public $result ;
        public $connection;
        
        public static  function of($query,$connection= null){
            $ins = new static;
            $ins->save_query($query);
            $ins->connection($connection);
            return $ins;
        }
        protected function save_query($query){
            $this->query = $query;
        }
        protected function connection($name = null){
            if (is_null($name)) $this->connection = Config::get('database.default');
            else $this->connection = $name;
        }
        protected function get_result(){
            $rows = array();
            $this->result = $this->selectprc();
            $columns = array();
            $key_count = 0;
            $first_call = true;
            do{
                $result_new = $this->result->fetchAll(\PDO::FETCH_ASSOC);
                if(count($result_new)){
                    foreach($result_new as $row){
                        if(isset($row['totalcount'])){
                            $this->iTotalDisplayRecords =$row['totalcount'];
                            $this->iTotalRecords =$row['totalcount'];
                            break;
                        }
                        $rows[] = array_values((array)  $row);
                        if($first_call == true){
                            foreach($row as $key=> $columns_key){
                                $columns[] = $key;

                            }
                            $first_call = false;
                        }

                    }
                    $this->data = $rows;
                    $this->Columns  = $columns;

                }
            }while($this->result->nextRowset());

        }


        public function select($query){
            
            echo DB::Select(db::raw($query))->toSql();
            
            return DB::Select(db::raw($query)->toSql());
        }
        protected  function  selectprc(){
            $pdo = DB::connection($this->connection)->getPdo();
            DB::connection()->logQuery($this->query,array());
            return $pdo->query($this->query);
        }
        
        public function make(){
            //$query = $this->query->get();
            $this->get_result();
            return $this->output();
            
        }
        protected function output(){
            $output = array(
                "sEcho" => Input::get('sEcho'),
                "iTotalRecords" => $this->iTotalRecords,
                "iTotalDisplayRecords" => $this->iTotalDisplayRecords,
                "aaData" => $this->data,
                "sColumns" => $this->Columns
            );
            if(Config::get('app.debug', false)) {
                $output['aQueries'] = DB::getQueryLog();
            }
            return Response::json($output);
        }

        /*
         * For All Other Query
         * */
        public function getProcResult($returnKeys = array() ){

            $this->result = $this->selectprc();
            $key_count = 0;
            $data['data']= array();
            do{
                $result_new = $this->result->fetchAll(\PDO::FETCH_CLASS);
                if(isset($returnKeys[$key_count])) {
                    if (count($result_new)) {
                        //print_r($result_new);
                        //echo  $returnKeys[$key_count];
                        //echo '<br>=========<br>';
                        $data['data'][$returnKeys[$key_count]] = $result_new;
                    } else {
                        $data['data'][$returnKeys[$key_count]] = array();
                    }
                }
                $key_count++;
            }while($this->result->nextRowset());

            do{
                if(isset($returnKeys[$key_count])) {
                    $data['data'][$returnKeys[$key_count]] = array();
                }
                $key_count++;
            }while($key_count<count($returnKeys));


            return $data;

        }
}