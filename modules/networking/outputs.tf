output "vnet_id" {
  value = azurerm_virtual_network.this.id
}

output "subnet_id" {
  value = azurerm_subnet.web.id
}

output "network_security_group_id" {
  value = azurerm_network_security_group.web.id
}
