variable "location" {
  description = "Specifies the location for the resource group and all the resources"
  default     = "southindia"
  type        = string
}

variable "resource_group_name" {
  description = "Specifies the resource group name"
  default     = "tf-test-rg"
  type        = string
}

variable "tags" {
  description = "(Optional) Specifies tags for all the resources"
  default     = {
    createdWith = "Test"
  }
}

# Log Analytics Worksace
variable "log_analytics_workspace_name" {
  description = "Specifies the name of the log analytics workspace"
  default     = "testWorkspace"
  type        = string
}

variable "log_analytics_retention_days" {
  description = "Specifies the number of days of the retention policy"
  type        = number
  default     = 7
}

variable "solution_plan_map" {
  description = "Specifies solutions to deploy to log analytics workspace"
  default     = {
    ContainerInsights= {
      product   = "OMSGallery/ContainerInsights"
      publisher = "Microsoft"
    }
  }
  type = map(any)
}

# Virtual Network
variable "vnet1_name" {
  description = "Specifies the name of the hub virtual virtual network"
  default     = "vnet1"
  type        = string
}

variable "vnet1_address_space" {
  description = "Specifies the address space of the hub virtual virtual network"
  default     = ["10.1.0.0/16"]
  type        = list(string)
}

variable "subnet1_address_prefix" {
  description = "Specifies the address prefix of the firewall subnet"
  default     = ["10.1.0.0/24"]
  type        = list(string)
}

variable "subnet2_address_prefix" {
  description = "Specifies the address prefix of the firewall subnet"
  default     = ["10.1.1.0/24"]
  type        = list(string)
}

# Virtual Machine
variable "vm_name" {
  description = "Specifies the name of the jumpbox virtual machine"
  default     = "TestVm"
  type        = string
}

variable "vm_public_ip" {
  description = "(Optional) Specifies whether create a public IP for the virtual machine"
  type = bool
  default = false
}

variable "vm_size" {
  description = "Specifies the size of the jumpbox virtual machine"
  default     = "Standard_DS1_v2"
  type        = string
}

variable "vm_os_disk_storage_account_type" {
  description = "Specifies the storage account type of the os disk of the jumpbox virtual machine"
  default     = "Standard_LRS"
  type        = string

  validation {
    condition = contains(["Premium_LRS", "Premium_ZRS", "StandardSSD_LRS", "StandardSSD_ZRS",  "Standard_LRS"], var.vm_os_disk_storage_account_type)
    error_message = "The storage account type of the OS disk is invalid."
  }
}

variable "vm_os_disk_image" {
  type        = map(string)
  description = "Specifies the os disk image of the virtual machine"
  default     = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS" 
    version   = "latest"
  }
}

variable "domain_name_label" {
  description = "Specifies the domain name for the jumbox virtual machine"
  default     = "babotestvm"
  type        = string
}

variable "admin_username" {
  description = "(Required) Specifies the admin username of the jumpbox virtual machine and AKS worker nodes."
  type        = string
  default     = "vmadmin"
}

variable "admin_password" {
  description = "(Required) Specifies the admin username of the jumpbox virtual machine and AKS worker nodes."
  type        = string
  default     = "Welcome@2022"
}

# variable "ssh_public_key" {
#   description = "(Required) Specifies the SSH public key for the jumpbox virtual machine and AKS worker nodes."
#   type        = string
#   default        = "xx"
# }


# Bastion Host
variable "bastion_host_name" {
  description = "(Optional) Specifies the name of the bastion host"
  default     = "BaboBastionHost"
  type        = string
}

# Storage
variable "storage_account_kind" {
  description = "(Optional) Specifies the account kind of the storage account"
  default     = "StorageV2"
  type        = string

   validation {
    condition = contains(["Storage", "StorageV2"], var.storage_account_kind)
    error_message = "The account kind of the storage account is invalid."
  }
}

variable "storage_account_tier" {
  description = "(Optional) Specifies the account tier of the storage account"
  default     = "Standard"
  type        = string

   validation {
    condition = contains(["Standard", "Premium"], var.storage_account_tier)
    error_message = "The account tier of the storage account is invalid."
  }
}

variable "storage_account_replication_type" {
  description = "(Optional) Specifies the replication type of the storage account"
  default     = "LRS"
  type        = string

  validation {
    condition = contains(["LRS", "ZRS", "GRS", "GZRS", "RA-GRS", "RA-GZRS"], var.storage_account_replication_type)
    error_message = "The replication type of the storage account is invalid."
  }
}