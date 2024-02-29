#!/bin/bash
# Short script to validate the pipeline installation

docker compose -f ./build/docker-compose.yaml \
    run nitelite-pipeline \
    /bin/bash -c \
    'conda run -n nitelite-pipeline-conda python -c \
    "import sys; \
print(f\"sys.executable at {sys.executable}\");
print(\"Image validated!\")"'