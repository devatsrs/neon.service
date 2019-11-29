<?php
namespace App\Lib;
class Logging extends \Illuminate\Log\Writer
{

    public function alert($message, array $context = array())
	{
		return false;
	}

	/**
	 * Log a critical message to the logs.
	 *
	 * @param  string  $message
	 * @param  array  $context
	 * @return void
	 */
	public function critical($message, array $context = array())
	{
		return false;
	}

	/**
	 * Log an error message to the logs.
	 *
	 * @param  string  $message
	 * @param  array  $context
	 * @return void
	 */
	public function error($message, array $context = array())
	{
		return $this->writeLog(__FUNCTION__, $message, $context);
	}

	/**
	 * Log a warning message to the logs.
	 *
	 * @param  string  $message
	 * @param  array  $context
	 * @return void
	 */
	public function warning($message, array $context = array())
	{
		return false;
	}

	/**
	 * Log a notice to the logs.
	 *
	 * @param  string  $message
	 * @param  array  $context
	 * @return void
	 */
	public function notice($message, array $context = array())
	{
		return false;
	}

	/**
	 * Log an informational message to the logs.
	 *
	 * @param  string  $message
	 * @param  array  $context
	 * @return void
	 */
	public function info($message, array $context = array())
	{
		return false;
	}

	/**
	 * Log a debug message to the logs.
	 *
	 * @param  string  $message
	 * @param  array  $context
	 * @return void
	 */
	public function debug($message, array $context = array())
	{
		return false;
	}

}