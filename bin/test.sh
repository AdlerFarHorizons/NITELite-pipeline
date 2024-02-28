#!/bin/bash
# Short script to test scripting works

echo "Available images:"
docker image list

echo
echo "Current system parameters:"
uname -a
echo

echo "nitelite-pipeline system parameters:"
docker compose -f ./build/docker-compose.yaml run interior-nitelite-pipeline bash -c "uname -a"
