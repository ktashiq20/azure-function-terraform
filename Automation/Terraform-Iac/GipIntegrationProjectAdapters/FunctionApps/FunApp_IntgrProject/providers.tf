terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.116"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  # Left empty on purpose: the GitHub workflow passes storage_account_name,
  # container_name, key and access_key via -backend-config at init time.
  backend "azurerm" {}
}

# Authentication comes from the `azure/login` step (Azure CLI session).
provider "azurerm" {
  features {}
}
