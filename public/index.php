<?php

declare(strict_types=1);

//* This is the entry point of the application.

// Define the path of the application's root directory.
define('APP_BASE_DIR', realpath(dirname(__DIR__)));
// Get the name of the application's root directory.
define('APP_ROOT_DIR_NAME', basename(dirname(__FILE__,2)));

// Launch the application bootstrap process.
require_once __DIR__ . '/../config/bootstrap.php';
