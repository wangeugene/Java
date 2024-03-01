It's a pilot of containerized clusters

# Minikube

Minikube is a tool that makes it easy to run Kubernetes locally. Minikube runs a single-node Kubernetes cluster inside a
VM on your laptop for users looking to try out Kubernetes or develop with it day-to-day.

```zsh
# Install miniKube
brew install minikube
```

```zsh
# Start miniKube & create cluster
minikube start
# Check the status of miniKube
minikube status
# Check updates
minikube update-check

```

```zsh
# Stop miniKube
minikube stop cluster
# Delete miniKube cluster
minikube delete
```

## Manage cluster

```zsh
# Get cluster info
kubectl cluster-info
# List nodes
kubectl get nodes
# List namespaces
kubectl get namespaces 
# List pods in all namespaces (-A stands for --all-namespaces)
kubectl get pods -A
# List services in all namespaces 
kubectl get services -A 
```

## Create namespace

```zsh
# Create namespaces development & production
kubectl apply -f namespace.yaml
# List namespaces to verify
kubectl get namespaces
```

```zsh
# Delete namespaces 
kubectl delete -f namespace.yaml
```

## Create deployment

```zsh
# Create deployments
kubectl apply -f deployment.yaml
# Get namespaces
kubectl get ns
# List pods under namespace development
kubectl get pods -n development
```

### Get verbose mode from pods under namespace development

```zsh
kubectl get deployments -n development
kubectl get pods -n development -o wide
```

```zsh
# Describe a pod
kubectl describe pod pod-info-deployment-57468d67c-dl9gp -n development
# Delete deployments
kubectl delete -f deployment.yaml
# Delete pod by name
kubectl delete pod <pod-name> -n development
# Delete pods under namespace development
kubectl delete pods -n development --all
```

### Create busybox pod under default namespace

```zsh
kubectl apply -f busybox.yaml
kubectl get pods
````

### Get into the busybox pod

```zsh
kubectl logs <pod-name>
# To login to the pod
kubectl exec -it <pod-name> -- /bin/sh
```
- `kubectl exec -it busybox-66c99d76cf-vc4cm -- /bin/sh`

### Operations inside the busybox pod

```zsh
wget <pod-ip>:<port>
cat index.html
exit
```

### Challenge

```zsh
kubectl apply -f quote.yaml
kubectl get pods
kubectl delete -f quote.yaml
```
