#!/usr/bin/env bash
# Sets up a mock /etc/.larasail environment for testing

setup_mock_larasail() {
    export MOCK_ETC="$BATS_TMPDIR/etc/.larasail"
    mkdir -p "$MOCK_ETC/includes" "$MOCK_ETC/tmp"

    # Mock includes
    cat > "$MOCK_ETC/includes/colors" << 'EOF'
Color_Off="" Red="" Green="" Yellow="" Blue="" Cyan="" White=""
BRed="" BGreen="" BYellow="" BCyan="" BWhite=""
EOF

    cat > "$MOCK_ETC/includes/format" << 'EOF'
bar()     { :; }
setsail() { :; }
cyan()    { :; }
red()     { :; }
redbg()   { :; }
EOF

    # Override /etc/.larasail path in test scripts via symlink
    export LARASAIL_ETC="$MOCK_ETC"
}

# Run a modified version of setup's arg-parsing block in isolation
# Returns variables: PHP, DB_SERVICE, DB_PACKAGE
parse_setup_args() {
    PHP="8.5"
    DB_SERVICE="MariaDB"
    DB_PACKAGE="mariadb-server"

    for arg in "$1" "$2" "$3"; do
        case "$arg" in
            php85)   PHP="8.5" ;;
            php84)   PHP="8.4" ;;
            php83)   PHP="8.3" ;;
            php81)   PHP="8.1" ;;
            php80)   PHP="8.0" ;;
            php74)   PHP="7.4" ;;
            php73)   PHP="7.3" ;;
            php72)   PHP="7.2" ;;
            php71)   PHP="7.1" ;;
            mysql)   DB_SERVICE="MySQL";      DB_PACKAGE="mysql-server" ;;
            mariadb) DB_SERVICE="MariaDB";    DB_PACKAGE="mariadb-server" ;;
            pgsql)   DB_SERVICE="PostgreSQL"; DB_PACKAGE="postgresql postgresql-contrib" ;;
        esac
    done
}
