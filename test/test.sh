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
    -f, --compose-file              Specify the docker-compose file to use.
                                    Default is ./build/docker-compose.yaml
    -h, --help                      Show this help message

Example:
    ./bin/mapmake.sh -c ./config/mosaic.yml -d /Users/shared/data
EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -c|--config)
            CONFIG_FILEPATH=$(realpath "$2")
            shift # past argument
            shift # past value
            ;;
        -d|--data)
            DATA_DIR=$(realpath "$2")
            shift # past argument
            shift # past value
            ;;
        -f|--compose-file)
            COMPOSE_FILE="$2"
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
if [ -z "$COMPOSE_FILE" ]; then
    COMPOSE_FILE="./build/docker-compose.yaml"
fi

echo 'Running the test suite...'
echo

echo 'Can we see the input and output?'
ls $DATA_DIR
echo

echo 'Can we see individual input files?'
ls $DATA_DIR/input/referenced_images/220513-FH135/
echo

echo 'Where are we inside the docker container?'
docker compose -f $COMPOSE_FILE \
    run \
    --volume $DATA_DIR:/data \
    nitelite-pipeline \
    pwd
echo

echo 'Can we see individual input files from inside the docker container?'
docker compose -f $COMPOSE_FILE \
    run \
    --volume $DATA_DIR:/data \
    nitelite-pipeline \
    /bin/bash -c \
    'ls /data/input/referenced_images/220513-FH135/'
echo

echo 'Can we create, see, and delete files inside the output directory?'
echo 'Writing files to output...'
touch $DATA_DIR/output/test.txt; touch $DATA_DIR/output/test2.txt
echo 'Files in output bucket:'
ls $DATA_DIR/output/
echo 'Removing files from output bucket...'
rm $DATA_DIR/output/test.txt; rm $DATA_DIR/output/test2.txt
ls $DATA_DIR/output/
echo

echo 'Can we see the config file from inside the docker container?'
docker compose -f $COMPOSE_FILE \
    run \
    --volume $DATA_DIR:/data \
    --volume $CONFIG_FILEPATH:/used_config.yml \
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
    --volume $(realpath ./test/validate_filesystem.py):/validate_filesystem.py \
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
    'pwd; echo "Files in night_horizons:"; ls ./night-horizons-mapmaker/night_horizons'
echo

echo 'Does the test suite work?'
docker compose -f $COMPOSE_FILE \
    run \
    --volume $DATA_DIR:/data \
    --volume $(realpath .):/NITELite-pipeline \
    nitelite-pipeline \
    /bin/bash -c \
    'cd night-horizons-mapmaker; \
    conda run -n nitelite-pipeline-conda --live-stream \
    pytest .'
echo

# echo 'Does the pipeline code inside the docker container find the data?'
# docker compose -f $COMPOSE_FILE \
#     run \
#     --volume $CONFIG_FILEPATH:/used_config.yml \
#     nitelite-pipeline \
#     /bin/bash -c \
#     'conda run -n nitelite-pipeline-conda \
#     python night-horizons-mapmaker/night_horizons/mapmake.py \
#     /used_config.yml --validate_only'
# 
# echo 'Does the execution script work?'
# ./validate/mapmake.sh -d /data:/data -c $CONFIG_FILEPATH:/used_config.yml --validate_only
# echo