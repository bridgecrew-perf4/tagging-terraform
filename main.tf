provider "azurerm" {
  version = "=2.0.0"
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-service"
    storage_account_name = "stbuildtfstate"
    container_name       = "resource-tag"
    key                  = "github.tfstate"
  }
}

resource "azurerm_resource_group" "rg-hello-azure" {
  name     = "rg-github-actions"
  location = "uksouth"
    tags = {
    application = var.app_name
    environment = var.environment
    market      = var.market
    }
}