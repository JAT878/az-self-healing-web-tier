resource "azurerm_linux_virtual_machine_scale_set" "web" {
  name                = "vmss-${var.name_prefix}-web"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.vm_size
  instances           = var.instance_count
  zones               = var.zones
  zone_balance        = true

  admin_username                  = var.admin_username
  disable_password_authentication = true
  computer_name_prefix            = "web"

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_public_key
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "nic-${var.name_prefix}-web"
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = var.subnet_id
      load_balancer_backend_address_pool_ids = var.backend_address_pool_ids
    }
  }

  custom_data = base64encode(templatefile("${path.module}/cloud-init.yaml.tftpl", {
    project_name    = var.project_name
    environment     = var.environment
    container_image = var.container_image
  }))

  upgrade_mode    = "Automatic"
  health_probe_id = var.health_probe_id

  automatic_instance_repair {
    enabled      = true
    grace_period = "PT10M"
  }

  tags = var.tags
}

resource "azurerm_monitor_autoscale_setting" "web" {
  name                = "as-${var.name_prefix}-web"
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.web.id
  enabled             = true

  profile {
    name = "default"

    capacity {
      default = var.instance_count
      minimum = var.instance_count
      maximum = var.instance_count + 1
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.web.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.web.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
  }

  tags = var.tags
}
