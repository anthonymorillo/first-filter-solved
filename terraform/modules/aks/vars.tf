variable "resource_group_name" {
  type = string
  description = "(Required) The Name which should be used for this Resource Group."
}

variable "domain_name" {
  type = string
  description = "(Required) The name of the DNS Zone. Must be a valid domain name. Changing this forces a new resource to be created."
}

variable "cluster_name" {
  type = string
  description = "(Required) The Name which should be used for this AKS Cluster."
}

variable "location" {
  type = string
  description = "(Required) The Azure Region where the Resource Group will exist."
}

variable "dns_prefix" {
  type = string
  description = "(Required) DNS name prefix to use with the hosted Kubernetes API server FQDN. You will use this to connect to the Kubernetes API when managing containers after creating the cluster."
}

variable "cluster_sku_tier" {
  type = string
  description = "(Required) The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free, Standard and Premium."
}

variable "node_pool_name" {
  type = string
  description = "(Required) The name of the Node Pool which should be created within the Kubernetes Cluster."
}

variable "node_count" {
  type = number
  description = "(Required) The initial number of nodes which should exist within this Node Pool."
}

variable "node_pool_vmsize" {
  type = string
  description = "(Required) The SKU which should be used for the Virtual Machines used in this Node Pool."
}

variable "registry_name" {
  type = string
  description = "(Required) Specifies the name of the Container Registry."
}

variable "registry_sku_tier" {
  type = string
  description = "(Required) The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free, Standard and Premium."
}