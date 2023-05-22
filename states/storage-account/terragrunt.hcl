terraform {
  source = "../../modules/storageaccount"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  env            = "dev"
  location       = "WestEurope"
  resourcegroups = yamldecode(file("env-dev.yml"))
}

locals {
}
