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

