#!/bin/bash
# Short script to test scripting works

echo "Checking docker compose"
docker compose --help

docker pull 
docker compose -f ./build/docker-compose.yaml run -i nitelite-pipeline /bin/bash -c 'echo "Pipeline is ready to run!"'

echo "The script works!"