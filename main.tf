resource "azurerm_resource_group" "this" {
  name     = "rg-${local.name_prefix}"
  location = var.location

  tags = local.tags
}

module "networking" {
  source = "./modules/networking"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  name_prefix         = local.name_prefix
  tags                = local.tags
}

module "load_balancer" {
  source = "./modules/load_balancer"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  name_prefix         = local.name_prefix
  tags                = local.tags
}

module "compute" {
  source = "./modules/compute"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  name_prefix         = local.name_prefix
  project_name        = var.project_name
  environment         = var.environment

  subnet_id                = module.networking.subnet_id
  backend_address_pool_ids = [module.load_balancer.backend_address_pool_id]
  health_probe_id          = module.load_balancer.probe_id

  vm_size              = var.vm_size
  instance_count       = var.instance_count
  admin_username       = var.admin_username
  admin_ssh_public_key = var.admin_ssh_public_key
  zones                = var.zones
  container_image      = var.container_image

  tags = local.tags
}
