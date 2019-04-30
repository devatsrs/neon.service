<?php
/**
 * Created by PhpStorm.
 * User: deven
 * Date: 22/03/2016
 * Time: 5:01 PM
 */

namespace App\Lib;

use Box\Spout\Common\Type;
use Box\Spout\Reader\ReaderFactory;
use Box\Spout\Writer\WriterFactory;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Log;
use PHPExcel_IOFactory;
use Illuminate\Support\Facades\DB;


class NeonExcelIO
{


    var $file ;
    var $Sheet ;
    var $first_row ; // Read: skipp first row for column name
    var $sheet ; // default sheet to read
    var $row_cnt = 0; // set row counter to 0
    var $columns = array();
    var $file_type;
    var $records; // output records
    var $reader;
    var $Delimiter;
    var $Enclosure;
    var $Escape;
    var $csvoption;
    public static $COLUMN_NAMES = 0 ;
    public static $start_row 	= 	0 ;
    public static $end_row 	= 	0 ;
    public static $DATA = 1;
    public static $EXCEL = 'xlsx'; // Excel file
	public static $EXCELs  	= 	'xls'; // Excel file
    public static $CSV = 'csv'; // csv file


    public function __construct($file , $csvoption = array(), $Sheet='')
    {
        $this->file = $file;
        $this->Sheet = $Sheet;
        $this->sheet = 0;
        $this->first_row = self::$COLUMN_NAMES;
        $this->file_type = self::$CSV;

        $this->set_file_type();
        $this->get_file_settings($csvoption);
        /*if(self::$start_row>0)
        {
            self::$start_row--;
        }*/
    }


    public function get_file_settings($csvoption=array()) {

        if(!empty($csvoption)){

            if(!empty($csvoption["Delimiter"])){
                $this->Delimiter = $csvoption["Delimiter"];

            }
            if(!empty($csvoption["Enclosure"])){
                $this->Enclosure = $csvoption["Enclosure"];

            }
            if(!empty($csvoption["Enclosure"])){

                $this->Escape    = $csvoption["Enclosure"];
            }
            if(!empty($csvoption["Firstrow"]) && $csvoption["Firstrow"] == 'data'){

                $this->first_row = self::$DATA;
            }else{

                $this->first_row = self::$COLUMN_NAMES;

            }

        }

    }

    public function set_file_settings() {

        if(!empty($this->Delimiter)) {
            $this->reader->setFieldDelimiter($this->Delimiter);
        }
        if(!empty($this->Enclosure)) {
            $this->reader->setFieldEnclosure($this->Enclosure);
        }
        if(!empty($this->Escape)) {
            $this->reader->setEndOfLineCharacter($this->Escape);
        }
    }


    public function set_file_type(){

        $extension = pathinfo($this->file,PATHINFO_EXTENSION);

        if(in_array($extension ,["xls","xlsx"])){
            $this->set_file_excel();
        }else{
            $this->set_file_csv();
        }

    }

    public function set_file_excel(){
		$extension = pathinfo($this->file,PATHINFO_EXTENSION);
		if($extension=='xls'){
        	$this->file_type = self::$EXCELs;
		}
		if($extension=='xlsx'){
        	$this->file_type = self::$EXCEL;
		}
    }

    public function set_file_csv(){

        $this->file_type = self::$CSV;

    }

    /** Set sheet to read / write
     * @param $sheet
     */
    public function set_sheet($sheet) {

        if(is_numeric($sheet) && $sheet >= 0 ){

            $this->sheet = $sheet;
        }
    }

    public function read($limit=0) {

        if($this->file_type == self::$CSV){
            return $this->read_csv($this->file,$limit);
        }
        if($this->file_type == self::$EXCEL){
            //return $this->readExcel($this->file,$limit);
            return $this->readExcel2($this->file,$limit);
        }
		if($this->file_type == self::$EXCELs){
            //return $this->readExcel($this->file,$limit);
            return $this->readExcel2($this->file,$limit);
        }

    }

    /** Create CSV file from rows data from procedure.
     * @param $filepath
     * @param $rows
     * @throws \Box\Spout\Common\Exception\UnsupportedTypeException
     */
    public function write_csv($rows,$csvoption=array()){

        $writer = WriterFactory::create(Type::CSV); // for XLSX files
        if(isset($csvoption['delimiter'])){
            $writer->setFieldDelimiter($csvoption['delimiter']);
        }
        if(isset($csvoption['enclosure'])){
            $writer->setFieldEnclosure($csvoption['enclosure']);
        }
        $writer->openToFile($this->file); // write data to a file or to a PHP stream

        if(isset($rows[0]) && count($rows[0]) > 0 ) {
            $columns = array_keys($rows[0]);
            $writer->addRow($columns); // add a row at a time
            $writer->addRows($rows); // add multiple rows at a time
        }
        $writer->close();

    }

    /** Create Excel file from rows data from procedure.
     * @param $filepath
     * @param $rows
     * @throws \Box\Spout\Common\Exception\UnsupportedTypeException
     */
    public function write_excel($rows){

        $writer = WriterFactory::create(Type::XLSX); // for XLSX files
        $writer->openToFile($this->file); // write data to a file or to a PHP stream

        if(isset($rows[0]) && count($rows[0]) > 0 ) {
            $columns = array_keys($rows[0]);  // Column Names
            $writer->addRow($columns); // add a row at a time
            $writer->addRows($rows); // add multiple rows at a time
        }
        $writer->close();
    }

