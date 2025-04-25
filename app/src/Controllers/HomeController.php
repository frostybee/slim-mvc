<?php

namespace App\Controllers;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class HomeController extends BaseController
{
    public function __construct(\DI\Container $container)
    {
        parent::__construct($container);
    }


    public function index(Request $request, Response $response, array $args): Response
    {
        //$data['flash'] = $this->flash->getFlashMessage();
        //echo $data['message'] ;exit;

        $data['data'] = [
            'title' => 'Home',
            'message' => 'Welcome to the home page',
        ];
        //dd($data);
        //var_dump($this->session); exit;
        return $this->render($response, 'homeView.php', $data);
    }
}
