#!/bin/bash

mkdir /data/nitelite.test-data

mount-s3 nitelite.test-data /data/nitelite.test-data \
    --allow-overwrite --allow-delete

./test/test.sh \
    -c ./night-horizons-mapmaker/configs/metadata.yaml \
    -d /data/nitelite.test-data \
    -f ./aws/docker-compose.yaml