    /** Read Excel file
     * @param $filepath
     * @return array
     * @throws \Box\Spout\Common\Exception\UnsupportedTypeException
     */
    public function read_csv($filepath,$limit=0) {

        if(self::$start_row>0)
        {
            if($limit>0)
            {
                $limit++;
            }
        }

        $result = array();

        $this->reader = ReaderFactory::create(Type::CSV); // for XLSX files
        $this->set_file_settings();
        $this->reader->open($filepath);

        foreach($this->reader->getSheetIterator() as $key  => $sheet) {

            // For First Sheet only.
            if($key == 1) {

                foreach ($sheet->getRowIterator() as $row) {

                    if(self::$start_row>= ($this->row_cnt+1))
                    {
                        $this->row_cnt++;
                        if($limit>0)
                        {
                            $limit++;
                        }
                        continue;
                    }

                    if($limit > 0 && $limit <= $this->row_cnt) {
//                        break;
                        $this->row_cnt++;
                        continue;
                    }

                    if ($this->row_cnt == 0 && $this->first_row == self::$COLUMN_NAMES) {
                        $first_row = $row;
                        $this->set_columns($first_row);
                        $this->row_cnt++;
                        if($limit > 0 ){
                            $limit++;
                        }
                        continue;
                    }
                    else if( self::$start_row>0 && $this->row_cnt == self::$start_row && $this->first_row == self::$COLUMN_NAMES)
                    {
                        $first_row = $row;
                        $this->set_columns($first_row);
                        $this->row_cnt++;
                        continue;
                    }

                    $result[] = $this->set_row($row);

                    $this->row_cnt++;

                }
            }

        }

        //$result = $this->remove_footer_bottom_rows($result);
        if(self::$end_row)
        {
            $requiredRow = abs($this->row_cnt - self::$end_row - self::$start_row-1);
            $totatRow = count($result);
            if($requiredRow<$limit || $limit==0)
            {
                for($i=$requiredRow ; $i < $totatRow; $i++)
                {
                    unset($result[$i]);
                }
            }
        }

        $this->reader->close();
        return $result;

    }

    public function read_excel($filepath,$limit=0){

        if(self::$start_row>0)
        {
            if($limit>0)
            {
                $limit++;
            }
        }

        $this->reader = ReaderFactory::create(Type::XLSX); // for XLSX files
        $this->reader->open($filepath);
        $result = array();

        foreach($this->reader->getSheetIterator() as $key  => $sheet) {

            // For First Sheet only.
            if($key == 1) {

                foreach ($sheet->getRowIterator() as $row) {

                    if(self::$start_row > ($this->row_cnt))
                    {
                        $this->row_cnt++;
                        if($limit>0) {
                            $limit++;
                        }
                        continue;
                    }

                    if($limit > 0 && $limit <= $this->row_cnt) {
//                        break;
                        $this->row_cnt++;
                        continue;
                    }

                    if ($this->row_cnt == 0 && $this->first_row == self::$COLUMN_NAMES) {
                        $first_row = $row;
                        $this->set_columns($first_row);
                        $this->row_cnt++;
                        if($limit > 0 ){
                            $limit++;
                        }
                        continue;
                    }
                    else if(self::$start_row>0 && $this->row_cnt == self::$start_row && $this->first_row == self::$COLUMN_NAMES) {
                        $first_row = $row;
                        $this->set_columns($first_row);
                        $this->row_cnt++;
                        continue;
                    }

                    $result[] = $this->set_row($row);
                    $this->row_cnt++;

                }
            }

        }

        //$result = $this->remove_footer_bottom_rows($result);

        if(self::$end_row > 0)
        {

            $requiredRow = abs($this->row_cnt - self::$end_row - self::$start_row);
            $totatRow = count($result);
            if($requiredRow<$limit || $limit==0)
            {
                for($i=$requiredRow ; $i < $totatRow; $i++)
                {
                    unset($result[$i]);
                }
            }
        }

        $this->reader->close();

        return $result;

    }
		/*
		Read xls file
	*/
	////////
	 public function read_xls_excel($filepath,$limit=0){
		  $result = array();
		  $flag   = 0;			 
			if(!empty($data['Firstrow'])){
				$data['option']['Firstrow'] = $data['Firstrow'];
			}
		
			if (!empty($data['option']['Firstrow'])) {
				if ($data['option']['Firstrow'] == 'data') {
					$flag = 1;
				}
			}

			Config::set('excel.import.heading','original');
            Config::set('excel.import.dates.enable',false);
					
			$isExcel = in_array(pathinfo($filepath, PATHINFO_EXTENSION),['xls','xlsx'])?true:false;
            $totalRow=0;
            if($limit>0)
            {
             $limit++;
            }

			$result = Excel::selectSheetsByIndex(0)->load($filepath, function ($reader) use ($flag,$isExcel,&$totalRow) {
                if(self::$start_row>0)
                {
                    $reader->skip(self::$start_row-1);
                }
                $totalRow=$reader->getTotalRowsOfFile();
				if ($flag == 1) {
					$reader->noHeading();
				}
			})->take($limit)->toArray();

            if(self::$start_row>0)
            {
                 $tmp_results=array();
                 $column=array_values($result[0]);
                 unset($result[0]);
                 foreach ($result as $row)
                 {
                     $tmp_results[] = array_combine($column, array_values($row));
                 }
                 $result=$tmp_results;
            }

         //$result = $this->remove_footer_bottom_rows($result);

            if(self::$end_row && $totalRow>0)
            {
                $requiredRow = $totalRow - self::$end_row - self::$start_row;
                $countRow =count($result);
                for($i=$requiredRow-1 ; $i < $countRow; $i++)
                {
                    unset($result[$i]);
                }
            }

			return $result;
				 
	 }
	///////////

