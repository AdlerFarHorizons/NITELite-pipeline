docker stop build-db-1
docker system prune -f
docker container prune -f

DATA_DIR="/Users/Shared/data/nitelite/220513-FH135/db"
[ -d "$DATA_DIR" ] && rm -r "$DATA_DIR"