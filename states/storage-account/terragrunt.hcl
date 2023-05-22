terraform {
  source = "../..//modules/storageaccount"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  env            = "${get_env("TF_VAR_env")}"
  location       = "${get_env("TF_VAR_location")}"
  resourcegroups = yamldecode(file("env-${get_env("TF_VAR_env")}.yml"))
}

locals {
}
