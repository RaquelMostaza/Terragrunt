provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

locals {
  resourcegroups_map = {
    for rg in var.resourcegroups : lower(rg.resource_group_name) => {
      resource_group_name = lower("${var.env}-${rg.resource_group_name}-rg") #final resource name
      rg                  = rg
      storageaccounts     = rg.storageaccounts
    }
  }

  storageaccounts_map = {
    for x in flatten([
      for k, v in local.resourcegroups_map : [
        for sa in v.storageaccounts : {
          resource_group_name  = v.resource_group_name
          storage_account_name = "${var.env}${sa.storage_account_name}" #final resource name
          rg                   = v.rg
          sa                   = sa
        }
      ]
    ]) : lower(x.sa.storage_account_name) => x
  }
}
