#!/bin/bash

# Function to display help message
show_help() {
    cat << EOF
Usage: ./mosaic.sh -c CONFIG_FILEPATH -d DATA_DIR [OPTIONS]

Options:
    -c, --config CONFIG_FILEPATH    Location of the configuration file.
    -d, --data DATA_DIR             Location of the data directory. This will
                                    be mounted to the /data directory inside
                                    the docker container. Any data you want to
                                    use should be inside DATA_DIR, and any paths
                                    in the config should be relative to this.
    -h, --help                      Show this help message

Example:
    ./bin/mosaic.sh -c ./mosaic_config.yml -d ~/data
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
        -d|--data)
            DATA_DIR="$2"
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

# Check the necessary arguments are provided
if [ -z "$CONFIG_FILEPATH" ]; then
    echo "Error: Configuration filepath is required."
    show_help
    exit 1
fi
if [ -z "$DATA_DIR" ]; then
    echo "Error: Data directory is required."
    show_help
    exit 1
fi

# Construct docker run command
# DOCKER_CMD="docker compose run"
DOCKER_CMD="docker compose -f ./docker/docker-compose.yaml run"

# Mount the data directory
DOCKER_CMD+=" --volume $DATA_DIR:/data"

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
