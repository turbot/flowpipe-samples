# Common descriptions
locals {
  access_token_param_description     = "The GitHub personal access token to authenticate to the GitHub APIs."
  repository_owner_param_description = "The organization or user name."
  repository_name_param_description  = "The name of the repository."
}

# Convenience variables
locals {
  repository_owner = split("/", var.repository_full_name)[0]
  repository_name  = split("/", var.repository_full_name)[1]
}