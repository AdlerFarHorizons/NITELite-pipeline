echo 'Validating mount...'

docker compose -f ./aws/docker-compose.yaml \
    run nitelite-pipeline \
    /bin/bash -c \
    'touch /data/nitelite_pipeline_output/test_mount'

docker compose -f ./aws/docker-compose.yaml \
    run nitelite-pipeline \
    /bin/bash -c \
    'conda run -n nitelite-pipeline-conda touch /data/nitelite_pipeline_output/test_mount_conda'

docker compose -f ./aws/docker-compose.yaml \
    run nitelite-pipeline \
    /bin/bash -c \
    'conda run -n nitelite-pipeline-conda python -c \
    "import os; \
os.listdir(\"/data\"); \
os.listdir(\"/data/referenced_images\"); \
os.listdir(\"/data/nitelite_pipeline_output\")"'