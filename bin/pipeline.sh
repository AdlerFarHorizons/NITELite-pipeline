#!/bin/bash

# Function to display help message
show_help() {
    cat << EOF
Usage: ./mosaic.sh -c CONFIG_FILEPATH -d DATA_DIR [OPTIONS]

Options:
    -c, --config CONFIG_FILEPATH    Location of the configuration file.
                                    Must be inside either the repository
                                    or the data directory.
    -d, --data DATA_DIR             Location of the data directory. This will
                                    be mounted to the /data directory inside
                                    the docker container. Any data you want to
                                    use should be inside DATA_DIR, and any paths
                                    in the config should be relative to this.
    -i, --interactive               Instead of running the execution script,
                                    open an interactive shell inside the
                                    docker container.
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
        -i|--interactive)
            INTERACTIVE="true"
            shift # past argument
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
if [ -z "$DATA_DIR" ]; then
    echo "Error: Data directory is required."
    show_help
    exit 1
fi
if [ -z "$CONFIG_FILEPATH" ] && [ -z "$INTERACTIVE" ]; then
    echo "Error: Configuration filepath is required."
    show_help
    exit 1
fi

# Construct docker command
DOCKER_CMD="docker compose -f ./docker/docker-compose.yaml"
# The docker command itself
DOCKER_CMD+=" run"

# If not interactive, then we add a "run"
if [ -n "$INTERACTIVE" ]; then
    DOCKER_CMD+=" -i"
fi

# Mount the data directory
DOCKER_CMD+=" --volume $DATA_DIR:/data"

# Name of the service
DOCKER_CMD+=" nitelite_pipeline"

# The script to run inside the docker image
if [ -z "$INTERACTIVE" ]; then

    # This part of the command specifies the python environment
    # (inside the docker image) to use
    DOCKER_CMD+=" conda run -n nitelite-pipeline-conda"

    DOCKER_CMD+=" python ./night-horizons-mapmaker/night_horizons/mapmake.py"

    # The command line arguments to the script
    DOCKER_CMD+=" $CONFIG_FILEPATH"
else
    DOCKER_CMD+=" /bin/bash"
fi


# TODO: Delete this later
# DOCKER_CMD+=" ls /data/other"

# Execute docker run command
echo "Running the following command:"
echo $DOCKER_CMD
echo
eval $DOCKER_CMD
