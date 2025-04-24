<?php

declare(strict_types=1);

//* This is the entry point of the application.
// (the front controller of the Slim application)

// Define the path of the application's root directory.
define('APP_BASE_DIR', realpath(dirname(__DIR__)));
// Get the name of the application's root directory.
define('APP_ROOT_DIR_NAME', basename(dirname(__FILE__,2)));

// Launch the application bootstrap process.
(require_once realpath(__DIR__ . '/../app/config/bootstrap.php'))->run();
