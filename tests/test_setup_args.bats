#!/usr/bin/env bats

load helpers/mock_env

# Tests for setup argument parsing logic

@test "defaults: PHP 8.5, MariaDB" {
    parse_setup_args
    [ "$PHP" = "8.5" ]
    [ "$DB_SERVICE" = "MariaDB" ]
    [ "$DB_PACKAGE" = "mariadb-server" ]
}

@test "php84 flag sets PHP 8.4" {
    parse_setup_args "php84"
    [ "$PHP" = "8.4" ]
}

@test "php83 flag sets PHP 8.3" {
    parse_setup_args "php83"
    [ "$PHP" = "8.3" ]
}

@test "php81 flag sets PHP 8.1" {
    parse_setup_args "php81"
    [ "$PHP" = "8.1" ]
}

@test "php74 flag sets PHP 7.4" {
    parse_setup_args "php74"
    [ "$PHP" = "7.4" ]
}

@test "mysql flag sets MySQL" {
    parse_setup_args "mysql"
    [ "$DB_SERVICE" = "MySQL" ]
    [ "$DB_PACKAGE" = "mysql-server" ]
}

@test "mariadb flag sets MariaDB" {
    parse_setup_args "mariadb"
    [ "$DB_SERVICE" = "MariaDB" ]
    [ "$DB_PACKAGE" = "mariadb-server" ]
}

@test "pgsql flag sets PostgreSQL" {
    parse_setup_args "pgsql"
    [ "$DB_SERVICE" = "PostgreSQL" ]
    [ "$DB_PACKAGE" = "postgresql postgresql-contrib" ]
}

@test "mariadb php84 together" {
    parse_setup_args "mariadb" "php84"
    [ "$PHP" = "8.4" ]
    [ "$DB_SERVICE" = "MariaDB" ]
}

@test "mysql php83 together" {
    parse_setup_args "mysql" "php83"
    [ "$PHP" = "8.3" ]
    [ "$DB_SERVICE" = "MySQL" ]
}

@test "pgsql php84 together" {
    parse_setup_args "pgsql" "php84"
    [ "$PHP" = "8.4" ]
    [ "$DB_SERVICE" = "PostgreSQL" ]
}

@test "args work in any order: php84 mariadb" {
    parse_setup_args "php84" "mariadb"
    [ "$PHP" = "8.4" ]
    [ "$DB_SERVICE" = "MariaDB" ]
}

@test "unknown arg is ignored, defaults preserved" {
    parse_setup_args "redis"
    [ "$PHP" = "8.5" ]
    [ "$DB_SERVICE" = "MariaDB" ]
}
