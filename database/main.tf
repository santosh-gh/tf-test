terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "my-resource-group"
  location = "southindia"
}

resource "azurerm_sql_server" "example" {
  name                         = "my-sql-server001"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  version                      = "12.0"
  administrator_login          = "myadmin"
  administrator_login_password = "P@ssw0rd1234!"
}

resource "azurerm_sql_database" "example" {
  name                = "my-database"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  server_name         = azurerm_sql_server.example.name
  edition             = "Basic"
  collation           = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb         = 1
}

output "server_fully_qualified_domain_name" {
  value = azurerm_sql_server.example.fully_qualified_domain_name
}

output "database_id" {
  value = azurerm_sql_database.example.id
}
