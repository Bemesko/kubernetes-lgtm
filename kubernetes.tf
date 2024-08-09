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

resource "helm_release" "tempo" {
  name             = "tempo"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "tempo"
  version          = "1.10.2"
  reset_values     = true
  namespace        = "tempo"
  create_namespace = true

  values = [file("${path.module}/tempo-values.yaml")]
}

resource "kubectl_manifest" "jaeger-hotrod" {
  yaml_body = file("${path.module}/jaeger-hotrod.yaml")
}
