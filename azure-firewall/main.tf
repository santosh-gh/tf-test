provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg_firewall"
  location = "southindia"
}

# generate a random prefix
resource "random_string" "new" {
  length  = 16
  special = false
  upper   = false
  numeric  = false
}

# Storage account to hold diag data from VMs and Azure Resources
resource "azurerm_storage_account" "sa" {
  name                     = random_string.new.result
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "dev"
    costcenter  = "IT"
  }
}

# Virtual network for azure firewall and servers
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["168.63.129.16", "8.8.8.8"]

  tags = {
    environment = "dev"
    costcenter  = "IT"
  }
}

# Subnet for Jumpbox, Servers, and Firewall and Route Table Association
resource "azurerm_subnet" "sn_jumpbox" {
  name                 = "JumpboxSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "sn_firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "sn_server" {
  name                 = "ServersSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Public IP for Azure Firewall
resource "azurerm_public_ip" "pip_fw" {
  name                = "ip_firewall"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    environment = "dev"
    costcenter  = "IT"
  }
}

# Azure Firewall
resource "azurerm_firewall" "fw" {
  name                = "firewall1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.sn_firewall.id
    public_ip_address_id = azurerm_public_ip.pip_fw.id
  }
}

# Azure Firewall Application Rule
resource "azurerm_firewall_application_rule_collection" "fw_rule" {
  name                = "appRc1"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = azurerm_resource_group.rg.name
  priority            = 101
  action              = "Allow"

  rule {
    name = "appRule1"

    source_addresses = [
      "10.0.0.0/24",
    ]

    target_fqdns = [
      "www.microsoft.com",
    ]

    protocol {
      port = "80"
      type = "Http"
    }
  }
}

# Azure Firewall Network Rule
resource "azurerm_firewall_network_rule_collection" "net_rule" {
  name                = "testcollection"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = azurerm_resource_group.rg.name
  priority            = 200
  action              = "Allow"

  rule {
    name = "netRc1"

    source_addresses = [
      "10.0.0.0/24",
    ]

    destination_ports = [
      "8000-8999",
    ]

    destination_addresses = [
      "*",
    ]

    protocols = [
      "TCP",
    ]
  }
}

# Public IP for Jumpbox
resource "azurerm_public_ip" "pip_jb" {
  name                = "ip-jumpbox"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"
  sku                 = "Basic"

  tags = {
    environment = "dev"
    costcenter  = "IT"
  }
}

# Nic for JumpBox Server
resource "azurerm_network_interface" "nic_jb" {
  name                = "nic-jumpbox"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.sn_jumpbox.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_jb.id
  }

  tags = {
    environment = "dev"
    costcenter  = "IT"
  }
}

# NSG for JumpBox Server
resource "azurerm_network_security_group" "nsg_jb" {
  name                = "nsg-jumpbox"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  security_rule {
    name                       = "RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "dev"
    costcenter  = "IT"
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic_jb.id
  network_security_group_id = azurerm_network_security_group.nsg_jb.id
}

# JumpBox VM
resource "azurerm_virtual_machine" "vm_jb" {
  name                  = "vm-jumpbox"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  network_interface_ids = ["${azurerm_network_interface.nic_jb.id}"]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2012-R2-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = "JumpBox-OSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "JumpBox"
    admin_username = var.adminUsername
    admin_password = var.adminPassword
  }
  os_profile_windows_config {}

  boot_diagnostics {
    enabled     = true
    storage_uri = azurerm_storage_account.sa.primary_blob_endpoint
  }


  tags = {
    environment = "dev"
    costcenter  = "IT"
  }

  depends_on = [azurerm_network_interface_security_group_association.nic_nsg]
}

# Nic for Server
resource "azurerm_network_interface" "nic_server" {
  name                = "nic-server"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.sn_server.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "dev"
    costcenter  = "IT"
  }
}

# Server VM
resource "azurerm_virtual_machine" "vm_server" {
  name                  = "vm_server"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  network_interface_ids = ["${azurerm_network_interface.nic_server.id}"]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2012-R2-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = "Server-OSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "Server"
    admin_username = var.adminUsername
    admin_password = var.adminPassword
  }
  os_profile_windows_config {}
  boot_diagnostics {
    enabled     = true
    storage_uri = azurerm_storage_account.sa.primary_blob_endpoint
  }


  tags = {
    environment = "dev"
    costcenter  = "IT"
  }
}

# Route Table for Azure Virtual Network and Server Subnet
resource "azurerm_route_table" "rt" {
  name                          = "route-table"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  disable_bgp_route_propagation = false

  route {
    name                   = "AzfwDefaultRoute"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.1.4"
  }

  tags = {
    environment = "dev"
    costcenter  = "IT"
  }
}

resource "azurerm_subnet_route_table_association" "rtassoc" {
  subnet_id      = azurerm_subnet.sn_server.id
  route_table_id = azurerm_route_table.rt.id
}


