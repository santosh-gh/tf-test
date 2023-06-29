# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Create a Virtual Network
module "vnet1" {
  source                       = "./modules/virtual_network"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = var.location
  vnet_name                    = var.vnet1_name
  address_space                = var.vnet1_address_space
  tags                         = var.tags

  subnets = [
    {
      name : "subnet1"
      address_prefixes : var.subnet1_address_prefix
    },
    {
      name : "subnet2"
      address_prefixes : var.subnet2_address_prefix
    }
  ]
}

# Create a Virtual Machine
module "virtual_machine" {
  source                              = "./modules/virtual_machine"
  name                                = var.vm_name
  size                                = var.vm_size
  location                            = var.location
  public_ip                           = var.vm_public_ip

  vm_user                             = var.admin_username
  vm_password                         = var.admin_password
  #admin_ssh_public_key                = var.ssh_public_key

  os_disk_image                       = var.vm_os_disk_image
  domain_name_label                   = var.domain_name_label
  resource_group_name                 = azurerm_resource_group.rg.name
  subnet_id                           = module.vnet1.subnet_ids["subnet1"]
  os_disk_storage_account_type        = var.vm_os_disk_storage_account_type
  # boot_diagnostics_storage_account    = module.storage_account.primary_blob_endpoint
  # log_analytics_workspace_id          = module.log_analytics_workspace.workspace_id
  # log_analytics_workspace_key         = module.log_analytics_workspace.primary_shared_key
  # log_analytics_workspace_resource_id = module.log_analytics_workspace.id
  # log_analytics_retention_days        = var.log_analytics_retention_days
  # script_storage_account_name         = var.script_storage_account_name
  # script_storage_account_key          = var.script_storage_account_key
  # container_name                      = var.container_name
  # script_name                         = var.script_name
}
