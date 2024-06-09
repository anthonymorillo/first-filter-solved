resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

module "azure-kubernetes-service" {
  source              = "../aks"
  for_each            = {for aks in var.aks_list : aks.cluster_name => aks}
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  cluster_name        = each.value.cluster_name
  dns_prefix          = each.value.dns_prefix
  cluster_sku_tier    = each.value.cluster_sku_tier
  node_pool_name      = each.value.node_pool_name
  node_count          = each.value.node_count
  node_pool_vmsize    = each.value.node_pool_vmsize
  registry_name       = each.value.registry_name
  registry_sku_tier   = each.value.registry_sku_tier
  domain_name         = each.value.domain_name
}