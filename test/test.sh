#!/bin/bash

# Docker tests
./test/test_docker.sh "$@"

# Python tests
./test/test_python.sh "$@"
