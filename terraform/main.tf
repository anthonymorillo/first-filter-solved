module "resource-group" {
    source = "./modules/rg"
    for_each = {for rg in var.rglist : rg.resource_group_name => rg}
    resource_group_name = each.value.resource_group_name
    location = each.value.location
    aks_list = each.value.aks_list
}