output "vmss_id" {
  value = azurerm_linux_virtual_machine_scale_set.web.id
}

output "vmss_name" {
  value = azurerm_linux_virtual_machine_scale_set.web.name
}
