output "vnet_id" {
  description = "The ID of the created VNet"
  value       = azurerm_virtual_network.this.id
}