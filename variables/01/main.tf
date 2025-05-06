resource "azurerm_resource_group" "example" {
  name     = "murg${var.name}"
  location = "West Europe"
}
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.27.0"
    }
  }
}
 
provider "azurerm" {
  # Configuration options
features{}
subscription_id="bf7e75db-e819-49ca-b6d2-69c32a2353fe"
}

output "name"{
  value=azurerm_resource_group.example.name
}