    /** Set Column Names from first row
     * @param $first_row
     */

    public function set_columns($first_row){

        if(is_array($first_row) && count($first_row) > 0 ){

            $this->columns = $first_row;
        }

    }

    /** Return row as associative array of columnnames
     * @param $row
     * @return array
     */
    public function set_row($row) {

        $col_row = array();

        foreach($row as $col_index => $row_value){

            $col_key = $col_index ;

            if ($this->first_row == self::$COLUMN_NAMES && isset($this->columns[$col_index]) ){
                $col_key = ($this->columns[$col_index]);
            }

            // for dat value only
            if( method_exists($row_value , "format") && $col_key instanceof \DateTime ) {
                $col_row[$col_index] = $row_value->format("H:i:s") != '00:00:00' ? $row_value->format("Y-m-d H:i:s") : $row_value->format("Y-m-d");
            }elseif( method_exists($row_value , "format")) {
                $col_row[$col_key] = $row_value->format("H:i:s") != '00:00:00' ? $row_value->format("Y-m-d H:i:s") : $row_value->format("Y-m-d");
            }else{
                $col_row[$col_key] = $row_value;
            }
        }

        return $col_row;
    }


    /**
     * Generare Rate Sheet Excel file
     * @param $excel_data_sheet
     * @param $header_data
     * @param $data
     * @throws \Box\Spout\Common\Exception\UnsupportedTypeException
     */
    public function write_ratessheet_excel_generate($data,$downloadtype){
        $start_time = date('Y-m-d H:i:s');
        Log::info('Excel Generate Start Time : ' . $start_time);

        $CompanyID = $data['Company']->CompanyID;

        $excel_data_sheet = array();
        $header_data = array();
        $excel_data = $data['excel_data'];
        $max_increase_date = '0000-00-00';
        $max_decrease_date = '0000-00-00';
        foreach($excel_data as $excel_data_rr){
            array_shift($excel_data_rr);
            array_shift($excel_data_rr);
            array_shift($excel_data_rr);

            $excel_data_rr['rate per minute (usd)'] = number_format(str_replace(',','',$excel_data_rr['rate per minute (usd)']), 4);

            $excel_data_sheet[] = $excel_data_rr;

            if(strtolower($excel_data_rr['change']) == 'increase') {
                if($excel_data_rr['effective date'] > $max_increase_date)
                    $max_increase_date = $excel_data_rr['effective date'];
            }
            if(strtolower($excel_data_rr['change']) == 'decrease') {
                if($excel_data_rr['effective date'] > $max_decrease_date)
                    $max_decrease_date = $excel_data_rr['effective date'];
            }

            if($max_increase_date == '0000-00-00')
                $max_increase_date = "";
            if($max_decrease_date == '0000-00-00')
                $max_decrease_date = "";

            $header_data = array_keys($excel_data_rr);
        }
        $header_data  = array_map('ucwords',$header_data);
        if(count($header_data) == 0){
            $header_data[] = 'Destination';
            $header_data[] = 'Codes';
            $header_data[] = 'Tech Prefix';
            $header_data[] = 'Interval';
            $header_data[] = 'Rate Per Minute (usd)';
            $header_data[] = 'Level';
            $header_data[] = 'Change';
            $header_data[] = 'Effective Date';
        }
        array_walk($header_data , 'custom_replace');
        $replace_array = Helper::create_replace_array($data['Account'],array());
        $replace_array['TrunkPrefix'] = empty($data['Account']->trunkprefix)?'':$data['Account']->trunkprefix;
        $replace_array['TrunkName'] = empty($data['Account']->trunk_name)?'':$data['Account']->trunk_name;

        if(!empty($data['Account']->CurrencyId) && $data['Account']->CurrencyId > 0) {
            $Currency = Currency::find($data['Account']->CurrencyId);
            $replace_array['CurrencyCode'] = $Currency->Code;
            $replace_array['CurrencyDescription'] = $Currency->Description;
            $replace_array['CurrencySymbol'] = $Currency->Symbol;
        } else {
            $replace_array['CurrencyCode'] = "";
            $replace_array['CurrencyDescription'] = "";
            $replace_array['CurrencySymbol'] = "";
        }

        $header_data = template_var_replace($header_data,$replace_array);

        $RateSheetTemplate = CompanySetting::getKeyVal($CompanyID,'RateSheetTemplate') != 'Invalid Key' ? json_decode(CompanySetting::getKeyVal($CompanyID,'RateSheetTemplate')) : '';
        $RateSheetTemplateFile = '';
        if($RateSheetTemplate != '') {
            $RateSheetTemplateFile = $temp_file = $RateSheetTemplate->Excel;
            $RateSheetTemplateFile = AmazonS3::preSignedUrl($RateSheetTemplateFile,$CompanyID);

            if(is_amazon($CompanyID) == true) {
                $upload_path = CompanyConfiguration::get($CompanyID,'TEMP_PATH');
                $temp_file = substr($temp_file, strrpos($temp_file, '/') + 1);
                file_put_contents($upload_path.'/'.$temp_file, fopen($RateSheetTemplateFile, 'r'));
                $RateSheetTemplateFile = $upload_path.'/'.$temp_file;
            }
        }
        if($RateSheetTemplateFile != '') {
            $writer = WriterFactory::create(Type::XLSX);
            $writer->openToFile($this->file);

            if(isset($header_data)){
                $writer->addRow($header_data);
            }
            if(isset($excel_data_sheet) > 0 ) {
                $writer->addRows($excel_data_sheet); // add multiple rows at a time
            }
            $writer->close();

            $objPHPExcelTemplate = PHPExcel_IOFactory::load($RateSheetTemplateFile);
            $ActiveSheetTemplate = $objPHPExcelTemplate->getActiveSheet();

            $objPHPExcelFile = PHPExcel_IOFactory::load($this->file);
            $ActiveSheetFile = $objPHPExcelFile->getActiveSheet();

            $RateSheetHeaderSize = $RateSheetTemplate->HeaderSize != null ? (int) $RateSheetTemplate->HeaderSize : 0 ;
            $RateSheetFooterSize = $RateSheetTemplate->FooterSize != null ? (int) $RateSheetTemplate->FooterSize : 0 ;

            $drow = $ActiveSheetFile->getHighestRow();
            $dcol = $ActiveSheetFile->getHighestColumn();
            
            $rstartdate = date('Y-m-d H:i:s');
            Log::info('Excel read Start Time : ' . $rstartdate);
            $allRows = $ActiveSheetFile->rangeToArray('A1:'.$dcol.$drow);
            $renddate = date('Y-m-d H:i:s');
            $process_time = strtotime($renddate) - strtotime($rstartdate);
            Log::info('Excel read End Time : ' . $renddate);
            Log::info('Excel read Time : ' . $process_time . ' Seconds');
            
            $rstartdate = date('Y-m-d H:i:s');
            Log::info('Excel write Start Time : ' . $rstartdate);
            $ActiveSheetTemplate->insertNewRowBefore($RateSheetHeaderSize+2,$drow);
            $ActiveSheetTemplate->fromArray($allRows, NULL, 'A'.($RateSheetHeaderSize+1));
            $renddate = date('Y-m-d H:i:s');
            $process_time = strtotime($renddate) - strtotime($rstartdate);
            Log::info('Excel write End Time : ' . $renddate);
            Log::info('Excel write Time : ' . $process_time . ' Seconds');


            $rstartdate = date('Y-m-d H:i:s');
            Log::info('Excel replace variables Start Time : ' . $rstartdate);
            for($i=0;$i<=$RateSheetHeaderSize;$i++) {
                for($j=0;$j<6;$j++) {
                    $col = $this->num2char($j);
                    $excel_header = $ActiveSheetTemplate->getCell($col.''.$i);
                    $excel_header = template_var_replace($excel_header,$replace_array);
                    $excel_header = str_replace('{{CurrentDate}}',date('d-m-Y'),$excel_header);
                    if(preg_match('/{{CurrentDate(.*?)}}/',$excel_header,$date_placeholder)) {
                        $date_format = explode('|',$date_placeholder[0]);
                        $date_format = rtrim($date_format[1],'}');
                        $date = date($date_format);
                        $excel_header = str_replace($date_placeholder,$date,$excel_header);
                    }
                    if($excel_header == '{{increase_max_date}}') {
                        $excel_header = str_replace('{{increase_max_date}}',$max_increase_date,$excel_header);
                    }
                    if($excel_header == '{{decrease_max_date}}') {
                        $excel_header = str_replace('{{decrease_max_date}}',$max_decrease_date,$excel_header);
                    }
                    $ActiveSheetTemplate->setCellValue($col.''.$i,$excel_header);
                }
            }
            $RateSheetFooterSize = $RateSheetFooterSize+$RateSheetHeaderSize+2;
            for($i=($RateSheetHeaderSize+count($excel_data_sheet)+1);$i<($RateSheetFooterSize+count($excel_data_sheet)-1);$i++) {
                for($j=0;$j<6;$j++) {
                    $col = $this->num2char($j);
                    $excel_footer = $ActiveSheetTemplate->getCell($col.''.$i);
                    $excel_footer = template_var_replace($excel_footer,$replace_array);
                    $ActiveSheetTemplate->setCellValue($col.''.$i,$excel_footer);
                }
            }
            $renddate = date('Y-m-d H:i:s');
            $process_time = strtotime($renddate) - strtotime($rstartdate);
            Log::info('Excel replace variables End Time : ' . $renddate);
            Log::info('Excel replace variables Time : ' . $process_time . ' Seconds');


            $rstartdate = date('Y-m-d H:i:s');
            Log::info('Excel save Start Time : ' . $rstartdate);
            $objWriter = \PHPExcel_IOFactory::createWriter($objPHPExcelTemplate, 'Excel2007');
            $this->file = substr($this->file, 0, strrpos($this->file,".")).'.xlsx';
            $objWriter->save($this->file);
            $renddate = date('Y-m-d H:i:s');
            $process_time = strtotime($renddate) - strtotime($rstartdate);
            Log::info('Excel save End Time : ' . $renddate);
            Log::info('Excel save Time : ' . $process_time . ' Seconds');

        } else {

            if($downloadtype == 'xlsx'){
                $writer = WriterFactory::create(Type::XLSX); // for XLSX files
            }else{
                $writer = WriterFactory::create(Type::CSV); // for CSV files
            }

            $writer->openToFile($this->file); // write data to a file or to a PHP stream

            if(isset($header_data)){
                $writer->addRow($header_data);
            }
            if(isset($excel_data_sheet) > 0 ) {
                $writer->addRows($excel_data_sheet); // add multiple rows at a time
            }
            $writer->close();
        }
        $end_time = date('Y-m-d H:i:s');
        Log::info('Excel Generate End Time : ' . $end_time);
        $process_time = strtotime($end_time) - strtotime($start_time);
        Log::info('Excel Generation Time : ' . $process_time . ' Seconds');
    }

