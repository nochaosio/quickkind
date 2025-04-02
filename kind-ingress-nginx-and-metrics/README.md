# kind-ingress-nginx-and-metrics

| Tool     | Version  |
| -------- | -------- |
| OpenTofu | v1.9.0   |
| Kubectl  | v1.32.2  |
| Helm     | v3.17.0  |
| mise     | 2025.4.0 |

## Manual steps

```sh
kind create cluster --config kind-config.yaml 
```

```sh
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo update

helm install prometheus-operator prometheus-community/kube-prometheus-stack \
  --values prometheus-values.yaml \
  --namespace monitoring
```

## OpenTofu steps

```
tofu init
tofu plan
tofy apply
```

## Exploring

### Create demo application

```
```

### Generate load

Generate load on the created Ingresses by sending request
```
```