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

variable "ssh_public_key" {
  description = "(Required) Specifies the SSH public key for the jumpbox virtual machine and AKS worker nodes."
  type        = string
  default        = "AAAAB3NzaC1yc2EAAAADAQABAAACAQDR8ZrgXQ/1MeAv5Fc/B5ldKJW6H4Rr0OI/5EfSvfvyIxsaTu8/yeHjNVmWSsTLAwuLaMdKL63gwz9tdynPuFPyH4POsouLkUHnLsKBo40JGXDRzTTZTKrRCktFqAv+9j9GTFLoOrViksfNzNGoEx2KBiWRst47RmUdOeENg6NmX7Kv/p/srM/rtUI0Ky0u2AGvcahnvc4b9ZIbyykZKc6Rs2kHIq7BQQi5g4rdL+/wwfrHqmvOgJFTOuwAWJqqwhpnwxPpV5yfBee4+JRO0Xikc0hvJ9Y/ozoExmvyZDPj/n6og69IjTAA2xD1QkYHfNzxcWu8pFyC3ZTMSyqsO2LGKXt07uJHc8boAxe9YaJt/XWT6Z4WnG4s7QG8u25j9ZnoNpWYQv18I0EXIAa6NVhwpwqBJVB8nMExi2trmrxoGTsZaq+z+cnRBx0rbzNrlbHuXMZSTu7hg5mFwORFs4ly7ReVnLUxYdGrFWfp+7ZszatPCYXuZewLno8FjsulGCQhtCtZP60oskABM3SPmxo1ZoZLE2BDRygnkYNL9d8x5dg+FTPrUgl9uVxEHKE5/p1eO2frug5uvuFNaMhWpkaIepX/htd90zapfgxxT86y1kLCSBPZG8wUD1CIBPlCVBqkJh29R85ImX4pgBg3bijuJYB4bmtaKjTpl8MOttvtBQ== home@DESKTOP-9B1KCVG"
}