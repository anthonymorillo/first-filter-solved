module "azure-dns-zone" {
  source = "../dns"
  domain_name         = var.domain_name
  resource_group_name = var.resource_group_name
}

module "azure-containter-registry" {
  source = "../acr"
  registry_name       = var.registry_name
  resource_group_name = var.resource_group_name
  location            = var.location
  registry_sku_tier   = var.registry_sku_tier
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  sku_tier            = var.cluster_sku_tier

  default_node_pool {
    name       = var.node_pool_name
    node_count = var.node_count
    vm_size    = var.node_pool_vmsize
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "ra_aks" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = module.azure-containter-registry.registry_id
  skip_service_principal_aad_check = true
}