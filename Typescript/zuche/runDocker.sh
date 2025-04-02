docker build -t zuche:1.0 .
if [ "$(docker ps -aq -f name=zuche_container)" ]; then
  docker rm -f zuche_container
fi
docker run --env-file .env --name zuche_container zuche:1.0
docker logs zuche_container