#!/bin/bash

# Function to display help message
show_help() {
    cat << EOF
Usage: ./mosaic.sh -d INPUT_DIR -o OUTPUT_DIR [OPTIONS]

Options:
    -c, --config CONFIG_FILEPATH    Location of the configuration file.
                                    Must be inside either the repository
                                    or the data directory.
    -d, --input INPUT_DIR           Location of rasters to convert.
    -i, --interactive               Instead of running the execution script,
                                    open an interactive shell inside the
                                    docker container.
    -f, --compose-file              Specify the docker-compose file to use.
                                    Default is ./build/docker-compose.yaml
    -h, --help                      Show this help message

Example:
    ./bin/mosaic.sh -c ./mosaic_config.yml -d ~/data
EOF
}


# Parse command line arguments
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -d|--data)
            INPUT_DIR="$2"
            shift # past argument
            shift # past value
            ;;
        -o|--output)
            OUTPUT_DIR="$2"
            shift # past argument
            shift # past value
            ;;
        -f|--compose-file)
            COMPOSE_FILE="$2"
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
if [ -z "$INTERACTIVE" ]; then
    if [ -z "$INPUT_DIR" ]; then
        echo "Error: Data directory is required."
        show_help
        exit 1
    fi
fi
if [ -z "$COMPOSE_FILE" ]; then
    COMPOSE_FILE="./build/dev-docker-compose.yaml"
fi

# Construct docker command
DOCKER_CMD="docker compose -f $COMPOSE_FILE"
# The docker command itself
DOCKER_CMD+=" run"

# If not interactive, then we add a "run"
if [ -n "$INTERACTIVE" ]; then
    DOCKER_CMD+=" -i"
fi

# Mount the data directory
if [ -n "$INPUT_DIR" ]; then
    DOCKER_CMD+=" --volume $INPUT_DIR:/data"
fi

# Name of the service
DOCKER_CMD+=" postgis "

# The script to run inside the docker image
if [ -z "$INTERACTIVE" ]; then

    # This part of the command specifies the python environment
    # (inside the docker image) to use
    DOCKER_CMD+="/bin/bash -c 'raster2pgsql /data/*.tif public.referenced'"
    # DOCKER_CMD+=" psql"
else
    DOCKER_CMD+=" /bin/bash"
fi

# Execute docker run command
echo "Executing:"
echo $DOCKER_CMD
echo
eval $DOCKER_CMD
