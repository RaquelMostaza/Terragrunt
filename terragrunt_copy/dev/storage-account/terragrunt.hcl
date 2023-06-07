terraform {
  source = "${get_repo_root()}/infrastructure//modules//storageaccount"

  # extra_arguments "plan_args" {
  #   commands = ["plan"]
  #   arguments = concat(
  #     [
  #       "-lock=false" # do not lock on plan - useful in CI to use plan to validate code
  #     ],
  #   )
  # }
}

# terraform {
#   source = "${include.env.locals.source_base_url}?ref=${include.env.locals.module_version}"
# }

