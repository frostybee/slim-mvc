<?php

declare(strict_types=1);

namespace App\Domain\Models;

use App\Core\PDOService;

/**
 * Base model class for all models.
 *
 * This class provides a base implementation for all models.
 * It is intended to be extended by specific model classes.
 */
class BaseModel
{
    protected PDOService $db_service;

    public function __construct(PDOService $db_service)
    {
        $this->db_service = $db_service;
    }
}
