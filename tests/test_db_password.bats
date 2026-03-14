#!/usr/bin/env bats

# Tests for database password extraction from .my.cnf

setup() {
    export MOCK_CNF="$BATS_TMPDIR/.my.cnf"
}

teardown() {
    rm -f "$MOCK_CNF"
}

@test "extracts plain password from .my.cnf" {
    printf '[client]\nuser=dbadmin\npassword=MySecretPass123\n' > "$MOCK_CNF"
    result=$(grep '^password=' "$MOCK_CNF" | cut -d'=' -f2-)
    [ "$result" = "MySecretPass123" ]
}

@test "extracts password containing equals sign" {
    printf '[client]\nuser=dbadmin\npassword=abc=def=ghi\n' > "$MOCK_CNF"
    result=$(grep '^password=' "$MOCK_CNF" | cut -d'=' -f2-)
    [ "$result" = "abc=def=ghi" ]
}

@test "extracts alphanumeric password" {
    printf '[client]\nuser=dbadmin\npassword=aB3dE6fG9hI0\n' > "$MOCK_CNF"
    result=$(grep '^password=' "$MOCK_CNF" | cut -d'=' -f2-)
    [ "$result" = "aB3dE6fG9hI0" ]
}

@test "does not include user line in password extraction" {
    printf '[client]\nuser=dbadmin\npassword=TestPass\n' > "$MOCK_CNF"
    result=$(grep '^password=' "$MOCK_CNF" | cut -d'=' -f2-)
    [ "$result" = "TestPass" ]
    [ "$result" != "dbadmin" ]
}

@test "openssl password generation produces non-empty string" {
    result=$(openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | head -c 32)
    [ -n "$result" ]
}

@test "openssl password generation length is 32" {
    result=$(openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | head -c 32)
    [ ${#result} -eq 32 ]
}

@test "openssl password generation is alphanumeric only" {
    result=$(openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | head -c 32)
    [[ "$result" =~ ^[a-zA-Z0-9]+$ ]]
}
