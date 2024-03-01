echo 'Validating mount...'

docker compose -f ./build/docker-compose.yaml \
    run nitelite-pipeline \
    /bin/bash -c \
    'conda run -n nitelite-pipeline-conda python -c \
    "import os; \
os.listdir(\"/data\"); \
os.listdir(\"/data/referenced_images\"); \
os.listdir(\"/data/nitelite_pipelin_output\")"'