    public function num2char($num) {
        $numeric = $num % 26;
        $letter = chr(65 + $numeric);
        $num2 = intval($num / 26);
        if ($num2 > 0) {
            return $this->num2char($num2 - 1) . $letter;
        } else {
            return $letter;
        }
    }

    /**
     * Generare Multi Rate Sheet Excel file
     * @param $excel_data_sheet
     * @param $header_data
     * @param $data
     * @throws \Box\Spout\Common\Exception\UnsupportedTypeException
     */
    public function write_multi_ratessheet_excel_generate($data,$downloadtype){
        $CompanyID = $data['Company']->CompanyID;

        $this->file = substr($this->file, 0, strrpos($this->file,".")).'.xlsx';

        $RateSheetTemplate = CompanySetting::getKeyVal($CompanyID,'RateSheetTemplate') != 'Invalid Key' ? json_decode(CompanySetting::getKeyVal($CompanyID,'RateSheetTemplate')) : '';
        $RateSheetTemplateFile = '';
        if($RateSheetTemplate != '') {
            $RateSheetTemplateFile = $temp_file = $RateSheetTemplate->Excel;
            $RateSheetTemplateFile = AmazonS3::preSignedUrl($RateSheetTemplateFile,$CompanyID);

            if(is_amazon($CompanyID) == true) {
                $upload_path = CompanyConfiguration::get($CompanyID,'TEMP_PATH');
                $temp_file = substr($temp_file, strrpos($temp_file, '/') + 1);
                file_put_contents($upload_path.'/'.$temp_file, fopen($RateSheetTemplateFile, 'r'));
                $RateSheetTemplateFile = $upload_path.'/'.$temp_file;
            }
        }
        if($RateSheetTemplateFile != '') {
            $writer = WriterFactory::create(Type::XLSX);
            $writer->openToFile($this->file);

            Log::info( " writing to... " . $this->file );
            $excel_data = isset($data['excel_data'])?$data['excel_data']:array();

            $replace_array = Helper::create_replace_array($data['Account'],array());
            $replace_array['TrunkPrefix'] = empty($data['Account']->trunkprefix)?'':$data['Account']->trunkprefix;
            $replace_array['TrunkName'] = empty($data['Account']->trunk_name)?'':$data['Account']->trunk_name;

            if(!empty($data['Account']->CurrencyId) && $data['Account']->CurrencyId > 0) {
                $Currency = Currency::find($data['Account']->CurrencyId);
                $replace_array['CurrencyCode'] = $Currency->Code;
                $replace_array['CurrencyDescription'] = $Currency->Description;
                $replace_array['CurrencySymbol'] = $Currency->Symbol;
            } else {
                $replace_array['CurrencyCode'] = "";
                $replace_array['CurrencyDescription'] = "";
                $replace_array['CurrencySymbol'] = "";
            }

            $max_increase_date = '0000-00-00';
            $max_decrease_date = '0000-00-00';

            if(isset($excel_data) > 0 ) {
                $sheet_index1 = 0;
                foreach ($excel_data as $trunk => $excel_rows) {
                    if($sheet_index1 == 0)
                        $sheet = $writer->getCurrentSheet();
                    else
                        $sheet = $writer->addNewSheetAndMakeItCurrent();

                    $sheet->setName($trunk);

                    $excel_data_sheet = array();
                    $header_data = array();

                    foreach($excel_rows as $excel_data_rr){
                        array_shift($excel_data_rr);
                        array_shift($excel_data_rr);
                        array_shift($excel_data_rr);

                        $excel_data_rr['rate per minute (usd)'] = number_format(str_replace(',','',$excel_data_rr['rate per minute (usd)']), 4);

                        $excel_data_sheet[] = $excel_data_rr;

                        if(strtolower($excel_data_rr['change']) == 'increase') {
                            if($excel_data_rr['effective date'] > $max_increase_date)
                                $max_increase_date = $excel_data_rr['effective date'];
                        }
                        if(strtolower($excel_data_rr['change']) == 'decrease') {
                            if($excel_data_rr['effective date'] > $max_decrease_date)
                                $max_decrease_date = $excel_data_rr['effective date'];
                        }

                        if($max_increase_date == '0000-00-00')
                            $max_increase_date = "";
                        if($max_decrease_date == '0000-00-00')
                            $max_decrease_date = "";

                        $header_data = array_keys($excel_data_rr);
                    }
                    $header_data  = array_map('ucwords',$header_data);
                    if(count($header_data) == 0){
                        $header_data[] = 'Destination';
                        $header_data[] = 'Codes';
                        $header_data[] = 'Tech Prefix';
                        $header_data[] = 'Interval';
                        $header_data[] = 'Rate Per Minute (usd)';
                        $header_data[] = 'Level';
                        $header_data[] = 'Change';
                        $header_data[] = 'Effective Date';
                    }
                    array_walk($header_data , 'custom_replace');

                    if(isset($header_data)){
                        $writer->addRow($header_data);
                    }
                    if(isset($excel_data_sheet) > 0 ) {
                        $writer->addRows($excel_data_sheet); // add multiple rows at a time
                    }

                    Log::info($trunk . " sheet index " . $sheet_index1 );
                    $sheet_index1++;
                }

                $writer->close();
            }

            $objPHPExcelTemplate = \PHPExcel_IOFactory::load($RateSheetTemplateFile);
            $ActiveSheetTemplate = $objPHPExcelTemplate->getActiveSheet();

            $RateSheetHeaderSize = $RateSheetTemplate->HeaderSize != null ? (int) $RateSheetTemplate->HeaderSize : 0 ;
            $RateSheetFooterSize = $RateSheetTemplate->FooterSize != null ? (int) $RateSheetTemplate->FooterSize : 0 ;

            $objPHPExcelFile = \PHPExcel_IOFactory::load($this->file);

            $sheetCount = $objPHPExcelFile->getSheetCount();
            for($l=0;$l<$sheetCount;$l++) {
                $objPHPExcelFile->setActiveSheetIndex($l);
                $ActiveSheetFile = $objPHPExcelFile->getActiveSheet();

                if($l==0) {
                    $ActiveSheetTemplate->setTitle($ActiveSheetFile->getTitle());
                }

                if($l != 0) {
                    $objWorkSheet1 = clone $ActiveSheetTemplate;
                    $objWorkSheet1->setTitle($ActiveSheetFile->getTitle());
                    $objPHPExcelTemplate->addSheet($objWorkSheet1);
                }
            }

            $trunks = array_keys($excel_data);

            for($l=0;$l<$sheetCount;$l++) {

                $replace_array['TrunkPrefix'] = empty($trunks[$l])?'':$trunks[$l];
                $replace_array['TrunkName'] = empty($trunks[$l])?'':$trunks[$l];

                $objPHPExcelFile->setActiveSheetIndex($l);
                $ActiveSheetFile = $objPHPExcelFile->getActiveSheet();
                $objPHPExcelTemplate->setActiveSheetIndex($l);
                $ActiveSheetTemplate = $objPHPExcelTemplate->getActiveSheet();

                $drow = $ActiveSheetFile->getHighestRow();
                $dcol = $ActiveSheetFile->getHighestColumn();

                $allRows = $ActiveSheetFile->rangeToArray('A1:'.$dcol.$drow);

                $ActiveSheetTemplate->insertNewRowBefore($RateSheetHeaderSize+2,$drow);
                $ActiveSheetTemplate->fromArray($allRows, NULL, 'A'.($RateSheetHeaderSize+1));

                for($i=0;$i<=$RateSheetHeaderSize;$i++) {
                    for($j=0;$j<6;$j++) {
                        $col = $this->num2char($j);
                        $excel_header = $ActiveSheetTemplate->getCell($col.''.$i);
                        $excel_header = template_var_replace($excel_header,$replace_array);
                        $excel_header = str_replace('{{CurrentDate}}',date('d-m-Y'),$excel_header);
                        if(preg_match('/{{CurrentDate(.*?)}}/',$excel_header,$date_placeholder)) {
                            $date_format = explode('|',$date_placeholder[0]);
                            $date_format = rtrim($date_format[1],'}');
                            $date = date($date_format);
                            $excel_header = str_replace($date_placeholder,$date,$excel_header);
                        }
                        if($excel_header == '{{increase_max_date}}') {
                            $excel_header = str_replace('{{increase_max_date}}',$max_increase_date,$excel_header);
                        }
                        if($excel_header == '{{decrease_max_date}}') {
                            $excel_header = str_replace('{{decrease_max_date}}',$max_decrease_date,$excel_header);
                        }
                        $ActiveSheetTemplate->setCellValue($col.''.$i,$excel_header);
                    }
                }
                $RateSheetFooterSize = $RateSheetFooterSize+$RateSheetHeaderSize+2;
                for($i=($RateSheetHeaderSize+count($excel_data_sheet)+1);$i<($RateSheetFooterSize+count($excel_data_sheet)-1);$i++) {
                    for($j=0;$j<6;$j++) {
                        $col = $this->num2char($j);
                        $excel_footer = $ActiveSheetTemplate->getCell($col.''.$i);
                        $excel_footer = template_var_replace($excel_footer,$replace_array);
                        $ActiveSheetTemplate->setCellValue($col.''.$i,$excel_footer);
                    }
                }
            }

            $objWriter = \PHPExcel_IOFactory::createWriter($objPHPExcelTemplate, 'Excel2007');
            $this->file = substr($this->file, 0, strrpos($this->file,".")).'.xlsx';
            $objWriter->save($this->file);

        } else {
            $writer = WriterFactory::create(Type::XLSX);
            $writer->openToFile($this->file); // write data to a file or to a PHP stream
            Log::info( " writing to... " . $this->file );
            $excel_data = isset($data['excel_data'])?$data['excel_data']:array();

            if(isset($excel_data) > 0 ) {
                $sheet_index = 1;
                foreach($excel_data as $trunk => $excel_rows) {
                    $excel_data_sheet = array();
                    $header_data = array();
                    foreach($excel_rows as $excel_data_rr){
                        array_shift($excel_data_rr);
                        array_shift($excel_data_rr);
                        array_shift($excel_data_rr);
                        $excel_data_sheet[] = $excel_data_rr;
                        $header_data = array_keys($excel_data_rr);
                    }
                    $header_data  = array_map('ucwords',$header_data);
                    if(count($header_data) == 0){
                        $header_data[] = 'Destination';
                        $header_data[] = 'Codes';
                        $header_data[] = 'Tech Prefix';
                        $header_data[] = 'Interval';
                        $header_data[] = 'Rate Per Minute (usd)';
                        $header_data[] = 'Level';
                        $header_data[] = 'Change';
                        $header_data[] = 'Effective Date';
                    }
                    array_walk($header_data , 'custom_replace');
                    $replace_array = Helper::create_replace_array($data['Account'],array());
                    $header_data = template_var_replace($header_data,$replace_array);

                    Log::info($trunk . " sheet index " . $sheet_index );
                    if($sheet_index == 1){
                        $sheet = $writer->getCurrentSheet();
                        $sheet_index++;
                    }else{
                        $sheet = $writer->addNewSheetAndMakeItCurrent();
                    }

                    $sheet->setName($trunk);

                    if(isset($header_data)){
                        $writer->addRow($header_data);
                    }
                    $writer->addRows($excel_data_sheet); // add multiple rows at a time
                }
            }
            $writer->close();
        }
    }

