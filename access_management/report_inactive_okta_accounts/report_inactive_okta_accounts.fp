trigger "schedule" "report_inactive_okta_accounts" {
  title       = "Report on Inactive Okta Accounts and Deactivate"
  description = "Runs daily at 9 AM UTC, this trigger scans inactive Okta accounts and deactivates them."
  schedule    = "0 9 * * *"
  pipeline    = pipeline.report_inactive_okta_accounts
}

pipeline "report_inactive_okta_accounts" {
  title       = "Report on Inactive Okta Accounts and Deactivate"
  description = "Routinely scan Okta environments for potential inactive accounts and deactivate accounts."

  tags = {
    recommended = "true"
  }

  param "jira_conn" {
    type        = connection.jira
    description = "Name for Jira connections to use. If not provided, the default connections will be used."
    default     = var.jira_conn
  }

  param "okta_conn" {
    type        = connection.okta
    description = "Name for Okta connections to use. If not provided, the default connections will be used."
    default     = var.okta_conn
  }

  param "inactive_hours" {
    type        = number
    description = "Number of hours of inactivity before an account is deactivated."
    default     = var.inactive_hours
  }

  # Jira Setup
  param "project_key" {
    type        = string
    description = "The key identifying the jira project."
    default     = var.project_key
  }

  param "issue_type" {
    type        = string
    description = "Issue type."
    default     = var.issue_type
  }

  # Get the current user
  step "pipeline" "get_current_okta_user" {
    pipeline = okta.pipeline.get_user
    args = {
      conn    = param.okta_conn
      user_id = "me"
    }
  }

  step "pipeline" "list_okta_users" {
    pipeline = okta.pipeline.list_users

    args = {
      conn = param.okta_conn
    }
  }

  # Deactivate inactive users
  step "pipeline" "deactivate_inactive_okta_users" {
    depends_on = [step.pipeline.list_okta_users, step.pipeline.get_current_okta_user]

    for_each = {
      for user in step.pipeline.list_okta_users.output.users : user.id => user
      if user.status == "ACTIVE" && (timecmp(coalesce(jsondecode(jsonencode(user.lastLogin)), jsondecode(jsonencode(user.created))), timeadd(timestamp(), "-${param.inactive_hours}h")) < 0) && step.pipeline.get_current_okta_user.output.user.id != user.id
    }

    pipeline = okta.pipeline.deactivate_user
    args = {
      conn    = param.okta_conn
      user_id = each.value.profile.email
    }
  }

  # Create an issue in Jira
  step "pipeline" "create_jira_issue" {
    depends_on = [step.pipeline.deactivate_inactive_okta_users]

    for_each = {
      for user in step.pipeline.list_okta_users.output.users : user.id => user
      if user.status == "ACTIVE" && (timecmp(coalesce(jsondecode(jsonencode(user.lastLogin)), jsondecode(jsonencode(user.created))), timeadd(timestamp(), "-${param.inactive_hours}h")) < 0) && step.pipeline.get_current_okta_user.output.user.id != user.id
    }

    pipeline = jira.pipeline.create_issue
    args = {
      conn        = param.jira_conn
      description = "User ${each.value.profile.firstName} ${each.value.profile.lastName} with the login ${each.value.profile.login} is scheduled to be deactivated."
      issue_type  = param.issue_type
      project_key = param.project_key
      summary     = "Deactivate ${each.value.profile.login}"
    }
  }

  output "jira_issue" {
    description = "Issue metadata."
    value       = step.pipeline.create_jira_issue
  }
}
