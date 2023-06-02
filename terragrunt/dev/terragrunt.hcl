locals {
  env_type = "config-infra-dev.yml"

  #Variables used in remote state azure provider. These inputs are set on github workflow during execution e.g. terragrunt plan -var subcription_id=... 
  subscription_id = ""
  tenant_id = ""
  module_version    = yamldecode(file("../../${local.env_type}")).module_version
  # Existing resources
  storage_account = yamldecode(file("../../${local.env_type}")).storage_account
  resource_group = yamldecode(file("../../${local.env_type}")).resource_group
  amlws_name = yamldecode(file("../../${local.env_type}")).aml_workspace
  vnet_name = yamldecode(file("../../${local.env_type}")).vnet_name 
  vnet_rg =  yamldecode(file("../../${local.env_type}")).vnet_rg
  subnet_name = yamldecode(file("../../${local.env_type}")).subnet_name
  route_table_name = yamldecode(file("../../${local.env_type}")).route_table_name
  location = yamldecode(file("../../${local.env_type}")).location
  
  # User config
  enable_aml_computecluster = yamldecode(file("../../${local.env_type}")).enable_aml_computecluster
  enable_aml_secure_workspace = yamldecode(file("../../${local.env_type}")).enable_aml_secure_workspace
  enable_monitoring = yamldecode(file("../../${local.env_type}")).enable_monitoring
  prefix = yamldecode(file("../../${local.env_type}")).namespace
  postfix = yamldecode(file("../../${local.env_type}")).postfix
  env = yamldecode(file("../../${local.env_type}")).environment
  clusters = yamldecode(file("../../${local.env_type}")).clusters

  # DNS Zone API
  dns_zone_api_name = yamldecode(file("../../${local.env_type}")).dns_zone_api_name
  dns_zone_api_rg = yamldecode(file("../../${local.env_type}")).dns_zone_api_rg

  # DNS Zone notebook
  dns_zone_nb_name = yamldecode(file("../../${local.env_type}")).dns_zone_nb_name
  dns_zone_nb_rg = yamldecode(file("../../${local.env_type}")).dns_zone_nb_rg
}


remote_state {
  backend = "azurerm"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    resource_group_name  = "rg-${local.prefix}-${local.postfix}${local.env}"
    storage_account_name = "st${local.prefix}${local.postfix}${local.env}"          
    container_name       = "default"
    key                  = "${path_relative_to_include()}/terraform.tfstate"
  }
}


# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "azurerm" {
  features {}
  subscription_id = "${local.subscription_id}"
  tenant_id       = "${local.tenant_id}"
  #version = "3.26.0"   
}
EOF
}

