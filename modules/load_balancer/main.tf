resource "azurerm_public_ip" "lb" {
  name                = "pip-${var.name_prefix}-lb"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]

  tags = var.tags
}

resource "azurerm_lb" "this" {
  name                = "lb-${var.name_prefix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "frontend"
    public_ip_address_id = azurerm_public_ip.lb.id
  }

  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "web" {
  name            = "beap-${var.name_prefix}-web"
  loadbalancer_id = azurerm_lb.this.id
}

resource "azurerm_lb_probe" "http" {
  name                = "http-probe"
  loadbalancer_id     = azurerm_lb.this.id
  protocol            = "Http"
  port                = 80
  request_path        = "/"
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "http" {
  name                           = "http"
  loadbalancer_id                = azurerm_lb.this.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "frontend"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.web.id]
  probe_id                       = azurerm_lb_probe.http.id

  disable_outbound_snat = true
}

resource "azurerm_lb_outbound_rule" "web" {
  name                     = "outbound-web"
  loadbalancer_id          = azurerm_lb.this.id
  protocol                 = "All"
  backend_address_pool_id  = azurerm_lb_backend_address_pool.web.id
  allocated_outbound_ports = 1024
  idle_timeout_in_minutes  = 4

  frontend_ip_configuration {
    name = "frontend"
  }
}
