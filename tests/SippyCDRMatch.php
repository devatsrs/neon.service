<?php

class SippyCDRMatch extends TestCase {


	/**
	 * A basic functional test example.
	 *
	 * @return void
	 */
	public function testBasicExample2()
	{

		Log::useFiles(storage_path() . '/logs/tempcommand-' .  date('Y-m-d') . '.log');

		$SippySQL = new SippySQL(3);
		$cdrs_table = "cdrs";
		$cdrs_connections_table = "cdrs_connections";
		$calls_table = "calls";
		$response = [];
		$tempVendortable = 'tblTempSippyCDRCompare';


		$InserData = $InserVData = array();
		$data_count = $data_countv = 0;
		$insertLimit = 1000;


		//$cdrs_conn_qry = "select cc.i_account_debug,cc.remote_ip,c.setup_time,cc.disconnect_time,cc.cost,cc.cld_out,cc.cli_out,cc.billed_duration,cc.prefix,cc.i_call,c.i_call from ".$cdrs_connections_table." as cc inner join ".$calls_table." as c on cc.i_call = c.i_call where date(cc.disconnect_time) = '" . $StartDate. "' ";
		//Log::info($cdrs_conn_qry);

		//$response['cdrs_response_connection'] = DB::connection('pgsql')->select($cdrs_conn_qry);
		//\Illuminate\Support\Facades\Cache::add("cdrs_response_connection", $response['cdrs_response_connection'], 60);

		$response['cdrs_response_connection'][] = json_decode(json_encode(\Illuminate\Support\Facades\Cache::get("cdrs_response_connection")), true);

		if (isset($response['cdrs_response_connection'])) {
			$IpBased = 0;
			foreach ($response['cdrs_response_connection'] as $cdr_rows) {
				Log::error('call count vendor ' . count($cdr_rows));
				foreach ($cdr_rows as $cdr_row) {
					if ( $cdr_row['cost'] > 0 && ($IpBased == 0 && !empty($cdr_row['i_account_debug'])) || ($IpBased == 1 && !empty($cdr_row['remote_ip']))) {


						$uddata = array();
						$uddata['remote_ip'] = $cdr_row['remote_ip'];
						$uddata['i_account_debug'] = $cdr_row['i_account_debug'];
						$uddata['setup_time'] = $cdr_row['setup_time'];
						$uddata['disconnect_time'] = $cdr_row['disconnect_time'];
						$uddata['cost'] = (float)$cdr_row['cost'];
						$uddata['cld_out'] = $cdr_row['cld_out'];
						$uddata['cli_out'] = $cdr_row['cli_out'];
						$uddata['billed_duration'] = $cdr_row['billed_duration'];
						$uddata['prefix'] = $cdr_row['prefix'];
						$uddata['i_call'] = $cdr_row['i_call'];

						$InserVData[] = $uddata;

						if ($data_countv > $insertLimit && !empty($InserVData)) {
							DB::connection('sqlsrvcdr')->table($tempVendortable)->insert($InserVData);
							$InserVData = array();
							$data_countv = 0;
							echo  "
										" . $data_countv;
						}
						$data_countv++;
					}
				}
			}// loop
		}
		if (!empty($InserVData)) {
			DB::connection('sqlsrvcdr')->table($tempVendortable)->insert($InserVData);
		}
		Log::info("vendor CDR Insert END");

	}

}
