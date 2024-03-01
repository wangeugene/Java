# Build and push your image to docker hub (public)

```zsh
docker build -t pod-info-app:latest .
docker image tag pod-info-app:latest sail456852/pod-info-app:latest
docker login
docker image push sail456852/pod-info-app:latest
```

remote url: https://hub.docker.com/repository/docker/sail456852/pod-info-app