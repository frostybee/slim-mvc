# Slim Framework Starter Template

A lightweight MVC web application starter template built on top of the Slim PHP microframework. Perfect for when you want the simplicity of Slim but with a proper MVC structure to keep your code organized and maintainable.

## Why Using this Template?

This template gives you a solid foundation to build web applications using the Slim 4 framework with a classic MVC (Model-View-Controller) pattern. It's got everything you need to get started without the bloat of larger frameworks.

## What's Included

This starter template follows best practices and adheres to industry standards:

- **Slim 4**: The "slim" PHP microframework
- **Routing**: Slim's custom routing based on [FastRoute](https://github.com/nikic/FastRoute)
- **Dependency injection container** (PSR-11)
- **HTTP message interfaces** (PSR-7)
- **HTTP Server Request Handlers**, Middleware (PSR-15)
- **Autoloader** (PSR-4)
- **Logger** (PSR-3)
- **Code styles** (PSR-12)
- **Composer** - Dependency management

## Requirements

- PHP 8.2 or higher
- Composer (for dependency management)
- A web server (Apache, Nginx)

## Installation

1. **Clone this repository** or download this repository.
   ```bash
   git clone https://github.com/frostybee/slim-mvc.git your-project-name
   cd your-project-name
   ```

2. **Install dependencies**
   ```bash
   composer install
   ```
   
   Or if you don't have Composer globally installed, use the included `composer.bat` (you might need to adjust the PHP path):
   ```bash
   composer.bat install
   ```

## Project Structure

Here's how everything is organized:

```
slim-mvc/
├── app/
│   ├── Controllers/    # Your controllers live here
│   ├── Domain/         # Domain logic and business rules
│   ├── Helpers/        # Utility classes and helpers
│   ├── Middleware/     # Custom middleware
│   ├── Models/         # Data models and entities
│   ├── Routes/         # Route definitions (web & API)
│   ├── Utils/          # General utility functions
│   └── Views/          # Your view templates
├── config/             # Configuration files and bootstrap
├── data/               # Database files, uploads, etc.
├── docs/               # Documentation
├── public/             # Web-accessible files
│   ├── assets/         # Static assets (CSS, JS, images)
│   │   ├── css/        # Stylesheets
│   │   └── js/         # JavaScript files
│   ├── index.php       # Application entry point
│   └── .htaccess       # Apache rewrite rules
├── var/                # Runtime files
│   └── logs/           # Application logs
└── vendor/             # Composer dependencies
```

## Quick Development Tips

### Adding Routes

Routes are defined in the `app/Routes/` directory. Check out the existing route files to see how it's done.

### Creating Controllers

Controllers go in `app/src/Controllers/`. They should extend the base controller class and follow PSR-4 autoloading.

### Views and Templates

Templates are stored in `app/src/Views/`. The template engine is already configured and ready to use.

### Configuration

App configuration lives in `app/config/`. Modify these files to customize your application settings.

### Logging

Logs are written to the `var/logs/` directory. Use the injected logger in your controllers to track what's happening.

## Need Help?

- Check out the [Slim documentation](https://www.slimframework.com/docs/v4/) for framework-specific questions.
- Look at the example controllers and routes to see how everything fits together.
- The code is pretty well commented, so don't hesitate to explore it well.

## Contributing

Got ideas for improvements? Found a bug? Pull requests are welcome!

- [Issues](https://github.com/forstybee/slim-mvc/issues)

## Acknowledgments

The application's bootstrap process and structure of this starter template is based on [slim4-skeleton](https://github.com/odan/slim4-skeleton) by [@odan](https://github.com/odan).  Many thanks to the original developers for their work!

## License

This project is open-sourced under the MIT License. See the `LICENSE` file for the full details.

---
