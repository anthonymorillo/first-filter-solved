output "registry_id" {
  value = azurerm_container_registry.acr.id
  sensitive = true
}