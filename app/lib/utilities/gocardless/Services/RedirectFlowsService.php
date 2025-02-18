<?php
/**
 * WARNING: Do not edit by hand, this file was generated by Crank:
 *
 * https://github.com/gocardless/crank
 */

namespace App\GoCardlessPro\Services;

use App\GoCardlessPro\Core\Paginator;
use App\GoCardlessPro\Core\Util;
use App\GoCardlessPro\Core\ListResponse;
use App\GoCardlessPro\Resources\RedirectFlow;
use App\GoCardlessPro\Core\Exception\InvalidStateException;


/**
 * Service that provides access to the RedirectFlow
 * endpoints of the API
 */
class RedirectFlowsService extends BaseService
{

    protected $envelope_key   = 'redirect_flows';
    protected $resource_class = '\GoCardlessPro\Resources\RedirectFlow';


    /**
    * Create a redirect flow
    *
    * Example URL: /redirect_flows
    *
    * @param  string[mixed] $params An associative array for any params
    * @return RedirectFlow
    **/
    public function create($params = array())
    {
        $path = "/redirect_flows";
        if(isset($params['params'])) { 
            $params['body'] = json_encode(array($this->envelope_key => (object)$params['params']));
        
            unset($params['params']);
        }

        
        try {
            $response = $this->api_client->post($path, $params);
        } catch(InvalidStateException $e) {
            if ($e->isIdempotentCreationConflict()) {
                return $this->get($e->getConflictingResourceId());
            }

            throw $e;
        }
        

        return $this->getResourceForResponse($response);
    }

    /**
    * Get a single redirect flow
    *
    * Example URL: /redirect_flows/:identity
    *
    * @param  string        $identity Unique identifier, beginning with "RE".
    * @param  string[mixed] $params   An associative array for any params
    * @return RedirectFlow
    **/
    public function get($identity, $params = array())
    {
        $path = Util::subUrl(
            '/redirect_flows/:identity',
            array(
                
                'identity' => $identity
            )
        );
        if(isset($params['params'])) { $params['query'] = $params['params'];
            unset($params['params']);
        }

        
        $response = $this->api_client->get($path, $params);
        

        return $this->getResourceForResponse($response);
    }

    /**
    * Complete a redirect flow
    *
    * Example URL: /redirect_flows/:identity/actions/complete
    *
    * @param  string        $identity Unique identifier, beginning with "RE".
    * @param  string[mixed] $params   An associative array for any params
    * @return RedirectFlow
    **/
    public function complete($identity, $params = array())
    {
        $path = Util::subUrl(
            '/redirect_flows/:identity/actions/complete',
            array(
                
                'identity' => $identity
            )
        );
        if(isset($params['params'])) { 
            $params['body'] = json_encode(array("data" => (object)$params['params']));
        
            unset($params['params']);
        }

        
        try {
            $response = $this->api_client->post($path, $params);
        } catch(InvalidStateException $e) {
            if ($e->isIdempotentCreationConflict()) {
                return $this->get($e->getConflictingResourceId());
            }

            throw $e;
        }
        

        return $this->getResourceForResponse($response);
    }

}
