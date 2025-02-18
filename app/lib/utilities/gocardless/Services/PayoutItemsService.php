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
use App\GoCardlessPro\Resources\PayoutItem;
use App\GoCardlessPro\Core\Exception\InvalidStateException;


/**
 * Service that provides access to the PayoutItem
 * endpoints of the API
 */
class PayoutItemsService extends BaseService
{

    protected $envelope_key   = 'payout_items';
    protected $resource_class = '\GoCardlessPro\Resources\PayoutItem';


    /**
    * Get all payout items in a single payout
    *
    * Example URL: /payout_items
    *
    * @param  string[mixed] $params An associative array for any params
    * @return ListResponse
    **/
    protected function _doList($params = array())
    {
        $path = "/payout_items";
        if(isset($params['params'])) { $params['query'] = $params['params'];
            unset($params['params']);
        }

        
        $response = $this->api_client->get($path, $params);
        

        return $this->getResourceForResponse($response);
    }

    /**
    * Get all payout items in a single payout
    *
    * Example URL: /payout_items
    *
    * @param  string[mixed] $params
    * @return Paginator
    **/
    public function all($params = array())
    {
        return new Paginator($this, $params);
    }

}
