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
			'host'      => env('DB_HOST', 'localhost'),
			'database'  => env('DB_DATABASE', 'forge'),
			'username'  => env('DB_USERNAME', 'forge'),
			'password'  => env('DB_PASSWORD', ''),
			'charset'   => 'utf8',
			'collation' => 'utf8_unicode_ci',
			'prefix'    => '',
			'strict'    => false,
		],

		'pgsql' => [
			'driver'   => 'pgsql',
			'host'     => env('DB_HOST', 'localhost'),
			'database' => env('DB_DATABASE', 'forge'),
			'username' => env('DB_USERNAME', 'forge'),
			'password' => env('DB_PASSWORD', ''),
			'charset'  => 'utf8',
			'prefix'   => '',
			'schema'   => 'public',
		],

		'sqlsrv' => [
			'driver'   => 'mysql',
			'host'     => env('DB_HOST', 'localhost'),
			'database' => env('DB_DATABASE', 'forge'),
			'username' => env('DB_USERNAME', 'forge'),
			'password' => substr(env('DB_PASSWORD', ''),5),
			'charset'   => 'utf8',
			'collation' => 'utf8_unicode_ci',
			'prefix'    => '',
			'strict'    => false,
		],
        'sqlsrv2' => [
            'driver'   => 'mysql',
            'host'     => env('DB_HOST2', 'localhost'),
            'database' => env('DB_DATABASE2', 'forge'),
            'username' => env('DB_USERNAME2', 'forge'),
            'password' => substr(env('DB_PASSWORD2', ''),5),
			'charset'   => 'utf8',
			'collation' => 'utf8_unicode_ci',
			'prefix'    => '',
			'strict'    => false,
        ],
        'sqlsrvcdr' => [
            'driver'   => 'mysql',
            'host'     => env('DB_HOSTCDR', 'localhost'),
            'database' => env('DB_DATABASECDR', 'forge'),
            'username' => env('DB_USERNAMECDR', 'forge'),
            'password' => substr(env('DB_PASSWORDCDR', ''),5),
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
            'password'  => substr(env('DB_PASSWORDPBX', ''),5),
            'charset'   => 'utf8',
            'collation' => 'utf8_unicode_ci',
            'prefix'    => '',
            'strict'    => false,
        ],
		'neon_report' => [
			'driver'    => 'mysql',
			'host'      => env('DB_HOSTREPORT', 'localhost'),
			'database'  => env('DB_DATABASEREPORT', 'forge'),
			'username'  => env('DB_USERNAMEREPORT', 'forge'),
			'password'  => substr(env('DB_PASSWORDREPORT', ''),5),
			'charset'   => 'utf8',
			'collation' => 'utf8_unicode_ci',
			'prefix'    => '',
			'strict'    => false,
			'options' => [
				PDO::MYSQL_ATTR_INIT_COMMAND => 'SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;'
			]
		],
            'neon_routingengine' => [
			'driver'    => 'mysql',
			'host'      => env('DB_HOSTRoutingEngine', 'localhost'),
			'database'  => env('DB_DATABASERoutingEngine', 'forge'),
			'username'  => env('DB_USERNAMERoutingEngine', 'forge'),
			'password'  => substr(env('DB_PASSWORDRoutingEngine', ''),5),
			'charset'   => 'utf8',
			'collation' => 'utf8_unicode_ci',
			'prefix'    => '',
			'strict'    => false,
			'options' => [
				PDO::MYSQL_ATTR_INIT_COMMAND => 'SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;'
			]
		],
		'vosmysql' => [
			'driver'   => 'mysql',
			'host'     => env('DB_HOSTVOS', 'localhost'),
			'database' => env('DB_DATABASEVOS', 'forge'),
			'username' => env('DB_USERNAMEVOS', 'forge'),
			'password' => substr(env('DB_PASSWORDVOS', ''),5),
			'charset'   => 'utf8',
			'collation' => 'utf8_unicode_ci',
			'prefix'    => '',
			'strict'    => false,
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
