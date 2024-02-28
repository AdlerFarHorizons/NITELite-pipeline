#!/bin/bash
# Short script to test scripting works

echo "Current system parameters:"
uname -a
echo

echo "nitelite-pipeline system parameters:"
docker compose -f ./build/docker-compose.yaml run nitelite-pipeline bash -c "uname -a"
