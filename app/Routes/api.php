<?php

declare(strict_types=1);

/**
 * This file is part of the Slim application.
 *
 * It contains the routes for the Web API exposed by this application.
 * Client applications can use this Web API to interact with the application using AJAX.
 */

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Routing\RouteCollectorProxy;

return static function (Slim\App $app): void {

    $app->group('/api', function (RouteCollectorProxy $group) {

        //* ROUTE: GET /api/status
        $group->get('/status', function (Request $request, Response $response, $args) {
            $payload = [
                "greetings" => "Reporting! Hello there!",
                "now" =>  date('Y-m-d H:i:s'),
            ];
            $response->getBody()->write(json_encode($payload, JSON_UNESCAPED_SLASHES | JSON_PARTIAL_OUTPUT_ON_ERROR));
            return $response;
        });
    });
};
