<?php

declare(strict_types=1);

//Settings for  development (dev) environment
define('APP_BASE_URI', '/booking-admin');
// App-specific config.
define('APP_DEBUG_MODE', true);
define('APP_BASE_URL', 'http://localhost' . APP_BASE_URI);
define('APP_ASSETS_URL', APP_BASE_URL . APP_BASE_URI . '/public/assets');
define('APP_ASSETS_DIR_PATH', realpath(APP_ROOT_DIR . '/' . 'public/assets'));
define('APP_ASSETS_URI', '/public/assets');


function myCustomErrorHandler(int $errNo, string $errMsg, string $file, int $line)
{
    echo "Error: #[$errNo] occurred in [$file] at line [$line]: [$errMsg] <br>";
}

set_error_handler('myCustomErrorHandler');

return function (array $settings): array {
    // Error reporting
    // Enable all error reporting for dev environment.
    error_reporting(E_ALL);
    ini_set('display_errors', '1');
    ini_set('display_startup_errors', '1');

    $settings['error']['display_error_details'] = true;

    // Database
    $settings['db']['database'] = 'worldcup';
    $settings['db']['hostname'] = 'localhost';
    $settings['db']['port'] = '3306';

    return $settings;
};
