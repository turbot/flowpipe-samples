pipeline "update_entra_id_user_status" {
  title       = "Update Entra ID User Status"
  description = "Create Jira issue to update Entra ID user status."

  tags = {
    type = "featured"
  }

  param "azure_cred" {
    type        = string
    description = "Name for Azure credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  param "jira_cred" {
    type        = string
    description = "Name for Jira credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  param "user_id" {
    type        = string
    description = "The Entra ID user object ID or principal name."
  }

  param "account_status" {
    type        = string
    description = "The account status to update for the user.  Here you can assign values as 'enable', 'disable' or 'delete' to raise respective issues in jira"
  }

  param "project_key" {
    type        = string
    description = "The key identifying the project."
  }

  param "issue_type" {
    type        = string
    description = "Issue type."
    default     = "Task"
  }

  step "pipeline" "get_user" {
    pipeline = entra.pipeline.get_user
    args = {
      cred    = param.azure_cred
      user_id = param.user_id
    }
  }

  step "pipeline" "create_disable_issue" {
    depends_on = [step.pipeline.get_user]
    if         = lower(param.account_status) == "disable"

    pipeline = jira.pipeline.create_issue
    args = {
      cred        = param.jira_cred
      project_key = param.project_key
      summary     = "Disable ${step.pipeline.get_user.output.user.userPrincipalName}"
      description = "User Details ${jsonencode(step.pipeline.get_user.output.user)}"
      issue_type  = param.issue_type
    }
  }

  step "pipeline" "create_enable_issue" {
    depends_on = [step.pipeline.get_user]
    if         = lower(param.account_status) == "enable"

    pipeline = jira.pipeline.create_issue
    args = {
      cred        = param.jira_cred
      project_key = param.project_key
      summary     = "Enable ${step.pipeline.get_user.output.user.userPrincipalName}"
      description = "User Details ${jsonencode(step.pipeline.get_user.output.user)}"
      issue_type  = param.issue_type
    }
  }

  step "pipeline" "create_delete_issue" {
    depends_on = [step.pipeline.get_user]
    if         = lower(param.account_status) == "delete"

    pipeline = jira.pipeline.create_issue
    args = {
      cred        = param.jira_cred
      project_key = param.project_key
      summary     = "Delete ${step.pipeline.get_user.output.user.userPrincipalName}"
      description = "User Details ${jsonencode(step.pipeline.get_user.output.user)}"
      issue_type  = param.issue_type
    }
  }

  output "disable_issue" {
    description = "Issue metadata."
    value       = step.pipeline.create_disable_issue
  }

  output "enable_issue" {
    description = "Issue metadata."
    value       = step.pipeline.create_enable_issue
  }

  output "delete_issue" {
    description = "Issue metadata."
    value       = step.pipeline.create_delete_issue
  }

}

