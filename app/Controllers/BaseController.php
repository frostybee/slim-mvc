<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Utils\AppSettings;
use Slim\Views\PhpRenderer;
use DI\Container;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Routing\RouteContext;

abstract class BaseController
{
    protected PhpRenderer $view;
    protected AppSettings $settings;
    protected Container $container;

    public function __construct(Container $container)
    {
        $this->container = $container;
        $this->view = $container->get(PhpRenderer::class);
    }
    protected function render(Response $response, string $view_name, array $data = []): Response
    {
        $response = $response->withHeader('Content-Type', 'text/html; charset=utf-8');
        //dd($data);
        return $this->view->render($response, $view_name, $data);
    }

    /**
     * Redirect a request to a named route.
     *
     * @param Request $request The request object.
     * @param Response $response The response object.
     * @param string $view_name The name of the view to redirect to.
     * @param int $status The status code to redirect with.
     * @return Response The response object.
     */
    protected function redirect(Request $request, Response $response, string $view_name, int $status = 302): Response
    {
        $route_parser = RouteContext::fromRequest($request)->getRouteParser();

        //TODO: @see: https://discourse.slimframework.com/t/redirecting-short-form/3985/3
        $view_uri = $route_parser->urlFor($view_name);
        return $response->withStatus($status)->withHeader('Location', $view_uri);
    }
}
