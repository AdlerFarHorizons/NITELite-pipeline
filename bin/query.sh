# docker exec -it build-db-1 /bin/bash -c "raster2pgsql /data/referenced/*modified.tif public.referenced | psql -U gis -d gis"
docker exec -it build-db-1 psql -U gis
# docker exec -it build-db-1 /bin/bash -c "psql -U postgres -d gis"