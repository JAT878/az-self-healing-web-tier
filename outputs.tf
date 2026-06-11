output "resource_group_name" {
  description = "Name of the resource group containing all resources."
  value       = azurerm_resource_group.this.name
}

output "web_url" {
  description = "URL of the load-balanced web tier."
  value       = "http://${module.load_balancer.public_ip_address}"
}

output "vmss_name" {
  description = "Name of the VM Scale Set backing the web tier."
  value       = module.compute.vmss_name
}
