terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.57.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = "rg_acc"
}
