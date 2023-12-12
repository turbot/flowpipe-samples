trigger "schedule" "scheduled_user_deactivate_action" {
  description = "Runs daily at 9 AM UTC, this trigger scans inactive Okta accounts and deactivates them."

  schedule = "0 9 * * *"
  pipeline = pipeline.report_inactive_okta_accounts
}

pipeline "report_inactive_okta_accounts" {
  title       = "Report on Inactive Okta Accounts and Deactivate"
  description = "Routinely scan Okta environments for potential inactive accounts and deactivate accounts."

  param "inactive_hours" {
    type        = number
    description = "Number of hours of inactivity before an account is deactivated."
  }

  # Jira Setup
  param "project_key" {
    type        = string
    description = "The key identifying the jira project."
  }

  param "issue_type" {
    type        = string
    description = "Issue type."
  }

  # Get the current user
  step "pipeline" "get_current_user" {
    pipeline = okta.pipeline.get_user
    args = {
      user_id = "me"
    }
  }

  step "pipeline" "list_users" {
    pipeline = okta.pipeline.list_users
  }

  # Deactivate inactive users
  step "pipeline" "deactivate_inactive_users" {
    depends_on = [step.pipeline.list_users, step.pipeline.get_current_user]

    for_each = {
      for user in step.pipeline.list_users.output.users : user.id => user
      if user.status == "ACTIVE" && (timecmp(coalesce(jsondecode(jsonencode(user.lastLogin)), jsondecode(jsonencode(user.created))), timeadd(timestamp(), "-${param.inactive_hours}h")) < 0) && step.pipeline.get_current_user.output.user.id != user.id
    }

    pipeline = okta.pipeline.deactivate_user
    args = {
      user_id = each.value.profile.email
    }
  }

  # Create an issue in Jira
  step "pipeline" "create_jira_issue" {
    depends_on = [step.pipeline.deactivate_inactive_users]

    for_each = {
      for user in step.pipeline.list_users.output.users : user.id => user
      if user.status == "ACTIVE" && (timecmp(coalesce(jsondecode(jsonencode(user.lastLogin)), jsondecode(jsonencode(user.created))), timeadd(timestamp(), "-${param.inactive_hours}h")) < 0) && step.pipeline.get_current_user.output.user.id != user.id
    }

    pipeline = jira.pipeline.create_issue
    args = {
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
