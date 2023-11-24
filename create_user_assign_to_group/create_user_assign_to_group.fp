pipeline "create_user_assign_to_group" {
  title       = "Create User Assign Group"
  description = "Create a user and assign it to a group."

  param "api_token" {
    description = "The personal api_token to authenticate to the Okta APIs."
    type        = string
    default     = var.api_token
  }

  param "domain" {
    description = "The domain of your Okta account."
    type        = string
    default     = var.okta_domain
  }

  param "group_id" {
    description = "The ID of the group."
    type        = string
    default     = var.group_id
  }

  param "first_name" {
    description = "Given name of the user."
    type        = string
    default     = var.first_name
  }

  param "last_name" {
    description = "The family name of the user."
    type        = string
    default     = var.last_name
  }

  param "email" {
    description = "The primary email address of the user."
    type        = string
    default     = var.email
  }

  param "login" {
    description = "The unique identifier for the user."
    type        = string
    default     = var.login
  }

  param "password" {
    description = "Specifies the password for a user."
    type        = string
    default     = var.password
  }

  step "pipeline" "create_user" {
    pipeline = pipeline.create_user
    args = {
      first_name = param.first_name
      last_name  = param.last_name
      email      = param.email
      login      = param.login
      password   = param.password
    }
  }

  step "pipeline" "assign_user" {
    pipeline = pipeline.assign_user
    args = {
      group_id = param.group_id
      user_id  = jsondecode(step.pipeline.create_user.user).id
    }
  }

  output "user" {
    value       = step.pipeline.create_user.response_body
    description = "User details."
  }

  output "assignment" {
    value       = step.pipeline.assign_user.response_body
    description = "Group assignment details for a user."
  }
}