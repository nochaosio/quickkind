resource "null_resource" "create_kind_cluster" {
  provisioner "local-exec" {
    command = "kind create cluster --config kind-config.yaml"
  }
}

provider "helm" {
  kubernetes {
    config_path = pathexpand("~/.kube/config")
  }
}

resource "null_resource" "wait_for_cluster" {
  depends_on = [null_resource.create_kind_cluster]
  
  provisioner "local-exec" {
    command = "kubectl wait --for=condition=Ready nodes --all --timeout=300s"
  }
}

resource "helm_release" "prometheus_operator" {
  name             = "prometheus-operator"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true
  
  depends_on = [null_resource.wait_for_cluster]

  values = [
    file("prometheus-values.yaml")
  ]
  
  timeout = 600
}

resource "null_resource" "wait_for_prometheus" {
  depends_on = [helm_release.prometheus_operator]
  
  provisioner "local-exec" {
    command = <<-EOT
      kubectl wait --for=condition=established --timeout=300s crd/prometheuses.monitoring.coreos.com
      kubectl wait --for=condition=Ready pods --all -n monitoring --timeout=300s
    EOT
  }
}
resource "null_resource" "apply_ingress" {
  depends_on = [null_resource.wait_for_prometheus]
  
  provisioner "local-exec" {
    command = "kubectl apply -f ingress.yaml"
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}