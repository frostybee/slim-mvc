<?php

declare(strict_types=1);

/**
 * This file is part of the Slim Framework.
 * It contains the routes for the web application.
 */

use App\Controllers\HomeController;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;


return static function (Slim\App $app): void {

    $app->get('/home', [HomeController::class, 'index'])
        ->setName('home.index');

    // Example route to test error handling
    $app->get('/error', function (Request $request, Response $response, $args) {
        throw new \Slim\Exception\HttpNotFoundException($request, "Something went wrong");
    });
};
