# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

LaraSail is a Bash CLI tool for setting up and managing Laravel servers on DigitalOcean (Ubuntu 24). It installs Nginx, PHP, MariaDB/MySQL/PostgreSQL, Node, Redis, and manages Nginx virtual hosts, SSL certificates, databases, and Laravel/Wave projects.

## Installation & Usage

The tool is installed on a server via:
```bash
curl -sL https://github.com/RomanNebesnuyGC/larasail/archive/master.tar.gz | tar xz && source larasail-master/install
```

This runs `install`, which copies `.larasail/` to `/etc/.larasail/` and sets up the `larasail` shell alias.

After install, commands are invoked as:
```bash
larasail setup [php85|php84|...] [mariadb|mysql|pgsql]  # defaults: PHP 8.5, MariaDB 11.8, Redis
larasail new myapp [--jet livewire|inertia] [--teams] [--wave] [--www-alias]
larasail host domain.com /var/www/myapp/public [--www-alias]
larasail hosts list
larasail database init [--user myuser] [--db mydb] [--force]
larasail database list
larasail database pass
larasail enter
larasail pass
larasail mysqlpass
larasail update
```

## Running Tests

```bash
# Install bats-core first
git clone https://github.com/bats-core/bats-core.git /tmp/bats-core
sudo /tmp/bats-core/install.sh /usr/local

# Run all tests
bats tests/

# Run a single test file
bats tests/test_setup_args.bats
```

CI runs automatically on GitHub Actions (Ubuntu 24) on every push/PR.

## Architecture

All source code lives in `.larasail/`. There is no build step — everything is plain Bash.

### Entry point & routing

`.larasail/larasail` is the main dispatcher. It sources scripts using `. /etc/.larasail/$1 "$@"` so each script receives the full argument list including its own command name as `$1`. Scripts that accept user arguments (e.g. `new`, `database`, `hosts`) call `shift` at the start to drop the command name. The `host` command is the exception — it runs with `sudo sh` (not sourced) and receives `$2 $3 $4` directly.

### Shared utilities

Scripts source shared utilities from `.larasail/includes/`:
- `colors` — ANSI color constants and helper functions
- `format` — `bar()`, `setsail()` banner functions
- `help` — `larasail help` output

Scripts source these with `. /etc/.larasail/includes/colors` (dot-source, not `source`).

### Runtime paths (on the server)

- Scripts installed to: `/etc/.larasail/`
- Credentials stored in: `/etc/.larasail/tmp/`
- Web projects live in: `/var/www/`
- DB admin credentials: `/home/larasail/.my.cnf` (format: `password=VALUE`, no quotes)

### Setup defaults (Ubuntu 24)

- PHP: 8.5 (via `ppa:ondrej/php`)
- Database: MariaDB 11.8 LTS (via official MariaDB repo script — Ubuntu repos don't carry 11.8)
- Redis: always installed, no flag needed
- Supported DB flags: `mariadb` (default), `mysql`, `pgsql`

### PHP version handling

`setup` defaults to PHP 8.5. Supported: 7.1–7.4, 8.0, 8.1, 8.3, 8.4, 8.5. PHP version is detected at runtime in `host` using `php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;'` to build the PHP-FPM socket path (e.g., `/run/php/php8.5-fpm.sock`).

### SSL

`certbot` is installed during `setup` (via pip in a venv at `/opt/certbot/`). Both `host` and `new` prompt interactively to run `certbot --nginx` for Let's Encrypt SSL.

## Code Conventions

- 4-space indentation (enforced by `.editorconfig`)
- Color output uses constants from `includes/colors` (e.g., `${Green}`, `${BWhite}`, `${Color_Off}`)
- Section separators use `bar` from `includes/format`
- Passwords are generated with `openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | head -c 32`
- Password extraction from `.my.cnf`: `grep '^password=' /home/larasail/.my.cnf | cut -d'=' -f2-`
- Nginx configs include security headers: `X-Frame-Options`, `X-Content-Type-Options`, `X-XSS-Protection`, `Referrer-Policy`
- Credentials written to `/etc/.larasail/tmp/` with mode `600`

## Tests

Tests live in `tests/` and use [bats-core](https://github.com/bats-core/bats-core):
- `tests/test_setup_args.bats` — argument parsing logic
- `tests/test_nginx_config.bats` — nginx config content and headers
- `tests/test_db_password.bats` — password extraction and generation
- `tests/helpers/mock_env.bash` — shared mock environment setup

## Versioning

Every push to `master` automatically bumps `.larasail/VERSION`, commits it back (`[skip ci]`), and creates a git tag via `.github/workflows/version.yml`.

**When pushing, always decide the bump type and include the right tag in the commit message:**

| Change type | Include in commit | Example |
|---|---|---|
| Bug fix, docs, small improvement | *(nothing)* | `2.0.1 → 2.0.2` |
| New command, new flag, new feature | `[minor]` | `2.0.2 → 2.1.0` |
| Breaking default change, removed command | `[major]` | `2.1.0 → 3.0.0` |

The VERSION file lives in `.larasail/VERSION` and is copied to `/etc/.larasail/VERSION` on install, so any server can run `larasail version` to see exactly what is installed and from which repo.

## Contributing

Per `CONTRIBUTING.md`: all source changes go in `.larasail/`. The `install` script at the root is only the bootstrapper that copies `.larasail/` into place on the server.
