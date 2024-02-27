#!/bin/bash

# Main command
DOCKER_CMD="docker build"

# By default we want to see more
DOCKER_CMD+=" --progress plain"

# The docker file, for convenience
DOCKER_CMD+=" -f ./build/Dockerfile"

# The tag
DOCKER_CMD+=" -t nitelite-pipeline:latest"

# Pass any other commands to the docker build command
if [ $# -gt 0 ]; then
    DOCKER_CMD+=" \"$@\""
fi

# What to build
DOCKER_CMD+=" ."

# Execute the build
echo "Executing:"
echo $DOCKER_CMD
echo
eval $DOCKER_CMD