variable "server_config" {

 description = "Configuration for the Azure Virtual Machines"

 type = map(object({

  os_type = string # Added os_type for Azure

  publisher = string

  offer = string

  sku = string

  vm_size = string

 }))

 default = {

  "web-server-a" = {

   os_type = "Ubuntu"

   publisher = "Canonical"

   offer = "UbuntuServer"

   sku = "18.04-LTS"

   vm_size = "Standard_DS1_v2"

  },

  "app-server-b" = {

   os_type = "Windows" # Added a different OS type for demonstration

   publisher = "MicrosoftWindowsServer"

   offer = "WindowsServer"

   sku = "2019-Datacenter"

   vm_size = "Standard_DS2_v2"

  },

 }

}

variable "resource_group_name" {

 description = "Name of the resource group"

 type = string

 default = "myResourceGroup"

}

variable "location" {

 description = "Location for the resources"

 type = string

 default = "WestUS"

}

# Create resource group

resource "azurerm_resource_group" "rg" {

 name = var.resource_group_name

 location = var.location

}

# Create virtual network and subnet

resource "azurerm_virtual_network" "vnet" {

 name = "myVNet"

 address_space = ["10.0.0.0/16"]

 location = var.location

 resource_group_name = azurerm_resource_group.rg.name

}

resource "azurerm_subnet" "subnet" {

 name = "mySubnet"

 resource_group_name = azurerm_resource_group.rg.name

 virtual_network_name = azurerm_virtual_network.vnet.name

 address_prefixes = ["10.0.0.0/24"]

}

# Create public IP addresses for the VMs

resource "azurerm_public_ip" "public_ip" {

 for_each = var.server_config

 name = "${each.key}-public-ip"

 location = var.location

 resource_group_name = azurerm_resource_group.rg.name

 allocation_method = "Dynamic" # Or "Static"

}

# Create network interfaces for the VMs

resource "azurerm_network_interface" "nic" {

 for_each = var.server_config

 name = "${each.key}-nic"

 location = var.location

 resource_group_name = azurerm_resource_group.rg.name

 ip_configuration {

  name = "internal"

  subnet_id = azurerm_subnet.subnet.id

  private_ip_address_allocation = "Dynamic"

  public_ip_address_id = azurerm_public_ip.public_ip[each.key].id # Associate Public IP

 }

}

# Create the virtual machines

resource "azurerm_virtual_machine" "vm" {

 for_each = var.server_config

 name = each.key

 location = var.location

 resource_group_name = azurerm_resource_group.rg.name

 vm_size = each.value.vm_size

 network_interface_ids = [azurerm_network_interface.nic[each.key].id]

 admin_username = "myadmin" # Change this!

 admin_password = "Password1234!" # Hardcoded password, NOT RECOMMENDED FOR PRODUCTION

 storage_os_disk {

  name = "${each.key}-osdisk"

  caching = "ReadWrite"

  create_option = "FromImage"

  managed_disk_type = "Standard_LRS" # Or "Premium_LRS", "UltraSSD_LRS"

 }

 source_image_reference {

  publisher = each.value.publisher

  offer = each.value.offer

  sku = each.value.sku

 }

}
