<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class PrcUpdateLiveTables3 extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{

		echo file_get_contents('database/migrations/test.sql');
		\Illuminate\Support\Facades\DB::unprepared(file_get_contents('database/migrations/test.sql'));

	}

	/**
	 * Reverse the migrations.
	 *
	 * @return void
	 */
	public function down()
	{
		//
	}

}
