# Company
variable "company" { 
  description = "This variable defines the name of the company"
  type = string
  default = "new"
}
# Environment
variable "environment" { 
  description = "This variable defines the environment to be built"
  type = string
  default = "dev"
}
# Azure region
variable "location" {
  type = string
  description = "Azure region where resources will be created"
  default = "southindia"
}

variable "resource_group_name" {
  description = "Specifies the resource group name"
  default     = "tf-rg"
  type        = string
}

variable "tags" {
  description = "(Optional) Specifies tags for all the resources"
  default     = {
    createdWith = "Test"
  }
}