# Build and push your image to docker hub (public)

```zsh
docker build --build-arg NAME=eugene -t sail456852/pod-info-app:latest .
```

```zsh
docker image tag pod-info-app:latest sail456852/pod-info-app:latest
docker login
docker image push sail456852/pod-info-app:latest
```

# Passing environment variables to docker container

```zsh
docker run -d -p 3000:3000 -e PORT=3000 -e NAME=John -e AGE=25 pod-info-app:latest
```

# expected output

```zsh
curl -X GET http://localhost:3000/health
```

# vulnerabilities

```zsh
docker login -u <username> -p <password> <registry>
docker scout cves
```

remote url: https://hub.docker.com/repository/docker/sail456852/pod-info-app