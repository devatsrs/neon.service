<?php
/**
 * WARNING: Do not edit by hand, this file was generated by Crank:
 *
 *   https://github.com/gocardless/crank
 */

namespace App\GoCardlessPro\Core;

/**
 * Wrapper for a list of models in a response
 * Decodes from a Response
 * @subpackage Core
 */
class ListResponse
{
    public $records = array();
    public $api_response;
    public $after;
    public $before;

    /**
     * Creates a new list response of the same model class and decodes
     * the array from the raw response.
     *
     * @param object      $unenveloped_body The unenveloped API response
     * @param string      $model_class      The class to build for each element in the body
     * @param ApiResponse $api_response     The raw ApiResponse from the original request
     */
    public function __construct($unenveloped_body, $model_class, $api_response)
    {
        $this->api_response = $api_response;
        $this->before = $this->api_response->body->meta->cursors->before;
        $this->after = $this->api_response->body->meta->cursors->after;

        foreach ($unenveloped_body as $item) {
            $this->records[] = new $model_class($item);
        }
    }
}
