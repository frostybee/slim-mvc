# Slim Framework Starter Template

A lightweight MVC web application starter template built on top of the Slim PHP microframework. Ideal for projects that require Slim's simplicity without sacrificing the benefits of a clean MVC architecture.

## Why Using this Template?

This template provides a starting point for building web applications with the Slim 4 framework using the classic MVC (Model–View–Controller) pattern. It includes everything you need to get started, without the extra complexity of larger frameworks.

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

## How Do I Use/Deploy this Template?

- [Option 1: Using Composer (Recommended)](#option-1-using-composer-recommended)
- [Option 2: Using Docker (macOS/Linux/Windows)](#option-2-using-docker-macoslinuxwindows)
- [Option 3: Manual Installation](#option-3-manual-installation)

### Option 1: Using Composer (Recommended)

**Prerequisites:**
- PHP 8.2 or higher installed locally
- [Composer](https://getcomposer.org/) installed globally
- A web server (Apache/Nginx) or [Wampoon](https://wampoon-box.github.io/)

> **Don't have a WAMP/LAMP stack installed?** Use [Option 2: Docker](#option-2-using-docker-macoslinuxwindows) instead.

1. Open a terminal in your web server's **document root** (i.e., `htdocs`).
2. Run the following command:
   ```bash
   composer create-project frostybee/slim-mvc [project-name]-app
   ```
   Replace `[project-name]` with your project name (e.g., `worldcup-app`).
3. Open your `[project-name]-app` folder in VS Code.
4. Adjust your database credentials in `config/env.php` (**see below**).

### Option 2: Using Docker (macOS/Linux/Windows)

Docker allows you to run the application in containers without installing PHP, Apache, or MariaDB locally. This works on **macOS**, **Linux**, and **Windows**.

**Prerequisites:**
- Install [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- Install [Git](https://git-scm.com/downloads)

**Quick Start:**

1. Clone the repository (since Composer requires PHP, which you may not have installed):
   ```bash
   git clone https://github.com/frostybee/slim-mvc.git [project-name]-app
   ```
   Replace `[project-name]` with your project name (e.g., `worldcup-app`).

2. Navigate to the project folder:
   ```bash
   cd [project-name]-app
   ```

3. Remove the `.git` folder to start fresh with your own repository:
   ```bash
   rm -rf .git
   ```

4. Start all containers by executing the following command:
   ```bash
   docker-compose up -d
   ```
   > **Note:** Use `docker-compose up -d --build` to rebuild images after modifying the Dockerfile or related configurations.

5. Install PHP dependencies (first time only):
   ```bash
   docker-compose exec app composer install
   ```

6. Access the application:
   - **App:** http://localhost:8080
   - **phpMyAdmin:** http://localhost:8081

**Configuring the Database:**

The default database name is `slim_mvc`. To use a different database name:

1. Update `docker-compose.yml`:
   ```yaml
   db:
     environment:
       MYSQL_DATABASE: your_database_name
   ```

2. Update `config/env.docker.php`:
   ```php
   $settings['db']['database'] = 'your_database_name';
   ```

3. Rebuild containers: `docker-compose up -d --build`

**Importing Database Schema:**

To automatically import a database schema when the container starts:

1. Place your `.sql` file(s) in the `docker/init-db/` folder
2. Start the containers: `docker-compose up -d`

The SQL files will be executed automatically on first container creation. If you have multiple files, they run in alphabetical order (e.g., `01-schema.sql`, `02-data.sql`).

To re-import the schema, remove the database volume and restart:
```bash
docker-compose down -v
docker-compose up -d
```

**Database Credentials (for phpMyAdmin):**
| Username  | Password  |
| --------- | --------- |
| root      | secret    |
| slim_user | slim_pass |

**Common Commands:**

| Action             | Command                                    |
| ------------------ | ------------------------------------------ |
| Start containers   | `docker-compose up -d`                     |
| Stop containers    | `docker-compose down`                      |
| View app logs      | `docker-compose logs -f app`               |
| Run composer       | `docker-compose exec app composer install` |
| Delete database    | `docker-compose down -v`                   |
| Rebuild containers | `docker-compose up -d --build`             |

**Working with Multiple Projects:**

If you run **one project at a time**, no configuration changes are needed. Simply stop one project before starting another:

```bash
# Stop current project
docker-compose down

# Switch to another project
cd ../other-project
docker-compose up -d
```

If you need to run **multiple projects simultaneously**, change the port numbers in `docker-compose.yml` to avoid conflicts:

```yaml
services:
  app:
    ports:
      - "8082:80"      # Change 8080 to 8082, 8083, etc.
  db:
    ports:
      - "3307:3306"    # Change 3306 to 3307, 3308, etc.
  phpmyadmin:
    ports:
      - "8083:80"      # Change 8081 to 8083, 8084, etc.
```

### Option 3: Manual Installation

1. Download this repository as a `.zip` file.
2. Extract the downloaded `slim-mvc-main.zip` file locally.
3. Copy the `slim-mvc-main` folder into your web server's **document root** (i.e., `htdocs`).
4. Rename the `slim-mvc-main` folder to `[project_name]-app` (for example, `worldcup-app`).
5. Open your `[project_name]-app` folder in VS Code.
6. Install the project dependencies by running composer. If you are using Wampoon, open a terminal window in VS Code (hit ``` Ctrl+` ```) then run `.\composer.bat update`
   - If you are not using Wampoon to develop your app, just run composer from the command line.
7. In the `config` folder, make a copy of `env.example.php` and rename it to `env.php`.
8. Adjust your database credentials (**see below**).

**```NOTE:```** You can always clone this repository. However, if you do, you need to remove the ```.git``` ***hidden*** directory before you copy this template over to ```htdocs```

## How Do I Configure My Database Connection?

Follow the outlined instructions in [config/env.example.php](config/env.example.php)

* Change the value of the `database` variable to reflect the name of the database to be used by your slim app.
* You may also want to change the connection credentials in that file.

## How do I Use Composer with Wampoon?

To install or update your project dependencies deployed on Wampoon, use the `composer.bat` script as follows:

| Action                | Command                            | Description                                                                     |
| --------------------- | ---------------------------------- | ------------------------------------------------------------------------------- |
| Install dependencies  | `./composer.bat install`           | Installs packages listed in `composer.json` and creates the `vendor` directory. |
| Update dependencies   | `./composer.bat update`            | Refreshes all packages to the latest versions allowed by `composer.json`.       |
| Add a package         | `./composer.bat require [package]` | Installs a new package and adds it to `composer.json`.                          |
| Regenerate autoloader | `./composer.bat dump-autoload -o`  | Rebuilds the optimized autoloader after adding or removing classes.             |


## On Using Environment Variables

Sensitive information used in app such as your database credentials, API key, etc. MUST not be pushed into your Git repo.

Do not use `.env` files for storing environment specific application settings/configurations. Dotenv [is not meant to be used in production](https://github.com/vlucas/phpdotenv/issues/76#issuecomment-87252126)

Just Google: "DB_PASSWORD" filetype:env
Alternatively, you can visit the following link: [Google env search](https://www.google.ch/search?q=%22DB_PASSWORD%22+filetype:env)

Instead, follow the instructions that are detailed in [config/env.example.php](config/env.example.php)

## Project Structure

Here's how everything is organized:

```plaintext
slim-mvc/
├── app/
│   ├── Controllers/    # Your controllers live here
│   ├── Domain/         # Domain logic and business rules
│   │   ├── Models/     # Data models and entities
│   │   └── Services/   # Business logic services
│   ├── Helpers/        # Utility classes and helpers
│   ├── Middleware/     # Custom middleware
│   ├── Routes/         # Route definitions (web & API)
│   └── Views/          # Your view templates
├── config/             # Configuration files and bootstrap
├── data/               # Database files, uploads, etc.
├── docker/             # Docker configuration files
│   ├── apache.conf     # Apache virtual host config
│   └── init-db/        # Database initialization scripts
├── docs/               # Documentation
├── public/             # Web-accessible files
│   ├── assets/         # Static assets (CSS, JS, images)
│   │   ├── css/        # Stylesheets
│   │   └── js/         # JavaScript files
│   ├── index.php       # Application entry point
│   └── .htaccess       # Apache rewrite rules
├── var/                # Runtime files
│   └── logs/           # Application logs
├── vendor/             # Composer dependencies
├── Dockerfile          # Docker image definition
└── docker-compose.yml  # Docker services configuration
```

## Quick Development Tips

### Adding Routes

Routes are defined in the `app/Routes/` directory. Check out the existing route files to see how it's done.

### Creating Controllers

Controllers go in `app/Controllers/`. They should extend the base controller class and follow PSR-4 autoloading.

### Views and Templates

Templates are stored in `app/Views/`. The template engine is already configured and ready to use.

### Configuration

App configuration lives in `config/`. Modify these files to customize your application settings.

### Logging

Logs are written to the `var/logs/` directory. Use the injected logger in your controllers to track what's happening.

## Need Help?

- Check out the [Slim documentation](https://www.slimframework.com/docs/v4/) for framework-specific questions.
- Look at the example controllers and routes to see how everything fits together.
- The code is pretty well commented, so don't hesitate to explore it well.

## Contributing

Got ideas for improvements? Found a bug? Pull requests are welcome!

- [Issues](https://github.com/frostybee/slim-mvc/issues)

## Acknowledgments

The application's bootstrap process and structure of this starter template is based on [slim4-skeleton](https://github.com/odan/slim4-skeleton) by [@odan](https://github.com/odan).  Many thanks to the original developers for their work!

## License

This project is open-sourced under the MIT License. See the `LICENSE` file for the full details.

---
