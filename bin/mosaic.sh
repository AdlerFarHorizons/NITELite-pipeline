#!/bin/bash

# Function to display help message
show_help() {
    cat << EOF
Usage: ./mosaic.sh -c CONFIG_FILEPATH [OPTIONS]

Options:
    -c, --config CONFIG_FILEPATH    Location of the configuration file
    -h, --help                      Show this help message

Example:
    ./bin/mosaic.sh ./mosaic_config.yml
EOF
}


# Parse command line arguments
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -c|--config)
            CONFIG_FILEPATH="$2"
            shift # past argument
            shift # past value
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Error: Unrecognized option $1"
            show_help
            exit 1
            ;;
    esac
done

# Check if the config file path was provided
if [ -z "$CONFIG_FILEPATH" ]; then
    echo "Error: Configuration filepath is required."
    show_help
    exit 1
fi

# Construct docker run command
# DOCKER_CMD="docker compose run"
DOCKER_CMD="docker compose -f ./docker/docker-compose.yaml run"

# We specify the platform, important for running on M1 Macs
# DOCKER_CMD+=" --platform linux/amd64"

# Name of the service
DOCKER_CMD+=" nitelite_pipeline"

# This part of the command specifies the python environment
# (inside the docker image) to use
DOCKER_CMD+=" conda run -n nitelite-pipeline-conda"
# DOCKER_CMD+=" \bin\bash -c"

# The script to run inside the docker image
# DOCKER_CMD+=" python "
# DOCKER_CMD+=" pytest"
DOCKER_CMD+=" python ./night-horizons-mapmaker/night_horizons/mapmake.py --help"
# DOCKER_CMD+=" ls ."

# Execute docker run command
echo "Running the following command:"
echo
echo $DOCKER_CMD
echo
eval $DOCKER_CMD
