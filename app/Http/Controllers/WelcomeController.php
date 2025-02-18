<?php namespace App\Http\Controllers;

use App\Commands\SendEmail;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Queue;

class WelcomeController extends Controller {

	/*
	|--------------------------------------------------------------------------
	| Welcome Controller
	|--------------------------------------------------------------------------
	|
	| This controller renders the "marketing page" for the application and
	| is configured to only allow guests. Like most of the other sample
	| controllers, you are free to modify or remove it as you desire.
	|
	*/

	/**
	 * Create a new controller instance.
	 *
	 * @return void
	 */
	public function __construct()
	{
		$this->middleware('guest');
	}

	/**
	 * Show the application welcome screen to the user.
	 *
	 * @return Response
	 */
	public function index()
	{

        //Log::info('This is some useful information.');
        $companyID = 1;
        $userID = 1;
        $isAdmin = 1;
        //$query = "prc_GetAllDashboardData ".$companyID.",".$userID.",".$isAdmin;
        //$dashboardData = \DataTableSql::of($query)->getProcResult(array('TotalDueCustomer','TotalDueVendor','AllHeaderJobs','CountJobs','RecentJobFiles','getRecentLeads','getRecentAccounts'));
        //Queue::push(new SendEmail('devensitapara@yahoo.com'));
        return view('welcome');
	}

}
