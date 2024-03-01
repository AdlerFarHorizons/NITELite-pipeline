echo 'Validating mount...'

docker compose -f ./aws/docker-compose.yaml \
    run nitelite-pipeline \
    /bin/bash -c \
    'ls /data/'

docker compose -f ./aws/docker-compose.yaml \
    run nitelite-pipeline \
    /bin/bash -c \
    'conda run -n nitelite-pipeline-conda ls /data/'

docker compose -f ./aws/docker-compose.yaml \
    run nitelite-pipeline \
    /bin/bash -c \
    'conda run -n nitelite-pipeline-conda python -c \
    "import os; \
print(os.listdir(\"/data\")); \
print(os.listdir(\"/data/referenced_images\")); \
print(os.listdir(\"/data/nitelite_pipeline_output\"))"'

docker compose -f ./aws/docker-compose.yaml \
    run nitelite-pipeline \
    /bin/bash -c \
    'tail ./night-horizons-mapmaker/night_horizons/mapmake.py'

docker compose -f ./aws/docker-compose.yaml \
    run \
    --volume $(realpath ./config/mosaic.yml):/used-config.yml \
    nitelite-pipeline \
    /bin/bash -c \
    'conda run -n nitelite-pipeline-conda \
    python '