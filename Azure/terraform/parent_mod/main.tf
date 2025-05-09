terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
 
}
 
provider "azurerm" {
  features {}
}

module "myvm"{
    source="./childmod"
    vm_count=1
    environment="dev"
    location="east us"
    ci1="10.0.0.0"
}