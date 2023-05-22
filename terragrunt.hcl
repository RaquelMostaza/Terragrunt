
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
    resource_group_name  = "${get_env("TF_VAR_environment")}-coin-tf-rg"
    storage_account_name = "${get_env("TF_VAR_environment")}cointerraformsa"
    container_name       = "${get_env("TF_VAR_backend_container_name")}"
    key                  = "${path_relative_to_include()}/terraform.tfstate"
    use_microsoft_graph  = true
  }
}

inputs = {
  global_tags = merge({Terraform = "true"}, {env = "${get_env("TF_VAR_environment")}"}, {location = "${get_env("TF_VAR_location")}"})
}

locals {
}
