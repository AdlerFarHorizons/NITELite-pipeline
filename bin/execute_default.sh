#!/bin/bash

CMD="./bin/mapmake.sh"
CMD+=" -c ./config/test-sequential-mosaic.yml"
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