#!/bin/bash

# Function to display help message
show_help() {
    cat << EOF
Usage: ./bin/mapmake.sh -c CONFIG_FILEPATH -d DATA_DIR [OPTIONS]

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
    -f, --compose-file              Specify the docker-compose file to use.
                                    Default is ./build/docker-compose.yaml
    -h, --help                      Show this help message
    --validate_only                 Only validate the setup and exit. This
                                    will not run the pipeline.

Example:
    ./bin/mapmake.sh -c ./config/mosaic.yml -d /Users/shared/data
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
        -f|--compose-file)
            COMPOSE_FILE="$2"
            shift # past argument
            shift # past value
            ;;
        -i|--interactive)
            INTERACTIVE="true"
            shift # past argument
            ;;
        --validate_only)
            VALIDATE_ONLY="true"
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
    if [ -z "$DATA_DIR" ]; then
        echo "Error: Data directory is required."
        show_help
        exit 1
    fi
    if [ -z "$CONFIG_FILEPATH" ]; then
        echo "Error: Configuration filepath is required."
        show_help
        exit 1
    fi
fi
if [ -z "$COMPOSE_FILE" ]; then
    COMPOSE_FILE="./build/docker-compose.yaml"
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
if [ -n "$DATA_DIR" ]; then
    DOCKER_CMD+=" --volume $DATA_DIR:/data"
fi

# Mount the config file
if [ -n "$CONFIG_FILEPATH" ]; then
    CONFIG_FILEPATH=$(realpath $CONFIG_FILEPATH)
    DOCKER_CMD+=" --volume $CONFIG_FILEPATH:/used-config.yml"
fi

# TODO: Delete and explain why
# Explanation for removal: The idea behind this is to allow the user to use
# their own version of the pipeline. However, one of the goals is to freeze the
# used code. In addition, copying over the code requires reinstalling it too.
# If the user wants to use their own code, they should either intentionally
# mess with a running image separately, or they should edit and rebuild.
# if [ -n "$COPY_CODE" ]; then
#     # Mount the code. Only use this if you want to use your own edited code.
#     CODE_DIR=$(realpath ..)
#     DOCKER_CMD+=" --volume $CODE_DIR:/NITELite-pipeline"
# fi

# Name of the service
DOCKER_CMD+=" nitelite-pipeline"

# The script to run inside the docker image
if [ -z "$INTERACTIVE" ]; then

    # This part of the command specifies the python environment
    # (inside the docker image) to use
    DOCKER_CMD+=" conda run -n nitelite-pipeline-conda --live-stream"

    DOCKER_CMD+=" python night-horizons-mapmaker/night_horizons/mapmake.py"

    # Pass in the config itself
    DOCKER_CMD+=" /used-config.yml"

    # If validation only, then add the flag
    if [ -n "$VALIDATE_ONLY" ]; then
        DOCKER_CMD+=" --validate_only"
    fi
else
    DOCKER_CMD+=" /bin/bash"
fi

# Execute docker run command
echo "Executing:"
echo $DOCKER_CMD
echo
eval $DOCKER_CMD
