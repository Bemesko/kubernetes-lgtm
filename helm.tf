provider "helm" {
  kubernetes {
    config_path            = ""
    host                   = data.azurerm_kubernetes_cluster.monitoring.kube_config[0].host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.monitoring.kube_config[0].client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.monitoring.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.monitoring.kube_config[0].cluster_ca_certificate)
  }
}

resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "61.6.1"

  values = [file("${path.module}/kube-prometheus-stack-values.yaml")]
}

resource "helm_release" "loki_stack" {
  name       = "loki-stack"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-stack"
  version    = "2.10.2"

  values = [file("${path.module}/loki-stack-values.yaml")]
}
