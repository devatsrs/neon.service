<?php namespace App;

class DomainApplication extends \Illuminate\Foundation\Application {
    public function langPath() {
        return __DIR__.'/../../../vishal.neon/app/lang';
    }
}