# tf-test

terraform -chdir=terraform/modules/virtual_network plan


# terraform backend
    az login

    $location="southindia"
    $resourceGroupName="tf-rg"
    $storageAccountName="tfstatestg11"
    $containerName="tfstate"    
    $sku="Standard_LRS"

    az group create --name $resourceGroupName --location $location 

    az storage account create --resource-group $resourceGroupName --name $storageAccountName --sku $sku --encryption-services blob

    $storageAccountKey=$(az storage account keys list --resource-group $resourceGroupName --account-name $storageAccountName --query [0].value -o tsv)
    echo $storageAccountKey

    az storage container create --name $containerName --account-name $storageAccountName --account-key $storageAccountKey 
#
# CLI Login
    $ az login

    $ az account show
    $ az account list

    $ az account set --subscription="SUBSCRIPTION_ID"

    # Service Principal
    $ az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/SUBSCRIPTION_ID"
    $ az ad sp create-for-rbac --name <SP_TEST> --role contributor --scopes /subscriptions/<SUBSCRIPTION_ID>

    # Use Bash to set Environment Variables
    $ export ARM_CLIENT_ID="appId"
    $ export ARM_CLIENT_SECRET="password"
    $ export ARM_SUBSCRIPTION_ID="subscriptionId"
    $ export ARM_TENANT_ID="tenant"

# PowerShell
    $env:ARM_TENANT_ID = "tenantId"
    $env:ARM_SUBSCRIPTION_ID = "subscriptionId"
    $env:ARM_CLIENT_ID = "appId"
    $env:ARM_CLIENT_SECRET = "password"

# main.tf

# Specify the Azure provider and version
    provider "azurerm" {
        features {}
    }

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

# Create a resource group
    resource "azurerm_resource_group" "rg" {
        name     = "example-resource-group"
        location = "West US"
    }

# Create a virtual network
    resource "azurerm_virtual_network" "example" {
        name                = "example-vnet"
        address_space       = ["10.0.0.0/16"]
        location            = azurerm_resource_group.example.location
        resource_group_name = azurerm_resource_group.example.name
    }

# Create a subnet within the virtual network
    resource "azurerm_subnet" "example" {
        name                 = "example-subnet"
        resource_group_name  = azurerm_resource_group.example.name
        virtual_network_name = azurerm_virtual_network.example.name
        address_prefixes     = ["10.0.1.0/24"]
    }