#!/bin/bash

CMD="./bin/pipeline.sh"
CMD+=" -c ./config/mosaic.yml"
CMD+=" -d /Users/Shared/data"

# Pass any other commands to the docker build command
if [ $# -gt 0 ]; then
    CMD+=" \"$@\""
fi

# Execute the build
echo "Executing:"
echo $CMD
echo
eval $CMD