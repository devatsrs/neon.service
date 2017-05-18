<?php
namespace App\Lib;

class TicketImportRuleCondition extends \Eloquent {

	var $field;
    var $operand;
    var $value;

    const IS = 'is';
    const IS_NOT = 'is_not';
    const CONTAINS = 'contains';
    const DOES_NOT_CONTAIN = 'does_not_contain';
    const START_WITH = 'start_with';
    const END_WITH = 'end_with';


    public function operand( $operand ) {
        $this->operand = trim($operand);
        return $this;
    }
    public static function field($field){
        $ins = new static;
        $ins->field = trim($field);
        return $ins;
    }

    public function value($value) {
        $this->value = trim($value);
        return $this;
    }

    public function check() {

        if(empty($this->operand)){
            return false;
        }

        switch ($this->operand) {

            case self::IS:

                if ($this->field == $this->value){
                    return true;
                }
                break;

            case self::IS_NOT :

                if ($this->field != $this->value){
                    return true;
                }
                break;

            case self::CONTAINS :

                if (strpos($this->field, $this->value) !== false ){
                    return true;
                }
                break;

            case self::DOES_NOT_CONTAIN:

                if (strpos($this->field, $this->value) == false ){
                    return true;
                }
                break;

            case self::START_WITH:

                $length = strlen($this->value);
                if ( substr($this->field, 0, $length) === $this->value ) {
                    return true;
                }
                break;

            case self::END_WITH:

                $length = strlen($this->value);
                if ($length == 0) {
                    return true;
                }
                if ( substr($this->field, -$length) === $this->value ) {
                    return true;
                }
                break;

        }

        return false;

    }

}
