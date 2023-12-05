//  Schedule Trigger
trigger "schedule" "scheduled_user_deactivate_action" {
  description = "A cron that checks inactive Okta user and initiates deactivation."
  schedule    = "*/5 * * * *" // Run every 5 min
  pipeline    = pipeline.deactivate_okta_accounts
}

pipeline "deactivate_okta_accounts" {
  title       = "Report on Inactive Okta Accounts and Deactivate"
  description = "Routinely scan Okta environments for potential inactive accounts and deactivate accounts."

  param "api_token" {
    type        = string
    description = "The Okta personal access api_token to authenticate to the okta APIs."
    default     = var.api_token
  }

  param "domain" {
    type        = string
    description = "The URL of the Okta domain."
    default     = var.okta_domain
  }

  param "inactive_hours" {
    description = "Number of hours the user is inactive since current timestamp."
    type        = number
    default     = var.inactive_hours
  }

  //Jira Setup
  param "token" {
    type        = string
    description = "API access token"
    # TODO: Add once supported
    # sensitive  = true
    default = var.token
  }

  param "api_base_url" {
    type        = string
    description = "API base URL."
    default     = var.api_base_url
  }

  param "project_key" {
    type        = string
    description = "The key identifying the project."
    default     = var.project_key
  }

  param "issue_type" {
    type        = string
    description = "Issue type."
    default     = var.issue_type
  }

  step "pipeline" "list_users" {
    pipeline = okta.pipeline.list_users
    args = {
      api_token = param.api_token
    }
  }

  step "pipeline" "deactivate_inactive_users" {
    depends_on = [step.pipeline.list_users]
    for_each = { for user in step.pipeline.list_users.output.users : user.id => user
    if user.status == "ACTIVE" && ((timecmp(user.lastLogin, timeadd(timestamp(), "-${param.inactive_hours}h"))) < 0) }
    pipeline = okta.pipeline.deactivate_user_synchronously
    args = {
      api_token = param.api_token
      user_id   = each.value.profile.email
    }
  }

  //Create issue in Jira
  step "pipeline" "create_jira_issue" {
    depends_on = [step.pipeline.deactivate_inactive_users]
    for_each = { for user in step.pipeline.list_users.output.users : user.id => user
    if user.status == "ACTIVE" && ((timecmp(user.lastLogin, timeadd(timestamp(), "-${param.inactive_hours}h"))) < 0) }
    pipeline = jira.pipeline.create_issue

    args = {
      api_base_url = param.api_base_url
      token        = param.token
      issue_type   = param.issue_type
      description  = "User ${each.value.profile.firstName} ${each.value.profile.lastName} with login as ${each.value.profile.login} is scheduled deactived"
      project_key  = param.project_key
      summary      = "Deactivate ${each.value.profile.login}"
    }
  }

  step "echo" "condition_info" {
    for_each = { for user in step.pipeline.list_users.output.users : user.id => user }
    text     = "${timecmp(each.value.lastLogin, timeadd(timestamp(), "-${param.inactive_hours}h"))} user ${each.value.profile.email} lastlogin ${each.value.lastLogin} status ${each.value.status}"
  }

  output "jira_issue" {
    description = "Issue metadata."
    value       = step.pipeline.create_jira_issue
  }

}