    /**
     * Generare Rate Update CSV file
     * @param $data
     * @throws \Box\Spout\Common\Exception\UnsupportedTypeException
     */
    public function generate_rate_update_file($data){

        $writer = WriterFactory::create(Type::CSV); // for CSV files

        /**
         * write into tmp file and rename to .csv file.
         */
        $new_file = $this->file;
        $old_file = str_replace(".csv",".tmp",$this->file);
        $this->file  = $old_file ;
        $writer->openToFile($this->file); // write data to a file or to a PHP stream

        $header_data = array_keys($data[0]);
        if(isset($header_data)){
            $writer->addRow($header_data);
        }
        $writer->addRows($data); // add multiple rows at a time
        $writer->close();
        if(rename (  $old_file , $new_file )) {
            return true;
        }

    }

    /**
     * Remove footer bottom rows for vendor upload file - for file cleanup.
     * @param $result
     */
    public function remove_footer_bottom_rows($result){

        if ( count($result) > 0 ) {

//            Log::info("Before end row cleanup");
//            Log::info("Total Result entries " . count($result));
//            Log::info(print_r($result[0],true));
//            Log::info(print_r($result[(count($result)-1)],true));

            $columns = array_keys($result);

            if(count($columns) > 0) {

                for($i  = count($result) - 1 ; $i > 0; $i--)
                {
                    $empty_cnt = 0;
                    foreach ($columns as $column ) {

                        if(isset($result[$i][$column]) && empty($result[$i][$column])){
                            $empty_cnt++;
                        }
                    }
                    if($empty_cnt > 2){
                        unset($result[$i]);
                    } else {
                        break;
                    }
                }
            }

//            Log::info("After end row cleanup");
//            Log::info("Total Result entries " . count($result));
//            Log::info(print_r($result[0],true));
//            Log::info(print_r($result[(count($result)-1)],true));

        }
        return $result;

    }

