#!/bin/bash

if $RUN_TESTS; then
    echo "Running tests..."

    # Docker tests
    ./test/test_docker.sh "$@"

    # Python tests
    ./test/test_python.sh "$@"
else
    echo "Skipping tests"
    exit 0
fi
