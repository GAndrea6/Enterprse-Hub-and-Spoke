terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group principale
resource "azurerm_resource_group" "rg" {
  name     = "rg-hubspoke-v2"
  location = var.location
  tags     = var.tags
}