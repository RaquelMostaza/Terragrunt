data "azurerm_client_config" "current" {}

data "http" "ip" {
  url = "https://ifconfig.me"
}

locals {
  safe_prefix  = replace(var.prefix, "-", "")
  safe_postfix = replace(var.postfix, "-", "")
}

data "azurerm_storage_account" "st" {
  name                     = "st${local.safe_prefix}${local.safe_postfix}${var.env}"
  resource_group_name      = var.rg_name
}
data "azurerm_resource_group" "rg" {
  name     = var.rg_name
}

data "azurerm_virtual_network" "vnet_default" {
  name                = var.vnet_name
  resource_group_name = var.vnet_rg
}

# Subnets
data "azurerm_subnet" "snet_default" {
  name                                           = var.subnet_name
  resource_group_name                            = var.vnet_rg
  virtual_network_name                           = data.azurerm_virtual_network.vnet_default.name
}

/*
resource "azurerm_storage_account_network_rules" "firewall_rules" {
  storage_account_id = data.azurerm_storage_account.st.id
  default_action             = "Deny"
}*/

# Virtual Network & Firewall configuration
resource "azurerm_storage_account_network_rules" "firewall_rules" {
  storage_account_id = data.azurerm_storage_account.st.id

  default_action             = "Deny"
  ip_rules                   = var.ip_ranges #[data.http.ip.body] # [data.http.ip.body]
  #Removal of vnets as a fix for online endpoints
  #virtual_network_subnet_ids = [data.azurerm_subnet.snet_default.id]
  bypass                     = ["AzureServices","Logging","Metrics"]
  #dynamic "private_link_access" {
  #  for_each = var.private_link_access
  #  content {
  #    endpoint_resource_id = private_link_access.value
  #  }
  #}
}

# DNS Zones
resource "azurerm_private_dns_zone" "st_zone_blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.rg_name

  count = var.enable_aml_secure_workspace ? 1 : 0
}

resource "azurerm_private_dns_zone" "st_zone_file" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = var.rg_name

  count = var.enable_aml_secure_workspace ? 1 : 0
}

resource "azurerm_private_dns_zone" "st_zone_web" {
  name                = "privatelink.web.core.windows.net"
  resource_group_name = var.rg_name

  count = var.enable_aml_secure_workspace ? 1 : 0
}

# Linking of DNS zones to Virtual Network

resource "azurerm_private_dns_zone_virtual_network_link" "st_zone_link_blob" {
  name                  = "${var.prefix}${var.postfix}_link_st_blob"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.st_zone_blob[0].name
  virtual_network_id    = data.azurerm_virtual_network.vnet_default.id

  count = var.enable_aml_secure_workspace ? 1 : 0
}

resource "azurerm_private_dns_zone_virtual_network_link" "st_zone_link_file" {
  name                  = "${var.prefix}${var.postfix}_link_st_file"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.st_zone_file[0].name
  virtual_network_id    = data.azurerm_virtual_network.vnet_default.id

  count = var.enable_aml_secure_workspace ? 1 : 0
}

resource "azurerm_private_dns_zone_virtual_network_link" "st_zone_link_web" {
  name                  = "${var.prefix}${var.postfix}_link_st_web"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.st_zone_web[0].name
  virtual_network_id    = data.azurerm_virtual_network.vnet_default.id

  count = var.enable_aml_secure_workspace ? 1 : 0
}

# Private Endpoint configuration

resource "azurerm_private_endpoint" "st_pe_blob" {
  name                = "pe-${data.azurerm_storage_account.st.name}-blob"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = data.azurerm_subnet.snet_default.id

  private_service_connection {
    name                           = "psc-blob-${var.prefix}-${var.postfix}${var.env}"
    private_connection_resource_id = data.azurerm_storage_account.st.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group-blob"
    private_dns_zone_ids = [azurerm_private_dns_zone.st_zone_blob[0].id]
  }

  count = var.enable_aml_secure_workspace ? 1 : 0

  tags = var.tags
}

resource "azurerm_private_endpoint" "st_pe_file" {
  name                = "pe-${data.azurerm_storage_account.st.name}-file"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = data.azurerm_subnet.snet_default.id

  private_service_connection {
    name                           = "psc-file-${var.prefix}-${var.postfix}${var.env}"
    private_connection_resource_id = data.azurerm_storage_account.st.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group-file"
    private_dns_zone_ids = [azurerm_private_dns_zone.st_zone_file[0].id]
  }

  count = var.enable_aml_secure_workspace ? 1 : 0

  tags = var.tags
}

resource "azurerm_private_endpoint" "st_pe_web" {
  name                = "pe-${data.azurerm_storage_account.st.name}-web"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = data.azurerm_subnet.snet_default.id

  private_service_connection {
    name                           = "psc-web-${var.prefix}-${var.postfix}${var.env}"
    private_connection_resource_id = data.azurerm_storage_account.st.id
    subresource_names              = ["web"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group-web"
    private_dns_zone_ids = [azurerm_private_dns_zone.st_zone_web[0].id]
  }

  count = var.enable_aml_secure_workspace ? 1 : 0

  tags = var.tags
}
