<?php

declare(strict_types=1);

namespace App\Utils;

use Exception;
use PDO;

class PDOService
{
    private ?PDO $db = null;
    private array $config = [];


    public function __construct(array $config)
    {
        $this->config = $config;
    }
    private function connect(): void
    {
        if ($this->db !== null) {
            return;
        }

        if (!isset($this->config['database'])) {
            throw new Exception('Database name is required in configuration.');
        }

        if (!isset($this->config['username'])) {
            throw new Exception('Username is required in configuration.');
        }

        $host = $this->config['host'] ?? 'localhost';
        $charset = 'utf8mb4';
        $port = $this->config['port'] ?? '3306';
        $password = $this->config['password'] ?? '';
        $database = $this->config['database'];
        $username = $this->config['username'];

        try {
            $dsn = sprintf(
                'mysql:host=%s;dbname=%s;port=%s;charset=%s',
                $host,
                $database,
                $port,
                $charset
            );
            $this->db = new PDO($dsn, $username, $password, $this->config['options']);
        } catch (\PDOException $e) {
            throw new \PDOException($e->getMessage(), (int)$e->getCode());
        }
    }
    function getPDO(): PDO
    {
        $this->connect();
        return $this->db;
    }
}
