<?php

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
        
        public static  function of($query){
            $ins = new static;
            $ins->save_query($query);
            return $ins;

        }
        protected  function save_query($query){
            $this->query = $query;
        }
        protected function get_result(){
            $rows = array();
            $this->result = $this->selectprc();
            $columns = array();
            $key_count = 0;
            $first_call = true;
            do{
                $result_new = $this->result->fetchAll(PDO::FETCH_ASSOC);
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
            $pdo = DB::connection()->getPdo();
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

            $rows = array();
            $this->result = $this->selectprc();
            $columns = array();
            $key_count = 0;
            $first_call = true;
            do{
                $result_new = $this->result->fetchAll(PDO::FETCH_CLASS);
                if(count($result_new)){
                    //print_r($result_new);
                    //echo  $returnKeys[$key_count];
                    //echo '<br>=========<br>';
                    $this->data[$returnKeys[$key_count]] =$result_new;
                }else{
                    $this->data[$returnKeys[$key_count]] =array();
                }
                $key_count++;
            }while($this->result->nextRowset());
            return $this;

        }


}