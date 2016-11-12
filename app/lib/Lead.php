<?php
namespace App\Lib;

class Lead extends \Eloquent {
    protected $fillable = [];
    protected $guarded = array('InvoiceDetailID');
    protected $table = 'tblAccount';
    protected  $primaryKey = "AccountID";
	
	 public static $rules = array(
      //  'Owner' =>      'required',
        'CompanyID' =>  'required',
        'AccountName' => 'required|unique:tblAccount,AccountName',
       // 'FirstName' =>  'required',
       // 'LastName' =>  'required',
    );

}