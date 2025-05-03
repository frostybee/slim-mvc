<?php

declare(strict_types=1);

/**
 * This file is part of the Slim application.
 *
 * It contains the routes for the Web API exposed by this application.
 * Client applications can use this Web API to interact with the application using AJAX.
 */

use App\Controllers\HomeController;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;


return static function (Slim\App $app): void {

    //* ROUTE: GET /ping
    $app->get('/ping', function (Request $request, Response $response, $args) {
        $payload = [
            "greetings" => "Reporting! Hello there!",
            "now" =>  date('Y-m-d H:i:s'),
        ];
        $response->getBody()->write(json_encode($payload, JSON_UNESCAPED_SLASHES | JSON_PARTIAL_OUTPUT_ON_ERROR));
        return $response;
    });
};
