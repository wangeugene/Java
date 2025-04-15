## Minikube Playground

```zsh
brew install minikube
```

```zsh
minikube delete
minikube start
minikube status
minikube stop cluster
minikube update-check
```

```zsh
kubectl apply -f busybox.yaml
kubectl apply -f deployment.yaml
kubectl apply -f namespace.yaml
kubectl apply -f quote.yaml
kubectl cluster-info
kubectl delete -f deployment.yaml
kubectl delete -f namespace.yaml
kubectl delete -f quote.yaml
kubectl delete pod pod_name -n development
kubectl delete pods -n development --all
kubectl describe pod pod_name -n development
kubectl exec -it pod_name -- /bin/sh
kubectl get deployments -n development
kubectl get namespaces
kubectl get nodes
kubectl get ns
kubectl get pods
kubectl get pods -A
kubectl get pods -n development
kubectl get pods -n development -o wide
kubectl get services -A
kubectl logs pod_name
kubectl version --client --output=yaml
```

## AWS Playground

```zsh
aws ec2 describe-instances
aws eks describe-addon-versions --addon-name vpc-cni
aws eks describe-cluster --name cluster_name  --query "cluster.version"
aws sts get-caller-identity
```

## Services vs Deployments

| Concept        | **Deployment**                                | **Service**                                       |
| -------------- | --------------------------------------------- | ------------------------------------------------- |
| Purpose        | Manages how apps are **deployed and updated** | Provides a **stable endpoint** to access pods     |
| Controls       | **ReplicaSets → Pods**                        | Routes traffic to **Pods** via selectors          |
| Concerned with | App lifecycle, scaling, rollouts              | Networking, discovery, load-balancing             |
| Creates        | **Pods** (indirectly)                         | **ClusterIP / NodePort / LoadBalancer endpoints** |
| Stateful?      | Typically used for **stateless** apps         | Can front stateless or stateful services          |
