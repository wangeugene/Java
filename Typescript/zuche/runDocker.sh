docker build -t zuche:1.0 .
docker rm -f zuche_container || true
docker run --env-file .env --name zuche_container zuche:1.0