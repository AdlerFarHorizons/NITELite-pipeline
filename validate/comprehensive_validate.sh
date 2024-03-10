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
if [ -z "$COMPOSE_FILE" ]; then
    COMPOSE_FILE="./build/docker-compose.yaml"
fi

echo 'Performing comprehensive validation...'
echo

echo 'Can we see the input and output?'
ls /data/
echo

echo 'Can we see individual input files?'
ls /data/input/referenced_images/220513-FH135/
echo

echo 'Can we see input and output from inside the docker container?'
docker compose -f $COMPOSE_FILE \
    run \
    --volume $DATA_DIR:/data \
    nitelite-pipeline \
    /bin/bash -c \
    'ls /data/input; ls /data/output'
echo

echo 'Can we create, see, and delete files inside the output directory?'
echo 'Writing files to output...'
touch /data/output/test.txt; touch /data/output/test2.txt
echo 'Files in output bucket:'
ls /data/output/
echo 'Removing files from output bucket...'
rm /data/output/test.txt; rm /data/output/test2.txt
ls /data/output/
echo

echo 'Can we see the config file from inside the docker container?'
docker compose -f $COMPOSE_FILE \
    run \
    --volume $DATA_DIR:/data \
    --volume $(realpath ./config/mosaic.yml):/used_config.yml \
    nitelite-pipeline \
    /bin/bash -c \
    'ls /*.yml'
echo

echo 'Does the conda environment inside the docker container work?'
docker compose -f $COMPOSE_FILE \
    run \
    --volume $DATA_DIR:/data \
    nitelite-pipeline \
    /bin/bash -c \
    'conda run -n nitelite-pipeline-conda python -c \
    "import sys; \
print(f\"Found sys.executable at {sys.executable}!\");"'
echo

echo 'Can we see the input and output from inside the conda environment inside the docker container?'
docker compose -f $COMPOSE_FILE \
    run \
    --volume $DATA_DIR:/data \
    nitelite-pipeline \
    /bin/bash -c \
    'conda run -n nitelite-pipeline-conda ls /data/'
echo

echo 'Can we create, see, and delete files inside the output using Python?'
docker compose -f $COMPOSE_FILE \
    run \
    --volume $DATA_DIR:/data \
    --volume $(realpath ./validate/validate_filesystem.py):/validate_filesystem.py \
    nitelite-pipeline \
    /bin/bash -c \
    'conda run -n nitelite-pipeline-conda --live-stream \
    python /validate_filesystem.py'
echo

echo 'Is the code inside the docker container what we expect?'
docker compose -f $COMPOSE_FILE \
    run \
    --volume $DATA_DIR:/data \
    nitelite-pipeline \
    /bin/bash -c \
    'pwd; echo "Contained files:"; ls ./night-horizons-mapmaker/night_horizons'
echo

echo 'Can we see the input and output from inside a python script inside the conda environment inside the docker container?'
docker compose -f $COMPOSE_FILE \
    run \
    --volume $DATA_DIR:/data \
    # --volume $(realpath ./validate/validate.py):/validate.py \
    # --volume $(realpath ./validate/io_manager.py):/io_manager.py \
    --volume $(realpath ./config/mosaic.yml):/used_config.yml \
    nitelite-pipeline \
    /bin/bash -c \
    'conda run -n nitelite-pipeline-conda --live-stream \
    python /validate.py /used_config.yml --validate_only'
echo

# echo 'Does the pipeline code inside the docker container find the data?'
# docker compose -f $COMPOSE_FILE \
#     run \
#     --volume $(realpath ./config/mosaic.yml):/used_config.yml \
#     nitelite-pipeline \
#     /bin/bash -c \
#     'conda run -n nitelite-pipeline-conda \
#     python night-horizons-mapmaker/night_horizons/mapmake.py \
#     /used_config.yml --validate_only'
# 
# echo 'Does the execution script work?'
# ./validate/mapmake.sh -d /data:/data -c $(realpath ./config/mosaic.yml):/used_config.yml --validate_only
# echo