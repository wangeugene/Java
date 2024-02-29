It's a pilot of containerized clusters

# Minikube

Minikube is a tool that makes it easy to run Kubernetes locally. Minikube runs a single-node Kubernetes cluster inside a
VM on your laptop for users looking to try out Kubernetes or develop with it day-to-day.

```zsh
# Install miniKube
brew install minikube
# Start miniKube & create cluster
minikube start
# Check the status of miniKube
minikube status
# Check updates
minikube update-check
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
# Delete namespaces 
kubectl delete -f namespace.yaml
```

## Create deployment

```zsh
# Create deployments
kubectl apply -f deployment.yaml
# Delete deployments
kubectl delete -f deployment.yaml
# Get namespaces
kubectl get ns
# List deployment under namespace development
kubectl get deployments -n development
# List pods under namespace development
kubectl get pods -n development
# Delete pod by name
kubectl delete pod <pod-name> -n development
# Delete pods under namespace development
kubectl delete pods -n development --all
# Describe a pod
kubectl describe pod pod-info-deployment-57468d67c-dl9gp -n development
# Get verbose mode from pods under namespace development
kubectl get pods -n development -o wide
```

## Create busybox pod

```zsh
kubectl apply -f busybox.yaml
kubectl get pods
kubectl logs <pod-name>
# To login to the pod
kubectl exec -it <pod-name> -- /bin/sh
```

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
