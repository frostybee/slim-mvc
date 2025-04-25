<?php

namespace App\Controllers;

use App\Core\AppSettings;
use Slim\Views\PhpRenderer;
use DI\Container;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

abstract class BaseController
{
    protected PhpRenderer $view;
    protected AppSettings $settings;

    public function __construct(Container $container)
    {
        $this->view = $container->get(PhpRenderer::class);
    }
    protected function render(Response $response, string $view_name, array $data = []): Response
    {
        $response = $response->withHeader('Content-Type', 'text/html; charset=utf-8');
        //dd($data);
        return $this->view->render($response, $view_name, $data);
    }
}
