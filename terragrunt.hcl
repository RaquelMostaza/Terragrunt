
remote_state {
  backend = "azurerm"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite" # Always overrides the file if one exists
  }
  config = {
    #https://www.terraform.io/language/settings/backends/azurerm
    #tenant_id           - set via ARM_ env variables
    #subscription_id     - set via ARM_ env variables
    #snapshot            - set via ARM_ env variables
    resource_group_name  = "sdadcdd"
    storage_account_name = "terraformsa128"
    container_name       = "tfstate"
    key                  = "${path_relative_to_include()}/terraform.tfstate"
    use_microsoft_graph  = true
  }
}

inputs = {
  global_tags = merge({Terraform = "true"}, {env = "dev"}, {location = "WestEurope"})
}

locals {
}
