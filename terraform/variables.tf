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

variable "hub_vnet_name" {
  description = "Specifies the name of the hub virtual virtual network"
  default     = "HubVNet"
  type        = string
}

variable "hub_address_space" {
  description = "Specifies the address space of the hub virtual virtual network"
  default     = ["10.1.0.0/16"]
  type        = list(string)
}

variable "hub_firewall_subnet_address_prefix" {
  description = "Specifies the address prefix of the firewall subnet"
  default     = ["10.1.0.0/24"]
  type        = list(string)
}

variable "hub_bastion_subnet_address_prefix" {
  description = "Specifies the address prefix of the firewall subnet"
  default     = ["10.1.1.0/24"]
  type        = list(string)
}