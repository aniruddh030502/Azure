provider "azurerm" {
  features {}
}
 
locals {
  vm_size = "Standard_B1s"
  tags = {
    Name = "My Virtual Machine"
    Env  = "Dev"
  }
}
 
resource "azurerm_resource_group" "main" {
  name     = "myResourceGroupani"
  location = "West US"
}
 
resource "azurerm_virtual_network" "vnet" {
  name                = "myVnetani"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}
 
resource "azurerm_subnet" "subnet" {
  name                 = "mySubnet"
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
  name                = "myVM-${random_id.vm_id.hex}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = local.vm_size
  admin_username      = "azureuser"
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
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }
 
  tags = local.tags
  lifecycle{
      create_before_destroy=true
  }
}

resource "random_id" "vm_id" {
  byte_length = 4  # 4 bytes = 8 hex characters
}
