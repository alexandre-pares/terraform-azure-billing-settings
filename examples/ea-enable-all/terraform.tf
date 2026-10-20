terraform {
  required_version = "~> 1.16"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.13"
    }
  }
}

provider "azapi" {
}
