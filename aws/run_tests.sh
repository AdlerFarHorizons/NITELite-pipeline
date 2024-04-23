#!/bin/bash

mkdir /data/test_data
mkdir /data/test_data/input
mkdir /data/test_data/output

mount-s3 nitelite.test-data /data/test_data/input \
    --allow-overwrite --allow-delete

./test/test.sh \
    -c ./night-horizons-mapmaker/configs/metadata.yaml \
    -d /data/test_data \
    -f ./aws/docker-compose.yaml
