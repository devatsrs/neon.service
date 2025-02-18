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
use App\GoCardlessPro\Resources\CustomerBankAccount;
use App\GoCardlessPro\Core\Exception\InvalidStateException;


/**
 * Service that provides access to the CustomerBankAccount
 * endpoints of the API
 */
class CustomerBankAccountsService extends BaseService
{

    protected $envelope_key   = 'customer_bank_accounts';
    protected $resource_class = '\GoCardlessPro\Resources\CustomerBankAccount';


    /**
    * Create a customer bank account
    *
    * Example URL: /customer_bank_accounts
    *
    * @param  string[mixed] $params An associative array for any params
    * @return CustomerBankAccount
    **/
    public function create($params = array())
    {
        $path = "/customer_bank_accounts";
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
    * List customer bank accounts
    *
    * Example URL: /customer_bank_accounts
    *
    * @param  string[mixed] $params An associative array for any params
    * @return ListResponse
    **/
    protected function _doList($params = array())
    {
        $path = "/customer_bank_accounts";
        if(isset($params['params'])) { $params['query'] = $params['params'];
            unset($params['params']);
        }

        
        $response = $this->api_client->get($path, $params);
        

        return $this->getResourceForResponse($response);
    }

    /**
    * Get a single customer bank account
    *
    * Example URL: /customer_bank_accounts/:identity
    *
    * @param  string        $identity Unique identifier, beginning with "BA".
    * @param  string[mixed] $params   An associative array for any params
    * @return CustomerBankAccount
    **/
    public function get($identity, $params = array())
    {
        $path = Util::subUrl(
            '/customer_bank_accounts/:identity',
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
    * Update a customer bank account
    *
    * Example URL: /customer_bank_accounts/:identity
    *
    * @param  string        $identity Unique identifier, beginning with "BA".
    * @param  string[mixed] $params   An associative array for any params
    * @return CustomerBankAccount
    **/
    public function update($identity, $params = array())
    {
        $path = Util::subUrl(
            '/customer_bank_accounts/:identity',
            array(
                
                'identity' => $identity
            )
        );
        if(isset($params['params'])) { 
            $params['body'] = json_encode(array($this->envelope_key => (object)$params['params']));
        
            unset($params['params']);
        }

        
        $response = $this->api_client->put($path, $params);
        

        return $this->getResourceForResponse($response);
    }

    /**
    * Disable a customer bank account
    *
    * Example URL: /customer_bank_accounts/:identity/actions/disable
    *
    * @param  string        $identity Unique identifier, beginning with "BA".
    * @param  string[mixed] $params   An associative array for any params
    * @return CustomerBankAccount
    **/
    public function disable($identity, $params = array())
    {
        $path = Util::subUrl(
            '/customer_bank_accounts/:identity/actions/disable',
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

    /**
    * List customer bank accounts
    *
    * Example URL: /customer_bank_accounts
    *
    * @param  string[mixed] $params
    * @return Paginator
    **/
    public function all($params = array())
    {
        return new Paginator($this, $params);
    }

}
