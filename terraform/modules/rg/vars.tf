variable "resource_group_name" {
  type = string
  description = "(Required) The Name which should be used for this Resource Group."
}

variable "location" {
  type = string
  description = "(Required) The Azure Region where the Resource Group will exist."
}

variable "aks_list" {
  type = list(object({
    cluster_name = string
    dns_prefix = string
    cluster_sku_tier = string
    node_pool_name = string
    node_count = number
    node_pool_vmsize = string
    registry_name = string
    registry_sku_tier = string
    domain_name = string
    }))
}