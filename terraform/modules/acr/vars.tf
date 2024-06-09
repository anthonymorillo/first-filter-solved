variable "resource_group_name" {
  type = string
  description = "(Required) The Name which should be used for this Resource Group."
}

variable "location" {
  type = string
  description = "(Required) The Azure Region where the Resource Group will exist."
}

variable "registry_name" {
  type = string
  description = "(Required) Specifies the name of the Container Registry."
}

variable "registry_sku_tier" {
  type = string
  description = "(Required) The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free, Standard and Premium."
}