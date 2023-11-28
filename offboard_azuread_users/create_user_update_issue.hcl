pipeline "create_user_update_issue" {
  title       = "Update Azure AD user status"
  description = "Raise jira issues to update Azure AD user status."

  # Azure Setup
  param "tenant_id" {
    type        = string
    description = "The Microsoft Entra ID tenant (directory) ID."
    default     = var.tenant_id
  }

  param "subscription_id" {
    type        = string
    description = "Azure Subscription Id. Examples: d46d7416-f95f-4771-bbb5-529d4c766."
    default     = var.subscription_id
  }

  param "client_secret" {
    type        = string
    description = "A client secret that was generated for the App Registration."
    default     = var.client_secret
  }

  param "client_id" {
    type        = string
    description = "The client (application) ID of an App Registration in the tenant."
    default     = var.client_id
  }

  param "user_id" {
    type        = string
    description = "The Azure AD user object ID or principal name."
  }

  param "account_status" {
    type        = string
    description = "The account status to update for the user.  Here you can assign values as 'enable' or 'disable' or 'delete' to raise respective issues in jira"
  }

  # Jira Setup
  param "token" {
    type        = string
    description = "API access token"
    default = var.token
  }

  param "user_email" {
    type        = string
    description = "Email-id of the user."
    default     = var.user_email
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
    default     = "Task"
  }

  step "pipeline" "get_ad_user" {
    pipeline = azure.pipeline.get_ad_user
    args = {
      tenant_id       = param.tenant_id
      client_secret   = param.client_secret
      client_id       = param.client_id
      subscription_id = param.subscription_id
      user_id         = param.user_id
    }
  }

  step "pipeline" "create_disable_issue" {
    if       = param.account_status == "disable"
    pipeline = jira.pipeline.create_issue
    args = {
      api_base_url = param.api_base_url
      token        = param.token
      user_email   = param.user_email
      project_key  = param.project_key
      summary      = "Disable ${step.pipeline.get_ad_user.output.stdout.userPrincipalName}"
      description  = "User Details ${jsonencode(step.pipeline.get_ad_user.output.stdout)}"
      issue_type   = param.issue_type
    }
  }

  step "pipeline" "create_enable_issue" {
    if       = param.account_status == "enable"
    pipeline = jira.pipeline.create_issue
    args = {
      api_base_url = param.api_base_url
      token        = param.token
      user_email   = param.user_email
      project_key  = param.project_key
      summary      = "Enable ${step.pipeline.get_ad_user.output.stdout.userPrincipalName}"
      description  = "User Details ${jsonencode(step.pipeline.get_ad_user.output.stdout)}"
      issue_type   = param.issue_type
    }
  }

  step "pipeline" "create_delete_issue" {
    if       = param.account_status == "delete"
    pipeline = jira.pipeline.create_issue
    args = {
      api_base_url = param.api_base_url
      token        = param.token
      user_email   = param.user_email
      project_key  = param.project_key
      summary      = "Delete ${step.pipeline.get_ad_user.output.stdout.userPrincipalName}"
      description  = "User Details ${jsonencode(step.pipeline.get_ad_user.output.stdout)}"
      issue_type   = param.issue_type
    }
  }

  // output "user" {
  //   description = "User info."
  //   value       = step.pipeline.get_ad_user
  // }

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

