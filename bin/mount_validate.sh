docker compose -f ./build/docker-compose.yaml \
    run \
    --volume $1:/data \
    $2 \
    /bin/bash -c \
    'ls /data'