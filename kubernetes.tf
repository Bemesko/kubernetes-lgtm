provider "helm" {
  kubernetes {
    config_path            = "~/.kube/config"
    config_context_cluster = azurerm_kubernetes_cluster.monitoring.name
    # host                   = data.azurerm_kubernetes_cluster.monitoring.kube_config[0].host
    # client_certificate     = base64decode(data.azurerm_kubernetes_cluster.monitoring.kube_config[0].client_certificate)
    # client_key             = base64decode(data.azurerm_kubernetes_cluster.monitoring.kube_config[0].client_key)
    # cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.monitoring.kube_config[0].cluster_ca_certificate)
  }
}

provider "kubectl" {
  config_context = azurerm_kubernetes_cluster.monitoring.name
}

resource "helm_release" "kube_prometheus_stack" {
  name         = "kube-prometheus-stack"
  repository   = "https://prometheus-community.github.io/helm-charts"
  chart        = "kube-prometheus-stack"
  version      = "61.7.0"
  reset_values = true

  values = [file("${path.module}/kube-prometheus-stack-values.yaml")]
}

resource "helm_release" "prometheus_adapter" {
  name         = "prometheus-adapter"
  repository   = "https://prometheus-community.github.io/helm-charts"
  chart        = "prometheus-adapter"
  version      = "4.10.0"
  reset_values = true
  set {
    name  = "prometheus.url"
    value = "http://prometheus-operated.default.svc"
  }
  set {
    name  = "rules.default"
    value = "false"
  }
}

# resource "helm_release" "loki_stack" {
#   name         = "loki-stack"
#   repository   = "https://grafana.github.io/helm-charts"
#   chart        = "loki-stack"
#   version      = "2.10.2"
#   reset_values = true

#   values = [file("${path.module}/loki-stack-values.yaml")]
# }

resource "helm_release" "loki" {
  name       = "loki"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"
  version    = "6.7.3"

  values = [file("${path.module}/loki-values.yaml")]
}

resource "helm_release" "fluent-bit" {
  name         = "fluent-bit"
  repository   = "https://fluent.github.io/helm-charts"
  chart        = "fluent-bit"
  version      = "0.47.5"
  reset_values = true

  values = [file("${path.module}/fluent-bit-values.yaml")]
}

resource "kubectl_manifest" "gelf_log_generator" {
  yaml_body = file("${path.module}/gelf-log-generator.yaml")
}
