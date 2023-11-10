pipeline "add_user_to_multiple_services" {
  title = "Add User to Multiple Services"
  description = "Adds a user to multiple services."

  param "user_email" {
    type        = string
    description = "The email address of the user to create."
  }

  param "services" {
    type        = list(string)
    description = "The services to create the user on. Currently supported: github and okta."
  }

  param "okta_group_id" {
    description = "The ID of the Okta group to add the user to."
    type        = string
    default     = var.okta_default_group_id
  }

  step "pipeline" "add_user_to_github_organization" {
    if == contains(param.services, "github")
    pipeline = github.pipeline.create_organization_invitation
    args = {
      organization = var.github_organization
      email        = param.user_email
    }
  }

  step "pipeline" "add_user_to_okta_group" {
    if == contains(param.services, "okta")
    pipeline = okta.pipeline.create_user
    args = {
      group_id = param.okta_group_id
      user_id  = param.user_email
    }
  }

  // output "add_user_to_okta_group" {
  //   if == contains(param.services, "okta")
  //   value = step.pipeline.add_user_to_okta_group
  // }

  output "github_invitation" {
    if == contains(param.services, "github")
    value = step.pipeline.add_user_to_github_organization
  }

}
