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

echo 'Do the unit tests pass?'
docker compose -f $COMPOSE_FILE \
    run \
    --volume $DATA_DIR:/data \
    --volume $(realpath .):/NITELite-pipeline \
    nitelite-pipeline \
    /bin/bash -c \
    'cd night-horizons-mapmaker; \
    conda run -n nitelite-pipeline-conda --live-stream \
    pytest --ignore=./test/test_pipeline.py .'
echo

# echo 'Does the test suite work?'
echo 'Does the metadata stage work?'
docker compose -f $COMPOSE_FILE \
    run \
    --volume $DATA_DIR:/data \
    --volume $(realpath .):/NITELite-pipeline \
    nitelite-pipeline \
    /bin/bash -c \
    'cd night-horizons-mapmaker; \
    conda run -n nitelite-pipeline-conda --live-stream \
    pytest ./test/test_pipeline.py::TestMetadataProcessor'
echo 'pytest.log:'
cat ./night-horizons-mapmaker/test/pytest.log
echo


echo 'Does the mosaic stage work?'
docker compose -f $COMPOSE_FILE \
    run \
    --volume $DATA_DIR:/data \
    --volume $(realpath .):/NITELite-pipeline \
    nitelite-pipeline \
    /bin/bash -c \
    'cd night-horizons-mapmaker; \
    conda run -n nitelite-pipeline-conda --live-stream \
    pytest ./test/test_pipeline.py::TestMosaicMaker'
echo 'pytest.log:'
cat ./night-horizons-mapmaker/test/pytest.log
echo

echo 'Does the sequential mosaic stage work?'
docker compose -f $COMPOSE_FILE \
    run \
    --volume $DATA_DIR:/data \
    --volume $(realpath .):/NITELite-pipeline \
    nitelite-pipeline \
    /bin/bash -c \
    'cd night-horizons-mapmaker; \
    conda run -n nitelite-pipeline-conda --live-stream \
    pytest ./test/test_pipeline.py::TestSequentialMosaicMaker'
echo 'pytest.log:'
cat ./night-horizons-mapmaker/test/pytest.log
echo