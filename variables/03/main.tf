provider "azurerm" {
  features {}
  subscription_id="bf7e75db-e819-49ca-b6d2-69c32a2353fe"
}
 
locals {
  vm_size = "Standard_B1s"
  tags = {
    Name = "aaMyVirtualMachine35"
    Env  = "Dev"
  }
  name="AVM02"
}
 
resource "azurerm_resource_group" "main" {
  name     = "myResourceGroupani03"
  location = "West US"
}
 
resource "azurerm_virtual_network" "vnet" {
  name                = "myVnetani03"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}
 
resource "azurerm_subnet" "subnet" {
  name                 = "mySubnet1"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
 
resource "azurerm_network_interface" "nic" {
  name                = "myNICani"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
 
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
 
  tags = {
    Name = "My NIC"
  }
}
 
resource "azurerm_linux_virtual_machine" "myvm" {
  name                = local.name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = local.vm_size
  admin_username      = "azureuserani"
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]
  admin_password = "P@ssword1234!"
  disable_password_authentication=false
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "myOsDisk"
  }
 
 source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
 
  tags = local.tags
}