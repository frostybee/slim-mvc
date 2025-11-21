# Custom 404 Error Page Implementation Guide

This document describes how to implement a custom 404 error page in your Slim Framework MVC application.

## Overview

This implementation redirects all 404 "Not Found" errors to a custom, branded error page that matches your application's UI theme with header and footer components.

---

## Files Changed/Created

### 1. **New File: `app/Views/errors/404.php`**

**Location:** `app/Views/errors/404.php`

**Purpose:** Custom 404 error page template that uses existing ViewHelper components.

**Full Code:**

```php
<?php

use App\Helpers\ViewHelper;

$page_title = '404 - Page Not Found';
ViewHelper::loadHeader($page_title);
?>

<div style="text-align: center; padding: 50px 20px;">
    <h1 style="font-size: 72px; margin: 0; color: #e74c3c;">404</h1>
    <h2 style="margin: 20px 0;">Page Not Found</h2>
    <p style="font-size: 18px; color: #666; margin: 20px 0;">
        Sorry, the page you are looking for does not exist.
    </p>
    <a href="/" style="display: inline-block; margin-top: 30px; padding: 12px 30px; background-color: #3498db; color: white; text-decoration: none; border-radius: 5px; font-size: 16px;">
        Go Back Home
    </a>
</div>

<?php
ViewHelper::loadJsScripts();
ViewHelper::loadFooter();
?>
```

**Notes:**
- Creates the `errors/` directory inside `app/Views/`
- Uses ViewHelper to maintain consistent branding
- Inline styles for simplicity (can be moved to CSS file)
- Production-friendly with minimal technical details

---

### 2. **MODIFIED: `app/Middleware/ExceptionMiddleware.php`**

**Changes Required:**

#### Step 2a: Add Import Statements

Add these two import statements at the top of the file (after existing imports):

```php
use Slim\Exception\HttpNotFoundException;
use Slim\Views\PhpRenderer;
```

**Full import section should look like:**

```php
use App\Helpers\Core\JsonRenderer;
use DomainException;
use Fig\Http\Message\StatusCodeInterface;
use InvalidArgumentException;
use Psr\Http\Message\ResponseFactoryInterface;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface;
use Psr\Log\LoggerInterface;
use Slim\Exception\HttpException;
use Slim\Exception\HttpNotFoundException;  // new
use Slim\Views\PhpRenderer;                // new
use Throwable;
```

#### Step 2b: Add PhpRenderer Property

Add a new private property for the view renderer:

```php
private PhpRenderer $viewRenderer;
```

**The properties section should look like:**

```php
private ResponseFactoryInterface $responseFactory;
private JsonRenderer $renderer;
private ?LoggerInterface $logger;
private bool $displayErrorDetails;
private PhpRenderer $viewRenderer;  // new
```

#### Step 2c: Update Constructor

Modify the constructor to accept and store the `PhpRenderer` dependency:

**BEFORE:**
```php
public function __construct(
    ResponseFactoryInterface $responseFactory,
    JsonRenderer $jsonRenderer,
    ?LoggerInterface $logger = null,
    bool $displayErrorDetails = false,
) {
    $this->responseFactory = $responseFactory;
    $this->renderer = $jsonRenderer;
    $this->displayErrorDetails = $displayErrorDetails;
    $this->logger = $logger;
}
```

**AFTER:**
```php
public function __construct(
    ResponseFactoryInterface $responseFactory,
    JsonRenderer $jsonRenderer,
    PhpRenderer $viewRenderer,              // new parameter
    ?LoggerInterface $logger = null,
    bool $displayErrorDetails = false,
) {
    $this->responseFactory = $responseFactory;
    $this->renderer = $jsonRenderer;
    $this->viewRenderer = $viewRenderer;    // new assignment
    $this->displayErrorDetails = $displayErrorDetails;
    $this->logger = $logger;
}
```

#### Step 2d: Update `renderHtml()` Method

Add the 404 detection logic at the beginning of the `renderHtml()` method:

**BEFORE:**
```php
public function renderHtml(ResponseInterface $response, Throwable $exception): ResponseInterface
{
    $response = $response->withHeader('Content-Type', 'text/html');

    $message = sprintf(
        "\n<br><strong>Error:</strong> %s (%s)\n<br><strong>Message:</strong> %s\n<br>",
        // ... rest of the method
```

**AFTER:**
```php
public function renderHtml(ResponseInterface $response, Throwable $exception): ResponseInterface
{
    $response = $response->withHeader('Content-Type', 'text/html');

    // Use custom 404 view for HttpNotFoundException.
    if ($exception instanceof HttpNotFoundException) {
        return $this->viewRenderer->render($response, 'errors/404.php');
    }

    $message = sprintf(
        "\n<br><strong>Error:</strong> %s (%s)\n<br><strong>Message:</strong> %s\n<br>",
        // ... rest of the method remains unchanged
```

---

### 3. **MODIFIED: `config/container.php`**

**Change Required:**

Update the `ExceptionMiddleware` dependency injection to include `PhpRenderer`.

**BEFORE:**
```php
ExceptionMiddleware::class => function (ContainerInterface $container) {
    $settings = $container->get(AppSettings::class)->get('error');
    return new ExceptionMiddleware(
        $container->get(ResponseFactoryInterface::class),
        $container->get(JsonRenderer::class),
        null,
        (bool) $settings['display_error_details'],
    );
},
```

**AFTER:**
```php
ExceptionMiddleware::class => function (ContainerInterface $container) {
    $settings = $container->get(AppSettings::class)->get('error');
    return new ExceptionMiddleware(
        $container->get(ResponseFactoryInterface::class),
        $container->get(JsonRenderer::class),
        $container->get(PhpRenderer::class),  // new parameter
        null,
        (bool) $settings['display_error_details'],
    );
},
```

---

## Step-by-Step Implementation Instructions

### Step 1: Create the Error View Directory and File

1. Navigate to `app/Views/` directory
2. Create a new folder called `errors`
3. Inside `app/Views/errors/`, create a file named `404.php`
4. Copy the code from **Section 1** above into this file

### Step 2: Modify the ExceptionMiddleware

1. Open `app/Middleware/ExceptionMiddleware.php`
2. Follow steps **2a through 2d** in **Section 2** above:
   - Add the two new import statements
   - Add the `$viewRenderer` property
   - Update the constructor signature and body
   - Add the 404 check in `renderHtml()` method

### Step 3: Update Dependency Injection Container

1. Open `config/container.php`
2. Locate the `ExceptionMiddleware::class` definition
3. Add `$container->get(PhpRenderer::class)` as shown in **Section 3** above

---

## How It Works

1. When a user visits a route that doesn't exist, Slim Framework throws an `HttpNotFoundException`
2. The `ExceptionMiddleware` catches all exceptions
3. It checks if the exception is specifically a `HttpNotFoundException` (404 error)
4. If it's a 404, it renders the custom `errors/404.php` view using `PhpRenderer`
5. If it's any other error, it falls back to the default error rendering (inline HTML)
