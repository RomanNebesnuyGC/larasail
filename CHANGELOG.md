# Changelog

## [2.1.1] — 2026-03-15

- Fix database list crashing with syntax error on sh/dash

---


## [2.1.0] — 2026-03-14

- Add changelog command and auto-generate CHANGELOG.md on version bump [minor]

---


## [2.0.0] — 2026-03-14

### Changed — Breaking defaults
- **PHP default: 8.5** (was 8.2/8.3)
- **Database default: MariaDB 11.8 LTS** via official MariaDB repo (was MySQL 8)
- **Redis: always installed** — no longer optional, flag removed
- **Target OS: Ubuntu 24.04**

### Added
- PHP 8.5 support (`larasail setup php85`)
- PostgreSQL support (`larasail setup pgsql`)
- `larasail hosts list` — list enabled/disabled Nginx virtual hosts
- `larasail database list` — list user databases
- `larasail update` — update LaraSail to the latest version
- `larasail version` / `larasail -v` — show installed version and source repo
- `VERSION` file embedded in `/etc/.larasail/` so installed version is always identifiable
- Security headers in generated Nginx configs (`X-Frame-Options`, `X-Content-Type-Options`, `X-XSS-Protection`, `Referrer-Policy`)
- Test suite with bats-core (`tests/`) and GitHub Actions CI on Ubuntu 24.04

### Fixed
- Dispatcher now passes `"$@"` to sourced scripts — fixes argument passing for `new`, `database`, and multi-flag `setup` calls
- `new`: unquoted `$1` and `$HOST` variable checks
- `host`: PHP version detection rewritten (`php -r` instead of fragile `cut`) — correctly handles PHP 8.10+
- `host`: nginx static asset regex had a trailing `\$1` typo (was breaking nginx config)
- `database` / `mysqlpass`: `.my.cnf` password extraction now handles `=` characters in passwords
- `database`: password generation standardized to `openssl rand` (was `/dev/urandom | tr`)
- Removed obsolete MySQL 5.7 debconf selections

### Removed
- `redis` setup flag (Redis is now always installed)

---

## [1.x] — Original

Original LaraSail by DevDojo: https://github.com/thedevdojo/larasail
