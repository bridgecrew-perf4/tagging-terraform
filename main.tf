provider "azurerm" {
  features {}
}

terraform {
  required_version = ">= 0.12" 
  backend "azurerm" {
    resource_group_name  = "rg-terraform-service"
    storage_account_name = "stbuildtfstate"
    container_name       = "resource-tag"
    key                  = "gitworkflow.tfstate"
  }
}
