<?php namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use App\lib\Log;
use Monolog\Logger as Monolog;


class AppServiceProvider extends ServiceProvider {

	/**
	 * Bootstrap any application services.
	 *
	 * @return void
	 */
	public function boot()
	{
		//
	}

	/**
	 * Register any application services.
	 *
	 * This service provider is a great spot to register your various container
	 * bindings with the application. As you can see, we are registering our
	 * "Registrar" implementation here. You can add your own bindings too!
	 *
	 * @return void
	 */
	public function register()
	{
		$this->app->bind(
			'Illuminate\Contracts\Auth\Registrar',
			'App\Services\Registrar'
		);

		if(getenv('APP_DEBUG') == 0){
			$this->registerLogger();
		}

	}


	public function registerLogger()
	{
		$this->app->instance('log', $log = new Log(
			new Monolog($this->app->environment()), $this->app['events'])
		);
		return $log;
	}

}
