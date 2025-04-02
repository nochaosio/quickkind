# superkind

```
kind create cluster --config kind-config.yaml 
```

```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

```
helm install prometheus-operator prometheus-community/kube-prometheus-stack \
  --values prometheus-values.yaml \
  --namespace monitoring
```

9614
14314
12006
11686