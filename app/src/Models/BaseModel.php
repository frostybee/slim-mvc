<?php

namespace App\Models;

class BaseModel
{
    protected $db;

    public function __construct()
    {
        $this->db = App::getContainer()->get(PDO::class);
    }
}