    public function convertExcelToCSV($data) {
        try {
            $file_name = $this->file;
            $ext = pathinfo($file_name, PATHINFO_EXTENSION);

            if (in_array(strtolower($ext), array("xls", "xlsx"))) {
                //reading from excel file and getting data from excel file starts
                $start_time = date('Y-m-d H:i:s');
                $objPHPExcelReader = PHPExcel_IOFactory::load($file_name);

                if(!empty($this->Sheet)) {
                    $objPHPExcelReader->setActiveSheetIndexByName($this->Sheet);
                }
                $ActiveSheet = $objPHPExcelReader->getActiveSheet();
                $drow = $ActiveSheet->getHighestDataRow();
                $dcol = $ActiveSheet->getHighestDataColumn();

                $start_row = intval($data["start_row"]) + 1;
                $end_row = ($drow - intval($data["end_row"]));

                Log::info('start row : ' . $start_row);
                Log::info('highest row : ' . $drow . ' and highest col : ' . $dcol);

                $start_time1 = date('Y-m-d H:i:s');
                $allRows = $ActiveSheet->rangeToArray('A' . $start_row . ':' . $dcol . $end_row);
                $end_time1 = date('Y-m-d H:i:s');
                $process_time1 = strtotime($end_time1) - strtotime($start_time1);
                Log::info('rangeToArray function call time : ' . $process_time1 . ' Seconds');

                //$file_name = substr($file_name, 0, strrpos($file_name, '.')) . '.csv';
                $file_name = substr($file_name, 0, strrpos($file_name, '.')) .'_'.$this->Sheet.'.csv';
                $end_time = date('Y-m-d H:i:s');
                $process_time = strtotime($end_time) - strtotime($start_time);
                Log::info('Convert to csv read time : ' . $process_time . ' Seconds');
                //reading from excel file and getting data from excel file ends

                $header_rows = $footer_rows = array();
                $char_arr = array_combine(range('a','z'),range(1,26));

                if ($start_row > 0) {
                    for ($i = 0; $i < intval($data["start_row"]); $i++) {
                        $row = array();
                        for ($j = 0; $j <= $char_arr[strtolower($dcol)] - 1; $j++) {
                            $row[$j] = "";
                        }
                        $header_rows[$i] = $row;
                    }
                }
                if (intval($data["end_row"]) > 0) {
                    for ($i = 0; $i < intval($data["end_row"]); $i++) {
                        $row = array();
                        for ($j = 0; $j <= $char_arr[strtolower($dcol)] - 2; $j++) {
                            $row[$j] = "";
                        }
                        $footer_rows[$i] = $row;
                    }
                }

                // creating csv file starts
                $start_time = date('Y-m-d H:i:s');
                $writer = WriterFactory::create('csv');
                $writer->openToFile($file_name);
                $writer->addRows($header_rows);
                $writer->addRows($allRows);
                $writer->addRows($footer_rows);
                $writer->close();
                $end_time = date('Y-m-d H:i:s');
                $process_time = strtotime($end_time) - strtotime($start_time);
                Log::info('Convert to csv using PHPExcel : ' . $process_time . ' Seconds');
                // creating csv file ends

                return $file_name;
            } else {
                return $file_name;
            }
        } catch (Exception $e) {
            return Response::json(array("status" => "failed", "message" => $e->getMessage()));
        }
    }

