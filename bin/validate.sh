#!/bin/bash
# Short script to validate the pipeline installation

CMD="docker compose -f ./build/docker-compose.yaml run -i nitelite-pipeline"
CMD+=" /bin/bash -c 'echo \"Pipeline is ready to run!\"'"

eval $CMD