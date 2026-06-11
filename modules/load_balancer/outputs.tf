output "backend_address_pool_id" {
  value = azurerm_lb_backend_address_pool.web.id
}

output "probe_id" {
  value = azurerm_lb_probe.http.id
}

output "public_ip_address" {
  value = azurerm_public_ip.lb.ip_address
}

output "load_balancer_id" {
  value = azurerm_lb.this.id
}