    //same function in service when change this need to change in service too
    public function readExcel($filepath,$limit=0) {
        $start_time = date('Y-m-d H:i:s');

        $start_time1 = date('Y-m-d H:i:s');
        $objPHPExcelReader = PHPExcel_IOFactory::load($filepath);
        $end_time1 = date('Y-m-d H:i:s');
        $process_time1 = strtotime($end_time1) - strtotime($start_time1);
        Log::info('load function call time : ' . $process_time1 . ' Seconds');

        $start_time1 = date('Y-m-d H:i:s');
        if(!empty($this->Sheet)) {
            $objPHPExcelReader->setActiveSheetIndexByName($this->Sheet);
        }
        $ActiveSheet = $objPHPExcelReader->getActiveSheet();
        $end_time1 = date('Y-m-d H:i:s');
        $process_time1 = strtotime($end_time1) - strtotime($start_time1);
        Log::info('getActiveSheet function call time : ' . $process_time1 . ' Seconds');

        $start_time1 = date('Y-m-d H:i:s');
        $drow = $ActiveSheet->getHighestDataRow();
        $end_time1 = date('Y-m-d H:i:s');
        $process_time1 = strtotime($end_time1) - strtotime($start_time1);
        Log::info('getHighestDataRow function call time : ' . $process_time1 . ' Seconds');

        $start_time1 = date('Y-m-d H:i:s');
        $dcol = $ActiveSheet->getHighestDataColumn();
        $end_time1 = date('Y-m-d H:i:s');
        $process_time1 = strtotime($end_time1) - strtotime($start_time1);
        Log::info('getHighestDataColumn function call time : ' . $process_time1 . ' Seconds');

        $start_row = intval(self::$start_row) + 1;
        $end_row   = $limit > 0 ? ($start_row + $limit) : ($drow - self::$end_row);
        //$end_row   = ($drow - intval(self::$end_row));

        $start_time1 = date('Y-m-d H:i:s');
        $all_rows = $ActiveSheet->rangeToArray('A' . $start_row . ':' . $dcol . $end_row);
        $end_time1 = date('Y-m-d H:i:s');
        $process_time1 = strtotime($end_time1) - strtotime($start_time1);
        Log::info('rangeToArray function call time : ' . $process_time1 . ' Seconds');
        Log::info('start row : ' . $start_row);

        //Log::info(print_r($all_rows,true));
        $end_time = date('Y-m-d H:i:s');
        $process_time = strtotime($end_time) - strtotime($start_time);
        Log::info('Convert to csv read time : ' . $process_time . ' Seconds');

        if($this->first_row == self::$COLUMN_NAMES) {
            $start_time = date('Y-m-d H:i:s');

            $result = $first_row = array();

            $i = 0;
            foreach ($all_rows as $row) {
                if ($i == 0) {
                    $first_row = $row;
                } else {
                    $j = 0;
                    foreach ($row as $column) {
                        $result[$i - 1][$first_row[$j]] = $column;
                        $j++;
                    }
                }
                $i++;
            }

            $end_time = date('Y-m-d H:i:s');
            $process_time = strtotime($end_time) - strtotime($start_time);
            Log::info('loop time : ' . $process_time . ' Seconds');

        } else {
            $result = $all_rows;
        }
        //Log::info(print_r($result, true));

        return $result;
    }

