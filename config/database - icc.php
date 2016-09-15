<?php

return [

	/*
	|--------------------------------------------------------------------------
	| PDO Fetch Style
	|--------------------------------------------------------------------------
	|
	| By default, database results will be returned as instances of the PHP
	| stdClass object; however, you may desire to retrieve records in an
	| array format for simplicity. Here you can tweak the fetch style.
	|
	*/

	'fetch' => PDO::FETCH_CLASS,

	/*
	|--------------------------------------------------------------------------
	| Default Database Connection Name
	|--------------------------------------------------------------------------
	|
	| Here you may specify which of the database connections below you wish
	| to use as your default connection for all database work. Of course
	| you may use many connections at once using the Database library.
	|
	*/

	'default' => 'sqlsrv',

	/*
	|--------------------------------------------------------------------------
	| Database Connections
	|--------------------------------------------------------------------------
	|
	| Here are each of the database connections setup for your application.
	| Of course, examples of configuring each database platform that is
	| supported by Laravel is shown below to make development simple.
	|
	|
	| All database work in Laravel is done through the PHP PDO facilities
	| so make sure you have the driver for your particular database of
	| choice installed on your machine before you begin development.
	|
	*/

	'connections' => [


		'sqlite' => [
			'driver'   => 'sqlite',
			'database' => storage_path().'/database.sqlite',
			'prefix'   => '',
		],

		'mysql' => [
			'driver'    => 'mysql',
			'host'      => 'localhost',
			'database'  => 'NeonRM',
			'username'  => 'neon-user',
			'password'  => '@r*aCz;@[vFMZRS/Pn3`',
			'charset'   => 'utf8',
			'collation' => 'utf8_unicode_ci',
			'prefix'    => '',
			'strict'    => false,
		],

		'pgsql' => [
			'driver'   => 'pgsql',
			'host'     => 'localhost',
			'database' => 'NeonRM',
			'username' => 'neon-user',
			'password' => '@r*aCz;@[vFMZRS/Pn3`',
			'charset'  => 'utf8',
			'prefix'   => '',
			'schema'   => 'public',
		],

		'sqlsrv' => [
			'driver'   => 'mysql',
			'host'     => 'localhost',
			'database' => 'NeonRM',
			'username' => 'neon-user',
			'password' => '@r*aCz;@[vFMZRS/Pn3`',
			'charset'   => 'utf8',
			'collation' => 'utf8_unicode_ci',
			'prefix'    => '',
			'strict'    => false,
		],
        'sqlsrv2' => [
            'driver'   => 'mysql',
            'host'     => 'localhost',
            'database' => 'NeonBilling',
            'username' => 'neon-user',
            'password' => '@r*aCz;@[vFMZRS/Pn3`',
			'charset'   => 'utf8',
			'collation' => 'utf8_unicode_ci',
			'prefix'    => '',
			'strict'    => false,
        ],
        'sqlsrvcdr' => [
            'driver'   => 'mysql',
            'host'     => 'localhost',
            'database' => 'NeonCDR',
            'username' => 'neon-user',
            'password' => '@r*aCz;@[vFMZRS/Pn3`',
			'charset'   => 'utf8',
			'collation' => 'utf8_unicode_ci',
			'prefix'    => '',
			'strict'    => false,
        ],
        'sqlsrvcdrazure' => [
            'driver'   => 'mysql',
            'host'     => 'localhost',
            'database' => 'NeonCDR',
            'username' => 'neon-user',
            'password' => '@r*aCz;@[vFMZRS/Pn3`',
			'charset'   => 'utf8',
			'collation' => 'utf8_unicode_ci',
			'prefix'    => '',
			'strict'    => false,
        ],
        'pbxmysql' => [
            'driver'    => 'mysql',
            'host'      => env('DB_HOSTPBX', 'localhost'),
            'database'  => env('DB_DATABASEPBX', 'forge'),
            'username'  => env('DB_USERNAMEPBX', 'forge'),
            'password'  => env('DB_PASSWORDPBX', ''),
            'charset'   => 'utf8',
            'collation' => 'utf8_unicode_ci',
            'prefix'    => '',
            'strict'    => false,
        ],
        'sqlsrvmaster' => [
            'driver'    => 'sqlsrv',
            'host'      => 'ratemanagement2\sqlexpress',
            'database'  => 'Ratemanagement3',
            'username'  => 'sa',
            'password'  => 'England1',
            'charset'   => 'utf8',
            'collation' => 'utf8_unicode_ci',
            'prefix'    => '',
            'strict'    => false,
        ],
        'mysqllinux' => [
            'driver'    => 'mysql',
            'host'      => '188.227.186.98',
            'database'  => 'Ratemanagement3',
            'username'  => 'neon-user',
            'password'  => 'aJcH!^VUnI#2WsYZQ45a',
            'charset'   => 'utf8',
            'collation' => 'utf8_unicode_ci',
            'prefix'    => '',
            'strict'    => false,
        ],
		'neon_report' => [
			'driver'    => 'mysql',
			'host'      => 'localhost',
			'database'  => 'NeonReport',
			'username'  => 'neon-user',
			'password'  => '@r*aCz;@[vFMZRS/Pn3`',
			'charset'   => 'utf8',
			'collation' => 'utf8_unicode_ci',
			'prefix'    => '',
			'strict'    => false,
			'options' => [
				PDO::MYSQL_ATTR_INIT_COMMAND => 'SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;'
			]
		],

	],

	/*
	|--------------------------------------------------------------------------
	| Migration Repository Table
	|--------------------------------------------------------------------------
	|
	| This table keeps track of all the migrations that have already run for
	| your application. Using this information, we can determine which of
	| the migrations on disk haven't actually been run in the database.
	|
	*/

	'migrations' => 'migrations',

	/*
	|--------------------------------------------------------------------------
	| Redis Databases
	|--------------------------------------------------------------------------
	|
	| Redis is an open source, fast, and advanced key-value store that also
	| provides a richer set of commands than a typical key-value systems
	| such as APC or Memcached. Laravel makes it easy to dig right in.
	|
	*/

	'redis' => [

		'cluster' => false,

		'default' => [
			'host'     => '127.0.0.1',
			'port'     => 6379,
			'database' => 0,
		],

	],

];
