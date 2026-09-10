terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-prod"
    storage_account_name = "sttfstate83415"
    container_name       = "tfstate"
    key                  = "hubspoke.terraform.tfstate"
  }
}