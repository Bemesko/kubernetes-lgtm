provider "azurerm" {
  features {}
}

provider "helm" {
  kubernetes {
    config_context         = azurerm_kubernetes_cluster.monitoring.name
    config_path            = "~/.kube/config"
    host                   = data.azurerm_kubernetes_cluster.monitoring.kube_config[0].host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.monitoring.kube_config[0].client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.monitoring.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.monitoring.kube_config[0].cluster_ca_certificate)
  }
}

provider "kubectl" {
  config_context         = azurerm_kubernetes_cluster.monitoring.name
  config_path            = "~/.kube/config"
  host                   = data.azurerm_kubernetes_cluster.monitoring.kube_config[0].host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.monitoring.kube_config[0].client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.monitoring.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.monitoring.kube_config[0].cluster_ca_certificate)
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.monitoring.kube_config[0].host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.monitoring.kube_config[0].client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.monitoring.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.monitoring.kube_config[0].cluster_ca_certificate)
  config_context         = azurerm_kubernetes_cluster.monitoring.name
  config_path            = "~/.kube/config"
}
