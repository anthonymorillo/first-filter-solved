variable "rglist" {
  type = list(object({
    resource_group_name = string
    location            = string
    aks_list            = list(object({
      cluster_name      = string
      dns_prefix        = string
      cluster_sku_tier  = string
      node_pool_name    = string
      node_count        = number
      node_pool_vmsize  = string
      registry_name     = string
      registry_sku_tier = string
      domain_name       = string
    }))
  }))
  default = [
    {
      resource_group_name = "rg-example-voting-app"
      location = "eastus2"
      aks_list = [{
          cluster_name = "aks-example-voting-app"
          dns_prefix = "example-voting-app"
          cluster_sku_tier = "Standard"
          node_pool_name = "agent"
          node_count = 1
          node_pool_vmsize = "Standard_D2s_v3"
          registry_name = "acrregistrovotingapp"
          registry_sku_tier = "Basic"
          domain_name = "cluster-demostracion.live"
        }
      ]
    }
  ]
}