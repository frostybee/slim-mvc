<?php

declare(strict_types=1);

//Settings for  development (dev) environment

// App-specific config.
const APP_DEBUG_MODE = true;
const APP_ASSETS_DIR = '/public/assets';
const APP_BASE_URL = 'http://localhost/' . APP_ROOT_DIR_NAME;

const APP_ASSETS_DIR_URL = APP_BASE_URL  . APP_ASSETS_DIR;
const APP_ASSETS_DIR_PATH = APP_BASE_DIR_PATH . '/' . APP_ASSETS_DIR;

// Update the cache busting token upon new deployments.
const CACHE_BUSTING_TOKEN = 'YV954';

return function (array $settings): array {
    // Error reporting
    // Enable all error reporting for dev environment.
    error_reporting(E_ALL);
    ini_set('display_errors', '1');
    ini_set('display_startup_errors', '1');

    $settings['error']['display_error_details'] = true;

    // Database
    $settings['db']['database'] = 'your_database_name';
    $settings['db']['hostname'] = 'localhost';
    $settings['db']['port'] = '3306';

    return $settings;
};
