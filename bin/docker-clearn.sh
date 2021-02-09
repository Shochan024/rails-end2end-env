docker system prune --force
docker container stop $( docker container ls -q )
