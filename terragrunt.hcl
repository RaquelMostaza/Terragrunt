
remote_state {
  backend = "azurerm"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite" # Always overrides the file if one exists
  }
  config = {
    resource_group_name  = "BMW-Terrsfotm-State"
    storage_account_name = "cdhterraform"
    container_name       = "cdhstatetg"
    key                  = "${path_relative_to_include()}/terraform.tfstate"
  }
}

inputs = {
  global_tags = merge({Terraform = "true"}, {env = "dev"}, {location = "WestEurope"})
}

locals {
}
