# Build the container. This is done automatically during docker compose
# So we only uncomment and use this line if we want to build with no cache
docker compose -f ./build/dev-docker-compose.yaml build --no-cache

# Boot up the container
docker compose -f ./build/dev-docker-compose.yaml up -d
# Wait for it to boot up
sleep 2

# Enable raster support, drop the table if it exists
docker exec -it build-db-1 psql -U gis -c "CREATE EXTENSION IF NOT EXISTS postgis_raster; DROP TABLE IF EXISTS public.referenced;"

# Convert the referenced rasters to pgsql
docker exec build-db-1 /bin/bash -c "raster2pgsql /data/referenced/*modified.tif public.referenced | psql -U gis -d gis"

# Open up the psql shell so we can take a look at output interactively, if we want
docker exec -it build-db-1 psql -U gis