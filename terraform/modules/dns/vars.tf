variable "resource_group_name" {
  type = string
  description = "(Required) The Name which should be used for this Resource Group."
}

variable "domain_name" {
  type = string
  description = "(Required) The name of the DNS Zone. Must be a valid domain name. Changing this forces a new resource to be created."
}