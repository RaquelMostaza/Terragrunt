## Create SA and container that will store the glossary exports
resource "azurerm_storage_account" "example23" {
  name                     = "fsldadfl"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
