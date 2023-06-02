locals {
  global_vars     = read_terragrunt_config(find_in_parent_folders("global-vars.hcl"))
  env_vars        = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
  module_version  = local.env_vars.locals.module_version
  resource_tags   = { "Environment" = "${local.env_vars.locals.env}", "Name" = "${local.env_vars.locals.prefix}" }
  tags            = merge(local.global_vars.locals.tags, local.resource_tags)
  source_base_url = "${local.global_vars.locals.source_base_url}storage-account"
}

dependencies {
  paths = ["${get_terragrunt_dir()}//../networking","${get_terragrunt_dir()}//../container-registry"]
}

dependency "containerregistry" {
  config_path = "${get_terragrunt_dir()}//../container-registry"
  mock_outputs = {
    id = "/subscriptions/e685500d-fd78-44fb-838b-XXXXXX/resourceGroups/XXXXXXX/providers/Microsoft.ContainerRegistry/registries/name"
  }
}

inputs = {
  st_name     = local.env_vars.locals.storage_account
  rg_name     = local.env_vars.locals.resource_group
  location    = local.env_vars.locals.location
  tags        = local.tags
  prefix      = local.env_vars.locals.prefix
  postfix     = local.env_vars.locals.postfix
  env         = local.env_vars.locals.env
  hns_enabled = false
  ip_ranges = local.global_vars.locals.allowedIpCidr
  enable_aml_secure_workspace   = local.env_vars.locals.enable_aml_secure_workspace
  vnet_name =  local.env_vars.locals.vnet_name
  vnet_rg =  local.env_vars.locals.vnet_rg
  subnet_name =  local.env_vars.locals.subnet_name
  private_link_access = [ dependency.containerregistry.outputs.id]
}
