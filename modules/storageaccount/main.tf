resource "azurerm_resource_group" "rg" {
  for_each = local.resourcegroups_map
  name     = each.value.resource_group_name
  location = var.location
  tags     = var.global_tags
}

resource "azurerm_storage_account" "storageaccount" {
  for_each                  = local.storageaccounts_map
  name                      = each.value.storage_account_name
  location                  = var.location
  resource_group_name       = each.value.resource_group_name
  account_tier              = each.value.sa.account_tier
  account_kind              = each.value.sa.account_kind
  account_replication_type  = each.value.sa.account_replication_type
  enable_https_traffic_only = each.value.sa.enable_https_traffic_only
  tags                      = var.global_tags
}
