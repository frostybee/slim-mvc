<?php

declare(strict_types=1);

use DI\ContainerBuilder;
use Slim\App;

$autoloadPath = realpath(__DIR__ . '/../vendor/autoload.php');
if ($autoloadPath !== false && is_file($autoloadPath)) {
    require $autoloadPath;
} else {
    echo '<br/><strong>Error:</strong> Composer autoload file not found. Please run "../../composer.bat" update to install the dependencies.';
    exit(1);
}

// Load the app's global constants.
require_once realpath(__DIR__ . '/constants.php');
// Include the global functions that will be used across the app's various components.
require realpath(__DIR__ . '/functions.php');

// Configure the DI container and load dependencies.
$definitions = require realpath(__DIR__ . '/container.php');

// Build DI container instance.
//@see https://php-di.org/
$container = (new ContainerBuilder())
    ->addDefinitions($definitions)
    ->build();
// Create App instance.
return $container->get(App::class);