    //same function in service when change this need to change in service too
    public function readExcel2($filepath,$limit=0) {
        $start_time1 = round(microtime(true) * 1000);

        $reader = ReaderFactory::create(Type::XLSX); // for XLSX files
        $reader->setShouldFormatDates(true);
        $reader->open($filepath);

        $i=0;$all_rows=[];$sheet_index=0;
        foreach ($reader->getSheetIterator() as $sheet) {
            if((!empty($this->Sheet) && $sheet->getName() == $this->Sheet) || (empty($this->Sheet) && $sheet_index==0)) {
                foreach ($sheet->getRowIterator() as $row) {
                    $i++;

                    if ($i <= self::$start_row) continue;
                    if ($limit != 0 && $i > (self::$start_row+$limit)) break;

                    $all_rows[] = $row;
                }
            }
            $sheet_index++;
        }

        if($this->first_row == self::$COLUMN_NAMES) {
            $result = $first_row = array();

            $i = 0;
            foreach ($all_rows as $row) {
                if ($i == 0) {
                    $first_row = $row;
                } else {
                    $j = 0;
                    foreach ($row as $column) {
                        $result[$i - 1][$first_row[$j]] = $column;
                        $j++;
                    }
                }
                $i++;
            }
        } else {
            $result = $all_rows;
        }

        $reader->close();

        $end_time1 = round(microtime(true) * 1000);
        $process_time1 = ($end_time1 - $start_time1) / 1000;
        Log::info('readExcel2 call time : ' . $process_time1 . ' Seconds');

        return $result;
    }

}