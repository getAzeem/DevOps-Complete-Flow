resource "azurerm_resource_group" "main" {
  name     = "${var.project_name}-${local.environment}-rg"
  location = var.location

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${local.environment}-rg"
  })
}

module "network" {
  source              = "../../modules/vnet"
  px                  = var.project_name
  env                 = local.environment
  region              = var.location
  rg                  = azurerm_resource_group.main.name
  tags                = local.common_tags
  net_space           = var.address_space
  priv_subnet         = var.private_subnet_cidr
  pub_subnet          = var.public_subnet_cidr
}

module "compute" {
  source              = "../../modules/vm"
  px                  = var.project_name
  env                 = local.environment
  region              = var.location
  rg                  = azurerm_resource_group.main.name
  tags                = local.common_tags
  replica_count       = local.vm_count
  inst_size           = local.vm_size
  admin_user          = local.admin_username
  ssh_key             = local.ssh_key
  net_subnet_id       = module.network.private_subnet_id
}

module "gateway" {
  source              = "../../modules/app-gateway"
  px                  = var.project_name
  env                 = local.environment
  region              = var.location
  rg                  = azurerm_resource_group.main.name
  tags                = local.common_tags
  gw_subnet_id        = module.network.public_subnet_id
  backend_list        = module.compute.vm_private_ips
}

module "bastion" {
  source              = "../../modules/jumpbox"
  px                  = var.project_name
  env                 = local.environment
  region              = var.location
  rg                  = azurerm_resource_group.main.name
  tags                = local.common_tags
  jumpbox_subnet_id   = module.network.public_subnet_id
  jumpbox_size        = local.bastion_vm_size
  admin_user          = local.admin_username
  ssh_key             = local.ssh_key
  ssh_allow_cidr      = var.allowed_ssh_cidr
}
