provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "monitoring" {
  name     = "rg-monitoring"
  location = "South Central US"
}

resource "azurerm_kubernetes_cluster" "monitoring" {
  name                = "aks-monitoring"
  location            = azurerm_resource_group.monitoring.location
  resource_group_name = azurerm_resource_group.monitoring.name
  dns_prefix          = "aksecoshare"
  default_node_pool {
    name       = "npsysdefault"
    node_count = 1
    vm_size    = "Standard_B2s_v2"
    upgrade_settings {
      drain_timeout_in_minutes      = 0
      max_surge                     = "10%"
      node_soak_duration_in_minutes = 0
    }
  }
  identity {
    type = "SystemAssigned"
  }
  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count,
    ]
  }
}


data "azurerm_kubernetes_cluster" "monitoring" {
  name                = azurerm_kubernetes_cluster.monitoring.name
  resource_group_name = azurerm_kubernetes_cluster.monitoring.resource_group_name
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.monitoring.kube_config[0].host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.monitoring.kube_config[0].client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.monitoring.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.monitoring.kube_config[0].cluster_ca_certificate)
}
