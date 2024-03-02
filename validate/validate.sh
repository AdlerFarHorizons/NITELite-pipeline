#!/bin/bash
# Short script to validate the availability of the image
# A more extensive validation that checks mounting, etc. is available as part
# of mapmake.py

echo 'Validating image...'

docker compose -f ./build/docker-compose.yaml \
    run nitelite-pipeline \
    /bin/bash -c \
    'conda run -n nitelite-pipeline-conda python -c \
    "import sys; \
print(f\"sys.executable at {sys.executable}\");
print(\"Image validated!\")"'