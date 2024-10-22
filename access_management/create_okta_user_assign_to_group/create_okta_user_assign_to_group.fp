pipeline "create_okta_user_assign_to_group" {
  title       = "Create User Assign Group"
  description = "Create a user and assign it to a group."

  param "conn" {
    type        = connection.okta
    description = "Name of Okta connection to use. If not provided, the default Okta connection will be used."
    default     = connection.okta.default
  }

  param "first_name" {
    description = "Given name of the user."
    type        = string
  }

  param "last_name" {
    description = "The family name of the user."
    type        = string
  }

  param "email" {
    description = "The primary email address of the user."
    type        = string
  }

  param "login" {
    description = "The unique identifier for the user."
    type        = string
  }

  param "password" {
    description = "Specifies the password for a user."
    type        = string
  }

  param "group_id" {
    description = "The ID of the group."
    type        = string
  }

  step "pipeline" "create_user" {
    pipeline = okta.pipeline.create_user
    args = {
      conn       = param.conn
      first_name = param.first_name
      last_name  = param.last_name
      email      = param.email
      login      = param.login
      password   = param.password
    }
  }

  step "pipeline" "assign_user" {
    pipeline = okta.pipeline.assign_user
    args = {
      conn     = param.conn
      group_id = param.group_id
      user_id  = step.pipeline.create_user.output.user.id
    }
  }

  step "pipeline" "list_member_users" {
    depends_on = [step.pipeline.assign_user]

    pipeline = okta.pipeline.list_member_users
    args = {
      conn     = param.conn
      group_id = param.group_id
    }
  }

  output "user" {
    description = "User details."
    value       = step.pipeline.create_user.output
  }

  output "group_members" {
    description = "List of users that are members of the group."
    value       = step.pipeline.list_member_users.output
  }
}
