# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

LaraSail is a Bash CLI tool for setting up and managing Laravel servers on DigitalOcean (Ubuntu). It installs Nginx, PHP, MySQL/MariaDB, Node, Redis, and manages Nginx virtual hosts, SSL certificates, databases, and Laravel/Wave projects.

## Installation & Usage

The tool is installed on a server via:
```bash
curl -sL https://larasail.com/install | bash
```

This runs `install`, which copies `.larasail/` to `/etc/.larasail/` and sets up the `larasail` shell alias.

After install, commands are invoked as:
```bash
larasail setup [--php 8.4] [--mariadb] [--redis]
larasail new myapp [--jet] [--teams] [--wave] [--www-alias]
larasail host add domain.com /var/www/myapp/public
larasail database init [--user myuser] [--db mydb]
larasail enter
larasail pass
larasail mysqlpass
```

## Architecture

All source code lives in `.larasail/`. There is no build step — everything is plain Bash.

### Entry point & routing

`.larasail/larasail` is the main dispatcher. It reads the first argument and delegates to the corresponding script in `.larasail/`. The `host` command is special — it re-invokes itself with `sudo`.

### Shared utilities

Scripts source shared utilities from `.larasail/includes/`:
- `colors` — ANSI color constants and helper functions
- `format` — `bar()`, `setsail()` banner functions
- `help` — `larasail help` output

Every script typically begins with sourcing these:
```bash
source /etc/.larasail/includes/colors
source /etc/.larasail/includes/format
```

### Runtime paths (on the server)

- Scripts installed to: `/etc/.larasail/`
- Credentials stored in: `/etc/.larasail/tmp/`
- Web projects live in: `/var/www/`
- MySQL credentials: `~/.my.cnf`

### PHP version handling

`setup` defaults to PHP 8.3. Supported: 7.1, 7.2, 7.3, 7.4, 8.0, 8.1, 8.3, 8.4. The detected installed PHP version is used dynamically in `host` to build the correct PHP-FPM socket path (e.g., `/run/php/php8.3-fpm.sock`).

### SSL

`certbot` is installed during `setup`. Both `host` and `new` prompt interactively to run `certbot --nginx` for Let's Encrypt SSL.

## Code Conventions

- 4-space indentation (enforced by `.editorconfig`)
- Color output uses constants from `includes/colors` (e.g., `${Green}`, `${BWhite}`, `${Color_Off}`)
- Section separators use `bar` from `includes/format`
- Passwords are generated with `openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | head -c 32`
- Credentials written to `/etc/.larasail/tmp/` with mode `600`

## Contributing

Per `CONTRIBUTING.md`: all source changes go in `.larasail/`. The `install` script at the root is only the bootstrapper that copies `.larasail/` into place on the server.
